module Root.View exposing (..)

import About
import AddNew.View
import AddNewCollection.View
import Authenticator.Routes
import Authenticator.Types
import Authenticator.View
import Card.View
import Collection.View
import Collections.View
import Faq
import Home
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Aria exposing (ariaHidden, ariaLabelledby)
import Html.Events exposing (onClick, onInput, onSubmit, onWithOptions)
import Html.Helpers exposing (aForPath)
import I18n
import Json.Decode
import Root.Types exposing (..)
import Routes exposing (..)
import Search.View
import Types exposing (..)
import Urls
import UserProfile.View
import Views exposing (..)


view : Model -> Html Msg
view model =
    let
        standardLayout language content =
            div []
                ([ viewHeader model language "container"
                 , viewAlert model language
                 ]
                    ++ [ content
                       , viewFooter model language
                       , viewAuthenticatorModal model language
                       , viewAddNewModal model language
                       , viewBackdrop model
                       ]
                )

        fullscreenLayout language content =
            div [ class "main-container" ]
                ([ div [ class "fixed-header" ]
                    [ viewHeader model language "container-fluid"
                    , viewAlert model language
                    ]
                 ]
                    ++ [ content
                       , div [ class "fixed-footer" ]
                            [ text (I18n.translate language I18n.Copyright) ]
                       , viewAuthenticatorModal model language
                       , viewAddNewModal model language
                       , viewBackdrop model
                       ]
                )

        searchQuery =
            Urls.querySearchTerm model.location
    in
        case model.route of
            I18nRouteWithLanguage language route ->
                case route of
                    AboutRoute ->
                        About.view language
                            |> standardLayout language

                    AuthenticatorRoute route ->
                        Authenticator.View.view
                            language
                            route
                            model.authenticatorModel
                            |> Html.map translateAuthenticatorMsg
                            |> standardLayout language

                    CollectionsRoute childRoute ->
                        case childRoute of
                            CollectionRoute _ ->
                                Collection.View.view model.collectionModel language
                                    |> Html.map translateCollectionMsg
                                    |> standardLayout language

                            CollectionsIndexRoute ->
                                Collections.View.view model.collectionsModel language
                                    |> Html.map translateCollectionsMsg
                                    |> standardLayout language

                            EditCollectionRoute _ ->
                                AddNewCollection.View.view model.addNewCollectionModel language
                                    |> Html.map translateAddNewCollectionMsg
                                    |> standardLayout language

                            NewCollectionRoute ->
                                AddNewCollection.View.view model.addNewCollectionModel language
                                    |> Html.map translateAddNewCollectionMsg
                                    |> standardLayout language

                    FaqRoute ->
                        Faq.view language
                            |> standardLayout language

                    HomeRoute ->
                        Home.view model.searchModel language model.location
                            |> Html.map translateSearchMsg
                            |> standardLayout language

                    NotFoundRoute _ ->
                        div [ class "row section" ]
                            [ div [ class "container" ]
                                [ viewNotFound language ]
                            ]
                            |> standardLayout language

                    OrganizationsRoute childRoute ->
                        case childRoute of
                            OrganizationRoute _ ->
                                Card.View.view model.cardModel language
                                    |> Html.map translateCardMsg
                                    |> standardLayout language

                            OrganizationsIndexRoute ->
                                Search.View.view model.searchModel OrganizationCard language model.location
                                    |> Html.map translateSearchMsg
                                    |> fullscreenLayout language

                            NewOrganizationRoute ->
                                AddNew.View.viewOrganization model.addNewModel language
                                    |> Html.map translateAddNewMsg
                                    |> standardLayout language

                    ToolsRoute childRoute ->
                        case childRoute of
                            ToolRoute _ ->
                                Card.View.view model.cardModel language
                                    |> Html.map translateCardMsg
                                    |> standardLayout language

                            ToolsIndexRoute ->
                                Search.View.view model.searchModel ToolCard language model.location
                                    |> Html.map translateSearchMsg
                                    |> fullscreenLayout language

                            NewToolRoute ->
                                AddNew.View.viewTool model.addNewModel language
                                    |> Html.map translateAddNewMsg
                                    |> standardLayout language

                    UseCasesRoute childRoute ->
                        case childRoute of
                            UseCaseRoute _ ->
                                Card.View.view model.cardModel language
                                    |> Html.map translateCardMsg
                                    |> standardLayout language

                            UseCasesIndexRoute ->
                                Search.View.view model.searchModel UseCaseCard language model.location
                                    |> Html.map translateSearchMsg
                                    |> fullscreenLayout language

                            NewUseCaseRoute ->
                                AddNew.View.viewUseCase model.addNewModel language
                                    |> Html.map translateAddNewMsg
                                    |> standardLayout language

                    UserProfileRoute ->
                        (case model.authentication of
                            Nothing ->
                                viewNotAuthentified language

                            Just user ->
                                UserProfile.View.view model.userProfileModel language user
                                    |> Html.map translateUserProfileMsg
                        )
                            |> standardLayout language

            I18nRouteWithoutLanguage _ ->
                div [ style [ ( "min-height", "60em" ) ] ]
                    [ viewBigMessage "" "" ]
                    |> standardLayout I18n.English


