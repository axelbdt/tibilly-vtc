module Web.View.Trips.Index where
import Web.View.Prelude

data IndexView = IndexView { trips :: [Trip]  }

instance View IndexView where
    html IndexView { .. } = [hsx|
        {breadcrumb}

        <h1>Trips</h1>
        <div class="table-responsive">
            <table class="table">
                <tbody>{forEach trips renderTrip}</tbody>
            </table>
            
        </div>
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Trips" TripsAction
                ]

renderTrip :: Trip -> Html
renderTrip trip = [hsx|
    <tr>
        <td>{trip}</td>
        <td><a href={ShowTripAction (get #id trip)}>Show</a></td>
        <td><a href={EditTripAction (get #id trip)} class="text-muted">Edit</a></td>
        <td><a href={DeleteTripAction (get #id trip)} class="js-delete text-muted">Delete</a></td>
    </tr>
|]
