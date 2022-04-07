module Web.Controller.Bills where

import Data.Time.Clock
import Data.Time.Calendar
import Web.Controller.Prelude
import Web.View.Bills.Index
import Web.View.Bills.SelectClient
import Web.View.Bills.Edit
import Web.View.Bills.Show


instance Controller BillsController where
    action BillsAction = do
        ensureIsUser
        bills <- query @Bill
            |> filterWhere (#userId, currentUserId)
            |> orderByDesc #createdAt
            |> fetch
            >>= collectionFetchRelated #clientId
        render IndexView { .. }

    action NewBillSelectClientAction = do
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
        let priceIncludingTax = computePriceIncludingTax bill
        let priceExcludingTax = excludeTax priceIncludingTax
        accessDeniedUnless (get #userId bill == currentUserId)
        render ShowView { .. }

    action EditBillAction { billId } = do
        ensureIsUser
        bill <- fetch billId
        accessDeniedUnless (get #userId bill == currentUserId)
        render EditView { .. }

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

    action CreateBillAction = do
        ensureIsUser
        let bill = newRecord @Bill
        bill
            |> fill @["userId","clientId"]
            |> validateFieldIO #clientId (validateClientBelongsToUser currentUserId)
            >>= ifValid \case
                Left bill -> do
                    userClients <- query @Client
                        |> filterWhere (#userId, currentUserId)
                        |> fetch
                    render SelectClientView { .. } 
                Right bill -> do
                    redirectTo (NewTripFromClientAction (get #clientId bill))
        redirectTo (NewTripFromClientAction (get #clientId bill))


    action RealCreateBillAction = do
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
                    bill <- bill 
                        |> createRecord
                    setSuccessMessage "Bill created"
                    redirectTo (ShowBillAction (get #id bill))

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
excludeTax price = fromIntegral price * (1.0 - 0.1)
