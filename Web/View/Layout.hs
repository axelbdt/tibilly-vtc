module Web.View.Layout (defaultLayout, Html) where

import IHP.ViewPrelude
import IHP.Environment
import qualified Text.Blaze.Html5            as H
import qualified Text.Blaze.Html5.Attributes as A
import Generated.Types
import IHP.Controller.RequestContext
import Web.Types
import Web.Routes
import Application.Helper.View

defaultLayout :: Html -> Html
defaultLayout inner = H.docTypeHtml ! A.lang "fr" $ [hsx|
<head>
    {metaTags}

    {stylesheets}
    {scripts}

    <title>{pageTitleOrDefault "Tibilly : vos factures de transport en quelques clics"}</title>
</head>
<body>
    {navbar}
    <div class="container mt-4">
        {renderFlashMessages}
        {inner}
    </div>
</body>
|]

navbar :: Html
navbar = [hsx|
<nav class="navbar navbar-light bg-light navbar-expand-lg">
    <!-- <a class="navbar-brand" href="/">Tibilly</a> -->
    {menuOptions}
    {loginButton}
</nav>
|]
    where
        menuOptions = case currentUserOrNothing of
            Just _ -> [hsx|
                    <a class="navbar-nav mr-3" href={pathTo BillsAction}>Factures</a>
                    <a class="navbar-nav mr-3" href={pathTo ClientsAction}>Clients</a>
                |]
            Nothing -> [hsx||]
        loginButton = case currentUserOrNothing of
            Just _ -> [hsx|<a class="ml-auto mr-3" href={ShowCurrentUserAction}>Compte</a><a class="btn btn-outline-primary mr-0 ml-0 js-delete js-delete-no-confirm" href={DeleteSessionAction}>Déconnexion</a>|]
            Nothing -> [hsx|<a class="ml-auto mr-3" href={NewUserAction}>S'inscrire</a><a class="btn btn-primary mr-0 ml-0" href={NewSessionAction}>Se connecter</a>|]
-- The 'assetPath' function used below appends a `?v=SOME_VERSION` to the static assets in production
-- This is useful to avoid users having old CSS and JS files in their browser cache once a new version is deployed
-- See https://ihp.digitallyinduced.com/Guide/assets.html for more details

stylesheets :: Html
stylesheets = [hsx|
        <link rel="stylesheet" href={assetPath "/vendor/bootstrap.min.css"}/>
        <link rel="stylesheet" href={assetPath "/vendor/flatpickr.min.css"}/>
        <link rel="stylesheet" href={assetPath "/app.css"}/>
    |]

scripts :: Html
scripts = [hsx|
        {when isDevelopment devScripts}
        <script src={assetPath "/vendor/jquery-3.6.0.slim.min.js"}></script>
        <script src={assetPath "/vendor/timeago.js"}></script>
        <script src={assetPath "/vendor/popper.min.js"}></script>
        <script src={assetPath "/vendor/bootstrap.min.js"}></script>
        <script src={assetPath "/vendor/flatpickr.js"}></script>
        <script src={assetPath "/vendor/morphdom-umd.min.js"}></script>
        <script src={assetPath "/vendor/turbolinks.js"}></script>
        <script src={assetPath "/vendor/turbolinksInstantClick.js"}></script>
        <script src={assetPath "/vendor/turbolinksMorphdom.js"}></script>
        <script src={assetPath "/helpers.js"}></script>
        <script src={assetPath "/ihp-auto-refresh.js"}></script>
        <script src={assetPath "/app.js"}></script>
    |]

devScripts :: Html
devScripts = [hsx|
        <script id="livereload-script" src={assetPath "/livereload.js"} data-ws={liveReloadWebsocketUrl}></script>
    |]

metaTags :: Html
metaTags = [hsx|
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <meta property="og:title" content="App"/>
    <meta property="og:type" content="website"/>
    <meta property="og:url" content="TODO"/>
    <meta property="og:description" content="TODO"/>
    {autoRefreshMeta}
|]
