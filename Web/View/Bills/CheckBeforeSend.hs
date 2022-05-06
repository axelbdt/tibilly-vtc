module Web.View.Bills.CheckBeforeSend where
import Web.View.Prelude

-- TODO: remove currentDay and use sentOn
data CheckBeforeSendView = CheckBeforeSendView { bill :: Bill }

instance View CheckBeforeSendView where
    html CheckBeforeSendView { .. } = [hsx|
        <h1>Téléchargez votre facture</h1>
        <div class="w-100 my-3" style="height:32em">
            <iframe class="w-100 h-100" src={pathTo (GenerateBillPDFAction (get #id bill) billNumber sentOnText)} title="Bill" allowfullscreen></iframe>
        </div>
        {renderForm bill} 
        |]
            where
                sentOnText = maybe "" show (get #sentOn bill)
                billNumber = fromMaybe 0 (get #number bill)


renderForm bill = formFor' bill (pathTo (SendBillAction (get #id bill))) [hsx|
    {hiddenField #sentOn}
    {hiddenField #number}
    <div class="d-flex justify-content-between mt-3">
        <a href={pathTo (ShowBillAction (get #id bill))} class="btn btn-outline-primary">Retour</a>
        {submitButton { label = "Enregistrer"}}
    </div>

|]
