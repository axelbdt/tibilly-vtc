module Application.Helper.View where

import IHP.ViewPrelude

-- Here you can add functions which are available in all your views
getClientFullName client = get #firstName client ++ " " ++ get #lastName client

