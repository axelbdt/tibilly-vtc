module Web.View.Trips.New where
import Web.View.Prelude

import Web.View.Trips.Render (tripForm)

data NewView = NewView { trip :: Trip }

instance View NewView where
    html NewView { .. } = [hsx|
        {breadcrumb}
        <h1>Add Trip</h1>
        {renderForm trip}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Bills" BillsAction
                , breadcrumbLink "Show Bill" (ShowBillAction (get #billId trip))
                , breadcrumbText "New Trip"
                ]

renderForm :: Trip -> Html
renderForm trip = formFor trip (tripForm trip)
