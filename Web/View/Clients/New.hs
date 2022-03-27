module Web.View.Clients.New where
import Web.View.Prelude

data NewView = NewView { client :: Client }

instance View NewView where
    html NewView { .. } = [hsx|
        {breadcrumb}
        <h1>New Client</h1>
        {renderForm client}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Clients" ClientsAction
                , breadcrumbText "New Client"
                ]

renderForm :: Client -> Html
renderForm client = formFor client [hsx|
    {(textField #email)}
    {(textField #firstName)}
    {(textField #lastName)}
    {(hiddenField #userId)}
    {submitButton}

|]
