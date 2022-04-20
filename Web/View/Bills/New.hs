module Web.View.Bills.New where
import Web.View.Prelude

data NewView = NewView { bill :: Bill, userClients :: [Client] }

instance View NewView where
    html NewView { .. } = [hsx|
        <h1>Nouvelle Facture</h1>
        {renderForm bill userClients}
    |]

renderForm :: Bill -> [Client] -> Html
renderForm bill userClients = formFor bill [hsx|
    {(hiddenField #userId)}
    <div class="d-flex flex-row justify-content-between">
        <div class="flex-fill pr-2">{(selectField #clientId userClients) { placeholder = "Sélectionner un client"}}</div>
        <div class="pb-3" style="padding-top:2em"><a class="btn btn-secondary" href={NewClientAction}>Nouveau Client</a></div>
    </div>
    {submitButton { label = "Valider" }}
|]

instance CanSelect Client where
    type SelectValue Client = Id Client
    selectValue client = get #id client
    selectLabel client = getClientFullName client ++ " - " ++ get #email client
