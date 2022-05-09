module Web.View.Clients.Index where
import Web.View.Prelude

data IndexView = IndexView { clients :: [Client] }

instance View IndexView where
    html IndexView { .. } = [hsx|
        <h1>Mes clients</h1>
        <div class="table-responsive">
            <table class="table">
                <tbody>{forEach clients renderClient}</tbody>
            </table>
            
        </div>
    |]

renderClient :: Client -> Html
renderClient client = [hsx|
    <tr>
        <td><a href={ShowClientAction (get #id client)}>{get #name client}</a></td>
        <td>{billButton} {editButton} {deleteButton}</td>
    </tr>
|]
    where
    billButton = [hsx|
        {renderForm client}
    |]
    editButton = [hsx|
    <a href={EditClientAction (get #id client)} title="Modifier">
        <button class="btn btn-outline-secondary"><img src="icons/pencil.svg" alt="Modifier"/></button>
    </a> 
    |]
    deleteButton = [hsx|
    <a href={DeleteClientAction (get #id client)} title="Supprimer" class="js-delete text-muted" data-confirm="Toutes les factures associées à ce client seront supprimées. Voulez-vous continuer ?">
        <button class="btn btn-outline-secondary"><img src="icons/trash.svg" alt="Supprimer" /></button>
    </a>
    |]

renderForm :: Client -> Html
renderForm client = [hsx|
    <form method="post" action={pathTo CreateBillAction} class="d-inline">
        <input type="hidden" name="clientId" value={theId}/>
        <button type="submit" title="Facturer" class="btn btn-outline-secondary">
            <img src="icons/receipt.svg" alt="Facturer"/>
        </button>
    </form>
|]
    where theId = show (get #id client)
