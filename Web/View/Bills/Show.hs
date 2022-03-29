module Web.View.Bills.Show where
import Web.View.Prelude

data ShowView = ShowView { bill :: Include' ["clientId", "trips"] Bill }
 
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
            </table>
        </div>

    |]
        where
            breadcrumb = renderBreadcrumb
                            [ breadcrumbLink "Bills" BillsAction
                            , breadcrumbText "Show Bill"
                            ]

renderTrip :: Trip -> Html
renderTrip trip = [hsx|
    <tr>
        <td>{get #startCity trip} - {get #destinationCity trip}</td>
        <td><a href={EditTripAction (get #id trip)} class="text-muted">Edit</a></td>
        <td><a href={DeleteTripAction (get #id trip)} class="js-delete text-muted">Delete</a></td>
    </tr>
|]
