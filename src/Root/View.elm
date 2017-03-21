module Root.View exposing (..)

import About
import Cards.New.View
import Authenticator.Routes
import Authenticator.Types
import Authenticator.View
import Cards.Item.View
import Collections.Item.View
import Collections.Edit.View
import Collections.Index.View
import Faq
import Home
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Aria exposing (ariaHidden, ariaLabelledby, role)
import Html.Events exposing (onClick, onInput, onSubmit, onWithOptions)
import Html.Helpers exposing (aForPath)
import I18n
import I18nHtml
import Json.Decode
import Press
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
                       , viewNewCardModal model language
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
                       , div [ class "fixed-footer" ] [ I18nHtml.translate language I18nHtml.CopyrightLine ]
                       , viewAuthenticatorModal model language
                       , viewNewCardModal model language
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
                            CollectionEditRoute _ ->
                                Collections.Edit.View.view model.collectionEditModel
                                    |> Html.map translateEditCollectionMsg
                                    |> standardLayout language

                            CollectionRoute _ ->
                                Collections.Item.View.view model.collectionModel
                                    |> Html.map translateCollectionMsg
                                    |> standardLayout language

                            CollectionsIndexRoute ->
                                Collections.Index.View.view model.collectionsModel language
                                    |> Html.map translateCollectionsMsg
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

                    OgpRoute ->
                        Home.view model.searchModel language model.location
                            |> Html.map translateSearchMsg
                            |> standardLayout language

                    OrganizationsRoute childRoute ->
                        case childRoute of
                            OrganizationRoute _ ->
                                Cards.Item.View.view model.cardModel
                                    |> Html.map translateCardMsg
                                    |> standardLayout language

                            OrganizationsIndexRoute ->
                                Search.View.view model.searchModel OrganizationCard language model.location
                                    |> Html.map translateSearchMsg
                                    |> fullscreenLayout language

                            NewOrganizationRoute ->
                                Cards.New.View.viewOrganization model.cardNewModel language
                                    |> Html.map translateNewCardMsg
                                    |> standardLayout language

                    PressRoute ->
                        Press.view language
                            |> standardLayout language

                    ToolsRoute childRoute ->
                        case childRoute of
                            ToolRoute _ ->
                                Cards.Item.View.view model.cardModel
                                    |> Html.map translateCardMsg
                                    |> standardLayout language

                            ToolsIndexRoute ->
                                Search.View.view model.searchModel ToolCard language model.location
                                    |> Html.map translateSearchMsg
                                    |> fullscreenLayout language

                            NewToolRoute ->
                                Cards.New.View.viewTool model.cardNewModel language
                                    |> Html.map translateNewCardMsg
                                    |> standardLayout language

                    UseCasesRoute childRoute ->
                        case childRoute of
                            UseCaseRoute _ ->
                                Cards.Item.View.view model.cardModel
                                    |> Html.map translateCardMsg
                                    |> standardLayout language

                            UseCasesIndexRoute ->
                                Search.View.view model.searchModel UseCaseCard language model.location
                                    |> Html.map translateSearchMsg
                                    |> fullscreenLayout language

                            NewUseCaseRoute ->
                                Cards.New.View.viewUseCase model.cardNewModel language
                                    |> Html.map translateNewCardMsg
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


