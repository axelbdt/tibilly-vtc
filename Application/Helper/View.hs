module Application.Helper.View where

import Numeric
import qualified Data.Text as T
import Text.Printf

import IHP.ViewPrelude

-- Here you can add functions which are available in all your views
getClientFullName client = get #firstName client ++ " " ++ get #lastName client

getUserFullName user = get #firstName user ++ " " ++ get #lastName user

renderPrice :: Int -> Text
renderPrice price = T.pack $ printf "%.2f" (fromIntegral price :: Float)

renderDecimalPrice :: Float -> Text
renderDecimalPrice = T.pack . printf "%.2f"

renderUTCTime :: UTCTime -> Text
renderUTCTime = T.pack . formatTime defaultTimeLocale "%F"

renderDay :: Day -> Text
renderDay = T.pack . formatTime defaultTimeLocale "%d/%m/%Y"

renderBillName bill = case get #sentAt bill of
    Nothing -> "Brouillon du " ++ (renderDay . utctDay $ get #createdAt bill)
    Just sentAt -> renderUTCTime sentAt

formFrame inner = [hsx|
    <div class="w-75 mx-auto border p-5 shadow rounded">
        {inner}
    </div>
|]
