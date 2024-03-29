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
import Web.View.Bills.CheckBillPDF

import Web.View.Bills.RenderBill

import Web.Mail.Bills.SendBillToClient

instance Controller BillsController where
    beforeAction = ensureIsUser

    action BillsAction = do
        bills <- query @Bill
            |> filterWhere (#userId, currentUserId)
            |> orderByDesc #createdAt
            |> fetch
            >>= collectionFetchRelated #clientId
        render IndexView { .. }

    action ShowBillAction { billId } = do
        fbill <- fetch billId
            >>= fetchRelated #clientId
            >>= pure . modify #trips (orderBy #date)
            >>= fetchRelated #trips
        accessDeniedUnless (get #userId fbill == currentUserId)
        let priceInfo = billPriceInfo fbill
        case get #sentOn fbill of
            Nothing -> do
                currentTime <- getCurrentTime
                let currentDay = utctDay currentTime
                billNumber <- generateBillNumber currentUserId currentDay
                let bill = fbill |> set #sentOn (Just currentDay) |> set #number (Just billNumber)
                render ShowView { .. }
            Just _ -> do
                let bill = fbill
                render ShowView { .. }


    action NewBillAction = do
        userClients <- query @Client
             |> filterWhere (#userId, currentUserId)
             |> orderBy #name
             |> fetch
        let bill = newRecord
        render NewView { .. }

    action CheckBillPDFAction { billId } = do
        bill <- fetch billId
        accessDeniedUnless (get #userId bill == currentUserId)
        -- TODO: use fetchRelated #trips
        tripCount <- query @Trip
            |> filterWhere (#billId, billId)
            |> fetchCount
        if tripCount == 0 then do
            setErrorMessage "Ajoutez d'abord une course à la facture"
            redirectTo (ShowBillAction billId)
        else do
            bill <- bill
                |> fill @["sentOn","number"]
                |> updateRecord
            setSuccessMessage "Facture enregistrée"
            render CheckBillPDFView { .. }

    -- TODO: Refacto when I have learned about Monads
    action GenerateBillPDFAction { billId, billNumber, sentOnText } = do
        fbill <- fetch billId
            >>= fetchRelated #userId
            >>= fetchRelated #clientId
            >>= pure . modify #trips (orderBy #date)
            >>= fetchRelated #trips
        accessDeniedUnless (currentUserId == get #id (get #userId fbill))
        let priceInfo = billPriceInfo fbill
        let sentOn = parseTimeOrError True defaultTimeLocale "%Y-%m-%d" (T.unpack sentOnText)
        let bill = fbill |> set #sentOn (Just sentOn) |> set #number (Just billNumber)
        renderPDFResponse (billFileName bill) RenderBillView { .. }

    action CreateBillAction = do
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

generateBillNumber userId billDate = do
    let (year, month, day) = toGregorian billDate
    maxNumberThisMonth :: Int <- sqlQueryScalar "SELECT COALESCE(MAX(number), 0) AS billCount FROM Bills WHERE user_id = ? AND EXTRACT(MONTH FROM sent_on) = ? AND EXTRACT(YEAR FROM sent_on) = ?" (userId, month, year)
    let billNumber = maxNumberThisMonth + 1
    return billNumber

billFileName bill =
    TE.encodeUtf8 fileName
    where
        fileName = "Facture " ++ get #name (get #clientId bill) ++ " " ++ dateSuffix
        dateSuffix= maybe "" show (get #sentOn bill)
