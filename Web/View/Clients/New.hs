module Web.View.Clients.New where
import Web.View.Prelude
import Web.View.Clients.Render

data NewView = NewView { client :: Client }

instance View NewView where
    html NewView { .. } = [hsx|
        <h1>Ajouter un client</h1>
        {renderForm client}
    |]

renderForm :: Client -> Html
renderForm client = formFor client (clientForm client)
