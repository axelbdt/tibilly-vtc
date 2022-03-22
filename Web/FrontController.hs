module Web.FrontController where

import IHP.RouterPrelude
import IHP.LoginSupport.Middleware
import Web.Controller.Prelude
import Web.Controller.Sessions
import Web.View.Layout (defaultLayout)

-- Controller Imports
import Web.Controller.Users
import Web.Controller.Static

instance FrontController WebApplication where
    controllers = 
        [ startPage WelcomeAction
        , parseRoute @SessionsController
        -- Generator Marker
        , parseRoute @UsersController
        ]

instance InitControllerContext WebApplication where
    initContext = do
        setLayout defaultLayout
        initAutoRefresh
        initAuthentication @User
