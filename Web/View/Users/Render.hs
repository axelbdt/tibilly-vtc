module Web.View.Users.Render where
import Web.View.Prelude

renderForm user buttonLabel = formFor user [hsx|
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
        {submitButton {label=buttonLabel, buttonClass="btn-block"}}
    </div>
|]