viewAddNewModal : Model -> I18n.Language -> Html Msg
viewAddNewModal model language =
    if model.displayAddNewModal then
        div
            [ ariaLabelledby "myModalLabel"
            , attribute "role" "dialog"
            , attribute "tabindex" "-1"
            , class "modal fade in"
            , style [ ( "display", "block" ) ]
            ]
            [ div [ class "modal-dialog", id "login-overlay" ]
                [ div [ class "modal-content" ]
                    [ div [ class "modal-header" ]
                        [ button
                            [ class "close"
                            , attribute "data-dismiss" "modal"
                            , onClick (DisplayAddNewModal False)
                            , type_ "button"
                            ]
                            [ span [ attribute "aria-hidden" "true" ]
                                [ text "×" ]
                            , span [ class "sr-only" ]
                                [ text "Close" ]
                            ]
                        , h4 [ class "modal-title", id "myModalLabel" ]
                            [ text (I18n.translate language (I18n.AddNewItemBox)) ]
                        ]
                    , div [ class "modal-body" ]
                        [ div [ class "row" ]
                            [ div [ class "col-xs-12" ]
                                [ aForPath
                                    Navigate
                                    language
                                    "/tools/new"
                                    [ class "media action"
                                      -- TODO trigger a login if not signed in
                                    , onClick (DisplayAddNewModal False)
                                    ]
                                    [ div [ class "media-left icon" ]
                                        [ span [ attribute "aria-hidden" "true", class "glyphicon glyphicon-wrench" ]
                                            []
                                        ]
                                    , div [ class "media-body" ]
                                        [ h4 [ class "media-heading" ]
                                            [ text (I18n.translate language (I18n.Tool I18n.Singular)) ]
                                        , text (I18n.translate language I18n.AddNewToolCatchPhrase)
                                        ]
                                    ]
                                , aForPath
                                    Navigate
                                    language
                                    "/use-cases/new"
                                    [ class "media action"
                                      -- TODO trigger a login if not signed in
                                    , onClick (DisplayAddNewModal False)
                                    ]
                                    [ div [ class "media-left icon" ]
                                        [ span [ attribute "aria-hidden" "true", class "glyphicon glyphicon-bookmark" ]
                                            []
                                        ]
                                    , div [ class "media-body" ]
                                        [ h4 [ class "media-heading" ]
                                            [ text (I18n.translate language (I18n.UseCase I18n.Singular)) ]
                                        , text (I18n.translate language I18n.AddNewUseCaseCatchPhrase)
                                        ]
                                    ]
                                , aForPath
                                    Navigate
                                    language
                                    "/collections/new"
                                    [ class "media action"
                                      -- TODO trigger a login if not signed in
                                    , onClick (DisplayAddNewModal False)
                                    ]
                                    [ div [ class "media-left icon" ]
                                        [ span [ attribute "aria-hidden" "true", class "glyphicon glyphicon-heart" ]
                                            []
                                        ]
                                    , div [ class "media-body" ]
                                        [ h4 [ class "media-heading" ]
                                            [ text (I18n.translate language (I18n.Collection I18n.Singular)) ]
                                        , text (I18n.translate language I18n.AddNewCollectionCatchPhrase)
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
    else
        text ""


viewAlert : Model -> I18n.Language -> Html Msg
viewAlert model language =
    case model.authentication of
        Nothing ->
            text ""

        Just authentication ->
            if authentication.activated then
                text ""
            else
                div [ class "alert alert-success alert-dismissible", attribute "role" "alert" ]
                    [ div [ class "container" ]
                        -- [ button [ attribute "aria-label" "Close", class "close", attribute "data-dismiss" "alert", type_ "button" ]
                        --     [ span [ attribute "aria-hidden" "true" ]
                        --         [ text "×" ]
                        --     ]
                        [ text (I18n.translate language (I18n.EmailSentForAccountActivation authentication.email))
                        , text " "
                        , button
                            [ class "btn btn-default btn-sm"
                            , type_ "button"
                            , onClick (AuthenticatorMsg (Authenticator.Types.sendActivationMsg authentication))
                            ]
                            [ text <| I18n.translate language I18n.SendEmailAgain ]
                        ]
                    ]


viewAuthenticatorModal : Model -> I18n.Language -> Html Msg
viewAuthenticatorModal model language =
    case model.authenticatorRoute of
        Just authenticatorRoute ->
            div
                [ ariaLabelledby "modal-title"
                , attribute "role" "dialog"
                , attribute "tabindex" "-1"
                , class "modal fade in"
                , style [ ( "display", "block" ) ]
                ]
                [ div [ class "modal-dialog", id "login-overlay" ]
                    [ div [ class "modal-content" ]
                        [ div [ class "modal-header" ]
                            [ button
                                [ attribute "data-dismiss" "modal"
                                , class "close"
                                , onClick (AuthenticatorTerminated authenticatorRoute (Err ()))
                                , type_ "button"
                                ]
                                [ span [ ariaHidden True ]
                                    [ text "×" ]
                                , span [ class "sr-only" ]
                                    [ text (I18n.translate language I18n.Close) ]
                                ]
                            , h4 [ class "modal-title", id "modal-title" ]
                                [ text (Authenticator.View.modalTitle language authenticatorRoute) ]
                            ]
                        , Authenticator.View.viewModalBody language authenticatorRoute model.authenticatorModel
                            |> Html.map translateAuthenticatorMsg
                        ]
                    ]
                ]

        Nothing ->
            text ""


viewBackdrop : Model -> Html Msg
viewBackdrop model =
    div [ classList [ ( "modal-backdrop in", model.authenticatorRoute /= Nothing || model.displayAddNewModal ) ] ]
        []


viewFooter : Model -> I18n.Language -> Html Msg
viewFooter model language =
    footer []
        [ div [ class "row section footer" ]
            [ div [ class "container" ]
                [ div [ class "row" ]
                    [ div [ class "col-xs-12 col-md-6" ]
                        [ div [ class "row" ]
                            [ div [ class "col-xs-6" ]
                                [ img [ alt "OGP logo", class "footer-logo", src "/img/ogp-logo.png" ]
                                    []
                                ]
                            , div [ class "col-xs-6" ]
                                [ h4 []
                                    [ text (I18n.translate language I18n.LanguageWord) ]
                                , div [ class "dropdown dropdown-language" ]
                                    [ button
                                        [ attribute "aria-expanded" "true"
                                        , attribute "aria-haspopup" "true"
                                        , class "btn btn-default dropdown-toggle"
                                        , attribute "data-toggle" "dropdown"
                                        , id "dropdownMenu1"
                                        , type_ "button"
                                        ]
                                        [ text (I18n.translate language (I18n.Language language))
                                        , span [ class "caret" ] []
                                        ]
                                    , ul [ attribute "aria-labelledby" "dropdownMenu1", class "dropdown-menu" ]
                                        (let
                                            aForPath urlPath children =
                                                a
                                                    [ href urlPath
                                                    , onWithOptions
                                                        "click"
                                                        { stopPropagation = True, preventDefault = True }
                                                        (Json.Decode.succeed (Navigate urlPath))
                                                    ]
                                                    children
                                         in
                                            [ li []
                                                [ aForPath
                                                    (Urls.replaceLanguageInLocation I18n.English model.location)
                                                    [ text (I18n.translate I18n.English (I18n.Language I18n.English)) ]
                                                ]
                                            , li []
                                                [ aForPath
                                                    (Urls.replaceLanguageInLocation I18n.French model.location)
                                                    [ text (I18n.translate I18n.French (I18n.Language I18n.French)) ]
                                                ]
                                            , li []
                                                [ aForPath
                                                    (Urls.replaceLanguageInLocation I18n.Spanish model.location)
                                                    [ text (I18n.translate I18n.Spanish (I18n.Language I18n.Spanish)) ]
                                                ]
                                            ]
                                        )
                                    ]
                                ]
                            ]
                        , p [ class "info-box" ]
                            [ text (I18n.translate language I18n.OpenGovParagraph) ]
                        , a [ href "https://www.etalab.gouv.fr", target "_blank", class "etalab-logo" ]
                            [ img [ alt "Etalab logo", src "/img/etalab-logo.png" ]
                                []
                            ]
                        ]
                    , div [ class "col-xs-6 col-md-3" ]
                        [ h4 []
                            [ text (I18n.translate language I18n.FooterDiscover) ]
                        , ul [ class "footer-menu" ]
                            [ li []
                                [ aForPath
                                    Navigate
                                    language
                                    "/tools"
                                    []
                                    [ text (I18n.translate language (I18n.Tool I18n.Plural)) ]
                                ]
                            , li []
                                [ aForPath
                                    Navigate
                                    language
                                    "/use-cases"
                                    []
                                    [ text (I18n.translate language (I18n.UseCase I18n.Plural)) ]
                                ]
                            , li []
                                [ aForPath
                                    Navigate
                                    language
                                    "/organizations"
                                    []
                                    [ text (I18n.translate language (I18n.Organization I18n.Plural)) ]
                                ]
                            , li []
                                [ aForPath
                                    Navigate
                                    language
                                    "/collections"
                                    []
                                    [ text (I18n.translate language (I18n.Collection I18n.Plural)) ]
                                ]
                            ]
                        ]
                    , div [ class "col-xs-6 col-md-3" ]
                        [ h4 []
                            [ text (I18n.translate language I18n.FooterAbout) ]
                        , ul [ class "footer-menu" ]
                            [ li []
                                [ aForPath
                                    Navigate
                                    language
                                    "/about"
                                    []
                                    [ text (I18n.translate language I18n.About) ]
                                ]
                            , li []
                                [ aForPath
                                    Navigate
                                    language
                                    "/faq"
                                    []
                                    [ text (I18n.translate language I18n.Faq) ]
                                ]
                            , li []
                                [ a [ href "http://www.opengovpartnership.org", target "_blank" ]
                                    [ text "Open Government Parntenrship" ]
                                ]
                            , li []
                                [ a [ href "https://www.etalab.gouv.fr", target "_blank" ]
                                    [ text "Etalab" ]
                                ]
                            ]
                        ]
                    ]
                , div [ class "row copyright" ]
                    [ div [ class "col-md-12" ]
                        [ text (I18n.translate language I18n.Copyright) ]
                    ]
                ]
            ]
        ]


viewHeader : Model -> I18n.Language -> String -> Html Msg
viewHeader model language containerClass =
    let
        profileNavItem =
            case model.authentication of
                Just authentication ->
                    li []
                        [ aForPath
                            Navigate
                            language
                            "/profile"
                            []
                            [ text authentication.name ]
                        ]

                Nothing ->
                    text ""

        signInOrOutNavItem =
            case model.authentication of
                Just authentication ->
                    li []
                        [ a
                            [ href "#"
                            , onWithOptions
                                "click"
                                { preventDefault = True, stopPropagation = False }
                                (Json.Decode.succeed SignOutImmediately)
                            ]
                            [ text (I18n.translate language I18n.SignOut) ]
                        ]

                Nothing ->
                    li []
                        [ a
                            [ href "#"
                            , onWithOptions
                                "click"
                                { preventDefault = True, stopPropagation = False }
                                (Json.Decode.succeed
                                    (StartAuthenticator Nothing Nothing Authenticator.Routes.SignInRoute)
                                )
                            ]
                            [ text (I18n.translate language I18n.SignIn) ]
                        ]
    in
        header []
            [ nav [ class "navbar navbar-default navbar-fixed-top", attribute "role" "navigation" ]
                [ div [ class containerClass ]
                    [ div [ class "navbar-header" ]
                        [ button
                            [ attribute "aria-controls" "navbar"
                            , attribute "aria-expanded" "false"
                            , class "navbar-toggle collapsed"
                            , attribute "data-target" "#menu-collapse"
                            , attribute "data-toggle" "collapse"
                            , type_ "button"
                            ]
                            [ span [ class "sr-only" ]
                                [ text "Toggle navigation" ]
                            , span [ class "icon-bar" ]
                                []
                            , span [ class "icon-bar" ]
                                []
                            , span [ class "icon-bar" ]
                                []
                            ]
                        , aForPath
                            Navigate
                            language
                            "/"
                            [ class "navbar-brand" ]
                            [ text "OGPtoolbox" ]
                        , p [ class "navbar-text" ]
                            [ text (I18n.translate language I18n.HeaderTitle) ]
                        ]
                    , ul [ class "nav navbar-nav navbar-right collapse navbar-collapse" ]
                        [ profileNavItem
                        , signInOrOutNavItem
                        , li []
                            [ button
                                [ class "btn btn-default btn-action"
                                , onClick (DisplayAddNewModal True)
                                , type_ "button"
                                ]
                                [ text (I18n.translate language I18n.AddNew) ]
                            ]
                        ]
                    ]
                ]
            , nav [ class "navbar navbar-inverse" ]
                [ div [ class containerClass ]
                    [ Html.form
                        [ class "navbar-form navbar-right collapse mobile"
                        , onSubmit Search
                        ]
                        [ div [ class "form-group search-bar" ]
                            [ span [ attribute "aria-hidden" "true", class "glyphicon glyphicon-search" ]
                                []
                            , input
                                [ class "form-control"
                                , onInput SearchInputChanged
                                , placeholder (I18n.translate language I18n.SearchInputPlaceholder)
                                , type_ "search"
                                , value model.searchInputValue
                                ]
                                []
                            ]
                        ]
                    , div [ class "collapse navbar-collapse" ]
                        [ ul [ class "nav navbar-nav" ]
                            [ li []
                                [ aForPath
                                    Navigate
                                    language
                                    "/tools"
                                    []
                                    [ text (I18n.translate language (I18n.Tool I18n.Plural)) ]
                                ]
                            , li []
                                [ aForPath
                                    Navigate
                                    language
                                    "/use-cases"
                                    []
                                    [ text (I18n.translate language (I18n.UseCase I18n.Plural)) ]
                                ]
                              --   , li []
                              --       [ aForPath
                              --           Navigate
                              --           language
                              --           "/organizations"
                              --           []
                              --           [ text (I18n.translate language (I18n.Organization I18n.Plural)) ]
                              --       ]
                            , li []
                                [ aForPath
                                    Navigate
                                    language
                                    "/collections"
                                    []
                                    [ text (I18n.translate language (I18n.Collection I18n.Plural)) ]
                                ]
                            , li []
                                [ aForPath
                                    Navigate
                                    language
                                    "/faq"
                                    []
                                    [ text (I18n.translate language I18n.Help) ]
                                ]
                            ]
                        , Html.form
                            [ class "navbar-form navbar-right"
                            , onSubmit Search
                            ]
                            [ div [ class "form-group search-bar" ]
                                [ span [ attribute "aria-hidden" "true", class "glyphicon glyphicon-search" ]
                                    []
                                , input
                                    [ class "form-control"
                                    , onInput SearchInputChanged
                                    , placeholder (I18n.translate language I18n.SearchInputPlaceholder)
                                    , type_ "search"
                                    , value model.searchInputValue
                                    ]
                                    []
                                ]
                            ]
                        ]
                    , div [ class "collapse", id "menu-collapse" ]
                        [ ul [ class "nav navbar-nav navbar-inverse" ]
                            [ button
                                [ class "btn btn-default btn-action"
                                , onClick (DisplayAddNewModal True)
                                , type_ "button"
                                ]
                                [ text (I18n.translate language I18n.AddNew) ]
                            , li []
                                [ aForPath
                                    Navigate
                                    language
                                    "/tools"
                                    []
                                    [ text (I18n.translate language (I18n.Tool I18n.Plural)) ]
                                ]
                            , li []
                                [ aForPath
                                    Navigate
                                    language
                                    "/use-cases"
                                    []
                                    [ text (I18n.translate language (I18n.UseCase I18n.Plural)) ]
                                ]
                              --   , li []
                              --       [ aForPath
                              --           Navigate
                              --           language
                              --           "/organizations"
                              --           []
                              --           [ text (I18n.translate language (I18n.Organization I18n.Plural)) ]
                              --       ]
                            , li []
                                [ aForPath
                                    Navigate
                                    language
                                    "/collections"
                                    []
                                    [ text (I18n.translate language (I18n.Collection I18n.Plural)) ]
                                ]
                            , li []
                                [ aForPath
                                    Navigate
                                    language
                                    "/faq"
                                    []
                                    [ text (I18n.translate language I18n.Help) ]
                                ]
                            , profileNavItem
                            , signInOrOutNavItem
                            ]
                        ]
                    ]
                ]
            ]
