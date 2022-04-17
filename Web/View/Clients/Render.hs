module Web.View.Clients.Render where
import Web.View.Prelude

clientForm client = [hsx|
    {(textField #email){ fieldLabel = "Adresse e-mail" }}
    {(textField #firstName) { fieldLabel = "Prénom" }}
    {(textField #lastName) { fieldLabel = "Nom" }}
    {(hiddenField #userId)}
    {submitButton}
|]
