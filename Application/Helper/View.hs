module Application.Helper.View where

import Numeric
import qualified Data.Text as T
import Text.Printf

import IHP.ViewPrelude

renderPrice :: Int -> Text
renderPrice price = T.pack $ printf "%.2f" (fromIntegral price :: Float)

renderDecimalPrice :: Float -> Text
renderDecimalPrice = T.pack . printf "%.2f"

renderDay :: Day -> Text
renderDay = T.pack . formatTime defaultTimeLocale "%d/%m/%Y"

renderBillName bill = case get #sentOn bill of
    Nothing -> "Brouillon du " ++ (renderDay . utctDay $ get #createdAt bill)
    Just sentOn -> get #number bill
