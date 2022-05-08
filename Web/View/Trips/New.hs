module Web.View.Trips.New where
import Web.View.Prelude

import Web.View.Trips.Render (tripForm)

data NewView = NewView { trip :: Trip, client :: Client }

instance View NewView where
    html NewView { .. } = [hsx|
        <h1>Ajouter une course</h1>
        <p>Votre course avec {get #name client}.</p>
        {renderForm trip}
    |]

renderForm :: Trip -> Html
renderForm trip = formFor trip (tripForm trip)
