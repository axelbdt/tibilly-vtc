module Web.Controller.Trips where

import qualified Data.Text as T
import Text.Read (reads)
import Data.Time.Calendar

import Web.Controller.Prelude
import Web.View.Trips.New
import Web.View.Trips.NewFromClient
import Web.View.Trips.Edit

import Web.Controller.Bills (buildBill)

instance Controller TripsController where
    action NewTripFromClientAction { clientId } = do
        currentTime <- getCurrentTime
        let trip = newRecord
              |> set #date (utctDay currentTime)
        render NewFromClientView { .. }

    action NewTripAction { billId } = do
        currentTime <- getCurrentTime
        let trip = newRecord
              |> set #billId billId
              |> set #date (utctDay currentTime)
        render NewView { .. }

    action EditTripAction { tripId } = do
        trip <- fetch tripId
        render EditView { .. }

    action UpdateTripAction { tripId } = do
        trip <- fetch tripId
        trip
            |> buildTrip
            |> validateFieldIO #billId (validateBillBelongsToUser currentUserId)
            >>= ifValid \case
                Left trip -> render EditView { .. }
                Right trip -> do
                    trip <- trip |> updateRecord
                    setSuccessMessage "Course modifiée"
                    redirectTo (ShowBillAction (get #billId trip))

    action CreateTripAction = do
        let trip = newRecord @Trip
        trip
            |> buildTrip
            |> validateFieldIO #billId (validateBillBelongsToUser currentUserId)
            >>= ifValid \case
                Left trip -> render NewView { .. } 
                Right trip -> do
                    trip <- trip |> createRecord
                    setSuccessMessage "Course ajoutée"
                    redirectTo (ShowBillAction (get #billId trip))

    action CreateTripAndBillAction { clientId } = do
        ensureIsUser
        let bill = newRecord @Bill
        let trip = newRecord @Trip |> buildTrip
        bill
            |> buildBill
            >>= ifValid \case
                Left bill ->
                    render NewFromClientView { .. }
                Right bill ->
                    trip
                        |> buildTrip
                        |> set #billId (get #id bill)
                        |> ifValid \case
                            Left trip -> do
                                render NewFromClientView { .. }
                            Right trip -> do
                                bill <- bill |> createRecord
                                trip <- trip |> set #billId (get #id bill) |> createRecord
                                setSuccessMessage "Facture créée"
                                redirectTo (ShowBillAction (get #id bill))

    action DeleteTripAction { tripId } = do
        trip <- fetch tripId
        deleteRecord trip
        setSuccessMessage "Course supprimée"
        redirectTo (ShowBillAction (get #billId trip))

buildTrip trip = trip
    |> fill @["start","destination","date","billId", "price"]
    |> validateField #price (isGreaterOrEqualThan 0)
    |> validateField #start frenchNonEmpty
    |> validateField #destination frenchNonEmpty

isGreaterOrEqualThan min value | value >= min = Success
isGreaterOrEqualThan min value = Failure "Doit être supérieur à 0"

validateBillBelongsToUser userId billId = do
    bill <- fetch billId
    return
        if currentUserId == get #userId bill then
            Success
        else
            Failure "La facture à laquelle vous tentez d'ajouter une course ne vous appartient pas."

