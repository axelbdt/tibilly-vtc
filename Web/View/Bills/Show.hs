module Web.View.Bills.Show where
import Web.View.Prelude
import Web.View.Bills.Render
import Web.View.Trips.Render

data ShowView = ShowView { bill :: Include' ["clientId", "trips"] Bill, priceInfo :: PriceInfo }
 
instance View ShowView where
    html ShowView { .. } = [hsx|
        <h1>Facture</h1>
        <p>{get #clientId bill |> renderClientFullName}</p>

        <h2>Courses<a href={pathTo (NewTripAction (get #id bill))} class="btn btn-secondary ml-4">+ Ajouter</a></h2>
        <div class="table-responsive">
            <table class="table">
                <tbody>{forEach (get #trips bill) renderTrip}</tbody>
                {renderPriceInfo priceInfo}
            </table>
        </div>
        <div class="d-flex justify-content-between">
            <div>
                <a href={pathTo BillsAction} class="btn btn-outline-primary">Retour</a>
            </div>
            <div>
                <a href={pathTo (DeleteBillAction (get #id bill))} class="btn btn-danger js-delete">Supprimer</a>
            </div>
            <div>
                <a href={pathTo (CheckBeforeSendBillAction (get #id bill))} class="btn btn-primary">Envoyer</a>
            </div>
        </div>

    |]
