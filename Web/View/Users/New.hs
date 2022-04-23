module Web.View.Users.New where
import Web.View.Prelude

data NewView = NewView { user :: User }

instance View NewView where
    html NewView { .. } = [hsx|
            <h1 class="text-center">Inscription</h1>
            {renderForm user}
    |]

renderForm user = formFor user [hsx|
    {(textField #email) { fieldLabel = "Adresse e-mail" }}
    {(textField #name) { fieldLabel = "Nom de l'entreprise" }}
    {(textField #immatriculation) { fieldLabel = "SIREN ou SIRET" }}
    {(passwordField #passwordHash) {fieldLabel="Mot de passe"}}
    {(passwordField #passwordHash) {fieldName="passwordConfirm", fieldLabel="Confirmer le mot de passe"}}
    {submitButton {label =  "S'inscrire" }}
|]
