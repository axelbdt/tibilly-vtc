module Web.View.Bills.RenderBill where
import Web.View.Prelude
import Web.View.Bills.Render
import Web.View.Trips.Render (renderTripDescription)
import qualified Data.Text as T


data RenderBillView = RenderBillView { bill :: Include' ["userId","clientId", "trips"] Bill, priceInfo :: PriceInfo }

instance View RenderBillView where
    beforeRender view = do
       setLayout (\view -> view)

    html RenderBillView { .. } = [hsx|
        <html>
            <body>
                <h1 class="text-center">
                    Facture<br/>
                    Transport de personnes
                </h1>
                <p>Facture no. {get #number bill}, expédiée le : {sentOn}, échéance immédiate.</p>
                <h2>Client</h2>
                <p>
                    {get #name client}<br/>
                    {get #address client}
                </p>
                
                <h2>Courses</h2>
                <div class="table-responsive">
                    <table class="table">
                        <thead class="text-left">
                            <th>Départ</th>
                            <th>Arrivée</th>
                            <th>Date</th>
                            <th>Prix</th>
                        </thead>
                        <tbody>{forEach (get #trips bill) renderTrip}</tbody>
                        {renderPriceInfo priceInfo}
                    </table>
                </div>
                {footer}
            </body>
        </html>
        |]
        where
            client = get #clientId bill
            user = get #userId bill
            sentOn = maybe "" renderDay (get #sentOn bill)
            footer = renderFooter user

renderFooter user = [hsx|
                <footer class="w-100 text-center" style="position:absolute;bottom:0;">
                    <p>
                        {get #name user} {renderLegalStatus (get #legalStatus user) (get #capital user)}<br/>
                        {renderAddress (get #address user)}
                        {renderImmatriculation user}<br/>
                        No. TVA : {vatNumberFromImmatriculation (get #immatriculation user)}
                    </p>
                </footer>
    |]
    where renderLegalStatus legalStatus capital
              | legalStatus == "" = [hsx||]
              | capital == 0 = [hsx| {legalStatus} |]
              | otherwise = [hsx| {legalStatus} au capital social de {renderPrice capital}€ |]
          renderAddress address
              | address == "" = [hsx||]
              | otherwise = [hsx| {address} <br/> |]
          renderVATNumber vatNumber
              | vatNumber == "" = [hsx||] 
              | otherwise = [hsx|No. TVA : {vatNumber} |]
  

renderImmatriculation user =
        immatriculationType ++ " : " ++ immatriculation
        where
            immatriculation = get #immatriculation user
            immatriculationType =
                case T.length immatriculation of
                    9 -> "SIREN"
                    14 -> "SIRET"
                    _ -> ""



renderTrip :: Trip -> Html
renderTrip trip = [hsx|
    <tr>
        <td>{(get #start trip) }</td>
        <td>{get #destination trip}</td>
        <td>{renderDay (get #date trip)}</td>
        <td>{renderPrice (get #price trip)}€</td>
    </tr>
|]
