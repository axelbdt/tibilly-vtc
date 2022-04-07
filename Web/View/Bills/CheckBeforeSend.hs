module Web.View.Bills.CheckBeforeSend where
import Web.View.Prelude
data CheckBeforeSendView = CheckBeforeSendView { bill :: Bill }

instance View CheckBeforeSendView where
    html CheckBeforeSendView { .. } = [hsx|
        {breadcrumb}
        <h1>CheckBeforeSendView</h1>
        |]
            where
                breadcrumb = renderBreadcrumb
                                [ breadcrumbLink "Bills" BillsAction
                                , breadcrumbLink "Show Bill" (ShowBillAction (get #id bill))
                                , breadcrumbText "Show Bill"
                                ]
