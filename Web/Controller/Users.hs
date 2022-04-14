module Web.Controller.Users where

import Web.Controller.Prelude
import Web.View.Users.Index
import Web.View.Users.New
import Web.View.Users.Edit

instance Controller UsersController where
    action UsersAction = do
        users <- query @User |> fetch
        render IndexView { .. }

    action NewUserAction = do
        let user = newRecord
        render NewView { .. }

    action EditUserAction { userId } = do
        user <- fetch userId
        let user = user |> set #passwordHash ""
        render EditView { .. }

    action UpdateUserAction { userId } = do
        user <- fetch userId
        user
            |> buildUser
            |> ifValid \case
                Left user -> render NewView { .. }
                Right user -> do
                    hashed <- hashPassword  (get #passwordHash user)
                    user <- user
                        |> set #passwordHash hashed
                        |> createRecord
                    setSuccessMessage ""
                    redirectTo NewSessionAction

    action CreateUserAction = do
    -- {-
        setErrorMessage "Sign up is disabled, sorry!"
        redirectTo NewSessionAction
    -- -}
    {-
        let user = newRecord @User
        user
            |> buildUser
            |> ifValid \case
                Left user -> render NewView { .. } 
                Right user -> do
                    hashed <- hashPassword  (get #passwordHash user)
                    user <- user
                        |> set #passwordHash hashed
                        |> createRecord
                    setSuccessMessage "You have successfully registered"
                    redirectTo NewSessionAction
    -}

    action DeleteUserAction { userId } = do
        user <- fetch userId
        deleteRecord user
        setSuccessMessage "User deleted"
        redirectTo UsersAction

buildUser user = user
    |> fill @["email","firstName","lastName","passwordHash","failedLoginAttempts"]
    |> validateField #email isEmail
    |> validateField #firstName nonEmpty
    |> validateField #lastName nonEmpty
    |> validateField #passwordHash nonEmpty
    |> validateField #passwordHash (hasMinLength 8)
    |> validateField #passwordHash (passwordMatch (param "passwordConfirm"))

passwordMatch pw1 pw2 = if pw1 == pw2
        then Success
        else Failure "The passwords don't match"