viewNewCardModal : Model -> I18n.Language -> Html Msg
viewNewCardModal model language =
    if model.displayNewCardModal then
        div
            [ ariaLabelledby "myModalLabel"
            , class "modal fade in"
            , role "dialog"
            , style [ ( "display", "block" ) ]
            , attribute "tabindex" "-1"
            ]
            [ div [ class "modal-dialog", id "login-overlay" ]
                [ div [ class "modal-content" ]
                    [ div [ class "modal-header" ]
                        [ button
                            [ class "close"
                            , attribute "data-dismiss" "modal"
                            , onClick (DisplayNewCardModal False)
                            , type_ "button"
                            ]
                            [ span [ attribute "aria-hidden" "true" ]
                                [ text "×" ]
                            , span [ class "sr-only" ]
                                [ text "Close" ]
                            ]
                        , h4 [ class "modal-title", id "myModalLabel" ]
                            [ text (I18n.translate language (I18n.NewCardItemBox)) ]
                        ]
                    , div [ class "modal-body" ]
                        [ div [ class "row" ]
                            [ div [ class "col-xs-12" ]
                                [ aForPath
                                    Navigate
                                    language
                                    "/tools/new"
                                    [ class "media action"
                                    , onClick (DisplayNewCardModal False)
                                    ]
                                    [ div [ class "media-left icon" ]
                                        [ span [ attribute "aria-hidden" "true", class "glyphicon glyphicon-wrench" ]
                                            []
                                        ]
                                    , div [ class "media-body" ]
                                        [ h4 [ class "media-heading" ]
                                            [ text (I18n.translate language (I18n.Tool I18n.Singular)) ]
                                        , text (I18n.translate language I18n.NewCardToolCatchPhrase)
                                        ]
                                    ]
                                , aForPath
                                    Navigate
                                    language
                                    "/use-cases/new"
                                    [ class "media action"
                                    , onClick (DisplayNewCardModal False)
                                    ]
                                    [ div [ class "media-left icon" ]
                                        [ span [ attribute "aria-hidden" "true", class "glyphicon glyphicon-bookmark" ]
                                            []
                                        ]
                                    , div [ class "media-body" ]
                                        [ h4 [ class "media-heading" ]
                                            [ text (I18n.translate language (I18n.UseCase I18n.Singular)) ]
                                        , text (I18n.translate language I18n.NewCardUseCaseCatchPhrase)
                                        ]
                                    ]
                                , aForPath
                                    Navigate
                                    language
                                    "/organizations/new"
                                    [ class "media action"
                                    , onClick (DisplayNewCardModal False)
                                    ]
                                    [ div [ class "media-left icon" ]
                                        [ span [ attribute "aria-hidden" "true", class "glyphicon glyphicon-home" ]
                                            []
                                        ]
                                    , div [ class "media-body" ]
                                        [ h4 [ class "media-heading" ]
                                            [ text (I18n.translate language (I18n.Organization I18n.Singular)) ]
                                        , text (I18n.translate language I18n.NewCardOrganizationCatchPhrase)
                                        ]
                                    ]
                                , aForPath
                                    Navigate
                                    language
                                    "/collections/new"
                                    [ class "media action"
                                    , onClick (DisplayNewCardModal False)
                                    ]
                                    [ div [ class "media-left icon" ]
                                        [ span [ attribute "aria-hidden" "true", class "glyphicon glyphicon-heart" ]
                                            []
                                        ]
                                    , div [ class "media-body" ]
                                        [ h4 [ class "media-heading" ]
                                            [ text (I18n.translate language (I18n.Collection I18n.Singular)) ]
                                        , text (I18n.translate language I18n.EditCollectionCatchPhrase)
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
                div [ class "alert alert-success", role "alert" ]
                    [ div [ class "container" ]
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
                , role "dialog"
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
    div [ classList [ ( "modal-backdrop in", model.authenticatorRoute /= Nothing || model.displayNewCardModal ) ] ]
        []


viewFooter : Model -> I18n.Language -> Html Msg
viewFooter model language =
    footer [ class "container-fluid" ]
        [ div [ class "row section footer" ]
            [ div [ class "container" ]
                [ div [ class "row" ]
                    [ div [ class "col-xs-12 col-md-6" ]
                        [ div [ class "row" ]
                            [ div [ class "col-xs-6" ]
                                [ a
                                    [ href "http://www.opengovpartnership.org"
                                    , target "_blank"
                                    , title (I18n.translate language I18n.OpenGovernmentPartnership)
                                    ]
                                    [ img
                                        [ alt (I18n.translate language I18n.OpenGovernmentPartnershipLogo)
                                        , class "footer-logo"
                                        , src "/img/ogp-logo.png"
                                        ]
                                        []
                                    ]
                                ]
                            , div [ class "col-xs-6" ]
                                [ h4 []
                                    [ text (I18n.translate language I18n.LanguageWord) ]
                                , div [ class "dropdown dropdown-language" ]
                                    [ button
                                        [ attribute "aria-expanded" "false"
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
                                            aForPath path children =
                                                a
                                                    [ href path
                                                    , onWithOptions
                                                        "click"
                                                        { stopPropagation = False, preventDefault = True }
                                                        (Json.Decode.succeed (Navigate path))
                                                    ]
                                                    children
                                         in
                                            I18n.languages
                                                |> List.map
                                                    (\language ->
                                                        ( language
                                                        , (I18n.translate language (I18n.Language language))
                                                        )
                                                    )
                                                |> List.sortBy (\( language, languageLabel ) -> languageLabel)
                                                |> List.map
                                                    (\( language, languageLabel ) ->
                                                        li []
                                                            [ aForPath
                                                                (Urls.replaceLanguageInLocation language model.location)
                                                                [ text languageLabel ]
                                                            ]
                                                    )
                                        )
                                    ]
                                ]
                            ]
                        , p [ class "info-box" ]
                            [ text (I18n.translate language I18n.OpenGovParagraph) ]
                        , a
                            [ class "etalab-logo"
                            , href "https://www.etalab.gouv.fr"
                            , target "_blank"
                            , title "Etalab"
                            ]
                            [ img [ alt (I18n.translate language I18n.EtalabLogo), src "/img/etalab-logo.png" ]
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
                                    [ text (I18n.translate language I18n.TheProject) ]
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
                                [ aForPath
                                    Navigate
                                    language
                                    "/press"
                                    []
                                    [ text (I18n.translate language I18n.Press) ]
                                ]
                            ]
                        , br [] []
                        , h4 []
                            [ text (I18n.translate language I18n.FooterContact) ]
                        , ul [ class "footer-menu" ]
                            [ li []
                                [ a [ href "mailto:info@ogptpoolbox.org" ]
                                    [ i [ attribute "aria-hidden" "true", class "fa fa-envelope" ] []
                                    , text " "
                                    , text (I18n.translate language I18n.Email)
                                    ]
                                ]
                            , li []
                                [ a [ href "https://twitter.com/ogptoolbox", target "_blank" ]
                                    [ i [ attribute "aria-hidden" "true", class "fa fa-twitter" ] []
                                    , text " "
                                    , text "Twitter"
                                    ]
                                ]
                            ]
                        ]
                    ]
                , div [ class "row copyright" ]
                    [ div [ class "col-md-12" ] [ I18nHtml.translate language I18nHtml.CopyrightLine ] ]
                ]
            ]
        ]


viewHeader : Model -> I18n.Language -> String -> Html Msg
viewHeader model language containerClass =
    let
        aboutDropdown =
            let
                -- A variant of aForPath with stopPropagation = False, to close menu after click
                aForPath navigate language path attributes children =
                    let
                        pathWithLanguage =
                            Urls.languagePath language path
                    in
                        a
                            ([ href pathWithLanguage
                             , onWithOptions
                                "click"
                                { stopPropagation = False, preventDefault = True }
                                (Json.Decode.succeed (navigate pathWithLanguage))
                             ]
                                ++ attributes
                            )
                            children
            in
                li [ class "dropdown" ]
                    [ a
                        [ attribute "aria-expanded" "false"
                        , attribute "aria-haspopup" "true"
                        , attribute "data-toggle" "dropdown"
                        , class "dropdown-toggle"
                        , href "#"
                        , role "button"
                        ]
                        [ text (I18n.translate language I18n.About)
                        , text " "
                        , span [ class "caret" ] []
                        ]
                    , ul [ class "dropdown-menu" ]
                        [ li []
                            [ aForPath
                                Navigate
                                language
                                "/about"
                                []
                                [ text (I18n.translate language I18n.TheProject) ]
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
                            [ aForPath
                                Navigate
                                language
                                "/press"
                                []
                                [ text (I18n.translate language I18n.Press) ]
                            ]
                        , li [ class "divider", role "separator" ] []
                        , li []
                            [ a [ href "mailto:info@ogptpoolbox.org" ]
                                [ i [ attribute "aria-hidden" "true", class "fa fa-envelope" ] []
                                , text " "
                                , text (I18n.translate language I18n.Email)
                                ]
                            ]
                        , li []
                            [ a [ href "https://twitter.com/ogptoolbox", target "_blank" ]
                                [ i [ attribute "aria-hidden" "true", class "fa fa-twitter" ] []
                                , text " "
                                , text "Twitter"
                                ]
                            ]
                        ]
                    ]

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
            [ nav [ class "navbar navbar-default navbar-fixed-top", role "navigation" ]
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
                                , onClick (DisplayNewCardModal True)
                                , type_ "button"
                                ]
                                [ text (I18n.translate language I18n.NewCard) ]
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
                            , li []
                                [ aForPath
                                    Navigate
                                    language
                                    "/ogp"
                                    [ title (I18n.translate language I18n.OpenGovernmentPartnership) ]
                                    [ text (I18n.translate language I18n.Ogp) ]
                                ]
                            , aboutDropdown
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
                                , onClick (DisplayNewCardModal True)
                                , type_ "button"
                                ]
                                [ text (I18n.translate language I18n.NewCard) ]
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
                            , aboutDropdown
                            , profileNavItem
                            , signInOrOutNavItem
                            ]
                        ]
                    ]
                ]
            ]
