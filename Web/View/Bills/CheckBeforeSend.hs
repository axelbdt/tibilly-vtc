module Web.View.Bills.CheckBeforeSend where
import Web.View.Prelude

-- TODO: remove currentDay and use sentOn
data CheckBeforeSendView = CheckBeforeSendView { bill :: Bill }

instance View CheckBeforeSendView where
    html CheckBeforeSendView { .. } = [hsx|
        <script data-pdf-url={pdfUrl}>
            const pdfUrl = document.currentScript.dataset.pdfUrl;
            function share() {
              fetch(pdfUrl)
                .then(function(response) {
                  return response.blob()
                })
                .then(function(blob) {

                  var file = new File([blob], "picture.jpg", {type: 'image/jpeg'});
                  var filesArray = [file];

                  if(navigator.canShare && navigator.canShare({ files: filesArray })) {
                    navigator.share({
                      files: filesArray,
                    });
                  }
                  else {
                      console.log("Sharing is not supported.")
                    }
                })
            }
        </script>
        <h1>Téléchargez votre facture</h1>
        <div class="w-100 my-3" style="height:32em">
            <iframe class="w-100 h-100" src={pdfUrl} title="Bill" allowfullscreen></iframe>
        </div>
        {renderForm bill} 
        |]
            where
                sentOnText = maybe "" show (get #sentOn bill)
                billNumber = fromMaybe 0 (get #number bill)
                pdfUrl = pathTo (GenerateBillPDFAction (get #id bill) billNumber sentOnText)


renderForm bill = formFor' bill (pathTo (SendBillAction (get #id bill))) [hsx|
    {hiddenField #sentOn}
    {hiddenField #number}
    <div class="d-flex justify-content-between mt-3">
        <a href={pathTo (ShowBillAction (get #id bill))} class="btn btn-outline-primary">Retour</a>
        <button type="button" class="btn btn-primary" onclick="share()">Partager</button>
        {submitButton { label = "Enregistrer"}}
    </div>
|]
