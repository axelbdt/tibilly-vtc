module Web.View.Sessions.New where
import IHP.AuthSupport.View.Sessions.New
import Web.View.Prelude

instance View (NewView User) where
    html NewView { .. } = [hsx|
            <h1 class="text-center">Connexion</h1>
            {renderForm user}
    |]

renderForm :: User -> Html
renderForm user = [hsx|
    <form method="POST" action={CreateSessionAction}>
        <div class="form-group">
            <input name="email" value={get #email user} type="email" class="form-control" placeholder="E-Mail" required="required" autofocus="autofocus" />
        </div>
        <div class="form-group">
            <input name="password" type="password" class="form-control" placeholder="Mot de passe"/>
        </div>
        <button type="submit" class="btn btn-primary">Se connecter</button>
    </form>
|]
