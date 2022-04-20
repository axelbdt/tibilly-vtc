module Web.Controller.Clients where

import Web.Controller.Prelude
import Web.Controller.Bills
import Web.View.Clients.Index
import Web.View.Clients.New
import Web.View.Clients.Edit
import Web.View.Clients.Show

instance Controller ClientsController where
    action ClientsAction = do
        ensureIsUser
        clients <- query @Client |> fetch
        render IndexView { .. }

    action NewClientAction = do
        ensureIsUser
        let client = newRecord
        render NewView { .. }

    action ShowClientAction { clientId } = do
        client <- fetch clientId
        render ShowView { .. }

    action EditClientAction { clientId } = do
        client <- fetch clientId
        render EditView { .. }

    action UpdateClientAction { clientId } = do
        client <- fetch clientId
        client
            |> buildClient
            |> ifValid \case
                Left client -> render EditView { .. }
                Right client -> do
                    client <- client |> updateRecord
                    setSuccessMessage "Client modifié"
                    redirectTo ClientsAction

    action CreateClientAction = do
        ensureIsUser
        -- paramOrDefault @Bool False "createBill"
        let client = newRecord @Client
        client
            |> buildClient
            |> ifValid \case
                Left client -> render NewView { .. } 
                Right client -> do
                    client <- client
                        |> createRecord
                    let bill = newRecord @Bill
                    bill
                        |> set #clientId (get #id client)
                        |> buildBill
                        >>= ifValid \case
                            Left bill -> do
                                userClients <- query @Client
                                    |> filterWhere (#userId, currentUserId)
                                    |> fetch
                                render NewView { .. } 
                            Right bill -> do
                                bill <- bill |> createRecord
                                setSuccessMessage "Client et facture créés, ajoutez une course."
                                redirectTo (NewTripAction (get #id bill))

    action DeleteClientAction { clientId } = do
        client <- fetch clientId
        deleteRecord client
        setSuccessMessage "Client supprimé"
        redirectTo ClientsAction

buildClient client = client
    |> fill @["email","firstName","lastName","userId"]
    |> set #userId currentUserId
    |> validateField #email isEmail
    |> validateField #firstName frenchNonEmpty
    |> validateField #lastName frenchNonEmpty
