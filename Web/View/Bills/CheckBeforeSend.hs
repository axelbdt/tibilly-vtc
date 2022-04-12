module Web.View.Bills.CheckBeforeSend where
import Web.View.Prelude

data CheckBeforeSendView = CheckBeforeSendView { bill :: Bill }

instance View CheckBeforeSendView where
    html CheckBeforeSendView { .. } = [hsx|
        {breadcrumb}
        <div class="d-flex justify-content-between">
        <h1>Check your bill</h1>
        <div class="ml-auto align-self-center">{sendButton}</div>
        </div>
        <div class="w-100" style="height:40em">
          <iframe class="w-100 h-100" src={pathTo (GenerateBillPDFAction (get #id bill))} title="Bill" allowfullscreen></iframe>
        </div>
        |]
            where
                breadcrumb = renderBreadcrumb
                                [ breadcrumbLink "Bills" BillsAction
                                , breadcrumbLink "Show Bill" (ShowBillAction (get #id bill))
                                , breadcrumbText "Check Bill"
                                ]
                sendButton = [hsx|
                    <a href={pathTo SendBillAction} class="btn btn-primary">Send</a>
                |]
