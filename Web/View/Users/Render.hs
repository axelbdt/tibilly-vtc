module Web.View.Users.Render where
import Web.View.Prelude

renderForm user buttonLabel = formFor user [hsx|
    {(textField #email) { fieldLabel = "Adresse e-mail" }}
    <div class="d-flex justify-content-between">
        <div class="pr-2 flex-fill">{(textField #firstName) { fieldLabel = "Prénom" }}</div>
        <div class="pl-2 flex-fill">{(textField #lastName) { fieldLabel = "Nom" }}</div>
    </div>
    <div class="d-flex justify-content-between">
        <div class="pr-2 flex-fill">{(passwordField #passwordHash) {fieldLabel="Mot de passe"}}</div>
        <div class="pl-2 flex-fill">{(passwordField #passwordHash) {fieldName="passwordConfirm", fieldLabel="Confirmer le mot de passe"}}</div>
    </div>
    <div class="text-center">
        {submitButton {label = buttonLabel, buttonClass = "btn-block"}}
    </div>
|]
