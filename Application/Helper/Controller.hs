module Application.Helper.Controller where

import IHP.ControllerPrelude
import Application.Helper.Wkhtmltopdf
import Network.HTTP.Types (status200)
import Network.HTTP.Types.Header
import Network.Wai (responseLBS)

 
renderPdf view = do
    billHtml <- renderHtml view
    pdfBytes <- convertHtml billHtml
    respondAndExit $ responseLBS status200 [(hContentType, "application/pdf")] pdfBytes


-- Here you can add functions which are available in all your controllers
