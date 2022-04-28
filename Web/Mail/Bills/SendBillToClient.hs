module Web.Mail.Bills.SendBillToClient where
import Web.View.Prelude
import IHP.MailPrelude

data SendBillToClientMail = SendBillToClientMail { bill :: Include' ["userId","clientId", "trips"] Bill, pdf :: LByteString }

instance BuildMail SendBillToClientMail where
    subject = "Your transport bill"

    -- TODO: fix email address
    to SendBillToClientMail { .. } = Address { addressName = Just (get #name client), addressEmail = "" }
        where client = get #clientId bill

    cc SendBillToClientMail { .. } = [
        Address { addressName = Just (get #name user), addressEmail = get #email user }
        ]
        where user = get #userId bill

    from = Address { addressName = Just "Tibilly Facturation", addressEmail = "factures@tibilly.fr" }

    html SendBillToClientMail { .. } = [hsx|
        Hello World
    |]

    attachments SendBillToClientMail { .. } = [
        -- TODO: use generated
        MailAttachment { name = "bill.pdf", contentType = "application/pdf", content = pdf}
        ]
