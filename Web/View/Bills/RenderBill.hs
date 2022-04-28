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
            <head>
                <style>
                .table th, .table td {
                    padding: 1em;
                  }
                </style>
            </head>
            <body class="mt-5 mx-5">
                <h1 class="text-center mb-3">
                    Facture
                </h1>
                
                <h1 class="text-center mb-5">
                    Transport de personnes
                </h1>

                <p class="my-5">Facture no. {renderBillNumber (get #sentOn bill) (get #number bill)}, expédiée le : {sentOn}, échéance immédiate.</p>

                <h2>Client</h2>
                <p>
                    {get #name client}<br/>
                    {get #address client}
                </p>
                
                <h2>Courses</h2>
                <div class="table-responsive pr-5">
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
                        {get #name user} {renderCompanyType (get #companyType user) (get #capital user)}<br/>
                        {renderAddress (get #address user)}
                        {renderImmatriculation user}<br/>
                        {renderVatNumber (get #hasVatNumber user) (get #immatriculation user)}
                    </p>
                </footer>
    |]
    where renderCompanyType companyType capital  =
              case companyType of
                    Nothing -> [hsx||]
                    Just companyType -> case capital of
                        Nothing -> [hsx| {companyType} |]
                        Just capital -> [hsx| {companyType} au capital social de {renderPrice capital}€ |]
        
          renderAddress address =
              case address of
                    Nothing -> [hsx||]
                    Just address ->  [hsx| Siège social : {address} <br/> |]
          renderVatNumber hasVatNumber immatriculation =
              if hasVatNumber then
                  [hsx| No. TVA : {vatNumberFromImmatriculation immatriculation} |]
              else
                  [hsx||]
  

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
