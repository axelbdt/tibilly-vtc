module Application.Helper.Controller where

import Application.Helper.Wkhtmltopdf
import Network.HTTP.Types (status200)
import Network.HTTP.Types.Header
import Network.Wai (responseLBS)

import IHP.ControllerPrelude

renderPDF view = do
    viewHtml <- renderHtml view 
    convertHtml viewHtml

renderPDFResponse view = do
    pdfBytes <- renderPDF view
    respondAndExit $ responseLBS status200 [(hContentType, "application/pdf")] pdfBytes

frenchNonEmpty value = (nonEmpty |> withCustomErrorMessage "Veuillez remplir ce champ") value

getCurrentDay :: IO Day
getCurrentDay = fmap utctDay getCurrentTime

isSent bill = isJust (get #sentOn bill)
