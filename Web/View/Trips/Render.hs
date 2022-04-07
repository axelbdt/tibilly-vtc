module Web.View.Trips.Render where
import Web.View.Prelude

renderTrip :: Trip -> Html
renderTrip trip = [hsx|
    <tr>
        <td>{get #startCity trip} - {get #destinationCity trip}</td>
        <td>{get #price trip}€</td>
        <td><a href={EditTripAction (get #id trip)} class="text-muted">Edit</a></td>
        <td><a href={DeleteTripAction (get #id trip)} class="js-delete text-muted">Delete</a></td>
    </tr>
|]

tripForm trip = [hsx|
    {(textField #startCity)}
    {(textField #destinationCity)}
    {(dateField #date)}
    {(numberField #price) {fieldLabel = "Price (€)", additionalAttributes = [("min","0")]}}
    {(textField #billId)}
    {submitButton}

|]
