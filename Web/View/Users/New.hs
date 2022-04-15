module Web.View.Users.New where
import Web.View.Prelude
import Web.View.Users.Render (renderForm)

data NewView = NewView { user :: User }

instance View NewView where
    html NewView { .. } = [hsx|
            <h1 class="text-center">Inscription</h1>
            {renderForm user "S'inscrire"}
    |]

