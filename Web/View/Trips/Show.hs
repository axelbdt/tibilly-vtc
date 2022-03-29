module Web.View.Trips.Show where
import Web.View.Prelude

data ShowView = ShowView { trip :: Trip }

instance View ShowView where
    html ShowView { .. } = [hsx|
        {breadcrumb}
        <h1>Show Trip</h1>
        <p>{trip}</p>

    |]
        where
            breadcrumb = renderBreadcrumb
                            [ breadcrumbLink "Trips" TripsAction
                            , breadcrumbText "Show Trip"
                            ]