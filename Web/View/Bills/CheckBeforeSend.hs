module Web.View.Bills.CheckBeforeSend where
import Web.View.Prelude

-- TODO: remove currentDay and use sentOn
data CheckBeforeSendView = CheckBeforeSendView { bill :: Include "clientId" Bill, billNumber :: Int }

instance View CheckBeforeSendView where
    html CheckBeforeSendView { .. } = [hsx|
        <h1>Vérifiez votre facture {billNumber}</h1>
        <p>Vérifiez votre facture avant envoi.</p>
        <p>Destinataire : {clientInfo}</p>
        <div class="w-100" style="height:40em">
            <iframe class="w-100 h-100" src={pathTo (GenerateBillPDFAction (get #id bill) billNumber sentOnText)} title="Bill" allowfullscreen></iframe>
        </div>
        {renderForm bill} 
        |]
            where
                client = get #clientId bill
                clientInfo = [hsx| {get #name client} ({get #email client}) |]
                sentOnText = maybe "" show (get #sentOn bill)


renderForm bill = formFor' bill (pathTo (SendBillAction (get #id bill))) [hsx|
    {numberField #number}
    <div class="d-flex justify-content-between mt-3">
        <a href={pathTo (ShowBillAction (get #id bill))} class="btn btn-outline-primary">Retour</a>
        {submitButton { label = "Envoyer"}}
    </div>

|]
