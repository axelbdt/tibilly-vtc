module Web.View.Clients.Index where
import Web.View.Prelude
import Web.View.Clients.Render

data IndexView = IndexView { clients :: [Client] }

instance View IndexView where
    html IndexView { .. } = [hsx|
        <h1>Mes clients<a href={NewClientAction Nothing} class="btn btn-primary ml-4">+ Nouveau client</a></h1>
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
    billButton = billClientForm client [hsx|
        <button type="submit" title="Facturer" class="btn btn-outline-secondary">
            <img src="icons/receipt.svg" alt="Facturer"/>
        </button>
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
