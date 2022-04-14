module Web.View.Bills.RenderBill where
import Web.View.Prelude


data RenderBillView = RenderBillView { bill :: Include' ["userId","clientId", "trips"] Bill, priceIncludingTax :: Int, priceExcludingTax :: Float, taxAmount :: Float }

instance View RenderBillView where
    beforeRender view = do
       setLayout (\view -> view)

    html RenderBillView { .. } = [hsx|
        <h1 class="text-center">
            Facture<br/>
            Transport de personnes
        </h1>
        <div class="d-flex justify-content-between">
            <div>
                <h2>Client</h2>
                <p>{get #clientId bill |> renderClientFullName}</p>
            </div>
            <div>
                <h2>Transporteur</h2>
                <p>{renderUserFullName user}</p>
            </div>
        </div>
        

        <h2>Course</h2>
        <div class="table-responsive">
            <table class="table">
                <tbody>{forEach (get #trips bill) renderTrip}</tbody>
                <tfoot>
                    <tr>
                        <th class="text-right">Total HT</th>
                        <th>{renderDecimalPrice priceExcludingTax}€</th>
                    </tr>
                    <tr>
                      <th class="text-right">TVA (10%)</th>
                      <th>{renderDecimalPrice taxAmount}€</th>
                    </tr>
                    <tr style="font-size:2em">
                        <th class="text-right fs-1">Total TTC</th>
                        <th>{renderPrice priceIncludingTax}€</th>
                    </tr>
                </tfoot>
            </table> 
        </div>
        |]
        where
            client = get #clientId bill
            user = get #userId bill


renderTrip :: Trip -> Html
renderTrip trip = [hsx|
    <tr>
        <td>{get #start trip} - {get #destination trip}</td>
        <td>{renderPrice (get #price trip)}€</td>
    </tr>
|] 
