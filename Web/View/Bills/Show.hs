module Web.View.Bills.Show where
import Web.View.Prelude
import Web.View.Bills.Render
import Web.View.Trips.Render

data ShowView = ShowView { bill :: Include' ["clientId", "trips"] Bill, priceInfo :: PriceInfo }
 
instance View ShowView where
    html ShowView { .. } = [hsx|
        <h1>Facture</h1>
        <p>{get #name client}</p>

        <h2>Courses{addButton}</h2>
        {renderBody (get #trips bill) priceInfo}
        {sentInfo}
        {renderButtons bill}
    |]
        where
            client = get #clientId bill
            addButton = [hsx|<a href={pathTo (NewTripAction (get #id bill))} class="btn btn-primary ml-4">+ Ajouter</a>|]
            sentInfo = case get #sentOn bill of
                Just sentOn -> [hsx|<p class="text-center">Envoyée le {sentOn}</p>|]
                Nothing -> [hsx||]

renderButtons bill = [hsx|
        <div class="d-flex justify-content-between">
                <a href={pathTo BillsAction} class="btn btn-outline-primary">Retour</a>
                <a href={pathTo (DeleteBillAction (get #id bill))} class="btn btn-danger js-delete">Supprimer</a>
                {sendButton}
        </div>
        |]
        where sendButton = if null (get #trips bill) then
                [hsx| <a href="#" class="btn btn-primary disabled">Envoyer</a> |]
                else
                [hsx| <a href={pathTo (CheckBeforeSendBillAction (get #id bill))} class="btn btn-primary">Envoyer</a> |]


renderBody trips priceInfo = if null trips then
            [hsx|
                <p class="w-100 text-center">Aucune course sur cette facture, veuillez en ajouter une.</p>
            |]
        else
            [hsx|
                <div class="table-responsive">
                    <table class="table">
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
              edit = [hsx|<a href={EditTripAction (get #id trip)} class="text-muted">Modifier</a>|]
              delete = [hsx|<a href={DeleteTripAction (get #id trip)} class="js-delete text-muted">Supprimer</a>|]

