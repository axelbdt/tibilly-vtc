module Application.Helper.View where

import Numeric
import qualified Data.Text as T
import Text.Printf

import IHP.ViewPrelude

-- Here you can add functions which are available in all your views
getClientFullName client = get #firstName client ++ " " ++ get #lastName client

renderPrice :: Int -> Text
renderPrice price = T.pack $ printf "%.2f" (fromIntegral price :: Float)

renderDecimalPrice :: Float -> Text
renderDecimalPrice = T.pack . printf "%.2f" 
