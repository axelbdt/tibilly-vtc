module Web.View.Bills.SelectClient where
import Web.View.Prelude

data SelectClientView = SelectClientView { bill :: Bill, userClients :: [Client] }

instance View SelectClientView where
    html SelectClientView { .. } = [hsx|
        {breadcrumb}
        <h1>New Bill</h1>
        {renderForm bill userClients}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Bills" BillsAction
                , breadcrumbText "New Bill"
                ]

renderForm :: Bill -> [Client] -> Html
renderForm bill userClients = formFor bill [hsx|
    {(hiddenField #userId)}
    <div class="d-flex flex-row justify-content-between">
      <div class="flex-fill pr-2">{(selectField #clientId userClients)}</div>
      <div class="pb-3" style="padding-top:2em"><a class="btn btn-secondary" href={NewClientAction}>Create New Client</a></div>
    </div>
    {submitButton}
|]

instance CanSelect Client where
    type SelectValue Client = Id Client
    selectValue client = get #id client
    selectLabel client = get #firstName client ++ " " ++ get #lastName client
