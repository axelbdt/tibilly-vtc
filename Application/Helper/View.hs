module Application.Helper.View where

import Numeric
import qualified Data.Text as T
import Text.Printf

import IHP.ViewPrelude

-- Here you can add functions which are available in all your views
renderClientFullName client = get #firstName client ++ " " ++ get #lastName client

renderPrice :: Int -> Text
renderPrice price = T.pack $ printf "%.2f" (fromIntegral price :: Float)

renderDecimalPrice :: Float -> Text
renderDecimalPrice = T.pack . printf "%.2f"

renderUTCTime :: UTCTime -> Text
renderUTCTime = T.pack . formatTime  defaultTimeLocale "%D"

renderBillName bill = renderClientFullName (get #clientId bill) ++ " " ++ renderUTCTime (get #createdAt bill)
