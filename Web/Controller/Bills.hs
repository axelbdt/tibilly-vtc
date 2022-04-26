module Web.Controller.Bills where

import qualified Data.Text as T
import qualified Data.Text.Encoding as TE
import Text.Printf
import Data.Time.Clock
import Data.Time.Calendar
import Web.Controller.Prelude
import Web.View.Bills.Index
import Web.View.Bills.New
import Web.View.Bills.Show
import Web.View.Bills.CheckBeforeSend

import Web.View.Bills.RenderBill

import Web.Mail.Bills.SendBillToClient
import Language.Haskell.Exts (SrcInfo(fileName))

instance Controller BillsController where
    action BillsAction = do
        ensureIsUser
        bills <- query @Bill
            |> filterWhere (#userId, currentUserId)
            |> orderByDesc #createdAt
            |> fetch
            >>= collectionFetchRelated #clientId
        render IndexView { .. }

    action ShowBillAction { billId } = do
        ensureIsUser
        bill <- fetch billId
            >>= fetchRelated #clientId
            >>= pure . modify #trips (orderBy #date)
            >>= fetchRelated #trips
        accessDeniedUnless (get #userId bill == currentUserId)
        let priceInfo = billPriceInfo bill
        render ShowView { .. }


    action NewBillAction = do
        ensureIsUser
        userClients <- query @Client
             |> filterWhere (#userId, currentUserId)
             |> orderBy #name
             |> fetch
        let bill = newRecord
        render NewView { .. }

    -- TODO: Refacto when I have learned about Monads
    action GenerateBillPDFAction { billId } = do
        ensureIsUser
        currentTime <- getCurrentTime
        fbill <- fetch billId
            >>= fetchRelated #userId
            >>= fetchRelated #clientId
            >>= pure . modify #trips (orderBy #date)
            >>= fetchRelated #trips
        let currentDay = utctDay currentTime
        let sentOn = Just currentDay
        let dbill = fbill |> set #sentOn sentOn
        billNumber <- generateBillNumber dbill
        let bill = dbill |> set #number (Just 0) -- billNumber
        accessDeniedUnless (currentUserId == get #id (get #userId bill))
        let priceInfo = billPriceInfo bill
        renderPDFResponse (billFileName bill) RenderBillView { .. }

    -- TODO: Refacto when I have learned about Monads
    action SendBillAction { billId } = do
        ensureIsUser
        currentTime <- getCurrentTime
        fbill <- fetch billId
            >>= fetchRelated #userId
            >>= fetchRelated #clientId
            >>= pure . modify #trips (orderBy #date)
            >>= fetchRelated #trips
        accessDeniedUnless (currentUserId == get #id (get #userId fbill))
        -- TODO: use fetchRelated #trips
        tripCount <- query @Trip
            |> filterWhere (#billId, billId)
            |> fetchCount
        if tripCount == 0 then do
            setErrorMessage "Ajoutez d'abord une course à la facture"
            redirectTo (ShowBillAction billId)
        else do
            let priceInfo = billPriceInfo fbill
            case get #sentOn fbill of
                Nothing -> do
                    let sentOn = Just (utctDay currentTime)
                    let dbill = fbill |> set #sentOn sentOn 
                    billNumber <- generateBillNumber dbill
                    let bill = dbill |> set #number (Just 0) -- billNumber
                    pdf <- renderPDF RenderBillView { .. }
                    -- sendMail SendBillToClientMail { .. }
                    ubill <- fetch billId
                    ubill
                        |> set #number (Just 0) -- billNumber
                        |> set #sentOn sentOn
                        |> updateRecord
                    setSuccessMessage "Facture envoyée"
                    redirectTo BillsAction
                Just _ -> do
                    setErrorMessage "Facture déjà envoyée"
                    redirectTo BillsAction

    action CheckBeforeSendBillAction { billId } = do
        ensureIsUser
        bill <- fetch billId
            >>= fetchRelated #clientId
        accessDeniedUnless (get #userId bill == currentUserId)
        -- TODO: use fetchRelated #trips
        tripCount <- query @Trip
            |> filterWhere (#billId, billId)
            |> fetchCount
        if tripCount == 0 then do
            setErrorMessage "Ajoutez d'abord une course à la facture"
            redirectTo (ShowBillAction billId)
        else do
            render CheckBeforeSendView { .. }

    action CreateBillAction = do
        ensureIsUser
        let bill = newRecord @Bill
        bill
            |> buildBill
            >>= ifValid \case
                Left bill -> do
                    userClients <- query @Client
                        |> filterWhere (#userId, currentUserId)
                        |> fetch
                    render NewView { .. } 
                Right bill -> do
                    bill <- bill |> createRecord
                    setSuccessMessage "Facture créée, ajoutez une course."
                    redirectTo (NewTripAction (get #id bill))

    action DeleteBillAction { billId } = do
        ensureIsUser
        bill <- fetch billId
        accessDeniedUnless (get #userId bill == currentUserId)
        deleteRecord bill
        setSuccessMessage "Facture supprimée"
        redirectTo BillsAction

buildBill bill = bill
    |> fill @["userId","clientId"]
    |> set #userId currentUserId
    |> validateFieldIO #clientId (validateClientBelongsToUser currentUserId)

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

generateBillNumber bill = do
    billsTodayCount :: Int <- query @Bill
        |> filterWhere (#sentOn, get #sentOn bill)
        |> filterWhere (#userId, get #id (get #userId bill))
        |> fetchCount
    let billNumberDateBlock = case get #sentOn bill of
            Nothing -> ""
            Just sentOn -> formatTime defaultTimeLocale "%Y%m%d" sentOn
        billNumberCountBlock = printf "%02d" (billsTodayCount + 1)
        billNumber = T.pack (billNumberDateBlock ++ "-" ++ billNumberCountBlock)
    return billNumber
          
billFileName bill =
    TE.encodeUtf8 fileName
    where
        fileName = "Facture " ++ get #name (get #clientId bill) ++ " " ++ dateSuffix
        dateSuffix= case get #sentOn bill of
            Just sentOn -> T.pack $ formatTime defaultTimeLocale "%d-%m-%Y" sentOn
            Nothing -> ""
