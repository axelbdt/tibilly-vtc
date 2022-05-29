module Web.Controller.Clients where

import Web.Controller.Prelude
import Web.Controller.Bills
import Web.View.Clients.Index
import Web.View.Clients.New
import Web.View.Clients.Edit
import Web.View.Clients.Show

instance Controller ClientsController where
    beforeAction = ensureIsUser

    action ClientsAction = do
        clients <- query @Client
            |> filterWhere (#userId, currentUserId)
            |> orderBy #name
            |> fetch
        render IndexView { .. }

    action NewClientAction { createBill } = do
        let client = newRecord
        render NewView { .. }

    action ShowClientAction { clientId } = do
        client <- fetch clientId
            >>= pure . modify #bills (orderByDesc #createdAt)
            >>= fetchRelated #bills
        accessDeniedUnless (currentUserId == get #userId client)
        render ShowView { .. }

    action EditClientAction { clientId } = do
        client <- fetch clientId
        accessDeniedUnless (currentUserId == get #userId client)
        render EditView { .. }

    action UpdateClientAction { clientId } = do
        client <- fetch clientId
        accessDeniedUnless (currentUserId == get #userId client)
        client
            |> buildClient
            |> ifValid \case
                Left client -> render EditView { .. }
                Right client -> do
                    client <- client |> updateRecord
                    setSuccessMessage "Client modifié"
                    redirectTo ClientsAction

    action CreateClientAction { createBill }= do
        let client = newRecord @Client
        client
            |> buildClient
            |> ifValid \case
                Left client -> render NewView { .. } 
                Right client -> do
                    client <- client
                        |> createRecord
                    case createBill of
                        Just _ -> do
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
                        Nothing -> do
                            setSuccessMessage "Client créé."
                            redirectTo ClientsAction
                        

    action DeleteClientAction { clientId } = do
        client <- fetch clientId
        accessDeniedUnless (currentUserId == get #userId client)
        deleteRecord client
        setSuccessMessage "Client supprimé"
        redirectTo ClientsAction

buildClient client = client
    |> fill @["name","address","userId"]
    |> emptyValueToNothing #address
    |> set #userId currentUserId
    |> validateField #name frenchNonEmpty
