module Web.View.Users.Edit where
import Web.View.Prelude
import Web.View.Users.Render (userForm)

data EditView = EditView { user :: User }

instance View EditView where
    html EditView { .. } = [hsx|
        <h1 class="text-center">Mon compte</h1>
        {renderForm user "Modifier"}
    |]

renderForm user buttonLabel = formFor' user (pathTo UpdateCurrentUserAction) (userForm user "Modifier")
