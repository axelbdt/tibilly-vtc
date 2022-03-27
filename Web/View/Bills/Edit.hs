module Web.View.Bills.Edit where
import Web.View.Prelude

data EditView = EditView { bill :: Bill }

instance View EditView where
    html EditView { .. } = [hsx|
        {breadcrumb}
        <h1>Edit Bill</h1>
        {renderForm bill}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Bills" BillsAction
                , breadcrumbText "Edit Bill"
                ]

renderForm :: Bill -> Html
renderForm bill = formFor bill [hsx|
    {(textField #userId)}
    {submitButton}

|]
