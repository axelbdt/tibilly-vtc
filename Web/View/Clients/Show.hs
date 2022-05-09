module Web.View.Clients.Show where
import Web.View.Prelude

data ShowView = ShowView { client :: Include "bills" Client }

instance View ShowView where
    html ShowView { .. } = [hsx|
        <h1>{get #name client}</h1>
        <p>{get #address client}</p>
        
        <div class="table-responsive">
            <table class="table">
                <tbody>{forEach (get #bills client) renderBill}</tbody>
            </table>
        </div>

    |]

renderBill :: Bill -> Html
renderBill bill = [hsx|
    <tr>
        <td><a href={ShowBillAction (get #id bill)}>{renderBillName bill}</a></td>
        <td>
            <a href={DeleteBillAction (get #id bill)} alt="Supprimer" class="js-delete text-muted" data-confirm="Êtes-vous sûr de vouloir supprimer cette facture ?">
                <button class="btn btn-outline-secondary" type="button"><img src="icons/trash.svg" alt="Supprimer"/></button>
            </a>
        </td>
    </tr>
|]
    where client = get #clientId bill
