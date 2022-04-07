module Web.View.Bills.Show where
import Web.View.Prelude
import Web.View.Trips.Render

data ShowView = ShowView { bill :: Include' ["clientId", "trips"] Bill, priceIncludingTax :: Int, priceExcludingTax :: Float }
 
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
                <tfoot>
                    <tr>
                        <th class="text-right">Total excl. VAT</th>
                        <th>{renderDecimalPrice priceExcludingTax}€</th>
                    </tr>
                    <tr>
                      <th class="text-right">VAT rate</th>
                      <th>10%</th>
                    </tr>
                    <tr>
                        <th class="text-right">Total incl. VAT</th>
                        <th>{renderPrice priceIncludingTax}€</th>
                    </tr>
                </tfoot>
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

