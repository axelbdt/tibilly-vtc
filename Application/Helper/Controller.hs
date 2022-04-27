module Application.Helper.Controller where

import Application.Helper.Wkhtmltopdf
import Network.HTTP.Types (status200)
import Network.HTTP.Types.Header
import Network.Wai (responseLBS)

import IHP.ControllerPrelude

renderPDF view = do
    viewHtml <- renderHtml view 
    convertHtml viewHtml

renderPDFResponse fileName view = do
    pdfBytes <- renderPDF view
    respondAndExit $ responseLBS status200 [(hContentType, "application/pdf"),(hContentDisposition,"inline; filename=\"" ++ fileName ++ ".pdf\"")] pdfBytes

isGreaterOrEqualThan min value | value >= min = Success
isGreaterOrEqualThan min value = Failure "Doit être supérieur ou égal à 0"

frenchNonEmpty value = (nonEmpty |> withCustomErrorMessage "Champ obligatoire") value

frenchIsEmail = isEmail |> withCustomErrorMessage "Doit être un e-mail valide"

frenchHasMinLength length = hasMinLength length |> withCustomErrorMessage ("Doit avoir une longueur de " ++ show length ++ " charactères minimum")

frenchValidateIsUnique field = withCustomErrorMessageIO "Cet e-mail est déjà utilisé" validateIsUnique field

getCurrentDay :: IO Day
getCurrentDay = fmap utctDay getCurrentTime

isSent bill = isJust (get #sentOn bill)
