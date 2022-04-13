module Web.Mail.Bills.SendBillToClient where
import Web.View.Prelude
import IHP.MailPrelude

data SendBillToClientMail = SendBillToClientMail { bill :: Include' ["clientId", "trips"] Bill, user :: User, pdf :: LByteString }

instance BuildMail SendBillToClientMail where
    subject = "Your transport bill"
    to SendBillToClientMail { .. } = Address { addressName = Just (renderClientFullName client), addressEmail = get #email client }
        where client = get #clientId bill
    cc SendBillToClientMail { .. } = [
        Address { addressName = Just (renderUserFullName user), addressEmail = get #email user }
        ]
    from = Address { addressName = Just "Tibilly Facturation", addressEmail = "factures@tibilly.fr" }
    html SendBillToClientMail { .. } = [hsx|
        Hello World
    |]

    attachments SendBillToClientMail { .. } = [
        MailAttachment { name = "bill.pdf", contentType = "application/pdf", content = pdf}
        ]
