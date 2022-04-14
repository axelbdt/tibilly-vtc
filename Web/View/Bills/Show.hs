module Web.View.Bills.Show where
import Web.View.Prelude
import Web.View.Trips.Render
import Web.View.Bills.Render

data ShowView = ShowView { bill :: Include' ["clientId", "trips"] Bill, priceInfo :: PriceInfo }
 
instance View ShowView where
    html ShowView { .. } = [hsx|
        {breadcrumb}
        <h1>Bill</h1>
        <p>{get #clientId bill |> renderClientFullName}</p>

        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>Trips<a href={pathTo (NewTripAction (get #id bill))} class="btn btn-secondary ml-4">+ Add</a></th>
                        <th></th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>{forEach (get #trips bill) renderTrip}</tbody>
                {renderPriceInfo priceInfo}
            </table>
        </div>
        <div>
            <a href={pathTo (CheckBeforeSendBillAction (get #id bill))} class="btn btn-primary">Next</a>
        </div>

    |]
        where
            breadcrumb = renderBreadcrumb
                            [ breadcrumbLink "Bills" BillsAction
                            , breadcrumbText "Show Bill"
                            ]

