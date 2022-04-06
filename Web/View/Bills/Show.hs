module Web.View.Bills.Show where
import Web.View.Prelude
import Web.View.Trips.Render

data ShowView = ShowView { bill :: Include' ["clientId", "trips"] Bill, priceIncludingTax :: Int, priceExcludingTax :: Float }
 
instance View ShowView where
    html ShowView { .. } = [hsx|
        {breadcrumb}
        <h1>Bill</h1>
        <p>{get #clientId bill |> getClientFullName}</p>

        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>Trips<a href={pathTo (NewTripAction (get #id bill))} class="btn btn-primary ml-4">+ New</a></th>
                        <th></th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>{forEach (get #trips bill) renderTrip}</tbody>
                <tfoot>
                    <tr>
                        <th>Total</th>
                        <th>{renderPrice priceIncludingTax}€ incl. VAT</th>
                        <th>{renderDecimalPrice priceExcludingTax}€ excl. VAT</th>
                    </tr>
                </tfoot>
            </table>
        </div>

    |]
        where
            breadcrumb = renderBreadcrumb
                            [ breadcrumbLink "Bills" BillsAction
                            , breadcrumbText "Show Bill"
                            ]

