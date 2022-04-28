module Web.View.Clients.Index where
import Web.View.Prelude

data IndexView = IndexView { clients :: [Client]  }

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
        <td><a href={EditClientAction (get #id client)}>{get #name client}</a></td>
        <td>{edit} {delete}</td>
    </tr>
|]
    where
    edit = [hsx|
    <a href={EditClientAction (get #id client)} class="text-muted">
        <button class="btn btn-outline-secondary" type="button"><img src="icons/pencil.svg" alt="Modifier"/></button>
    </a> 
    |]
    delete = [hsx|
    <a href={DeleteClientAction (get #id client)} class="js-delete text-muted" data-confirm="Toutes les factures associées à ce client seront supprimées. Voulez-vous continuer ?">
        <button class="btn btn-outline-secondary" type="button"><img src="icons/trash.svg" alt="Supprimer"/></button>
    </a>
    |]
