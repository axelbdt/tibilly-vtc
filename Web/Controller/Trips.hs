module Web.Controller.Trips where

import qualified Data.Text as T
import Text.Read (reads)
import Data.Time.Calendar

import Web.Controller.Prelude
import Web.View.Trips.New
import Web.View.Trips.Edit

import Web.Controller.Bills (buildBill)

instance Controller TripsController where
    action NewTripAction { billId } = do
        ensureIsUser
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

validateBillBelongsToUser userId billId = do
    bill <- fetch billId
    return
        if currentUserId == get #userId bill then
            Success
        else
            Failure "La facture à laquelle vous tentez d'ajouter une course ne vous appartient pas."

