module Web.View.Users.New where
import Web.View.Prelude

data NewView = NewView { user :: User }

instance View NewView where
    html NewView { .. } = [hsx|
        <div class="w-75 mx-auto border p-5 shadow rounded">
            <h1 class="text-center">Sign up</h1>
            {renderForm user}
        </div>
    |]

renderForm :: User -> Html
renderForm user = formFor user [hsx|
    {(textField #email)}
    <div class="d-flex justify-content-between">
        <div class="pr-2 flex-fill">{(textField #firstName)}</div>
        <div class="pl-2 flex-fill">{(textField #lastName)}</div>
    </div>
    <div class="d-flex justify-content-between">
        <div class="pr-2 flex-fill">{(passwordField #passwordHash) {fieldLabel="Password"}}</div>
        <div class="pl-2 flex-fill">{(passwordField #passwordHash) {fieldName="passwordConfirm", fieldLabel="Confirm Password"}}</div>
    </div>
    <div class="text-center">
        {submitButton {label="Sign up", buttonClass="btn-block"}}
    </div>
|]