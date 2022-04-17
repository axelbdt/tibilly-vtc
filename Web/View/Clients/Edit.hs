module Web.View.Clients.Edit where
import Web.View.Prelude
import Web.View.Clients.Render

data EditView = EditView { client :: Client }

instance View EditView where
    html EditView { .. } = [hsx|
        <h1>Modifier le client</h1>
        {renderForm client}
    |]

renderForm :: Client -> Html
renderForm client = formFor client (clientForm client)
