module Web.View.Bills.Render where
import Web.View.Prelude

renderPriceInfo priceInfo = [hsx|
                <tfoot>
                    <tr>
                        <th class="text-right">Total excl. VAT</th>
                        <th>{renderDecimalPrice (excludingTax priceInfo)}€</th>
                    </tr>
                    <tr>
                      <th class="text-right">VAT rate</th>
                      <th>10%</th>
                    </tr>
                    <tr>
                        <th class="text-right">Total incl. VAT</th>
                        <th>{renderPrice (includingTax priceInfo)}€</th>
                    </tr>
                </tfoot>
|]
