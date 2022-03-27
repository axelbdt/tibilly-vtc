module Web.View.Bills.Index where
import Web.View.Prelude

data IndexView = IndexView { bills :: [Bill]  }

instance View IndexView where
    html IndexView { .. } = [hsx|
        {breadcrumb}

        <h1>Index<a href={pathTo NewBillAction} class="btn btn-primary ml-4">+ New</a></h1>
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>Bill</th>
                        <th></th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>{forEach bills renderBill}</tbody>
            </table>
            
        </div>
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Bills" BillsAction
                ]

renderBill :: Bill -> Html
renderBill bill = [hsx|
    <tr>
        <td><a href={ShowBillAction (get #id bill)}>{get #createdAt bill}</a></td>
        <td><a href={EditBillAction (get #id bill)} class="text-muted">Edit</a></td>
        <td><a href={DeleteBillAction (get #id bill)} class="js-delete text-muted">Delete</a></td>
    </tr>
|]
