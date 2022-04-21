module Web.View.Trips.Edit where
import Web.View.Prelude

import Web.View.Trips.Render

data EditView = EditView { trip :: Trip }

instance View EditView where
    html EditView { .. } = [hsx|
        <h1>Modifier la course</h1>
        {renderForm trip}
    |]

renderForm :: Trip -> Html
renderForm trip = formFor trip (tripForm trip)
