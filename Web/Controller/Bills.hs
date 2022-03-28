module Web.Controller.Bills where

import Data.Time.Clock
import Data.Time.Calendar
import Web.Controller.Prelude
import Web.View.Bills.Index
import Web.View.Bills.New
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

    action NewBillAction = do
        ensureIsUser
        userClients <- query @Client
             |> filterWhere (#userId, currentUserId)
             |> fetch
        let bill = newRecord
        render NewView { .. }

    action ShowBillAction { billId } = do
        ensureIsUser
        bill <- fetch billId
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
            |> ifValid \case
                Left bill -> render EditView { .. }
                Right bill -> do
                    bill <- bill |> updateRecord
                    setSuccessMessage "Bill updated"
                    redirectTo EditBillAction { .. }

    action CreateBillAction = do
        ensureIsUser
        let bill = newRecord @Bill
        bill
            |> buildBill
            |> ifValid \case
                Left bill -> do
                    userClients <- query @Client
                        |> filterWhere (#userId, currentUserId)
                        |> fetch
                    render NewView { .. } 
                Right bill -> do
                    bill <- bill 
                        |> set #userId currentUserId
                        |> createRecord
                    setSuccessMessage "Bill created"
                    redirectTo BillsAction

    action DeleteBillAction { billId } = do
        ensureIsUser
        bill <- fetch billId
        accessDeniedUnless (get #userId bill == currentUserId)
        deleteRecord bill
        setSuccessMessage "Bill deleted"
        redirectTo BillsAction

buildBill bill = bill
    |> fill @["userId","clientId"]
