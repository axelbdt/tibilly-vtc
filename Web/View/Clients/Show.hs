module Web.View.Clients.Show where
import Web.View.Prelude

data ShowView = ShowView { client :: Client }

instance View ShowView where
    html ShowView { .. } = [hsx|
        <h1>{get #name client}</h1>
        <p>{get #email client}</p>

    |]
