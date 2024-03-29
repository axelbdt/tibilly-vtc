module Web.Controller.Users where

import Web.Controller.Prelude
import Web.View.Users.New
import Web.View.Users.Edit

import qualified Data.Text as T
import Data.Char

instance Controller UsersController where
    action NewUserAction = do
        let user = newRecord
        render NewView { .. }

    action ShowCurrentUserAction = do
        ensureIsUser
        user <- fetch currentUserId
                    |> fmap (set #passwordHash "")
        let companyTypes = companyTypeList
        render EditView { .. }

    action UpdateCurrentUserAction = do
        ensureIsUser
        user <- fetch currentUserId
        if param @Text "passwordHash" == "" then do
            user
                |> buildUpdatedUser
                >>= ifValid \case
                    Left user -> do
                        let companyTypes = companyTypeList
                        render EditView { .. }
                    Right user -> do
                        user <- user
                            |> updateRecord
                        setSuccessMessage "Profil modifié"
        else do
            user
                |> buildUser
                >>= ifValid \case
                    Left user -> do
                        let companyTypes = companyTypeList
                        render EditView { .. }
                    Right user -> do
                        hashed <- hashPassword  (get #passwordHash user)
                        user <- user
                            |> set #passwordHash hashed
                            |> updateRecord
                        setSuccessMessage "Profil et mot de passe modifiés"
        redirectTo ShowCurrentUserAction

    action CreateUserAction = do
    {-
        setErrorMessage "Inscription momentanément désactivée, désolé!"
        redirectTo NewSessionAction
    -}
    -- {-
        let user = newRecord @User
        user
            |> buildUser
            >>= ifValid \case
                Left user -> render NewView { .. } 
                Right user -> do
                    hashed <- hashPassword  (get #passwordHash user)
                    user <- user
                        |> set #passwordHash hashed
                        |> createRecord
                    setSuccessMessage "Votre compte a été créé, vous pouvez vous identifier"
                    redirectTo NewSessionAction
    -- -}


-- TODO: translate error messages
buildUser user = user
    |> fill @["email","name","immatriculation","passwordHash","failedLoginAttempts"]
    |> validateField #email frenchIsEmail
    |> validateField #name frenchNonEmpty
    |> validateImmatriculationField
    |> validatePasswordField
    |> frenchValidateIsUnique #email

buildUpdatedUser user = user
    |> fill @["email","name","immatriculation","hasVatNumber","companyType","capital","address","failedLoginAttempts"]
    |> emptyValueToNothing #companyType
    |> emptyValueToNothing #address
    |> validateField #email frenchIsEmail
    |> validateField #name frenchNonEmpty
    |> validateImmatriculationField
    |> validateField #capital (maybe Success (isGreaterOrEqualThan 0))
    -- --|> validateField #companyType (maybe Success (isInList companyTypeList))
    |> frenchValidateIsUnique #email

validateImmatriculationField user = user
    |> set #immatriculation cleanImmatriculation
    |> validateField #immatriculation frenchNonEmpty
    |> validateField #immatriculation isSiretOrSiren 
    where
        cleanImmatriculation = T.replace " " "" (get #immatriculation user)

isSiretOrSiren :: Text -> ValidatorResult
isSiretOrSiren immatriculation =
    if T.all isDigit immatriculation && (T.length immatriculation == 9 || T.length immatriculation == 14)
      then Success
    else Failure "Entrez un SIRET (14 chiffres) ou un SIREN (9 chiffres) valide"

validatePasswordField user = user
    |> validateField #passwordHash frenchNonEmpty
    |> validateField #passwordHash (frenchHasMinLength 8)
    |> validateField #passwordHash (passwordMatch (param "passwordConfirm"))

passwordMatch pw1 pw2 =
    if pw1 == pw2
        then Success
        else Failure "Les mots de passe ne correspondent pas"

companyTypeList = ["Auto-entrepreneur","EIRL","EURL","SNC","SA","SARL","SAS","SASU"]
