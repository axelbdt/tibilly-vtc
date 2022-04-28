module Web.View.Clients.Render where
import Web.View.Prelude

clientForm client = [hsx|
    {(textField #name) { fieldLabel = "Nom", required = True }}
    {(textField #address){ fieldLabel = "Adresse", helpText = "facultatif" }}
    {(hiddenField #userId)}
    {submitButton}
|]
