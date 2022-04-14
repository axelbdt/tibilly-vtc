module Web.Controller.Bills where

import Data.Time.Clock
import Data.Time.Calendar
import Web.Controller.Prelude
import Web.View.Bills.Index
import Web.View.Bills.SelectClient
import Web.View.Bills.Edit
import Web.View.Bills.Show
import Web.View.Bills.CheckBeforeSend

import Web.View.Bills.RenderBill

import Web.Mail.Bills.SendBillToClient

import Application.Helper.Wkhtmltopdf
import Network.HTTP.Types (status200)
import Network.HTTP.Types.Header
import Network.Wai (responseLBS)

renderPDF view = do
    viewHtml <- renderHtml view 
    convertHtml viewHtml

renderPDFResponse view = do
    pdfBytes <- renderPDF view
    respondAndExit $ responseLBS status200 [(hContentType, "application/pdf")] pdfBytes


instance Controller BillsController where
    action BillRenderPreviewAction { billId }= do
        ensureIsUser
        bill <- fetch billId
            >>= fetchRelated #userId
            >>= fetchRelated #clientId
            >>= fetchRelated #trips
        accessDeniedUnless (currentUserId == get #id (get #userId bill))
        let priceIncludingTax = computePriceIncludingTax bill
        let priceExcludingTax = excludeTax priceIncludingTax
        let taxAmount = fromIntegral priceIncludingTax - priceExcludingTax
        render RenderBillView { .. }

    action SendBillSuccessAction { billId } = do
        bill <- fetch billId
        currentTime <- getCurrentTime
        bill
            |> set #sentAt (Just currentTime)
            |> updateRecord
        redirectTo BillsAction

    action GenerateBillPDFAction { billId } = do
        ensureIsUser
        bill <- fetch billId
            >>= fetchRelated #userId
            >>= fetchRelated #clientId
            >>= fetchRelated #trips
        accessDeniedUnless (currentUserId == get #id (get #userId bill))
        let priceIncludingTax = computePriceIncludingTax bill
        let priceExcludingTax = excludeTax priceIncludingTax
        let taxAmount = fromIntegral priceIncludingTax - priceExcludingTax
        renderPDFResponse RenderBillView { .. }

    action SendBillAction { billId } = do
        ensureIsUser
        bill <- fetch billId
            >>= fetchRelated #userId
            >>= fetchRelated #clientId
            >>= fetchRelated #trips
        accessDeniedUnless (currentUserId == get #id (get #userId bill))
        let priceIncludingTax = computePriceIncludingTax bill
        let priceExcludingTax = excludeTax priceIncludingTax
        let taxAmount = fromIntegral priceIncludingTax - priceExcludingTax
        case get #sentAt bill of
            Nothing -> do
                pdf <- renderPDF RenderBillView { .. }
                setSuccessMessage "Bill sent"
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
        let priceIncludingTax = computePriceIncludingTax bill
        let priceExcludingTax = excludeTax priceIncludingTax
        let taxAmount = fromIntegral priceIncludingTax - priceExcludingTax
        render ShowView { .. }

    action EditBillAction { billId } = do
        ensureIsUser
        bill <- fetch billId
        accessDeniedUnless (get #userId bill == currentUserId)
        render EditView { .. }

    action CheckBeforeSendBillAction { billId } = do
        ensureIsUser
        bill <- fetch billId
        render CheckBeforeSendView { .. }

    action UpdateBillAction { billId } = do
        ensureIsUser
        bill <- fetch billId
        accessDeniedUnless (get #userId bill == currentUserId)
        bill
            |> buildBill
            >>= ifValid \case
                Left bill -> render EditView { .. }
                Right bill -> do
                    bill <- bill
                        |> updateRecord
                    setSuccessMessage "Bill updated"
                    redirectTo EditBillAction { .. }

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
        setSuccessMessage "Bill deleted"
        redirectTo BillsAction

buildBill bill = bill
    |> fill @["userId","clientId"]
    |> set #userId currentUserId
    |> validateFieldIO #clientId (validateClientBelongsToUser currentUserId)

validateClientBelongsToUser userId clientId = do
    if clientId == "00000000-0000-0000-0000-000000000000" then
        return (Failure "Please select a client")
    else do
      client <- fetch clientId
      return
          if userId == get #userId client then
              Success
          else
              Failure "Not yours"

computePriceIncludingTax bill = bill |> get #trips |> map (get #price) |> sum

excludeTax :: Int -> Float
excludeTax price = fromIntegral price / (1.0 + 0.1)
