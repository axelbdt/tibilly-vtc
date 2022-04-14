module Web.View.Users.Edit where
import Web.View.Prelude
import Web.View.Users.Render (renderForm)

data EditView = EditView { user :: User }

instance View EditView where
    html EditView { .. } = formFrame [hsx|
        <h1>Mon compte</h1>
        {renderForm user "Modifier"}
    |]
