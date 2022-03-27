module Web.View.Bills.Show where
import Web.View.Prelude

data ShowView = ShowView { bill :: Bill }

instance View ShowView where
    html ShowView { .. } = [hsx|
        {breadcrumb}
        <h1>Show Bill</h1>
        <p>{bill}</p>

    |]
        where
            breadcrumb = renderBreadcrumb
                            [ breadcrumbLink "Bills" BillsAction
                            , breadcrumbText "Show Bill"
                            ]