module Web.View.Trips.NewFromClient where
import Web.View.Prelude
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
                , breadcrumbText "New Trip"
                ]

renderForm :: Trip -> Id Client -> Html
renderForm trip clientId = formFor' trip (pathTo (CreateTripAndBillAction clientId)) [hsx|
    {(textField #startCity)}
    {(textField #destinationCity)}
    {(dateField #date)}
    {(numberField #price) {fieldLabel = "Price (€)", additionalAttributes = [("min","0")]}}
    {(textField #billId)}
    {submitButton}

|]
