module Web.View.Clients.Index where
import Web.View.Prelude

data IndexView = IndexView { clients :: [Client]  }

instance View IndexView where
    html IndexView { .. } = [hsx|
        {breadcrumb}

        <h1>Index<a href={pathTo NewClientAction} class="btn btn-primary ml-4">+ New</a></h1>
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
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Clients" ClientsAction
                ]

renderClient :: Client -> Html
renderClient client = [hsx|
    <tr>
        <td><a href={ShowClientAction (get #id client)}>{get #firstName client} {get #lastName client}</a></td>
        <td><a href={EditClientAction (get #id client)} class="text-muted">Edit</a></td>
        <td><a href={DeleteClientAction (get #id client)} class="js-delete text-muted">Delete</a></td>
    </tr>
|]
