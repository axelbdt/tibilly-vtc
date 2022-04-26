module Application.Helper.View where

import Numeric
import qualified Data.Text as T
import Data.Text.Read
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
    Just _ -> renderBillNumber (get #sentOn bill) (get #number bill)

renderBillNumber sentOn number = case sentOn of
    Nothing -> ""
    Just sentOn ->
        case number of
            Nothing -> ""
            Just number -> T.pack (formatTime defaultTimeLocale "%Y%m" sentOn) ++ "-" ++ show number

vatNumberFromImmatriculation immatriculationNumber =
    "FR" ++ key ++ siren
    where
        siren = T.take 9 immatriculationNumber
        key = T.pack $ printf "%d" (mod (12 + 3 * mod sirenAsInt 97) 97)
        sirenAsInt = case decimal siren of
            Right (val, _) -> val :: Int
            Left _         -> 0 :: Int
            
        


