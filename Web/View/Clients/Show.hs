module Web.View.Clients.Show where
import Web.View.Prelude

data ShowView = ShowView { client :: Client }

instance View ShowView where
    html ShowView { .. } = [hsx|
        {breadcrumb}
        <h1>{get #firstName client} {get #lastName client}</h1>
        <p>{get #email client}</p>

    |]
        where
            breadcrumb = renderBreadcrumb
                            [ breadcrumbLink "Clients" ClientsAction
                            , breadcrumbText "Show Client"
                            ]
