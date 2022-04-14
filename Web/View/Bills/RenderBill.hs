module Web.View.Bills.RenderBill where
import Web.View.Prelude

data RenderBillView = RenderBillView{ bill :: Include' ["userId","clientId", "trips"] Bill, priceIncludingTax :: Int, priceExcludingTax :: Float } 

instance View RenderBillView where
    beforeRender view = do
        setLayout (\view -> view)

    html RenderBillView { .. } = [hsx|
        <h1>Facture - Transport de personnes</h1>
        <h2>Transporteur</h2>
        <p>Placeholder</p>
        <h2>Client</h2>
        <p>{get #clientId bill |> renderClientFullName}</p>

        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>Trips</th>
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
        |]


renderTrip :: Trip -> Html
renderTrip trip = [hsx|
    <tr>
        <td>{get #start trip} - {get #destination trip}</td>
        <td>{renderPrice (get #price trip)}€</td>
    </tr>
|]
