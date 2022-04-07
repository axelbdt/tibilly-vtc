module Web.View.Trips.NewFromClient where
import Web.View.Prelude

import Web.View.Trips.Render
import Web.Types (BillsController(NewBillSelectClientPromptAction))

data NewFromClientView = NewFromClientView {trip :: Trip, clientId :: Id Client}

instance View NewFromClientView where
    html NewFromClientView { .. } = [hsx|
        {breadcrumb}
        <h1>New Trip</h1>
        {renderForm trip clientId}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Bills" BillsAction
                , breadcrumbText "New Bill" 
                , breadcrumbLink "Select Client" NewBillSelectClientPromptAction
                , breadcrumbText "New Trip"
                ]

renderForm :: Trip -> Id Client -> Html
renderForm trip clientId = formFor' trip (pathTo (CreateTripAndBillAction clientId)) (tripForm trip)
