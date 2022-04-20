module Web.View.Users.Render where
import Web.View.Prelude

userForm user buttonLabel = formFor user [hsx|
    {(textField #email) { fieldLabel = "Adresse e-mail" }}
    {(textField #name) { fieldLabel = "Nom" }}
    {(textField #immatriculation) { fieldLabel = "SIREN ou SIRET" }}
    {(passwordField #passwordHash) {fieldLabel="Mot de passe"}}
    {(passwordField #passwordHash) {fieldName="passwordConfirm", fieldLabel="Confirmer le mot de passe"}}
    {submitButton {label = buttonLabel }}
|]
