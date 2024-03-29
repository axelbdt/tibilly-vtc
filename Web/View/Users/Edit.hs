module Web.View.Users.Edit where
import Web.View.Prelude

data EditView = EditView { user :: User, companyTypes :: [Text] }

instance View EditView where
    html EditView { .. } = [hsx|
        <h1 class="text-center">Mon Profil</h1>
        {renderForm user companyTypes}
    |]

renderForm user ct = formFor' user (pathTo UpdateCurrentUserAction) [hsx|
    <fieldset>
        <legend>Mon compte</legend>
        {(textField #email) { fieldLabel = "Adresse e-mail", required = True }}
        {(passwordField #passwordHash) {fieldLabel = "Mot de passe" }}
        {(passwordField #passwordHash) {fieldName = "passwordConfirm", fieldLabel="Confirmer le mot de passe"}}
    </fieldset>
    <fieldset>
        <legend>Mon entreprise</legend>
        <p>Ces informations apparaîtront sur vos factures</p>
        {(textField #name) { fieldLabel = "Nom de l'entreprise", required = True}}
        {(textField #immatriculation) { fieldLabel = "SIREN ou SIRET", required = True }}
        {(checkboxField #hasVatNumber) { fieldLabel = "J'ai un numéro de TVA", helpText = "Si vous cochez cette case, votre numéro de TVA sera déterminé à partir de votre SIREN/SIRET et apparaîtra dans vos factures." }}
        {(selectField #companyType (Nothing:(map Just ct))) { fieldLabel = "Type d'entreprise", helpText = "facultatif" }}
        {(numberField #capital) {fieldLabel = "Capital social (€)", helpText = "facultatif", additionalAttributes = [("min","0")] }}
        {(textField #address) {fieldLabel = "Adresse du siège social", helpText = "facultatif" }}
    </fieldset>
    {submitButton {label =  "Modifier" }}
|]

instance CanSelect (Maybe Text) where
    type SelectValue (Maybe Text) = Maybe Text
    selectValue (Just companyType) = Just companyType
    selectValue Nothing = Nothing
    selectLabel (Just companyType) = companyType
    selectLabel Nothing = "(non précisé)"
