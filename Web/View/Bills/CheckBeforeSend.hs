module Web.View.Bills.CheckBeforeSend where
import Web.View.Prelude

data CheckBeforeSendView = CheckBeforeSendView { bill :: Include "clientId" Bill }

instance View CheckBeforeSendView where
    html CheckBeforeSendView { .. } = [hsx|
        <h1>Vérifiez votre facture</h1>
        <p>Vérifiez votre facture avant envoi.</p>
        <p>Destinataire : {clientInfo}</p>
        <div class="w-100" style="height:40em">
          <iframe class="w-100 h-100" src={pathTo (GenerateBillPDFAction (get #id bill))} title="Bill" allowfullscreen></iframe>
        </div>
        <div class="d-flex justify-content-between mt-3">
        <a href={pathTo (ShowBillAction (get #id bill))} class="btn btn-outline-primary">Retour</a>
        {sendButton}
        </div>
        
        |]
            where
                sendButton = [hsx|
                    <a href={pathTo (SendBillAction (get #id bill))} class="btn btn-primary">Send</a>
                |]
                client = get #clientId bill
                clientInfo = [hsx| {getClientFullName client} ({get #email client}) |]
