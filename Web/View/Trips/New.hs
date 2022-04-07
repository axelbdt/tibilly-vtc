module Web.View.Trips.New where
import Web.View.Prelude

data NewView = NewView { trip :: Trip }

instance View NewView where
    html NewView { .. } = [hsx|
        {breadcrumb}
        <h1>New Trip</h1>
        {renderForm trip}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Bills" BillsAction
                , breadcrumbText "New Trip"
                ]

renderForm :: Trip -> Html
renderForm trip = formFor trip [hsx|
    {(textField #startCity)}
    {(textField #destinationCity)}
    {(dateField #date)}
    {(numberField #price) {fieldLabel = "Price (€)", additionalAttributes = [("min","0")]}}
    {(textField #billId)}
    {submitButton}

|]
