module Web.View.Clients.Render where
import Web.View.Prelude

clientForm client = [hsx|
    {(textField #name) { fieldLabel = "Nom", required = True }}
    {(textField #email){ fieldLabel = "E-mail", required = True }}
    {(textField #address){ fieldLabel = "Adresse (facultatif)" }}
    {(hiddenField #userId)}
    {submitButton}
|]
