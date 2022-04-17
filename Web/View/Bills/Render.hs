module Web.View.Bills.Render where
import Web.View.Prelude

renderPriceInfo priceInfo = [hsx|
                <tfoot>
                    <tr>
                        <th class="text-right pr-3">Total HT</th>
                        <th class="text-left">{renderDecimalPrice (excludingTax priceInfo)}€</th>
                    </tr>
                    <tr>
                      <th class="text-right pr-3">TVA (10%)</th>
                      <th class="text-left">{renderDecimalPrice (taxAmount priceInfo)}€</th>
                    </tr>
                    <tr style="font-size:2em">
                        <th class="text-right pr-3">Total TTC</th>
                        <th class="text-left">{renderPrice (includingTax priceInfo)}€</th>
                    </tr>
                </tfoot>
|]
