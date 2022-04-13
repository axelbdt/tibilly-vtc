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

data SessionsController
    = NewSessionAction
    | CreateSessionAction
    | DeleteSessionAction
    deriving (Eq, Show, Data)

data UsersController
    = UsersAction
    | NewUserAction
    | ShowUserAction { userId :: !(Id User) }
    | CreateUserAction
    | EditUserAction { userId :: !(Id User) }
    | UpdateUserAction { userId :: !(Id User) }
    | DeleteUserAction { userId :: !(Id User) }
    deriving (Eq, Show, Data)

data BillsController
    = BillsAction
    | NewBillSelectClientPromptAction
    | ShowBillAction { billId :: !(Id Bill) }
    | CheckBeforeSendBillAction { billId :: !(Id Bill) }
    | NewBillSelectClientAction
    | EditBillAction { billId :: !(Id Bill) }
    | UpdateBillAction { billId :: !(Id Bill) }
    | DeleteBillAction { billId :: !(Id Bill) }
    | GenerateBillPDFAction { billId :: !(Id Bill) }
    | SendBillAction { billId :: !(Id Bill) }
    | SendBillSuccessAction { billId :: !(Id Bill) }
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
