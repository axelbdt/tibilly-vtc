module Web.Mail.Bills.SendBillToClient where
import Web.View.Prelude
import IHP.MailPrelude

data SendBillToClientMail = SendBillToClientMail { bill :: Include' ["userId","clientId", "trips"] Bill, pdf :: LByteString }

instance BuildMail SendBillToClientMail where
    subject = "Your transport bill"
    to SendBillToClientMail { .. } = Address { addressName = Just (getClientFullName client), addressEmail = get #email client }
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
        MailAttachment { name = "bill.pdf", contentType = "application/pdf", content = pdf}
        ]
