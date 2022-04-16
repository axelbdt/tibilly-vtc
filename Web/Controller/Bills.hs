module Web.Controller.Bills where

import qualified Data.Text as T
import Text.Printf
import Data.Time.Clock
import Data.Time.Calendar
import Web.Controller.Prelude
import Web.View.Bills.Index
import Web.View.Bills.SelectClient
import Web.View.Bills.Show
import Web.View.Bills.CheckBeforeSend

import Web.View.Bills.RenderBill

import Web.Mail.Bills.SendBillToClient

setBillNumber bill = do
    billsTodayCount :: Int <- query @Bill
        |> filterWhere (#sentOn, get #sentOn bill)
        |> filterWhere (#userId, get #id (get #userId bill))
        |> fetchCount
    let billNumberDateBlock = case get #sentOn bill of
            Nothing -> ""
            Just sentOn -> formatTime defaultTimeLocale "%Y%m%d" sentOn
        billNumberCountBlock = printf "%02d" (billsTodayCount + 1)
        billNumber = T.pack (billNumberDateBlock ++ "-" ++ billNumberCountBlock)
    return (bill
        |> set #number billNumber)
          

instance Controller BillsController where
    action SendBillSuccessAction { billId } = do
        -- bill <- fetch billId
        -- currentTime <- getCurrentTime
        -- bill
            -- --|> set #sentOn (Just currentTime)
            -- -- |> setBillNumber
            -- --|> updateRecord
        redirectTo BillsAction

    -- TODO: Refacto when I have learned about Monads
    action GenerateBillPDFAction { billId } = do
        ensureIsUser
        currentTime <- getCurrentTime
        fbill <- fetchBillInfo billId
        let dbill = fbill
                |> set #sentOn (Just (utctDay currentTime)) 
        bill <- setBillNumber dbill
        accessDeniedUnless (currentUserId == get #id (get #userId bill))
        let priceInfo = billPriceInfo bill
        renderPDFResponse RenderBillView { .. }

    action SendBillAction { billId } = do
        ensureIsUser
        bill <- fetchBillInfo billId
        accessDeniedUnless (currentUserId == get #id (get #userId bill))
        let priceInfo = billPriceInfo bill
        case get #sentOn bill of
            Nothing -> do
                pdf <- renderPDF RenderBillView { .. }
                setSuccessMessage "Facture envoyée"
                sendMail SendBillToClientMail { .. }
                redirectTo (SendBillSuccessAction billId)
            Just _ -> do
                redirectTo BillsAction



    action BillsAction = do
        ensureIsUser
        bills <- query @Bill
            |> filterWhere (#userId, currentUserId)
            |> orderByDesc #createdAt
            |> fetch
            >>= collectionFetchRelated #clientId
        render IndexView { .. }

    action NewBillSelectClientPromptAction = do
        ensureIsUser
        userClients <- query @Client
             |> filterWhere (#userId, currentUserId)
             |> fetch
        let bill = newRecord
        render SelectClientView { .. }

    action ShowBillAction { billId } = do
        ensureIsUser
        bill <- fetch billId
            >>= fetchRelated #clientId
            >>= fetchRelated #trips
        accessDeniedUnless (get #userId bill == currentUserId)
        let priceInfo = billPriceInfo bill
        render ShowView { .. }

    action CheckBeforeSendBillAction { billId } = do
        ensureIsUser
        bill <- fetch billId
            >>= fetchRelated #clientId
        accessDeniedUnless (get #userId bill == currentUserId)
        tripCount <- query @Trip
            |> filterWhere (#billId, billId)
            |> fetchCount
        if tripCount == 0 then do
            setErrorMessage "Ajoutez d'abord une course à la facture"
            redirectTo (ShowBillAction billId)
        else do
            render CheckBeforeSendView { .. }

    action NewBillSelectClientAction = do
        ensureIsUser
        let bill = newRecord @Bill
        bill
            |> buildBill
            >>= ifValid \case
                Left bill -> do
                    userClients <- query @Client
                        |> filterWhere (#userId, currentUserId)
                        |> fetch
                    render SelectClientView { .. } 
                Right bill -> do
                    redirectTo (NewTripFromClientAction (get #clientId bill))

    action DeleteBillAction { billId } = do
        ensureIsUser
        bill <- fetch billId
        accessDeniedUnless (get #userId bill == currentUserId)
        deleteRecord bill
        setSuccessMessage "Facture supprimée"
        redirectTo BillsAction

buildBill bill = bill
    |> fill @["userId","clientId"]
    |> set #number ""
    |> set #userId currentUserId
    |> validateFieldIO #clientId (validateClientBelongsToUser currentUserId)


fetchBillInfo billId = do
    fetch billId
        >>= fetchRelated #userId
        >>= fetchRelated #clientId
        >>= fetchRelated #trips


billPriceInfo bill = PriceInfo {
                        includingTax = priceIncludingTax,
                        excludingTax = priceExcludingTax,
                        taxAmount = fromIntegral priceIncludingTax - priceExcludingTax
                        }
                            where
                                priceIncludingTax = computePriceIncludingTax bill
                                priceExcludingTax = excludeTax priceIncludingTax


validateClientBelongsToUser userId clientId = do
    if clientId == "00000000-0000-0000-0000-000000000000" then
        return (Failure "Veuillez sélectionnez un client")
    else do
      client <- fetch clientId
      return
          if userId == get #userId client then
              Success
          else
              Failure "Ce client ne vous appartient pas"

computePriceIncludingTax bill = bill |> get #trips |> map (get #price) |> sum

excludeTax :: Int -> Float
excludeTax price = fromIntegral price / (1.0 + 0.1)
