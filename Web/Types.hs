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
    | CheckBeforeSendBillAction { billId :: !(Id Bill) }
    | DeleteBillAction { billId :: !(Id Bill) }
    | GenerateBillPDFAction { billId :: !(Id Bill) }
    | SendBillAction { billId :: !(Id Bill) }
    | CreateBillAction
    deriving (Eq, Show, Data)

data ClientsController
    = ClientsAction
    | NewClientAction
    | ShowClientAction { clientId :: !(Id Client) }
    | CreateClientAction
    | EditClientAction { clientId :: !(Id Client) }
    | UpdateClientAction { clientId :: !(Id Client) }
    | DeleteClientAction { clientId :: !(Id Client) }
    deriving (Eq, Show, Data)

data TripsController
    = NewTripAction { billId :: !(Id Bill) }
    | NewTripFromClientAction { clientId :: !(Id Client) }
    | CreateTripAction
    | CreateTripAndBillAction { clientId :: !(Id Client) }
    | EditTripAction { tripId :: !(Id Trip) }
    | UpdateTripAction { tripId :: !(Id Trip) }
    | DeleteTripAction { tripId :: !(Id Trip) }
    deriving (Eq, Show, Data)
