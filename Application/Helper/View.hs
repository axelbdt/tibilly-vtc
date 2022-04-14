module Application.Helper.View where

import Numeric
import qualified Data.Text as T
import Text.Printf

import IHP.ViewPrelude

-- Here you can add functions which are available in all your views
renderClientFullName client = get #firstName client ++ " " ++ get #lastName client

renderUserFullName user = get #firstName user ++ " " ++ get #lastName user

renderPrice :: Int -> Text
renderPrice price = T.pack $ printf "%.2f" (fromIntegral price :: Float)

renderDecimalPrice :: Float -> Text
renderDecimalPrice = T.pack . printf "%.2f"

renderUTCTime :: UTCTime -> Text
renderUTCTime = T.pack . formatTime  defaultTimeLocale "%D"

renderBillName bill = renderClientFullName (get #clientId bill) ++ " " ++ renderUTCTime (get #createdAt bill)

formFrame inner = [hsx|
    <div class="w-75 mx-auto border p-5 shadow rounded">
        {inner}
    </div>
|]
