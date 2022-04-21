module Web.View.Trips.Render where
import Web.View.Prelude

renderTripDescription trip = "De " ++ get #start trip ++ " à " ++ get #destination trip ++ ", le " ++  renderDay (get #date trip)

tripForm trip submitLabel = [hsx|
    {(textField #start) { fieldLabel = "Départ" }}
    {(textField #destination) { fieldLabel = "Arrivée" }}
    {(dateField #date)}
    {(numberField #price) {fieldLabel = "Prix TTC (€)", additionalAttributes = [("min","0")]}}
    {(hiddenField #billId)}
    {submitButton { label = submitLabel }}

|]
