module Web.View.Clients.Render where
import Web.View.Prelude

clientForm client = [hsx|
    {(textField #email){ fieldLabel = "Adresse e-mail" }}
    {(textField #name) { fieldLabel = "Nom" }}
    {(hiddenField #userId)}
    {submitButton}
|]
