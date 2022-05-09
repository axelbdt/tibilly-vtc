module Web.View.Clients.New where
import Web.View.Prelude
import Web.View.Clients.Render

data NewView = NewView { client :: Client, createBill :: Maybe Text }

instance View NewView where
    html NewView { .. } = [hsx|
        <h1>Ajouter un client</h1>
        {renderForm createBill client}
    |]

renderForm :: Maybe Text -> Client ->Html
renderForm createBill client = formFor' client (pathTo (CreateClientAction createBill)) [hsx|
    {(textField #name) { fieldLabel = "Nom", required = True }}
    {(textField #address){ fieldLabel = "Adresse", helpText = "facultatif" }}
    {(hiddenField #userId)}
    {submitButton}
|]
