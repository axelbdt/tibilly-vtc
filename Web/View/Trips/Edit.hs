module Web.View.Trips.Edit where
import Web.View.Prelude

data EditView = EditView { trip :: Trip }

instance View EditView where
    html EditView { .. } = [hsx|
        {breadcrumb}
        <h1>Edit Trip</h1>
        {renderForm trip}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Bills" BillsAction
                , breadcrumbText "Edit Trip"
                ]

renderForm :: Trip -> Html
renderForm trip = formFor trip [hsx|
    {(textField #startCity)}
    {(textField #destinationCity)}
    {(textField #date)}
    {(textField #billId)}
    {submitButton}

|]
