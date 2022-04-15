module Web.View.Trips.NewFromClient where
import Web.View.Prelude

import Web.View.Trips.Render
import Web.Types (BillsController(NewBillSelectClientPromptAction))

data NewFromClientView = NewFromClientView {trip :: Trip, clientId :: Id Client}

instance View NewFromClientView where
    html NewFromClientView { .. } = [hsx|
        <h1>Course</h1>
        {renderForm trip clientId}
    |]

renderForm :: Trip -> Id Client -> Html
renderForm trip clientId = formFor' trip (pathTo (CreateTripAndBillAction clientId)) (tripForm trip "Créer la facture")
