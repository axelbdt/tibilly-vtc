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
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <th>Départ</th>
                    <th>Arrivée</th>
                    <th>Date</th>
                    <th>Prix</th>
                </thead>
                <tbody>{forEach (get #trips bill) (renderTrip billNotSent)}</tbody>
                {renderPriceInfoShow priceInfo}
            </table>
        </div>
        <div class="d-flex justify-content-between">
                <a href={pathTo (DeleteBillAction (get #id bill))} class="btn btn-danger js-delete">Supprimer</a>
                {sendButton}
        </div>
    |]
        where
            client = get #clientId bill
            billNotSent = isNothing (get #sentOn bill)
            sendButton = case get #sentOn bill of
                Nothing -> [hsx|<a href={pathTo (CheckBeforeSendBillAction (get #id bill))} class="btn btn-primary">Envoyer</a>|]
                Just sentOn -> [hsx|Envoyée le {renderDay sentOn}|]
            addButton = case get #sentOn bill of
                Nothing -> [hsx|<a href={pathTo (NewTripAction (get #id bill))} class="btn btn-secondary ml-4">+ Ajouter</a>|]
                Just _ -> [hsx||]
