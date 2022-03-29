module Web.View.Trips.Index where
import Web.View.Prelude
import Web.View.Trips.Render

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
