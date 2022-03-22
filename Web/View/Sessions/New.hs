module Web.View.Sessions.New where
import IHP.AuthSupport.View.Sessions.New
import Web.View.Prelude

instance View (NewView User) where
    html NewView { .. } = [hsx|
        <div class="w-75 mx-auto border p-5 shadow rounded">
            <h1 class="text-center">Log in</h1>
            {renderForm user}
        </div>
    |]

renderForm :: User -> Html
renderForm user = [hsx|
    <form method="POST" action={CreateSessionAction}>
        <div class="form-group">
            <input name="email" value={get #email user} type="email" class="form-control" placeholder="E-Mail" required="required" autofocus="autofocus" />
        </div>
        <div class="form-group">
            <input name="password" type="password" class="form-control" placeholder="Password"/>
        </div>
        <button type="submit" class="btn btn-primary btn-block">Login</button>
    </form>
|]
