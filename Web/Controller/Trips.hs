module Web.Controller.Trips where

import Data.Time.Calendar

import Web.Controller.Prelude
import Web.View.Trips.Index
import Web.View.Trips.New
import Web.View.Trips.Edit
import Web.View.Trips.Show

instance Controller TripsController where
    action TripsAction = do
        trips <- query @Trip |> fetch
        render IndexView { .. }

    action NewTripAction { billId } = do
        currentTime <- getCurrentTime
        let trip = newRecord
              |> set #billId billId
              |> set #date (utctDay currentTime)
        render NewView { .. }

    action ShowTripAction { tripId } = do
        trip <- fetch tripId
        render ShowView { .. }

    action EditTripAction { tripId } = do
        trip <- fetch tripId
        render EditView { .. }

    action UpdateTripAction { tripId } = do
        trip <- fetch tripId
        trip
            |> buildTrip
            |> ifValid \case
                Left trip -> render EditView { .. }
                Right trip -> do
                    trip <- trip |> updateRecord
                    setSuccessMessage "Trip updated"
                    redirectTo EditTripAction { .. }

    action CreateTripAction = do
        let trip = newRecord @Trip
        trip
            |> buildTrip
            |> ifValid \case
                Left trip -> render NewView { .. } 
                Right trip -> do
                    trip <- trip |> createRecord
                    setSuccessMessage "Trip created"
                    redirectTo (ShowBillAction (get #billId trip))

    action DeleteTripAction { tripId } = do
        trip <- fetch tripId
        deleteRecord trip
        setSuccessMessage "Trip deleted"
        redirectTo TripsAction

buildTrip trip = trip
    |> fill @["startCity","destinationCity","date","billId"]
    |> validateField #startCity nonEmpty
    |> validateField #destinationCity nonEmpty
