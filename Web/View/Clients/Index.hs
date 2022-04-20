module Web.View.Clients.Index where
import Web.View.Prelude

data IndexView = IndexView { clients :: [Client]  }

instance View IndexView where
    html IndexView { .. } = [hsx|
        <h1>Mes clients</h1>
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>Client</th>
                        <th></th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>{forEach clients renderClient}</tbody>
            </table>
            
        </div>
    |]

renderClient :: Client -> Html
renderClient client = [hsx|
    <tr>
        <td><a href={EditClientAction (get #id client)}>{get #name client}</a></td>
        <td><a href={EditClientAction (get #id client)} class="text-muted">Modifier</a></td>
        <td><a href={DeleteClientAction (get #id client)} class="js-delete text-muted" data-confirm="Toutes les factures associées à ce client seront supprimées. Voulez-vous continuer ?">Supprimer</a></td>
    </tr>
|]
