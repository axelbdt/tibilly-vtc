module Web.View.Bills.Render where
import Web.View.Prelude

renderPriceInfo priceInfo = [hsx|
                <tfoot>
                    <tr>
                        <th class="text-right">Total HT</th>
                        <th>{renderDecimalPrice (excludingTax priceInfo)}€</th>
                    </tr>
                    <tr>
                      <th class="text-right">TVA (10%)</th>
                      <th>{renderDecimalPrice (taxAmount priceInfo)}€</th>
                    </tr>
                    <tr style="font-size:2em">
                        <th class="text-right">Total TTC</th>
                        <th>{renderPrice (includingTax priceInfo)}€</th>
                    </tr>
                </tfoot>
|]
