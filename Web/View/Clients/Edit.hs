module Web.View.Clients.Edit where
import Web.View.Prelude

data EditView = EditView { client :: Client }

instance View EditView where
    html EditView { .. } = [hsx|
        {breadcrumb}
        <h1>Edit Client</h1>
        {renderForm client}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Clients" ClientsAction
                , breadcrumbText "Edit Client"
                ]

renderForm :: Client -> Html
renderForm client = formFor client [hsx|
    {(textField #email)}
    {(textField #firstName)}
    {(textField #lastName)}
    {(textField #userId)}
    {submitButton}

|]