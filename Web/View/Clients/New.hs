module Web.View.Clients.New where
import Web.View.Prelude

data NewView = NewView { client :: Client }

instance View NewView where
    html NewView { .. } = [hsx|
        <h1>Ajouter un client</h1>
        {renderForm client}
    |]

renderForm :: Client -> Html
renderForm client = formFor client [hsx|
    {(textField #email){ fieldLabel = "Adresse e-mail" }}
    {(textField #firstName) { fieldLabel = "Prénom" }}
    {(textField #lastName) { fieldLabel = "Nom" }}
    {(hiddenField #userId)}
    {submitButton}

|]
