module Web.View.Trips.Render where
import Web.View.Prelude

renderTripDescription trip = "De " ++ get #start trip ++ " à " ++ get #destination trip ++ ", le " ++  renderDay (get #date trip)

renderTrip :: Bool -> Trip -> Html
renderTrip withCommands trip = [hsx|
    <tr>
        <td>{(get #start trip) }</td>
        <td>{get #destination trip}</td>
        <td>{renderPrice (get #price trip)}€</td>
        {commands}
    </tr>
|]
    where commands = if withCommands then [hsx|
              <td><a href={EditTripAction (get #id trip)} class="text-muted">Modifier</a></td>
              <td><a href={DeleteTripAction (get #id trip)} class="js-delete text-muted">Supprimer</a></td>
          |]
          else [hsx||]

tripForm trip submitLabel = [hsx|
    {(textField #start) { fieldLabel = "Départ" } }
    {(textField #destination)}
    {(dateField #date)}
    {(numberField #price) {fieldLabel = "Prix TTC (€)", additionalAttributes = [("min","0")]}}
    {(hiddenField #billId)}
    {submitButton { label = submitLabel }}

|]
