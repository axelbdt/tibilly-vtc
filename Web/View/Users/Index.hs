module Web.View.Users.Index where
import Web.View.Prelude

data IndexView = IndexView { users :: [User]  }

instance View IndexView where
    html IndexView { .. } = [hsx|
        {breadcrumb}

        <h1>Users<a href={pathTo NewUserAction} class="btn btn-primary ml-4">+ New</a></h1>
        <div class="table-responsive">
            <table class="table">
                <tbody>{forEach users renderUser}</tbody>
            </table>
            
        </div>
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Users" UsersAction
                ]

renderUser :: User -> Html
renderUser user = [hsx|
    <tr>
        <td><a href={ShowUserAction (get #id user)}>{getFullName user}</a></td>
        <td><a href={EditUserAction (get #id user)} class="text-muted">Edit</a></td>
        <td><a href={DeleteUserAction (get #id user)} class="js-delete text-muted">Delete</a></td>
    </tr>
|]
