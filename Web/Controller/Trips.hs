module Web.Controller.Trips where

import qualified Data.Text as T
import Text.Read (reads)
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
            >>= ifValid \case
                Left trip -> render EditView { .. }
                Right trip -> do
                    trip <- trip |> updateRecord
                    setSuccessMessage "Trip updated"
                    redirectTo EditTripAction { .. }

    action CreateTripAction = do
        let trip = newRecord @Trip
        trip
            |> buildTrip
            >>= ifValid \case
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
    |> fill @["startCity","destinationCity","date","billId", "price"]
    |> validateField #price (isGreaterOrEqualThan 0)
    |> validateField #startCity nonEmpty
    |> validateField #destinationCity nonEmpty
    |> validateFieldIO #billId (validateBillBelongsToUser currentUserId)

{-
parseAndSetPrice text record =
    case readFloatWithComma text of
        Left error  -> record |> attachFailure #price error
        Right amount -> record |> set #price (eurosToCents amount)

    
readFloatWithComma :: Text -> Either Text Float
readFloatWithComma text = case text |> T.replace "," "." |> T.unpack |> reads of
    [(x, "")] -> Right x
    _         -> Left "Invalid input"

eurosToCents :: Float -> Int
eurosToCents amount = round (100 * amount)
-}

isGreaterOrEqualThan min value | value >= min = Success
isGreaterOrEqualThan min value = Failure "Cannot be negative"


validateBillBelongsToUser userId billId = do
    bill <- fetch billId
    return
        if currentUserId == get #userId bill then
            Success
        else
            Failure "The bill you are trying to add a trip to does not belong to you."
