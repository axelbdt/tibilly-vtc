module Web.View.Bills.Show where
import Web.View.Prelude
import Web.View.Bills.Render
import Web.View.Trips.Render

data ShowView = ShowView { bill :: Include' ["clientId", "trips"] Bill, priceInfo :: PriceInfo }
 
instance View ShowView where
    html ShowView { .. } = [hsx|
        <h1>Facture {renderBillNumber (get #sentOn bill) (get #number bill)}</h1>
        <p>{get #name client}</p>

        <h2>Courses{addButton}</h2>
        {renderBody (get #trips bill) priceInfo}
        {renderForm bill}
    |]
        where
            client = get #clientId bill
            addButton = [hsx|<a href={pathTo (NewTripAction (get #id bill))} class="btn btn-primary ml-4">+ Ajouter</a>|]

renderForm bill = formFor' bill (pathTo (CheckBillPDFAction (get #id bill))) [hsx|
    <script>
    $(document).on("ready turbolinks:load", () => {
        let optionsFieldset = $('#options')
        let displayLink = $('#displayOptions')
        let displayLinkContainer = $('#displayOptionsLinkContainer')
        
        optionsFieldset.hide()
        displayLinkContainer.show()
        displayLink.click(() => {
            optionsFieldset.show()
            displayLinkContainer.hide()
        })
    })
    </script>
    <p id="displayOptionsLinkContainer" class="text-center" style="display:None">
        <a id="displayOptions" href="#"  data-turbolinks="false">Modifier la date ou le numéro de facture.</a>
    </p>
    <fieldset id="options">
        {(dateField #sentOn) { fieldLabel = "Date de la facture" }}
        {(numberField #number) { fieldLabel = "Numéro de facture", helpText = "Numéro de facture ce mois-ci." }}
    </fieldset>
    <div class="d-flex justify-content-between mt-3">
        <a href={pathTo BillsAction} class="btn btn-outline-primary">Retour</a>
        <a href={pathTo (DeleteBillAction (get #id bill))} class="btn btn-danger js-delete" data-confirm="Êtes-vous sûr de vouloir supprimer cette facture ?">Supprimer</a>
        {submitButton { label = "Valider" }}
    </div>
|]

renderBody trips priceInfo = if null trips then
            [hsx|
                <p class="w-100 text-center">Aucune course sur cette facture, veuillez en ajouter une.</p>
            |]
        else
            [hsx|
                <div class="table-responsive">
                    <table class="table table-striped">
                        <thead>
                            <th>Départ</th>
                            <th>Arrivée</th>
                            <th>Date</th>
                            <th>Prix</th>
                            <th></th>
                        </thead>
                        <tbody>
                           {forEach trips renderTrip}
                        </tbody>
                        {renderPriceInfo priceInfo}
                    </table>
                </div>
         |]

renderTrip :: Trip -> Html
renderTrip trip = [hsx|
    <tr>
        <td>{(get #start trip) }</td>
        <td>{get #destination trip}</td>
        <td>{renderDay (get #date trip)}</td>
        <td>{renderPrice (get #price trip)}€</td>
        <td>{edit} {delete}</td>
    </tr>
|]
          where
              edit = [hsx|
                  <a href={EditTripAction (get #id trip)} class="text-muted" title="Modifier">
                      <button class="btn btn-outline-secondary" type="button"><img src="icons/pencil.svg" alt="Modifier"/></button>
                  </a>
              |]
              delete = [hsx|
                  <a href={DeleteTripAction (get #id trip)} title="Supprimer" class="js-delete" data-confirm="Êtes-vous sûr de vouloir supprimer cette course ?">
                      <button class="btn btn-outline-secondary" type="button"><img src="icons/trash.svg" alt="Supprimer"/></button>
                  </a>
              |]

