module Web.View.Bills.Index where
import Web.View.Prelude

data IndexView = IndexView { bills :: [Include "clientId" Bill]  }

instance View IndexView where
    html IndexView { .. } = [hsx|
        <h1>Mes factures<a href={pathTo NewBillAction} class="btn btn-primary ml-4">+ Nouvelle facture</a></h1>
        <div class="table-responsive">
            <table class="table">
                <tbody>{forEach bills renderBill}</tbody>
            </table>
        </div>
    |]

renderBill :: Include "clientId" Bill -> Html
renderBill bill = [hsx|
    <tr>
        <td><a href={ShowBillAction (get #id bill)}>{renderBillName bill}</a></td>
        <td>{get #name client}</td>
        <td><a href={DeleteBillAction (get #id bill)} class="js-delete text-muted" data-confirm="Êtes-vous sûr de vouloir supprimer cette facture ?">Supprimer</a></td>
    </tr>
|]
    where client = get #clientId bill
