module Web.View.Clients.Render where
import Web.View.Prelude

clientForm client = [hsx|
    {(textField #name) { fieldLabel = "Nom", required = True }}
    {(textField #address){ fieldLabel = "Adresse", helpText = "facultatif" }}
    {(hiddenField #userId)}
    {submitButton}
|]

billClientForm client button = [hsx|
    <form method="post" action={pathTo CreateBillAction} class="d-inline">
        <input type="hidden" name="clientId" value={show (get #id client)}/>
        {button}
    </form>
|]
