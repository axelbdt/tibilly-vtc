module Web.Types where

import Generated.Types
import IHP.LoginSupport.Types
import IHP.ModelSupport
import IHP.Prelude

data WebApplication = WebApplication deriving (Eq, Show)

data StaticController = WelcomeAction deriving (Eq, Show, Data)

instance HasNewSessionUrl User where
    newSessionUrl _ = "/NewSession"

type instance CurrentUserRecord = User

data PriceInfo  = PriceInfo { includingTax :: Int, excludingTax :: Float, taxAmount :: Float}

data SessionsController
    = NewSessionAction
    | CreateSessionAction
    | DeleteSessionAction
    deriving (Eq, Show, Data)

data UsersController
    = NewUserAction
    | CreateUserAction
    | ShowCurrentUserAction
    | UpdateCurrentUserAction
    deriving (Eq, Show, Data)

data BillsController
    = BillsAction
    | NewBillAction 
    | ShowBillAction { billId :: !(Id Bill) }
    | CheckBillPDFAction { billId :: !(Id Bill) }
    | DeleteBillAction { billId :: !(Id Bill) }
    | GenerateBillPDFAction { billId :: !(Id Bill), billNumber :: Int, sentOnText :: Text }
    | CreateBillAction
    deriving (Eq, Show, Data)

data ClientsController
    = ClientsAction
    | NewClientAction { createBill :: Maybe Text }
    | ShowClientAction { clientId :: !(Id Client) }
    | CreateClientAction { createBill :: Maybe Text }
    | EditClientAction { clientId :: !(Id Client) }
    | UpdateClientAction { clientId :: !(Id Client) }
    | DeleteClientAction { clientId :: !(Id Client) }
    deriving (Eq, Show, Data)

data TripsController
    = NewTripAction { billId :: !(Id Bill) }
    | CreateTripAction
    | EditTripAction { tripId :: !(Id Trip) }
    | UpdateTripAction { tripId :: !(Id Trip) }
    | DeleteTripAction { tripId :: !(Id Trip) }
    deriving (Eq, Show, Data)
