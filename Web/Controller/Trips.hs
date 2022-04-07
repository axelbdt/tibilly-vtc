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
            -- >>= ifValid \case
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
            -- >>= ifValid \case
            |> ifValid \case
                Left trip -> render NewView { .. } 
                Right trip -> do
                    trip <- trip |> createRecord
                    setSuccessMessage "Trip created"
                    redirectTo (ShowBillAction (get #billId trip))

    action CreateTripAndBillAction { clientId }= do
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
                                setSuccessMessage "Bill created"
                                redirectTo (ShowBillAction (get #id bill))

    action DeleteTripAction { tripId } = do
        trip <- fetch tripId
        deleteRecord trip
        setSuccessMessage "Trip deleted"
        redirectTo (ShowBillAction (get #billId trip))

buildTrip trip = trip
    |> fill @["startCity","destinationCity","date","billId", "price"]
    |> validateField #price (isGreaterOrEqualThan 0)
    |> validateField #startCity nonEmpty
    |> validateField #destinationCity nonEmpty

buildTripAndValidateUser trip = trip
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
