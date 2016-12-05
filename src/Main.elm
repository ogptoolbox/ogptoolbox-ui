port module Main exposing (..)

import About
import Authenticator.Model
import Authenticator.Update
import Authenticator.View
import Constants
import Dom.Scroll
import Examples
import Help
import Home
import Hop.Types exposing (Location)
import Html exposing (..)
import Html.App
import Html.Attributes exposing (..)
import Html.Attributes.Aria exposing (ariaHidden, ariaLabelledby)
import Html.Events exposing (onClick, onInput, onSubmit, onWithOptions)
import Html.Helpers exposing (aForPath, aForPathWithLanguage)
import I18n
import Json.Decode
import Navigation
import Organizations
import Ports exposing (setDocumentMetatags)
import Routes
    exposing
        ( addSearchQueryToLocation
        , ExamplesNestedRoute(..)
        , getSearchQuery
        , I18nRoute(..)
        , makeUrl
        , makeUrlFromLocation
        , makeUrlWithLanguage
        , OrganizationsNestedRoute(..)
        , Route(..)
        , ToolsNestedRoute(..)
        , replaceLanguageInLocation
        , urlParser
        )
import String
import Task
import Tools
import Types exposing (..)
import Views exposing (viewBigMessage, viewNotFound)


main : Program Flags
main =
    Navigation.programWithFlags urlParser
        { init = init
        , update = update
        , urlUpdate = urlUpdate
        , view = view
        , subscriptions = subscriptions
        }


type alias Flags =
    { language : String
    , authentication : Maybe Authenticator.Model.Authentication
    }



-- MODEL


type alias Model =
    { authenticationMaybe : Maybe Authenticator.Model.Authentication
    , authenticatorModel : Authenticator.Model.Model
    , authenticatorRouteMaybe : Maybe Authenticator.Model.Route
    , displayAddNewModal : Bool
    , examplesModel : Examples.Model
    , homeModel : Home.Model
    , i18nRoute : I18nRoute
    , location : Hop.Types.Location
    , navigatorLanguage : Maybe I18n.Language
    , organizationsModel : Organizations.Model
    , searchInputValue : String
    , toolsModel : Tools.Model
    }


init : Flags -> ( I18nRoute, Hop.Types.Location ) -> ( Model, Cmd Msg )
init flags ( i18nRoute, location ) =
    { authenticationMaybe = flags.authentication
    , authenticatorModel = Authenticator.Model.init
    , authenticatorRouteMaybe = Nothing
    , displayAddNewModal = False
    , examplesModel = Examples.init
    , homeModel = Home.init
    , i18nRoute = i18nRoute
    , location = location
    , navigatorLanguage =
        flags.language
            |> String.left 2
            |> String.toLower
            |> I18n.languageFromIso639_1
    , organizationsModel = Organizations.init
    , searchInputValue = ""
    , toolsModel = Tools.init
    }
        |> urlUpdate ( i18nRoute, location )



-- ROUTING


urlUpdate : ( I18nRoute, Hop.Types.Location ) -> Model -> ( Model, Cmd Msg )
urlUpdate ( i18nRoute, location ) model =
    let
        searchQuery =
            getSearchQuery location

        ( model', cmd ) =
            case i18nRoute of
                I18nRouteWithLanguage language route ->
                    case route of
                        AboutRoute ->
                            ( model
                            , setDocumentMetatags
                                { title = I18n.translate language I18n.About
                                , imageUrl = Constants.logoUrl
                                }
                            )

                        ExamplesRoute childRoute ->
                            let
                                ( examplesModel, childCmd ) =
                                    Examples.urlUpdate ( childRoute, location ) language model.examplesModel
                            in
                                ( { model
                                    | examplesModel = examplesModel
                                    , searchInputValue = searchQuery
                                  }
                                , Cmd.map translateExamplesMsg childCmd
                                )

                        HelpRoute ->
                            ( model
                            , setDocumentMetatags
                                { title = I18n.translate language I18n.Help
                                , imageUrl = Constants.logoUrl
                                }
                            )

                        HomeRoute ->
                            let
                                ( homeModel, childCmd ) =
                                    Home.update
                                        (Home.Load searchQuery)
                                        model.homeModel
                                        model.authenticationMaybe
                                        language
                                        searchQuery
                                        mountd3bubbles

                                newModel =
                                    { model
                                        | homeModel = homeModel
                                        , searchInputValue = searchQuery
                                    }
                            in
                                newModel
                                    ! [ Cmd.map translateHomeMsg childCmd
                                      , setDocumentMetatags
                                            { title = I18n.translate language I18n.Home
                                            , imageUrl = Constants.logoUrl
                                            }
                                      ]

                        NotFoundRoute _ ->
                            ( model
                            , setDocumentMetatags
                                { title = I18n.translate language I18n.PageNotFound
                                , imageUrl = Constants.logoUrl
                                }
                            )

                        OrganizationsRoute childRoute ->
                            let
                                ( organizationsModel, childCmd ) =
                                    Organizations.urlUpdate ( childRoute, location ) model.organizationsModel
                            in
                                ( { model
                                    | organizationsModel = organizationsModel
                                    , searchInputValue = searchQuery
                                  }
                                , Cmd.map translateOrganizationsMsg childCmd
                                )

                        ToolsRoute childRoute ->
                            let
                                ( toolsModel, childCmd ) =
                                    Tools.urlUpdate ( childRoute, location ) language model.toolsModel
                            in
                                ( { model
                                    | toolsModel = toolsModel
                                    , searchInputValue = searchQuery
                                  }
                                , Cmd.map translateToolsMsg childCmd
                                )

                I18nRouteWithoutLanguage urlPath ->
                    let
                        language =
                            model.navigatorLanguage |> Maybe.withDefault I18n.English

                        command =
                            makeUrlWithLanguage language urlPath
                                |> Navigation.modifyUrl
                    in
                        ( model, command )
    in
        { model'
            | location = location
            , i18nRoute = i18nRoute
        }
            ! [ Task.perform
                    (\_ -> Debug.crash "Dom.Scroll.toTop \"html-element\"")
                    (always NoOp)
                    (Dom.Scroll.toTop "html-element")
              , cmd
              ]



-- UPDATE


type Msg
    = AuthenticatorMsg Authenticator.Update.Msg
    | AuthenticatorRouteMsg (Maybe Authenticator.Model.Route)
    | DeselectBubble String
    | DisplayAddNewModal Bool
    | ExamplesMsg Examples.InternalMsg
    | HomeMsg Home.InternalMsg
    | Navigate String
    | NoOp
    | OrganizationsMsg Organizations.InternalMsg
    | Search
    | SearchInputChanged String
    | SelectBubble String
    | ToolsMsg Tools.InternalMsg


port mountd3bubbles : ( List PopularTag, List String ) -> Cmd msg


examplesMsgTranslation : Examples.MsgTranslation Msg
examplesMsgTranslation =
    { onInternalMsg = ExamplesMsg
    , onNavigate = Navigate
    }


homeMsgTranslation : Home.MsgTranslation Msg
homeMsgTranslation =
    { onInternalMsg = HomeMsg
    , onNavigate = Navigate
    }


organizationsMsgTranslation : Organizations.MsgTranslation Msg
organizationsMsgTranslation =
    { onInternalMsg = OrganizationsMsg
    , onNavigate = Navigate
    }


toolsMsgTranslation : Tools.MsgTranslation Msg
toolsMsgTranslation =
    { onInternalMsg = ToolsMsg
    , onNavigate = Navigate
    }


translateExamplesMsg : Examples.MsgTranslator Msg
translateExamplesMsg =
    Examples.translateMsg examplesMsgTranslation


translateHomeMsg : Home.MsgTranslator Msg
translateHomeMsg =
    Home.translateMsg homeMsgTranslation


translateOrganizationsMsg : Organizations.MsgTranslator Msg
translateOrganizationsMsg =
    Organizations.translateMsg organizationsMsgTranslation


translateToolsMsg : Tools.MsgTranslator Msg
translateToolsMsg =
    Tools.translateMsg toolsMsgTranslation


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        searchQuery =
            getSearchQuery model.location

        language =
            case model.i18nRoute of
                I18nRouteWithLanguage language _ ->
                    language

                _ ->
                    I18n.English
    in
        case msg of
            AuthenticatorMsg childMsg ->
                let
                    ( authenticatorModel, childCmd ) =
                        Authenticator.Update.update childMsg model.authenticatorModel

                    changed =
                        authenticatorModel.authenticationMaybe /= model.authenticationMaybe

                    model' =
                        { model
                            | authenticationMaybe = authenticatorModel.authenticationMaybe
                            , authenticatorModel = authenticatorModel
                            , authenticatorRouteMaybe =
                                if changed then
                                    Nothing
                                else
                                    model.authenticatorRouteMaybe
                        }

                    ( model'', effect'' ) =
                        if changed then
                            update (Navigate "/") model'
                        else
                            ( model', Cmd.none )
                in
                    model'' ! [ Cmd.map AuthenticatorMsg childCmd, effect'' ]

            AuthenticatorRouteMsg authenticatorRouteMaybe ->
                ( { model | authenticatorRouteMaybe = authenticatorRouteMaybe }, Cmd.none )

            DeselectBubble deselectedTag ->
                case model.i18nRoute of
                    I18nRouteWithLanguage language route ->
                        case route of
                            HomeRoute ->
                                let
                                    ( homeModel, childCmd ) =
                                        Home.update
                                            (Home.DeselectBubble deselectedTag)
                                            model.homeModel
                                            model.authenticationMaybe
                                            language
                                            searchQuery
                                            mountd3bubbles
                                in
                                    ( { model | homeModel = homeModel }
                                    , Cmd.map translateHomeMsg childCmd
                                    )

                            OrganizationsRoute _ ->
                                let
                                    ( organizationsModel, childCmd ) =
                                        Organizations.update
                                            (Organizations.DeselectBubble deselectedTag)
                                            model.organizationsModel
                                            model.authenticationMaybe
                                            language
                                            searchQuery
                                            setDocumentMetatags
                                            mountd3bubbles
                                in
                                    ( { model | organizationsModel = organizationsModel }
                                    , Cmd.map translateOrganizationsMsg childCmd
                                    )

                            _ ->
                                ( model, Cmd.none )

                    I18nRouteWithoutLanguage _ ->
                        ( model, Cmd.none )

            DisplayAddNewModal displayAddNewModal ->
                ( { model | displayAddNewModal = displayAddNewModal }
                , Cmd.none
                )

            ExamplesMsg childMsg ->
                let
                    ( examplesModel, childCmd ) =
                        Examples.update
                            childMsg
                            model.examplesModel
                            model.authenticationMaybe
                            language
                            -- searchQuery
                            setDocumentMetatags

                    -- mountd3bubbles
                in
                    ( { model | examplesModel = examplesModel }
                    , Cmd.map translateExamplesMsg childCmd
                    )

            HomeMsg childMsg ->
                let
                    ( homeModel, childCmd ) =
                        Home.update
                            childMsg
                            model.homeModel
                            model.authenticationMaybe
                            language
                            searchQuery
                            mountd3bubbles
                in
                    ( { model | homeModel = homeModel }
                    , Cmd.map translateHomeMsg childCmd
                    )

            Navigate path ->
                let
                    command =
                        makeUrl path
                            |> Navigation.newUrl
                in
                    ( model, command )

            NoOp ->
                ( model, Cmd.none )

            OrganizationsMsg childMsg ->
                let
                    ( organizationsModel, childCmd ) =
                        Organizations.update
                            childMsg
                            model.organizationsModel
                            model.authenticationMaybe
                            language
                            searchQuery
                            setDocumentMetatags
                            mountd3bubbles
                in
                    ( { model | organizationsModel = organizationsModel }
                    , Cmd.map translateOrganizationsMsg childCmd
                    )

            Search ->
                let
                    urlPath =
                        "/tools?q=" ++ model.searchInputValue

                    command =
                        (case model.i18nRoute of
                            I18nRouteWithLanguage language _ ->
                                makeUrlWithLanguage language urlPath

                            I18nRouteWithoutLanguage _ ->
                                makeUrl urlPath
                        )
                            |> Navigation.newUrl
                in
                    ( model, command )

            SearchInputChanged searchInputValue ->
                ( { model | searchInputValue = searchInputValue }, Cmd.none )

            SelectBubble selectedTag ->
                case model.i18nRoute of
                    I18nRouteWithLanguage language route ->
                        case route of
                            HomeRoute ->
                                let
                                    ( homeModel, childCmd ) =
                                        Home.update
                                            (Home.SelectBubble selectedTag)
                                            model.homeModel
                                            model.authenticationMaybe
                                            language
                                            searchQuery
                                            mountd3bubbles
                                in
                                    ( { model | homeModel = homeModel }
                                    , Cmd.map translateHomeMsg childCmd
                                    )

                            OrganizationsRoute _ ->
                                let
                                    ( organizationsModel, childCmd ) =
                                        Organizations.update
                                            (Organizations.SelectBubble selectedTag)
                                            model.organizationsModel
                                            model.authenticationMaybe
                                            language
                                            searchQuery
                                            setDocumentMetatags
                                            mountd3bubbles
                                in
                                    ( { model | organizationsModel = organizationsModel }
                                    , Cmd.map translateOrganizationsMsg childCmd
                                    )

                            _ ->
                                ( model, Cmd.none )

                    I18nRouteWithoutLanguage _ ->
                        ( model, Cmd.none )

            ToolsMsg childMsg ->
                let
                    ( toolsModel, childCmd ) =
                        Tools.update childMsg model.toolsModel model.authenticationMaybe language
                in
                    ( { model | toolsModel = toolsModel }
                    , Cmd.map translateToolsMsg childCmd
                    )



-- VIEW


view : Model -> Html Msg
view model =
    let
        standardLayout language content =
            div []
                ([ viewHeader model language "container" ]
                    ++ content
                    ++ [ viewFooter model language
                       , viewAuthenticatorModal model language
                       , viewAddNewModal model language
                       , viewBackdrop model
                       ]
                )

        fullscreenLayout language content =
            div [ class "main-container" ]
                ([ div [ class "fixed-header" ]
                    [ viewHeader model language "container-fluid" ]
                 ]
                    ++ content
                    ++ [ div [ class "fixed-footer" ]
                            [ text (I18n.translate language I18n.Copyright) ]
                       , viewAuthenticatorModal model language
                       , viewAddNewModal model language
                       , viewBackdrop model
                       ]
                )

        searchQuery =
            getSearchQuery model.location
    in
        case model.i18nRoute of
            I18nRouteWithLanguage language route ->
                case route of
                    AboutRoute ->
                        standardLayout language
                            [ About.view language ]

                    ExamplesRoute childRoute ->
                        Examples.view model.authenticationMaybe model.examplesModel searchQuery language
                            |> List.map (Html.App.map translateExamplesMsg)
                            |> case childRoute of
                                ExampleRoute _ ->
                                    standardLayout language

                                ExamplesIndexRoute ->
                                    fullscreenLayout language

                                NewExampleRoute ->
                                    standardLayout language

                    HelpRoute ->
                        standardLayout language
                            [ Help.view language ]

                    HomeRoute ->
                        standardLayout language
                            [ Html.App.map translateHomeMsg
                                (Home.view model.homeModel (getSearchQuery model.location) language)
                            ]

                    NotFoundRoute _ ->
                        standardLayout language
                            [ div [ class "row section" ]
                                [ div [ class "container" ]
                                    [ viewNotFound language ]
                                ]
                            ]

                    OrganizationsRoute childRoute ->
                        Organizations.view model.authenticationMaybe model.organizationsModel searchQuery language
                            |> List.map (Html.App.map translateOrganizationsMsg)
                            |> case childRoute of
                                OrganizationRoute _ ->
                                    standardLayout language

                                OrganizationsIndexRoute ->
                                    fullscreenLayout language

                    ToolsRoute childRoute ->
                        Tools.view model.authenticationMaybe model.toolsModel searchQuery language
                            |> List.map (Html.App.map translateToolsMsg)
                            |> case childRoute of
                                ToolRoute _ ->
                                    standardLayout language

                                ToolsIndexRoute ->
                                    fullscreenLayout language

                                NewToolRoute ->
                                    standardLayout language

            I18nRouteWithoutLanguage _ ->
                standardLayout
                    I18n.English
                    [ div [ style [ ( "min-height", "60em" ) ] ]
                        [ viewBigMessage "" "" ]
                    ]


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
                            , type' "button"
                            ]
                            [ span [ attribute "aria-hidden" "true" ]
                                [ text "×" ]
                            , span [ class "sr-only" ]
                                [ text "Close" ]
                            ]
                        , h4 [ class "modal-title", id "myModalLabel" ]
                            [ text "Add an new item" ]
                        ]
                    , div [ class "modal-body" ]
                        [ div [ class "row" ]
                            [ div [ class "col-xs-12" ]
                                [ aForPathWithLanguage
                                    Navigate
                                    language
                                    "/tools/new"
                                    [ class "media action"
                                      -- TODO Disable if not signed-in.
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
                                , aForPathWithLanguage
                                    Navigate
                                    language
                                    "/examples/new"
                                    [ class "media action"
                                      -- TODO Disable if not signed-in.
                                    , onClick (DisplayAddNewModal False)
                                    ]
                                    [ div [ class "media-left icon" ]
                                        [ span [ attribute "aria-hidden" "true", class "glyphicon glyphicon-bookmark" ]
                                            []
                                        ]
                                    , div [ class "media-body" ]
                                        [ h4 [ class "media-heading" ]
                                            [ text (I18n.translate language (I18n.Example I18n.Singular)) ]
                                        , text (I18n.translate language I18n.AddNewExampleCatchPhrase)
                                        ]
                                    ]
                                , a [ class "media action", href "TODO-new-collection.html" ]
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


viewAuthenticatorModal : Model -> I18n.Language -> Html Msg
viewAuthenticatorModal model language =
    case model.authenticatorRouteMaybe of
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
                                , onWithOptions
                                    "click"
                                    { preventDefault = True, stopPropagation = False }
                                    (Json.Decode.succeed (AuthenticatorRouteMsg Nothing))
                                , type' "button"
                                ]
                                [ span [ ariaHidden True ]
                                    [ text "×" ]
                                , span [ class "sr-only" ]
                                    [ text (I18n.translate language I18n.Close) ]
                                ]
                            , h4 [ class "modal-title", id "modal-title" ]
                                [ text (Authenticator.View.modalTitle authenticatorRoute) ]
                            ]
                        , Html.App.map
                            AuthenticatorMsg
                            (Authenticator.View.viewModalBody authenticatorRoute model.authenticatorModel)
                        ]
                    ]
                ]

        Nothing ->
            text ""


viewBackdrop : Model -> Html Msg
viewBackdrop model =
    div [ classList [ ( "modal-backdrop in", model.authenticatorRouteMaybe /= Nothing || model.displayAddNewModal ) ] ]
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
                                        , type' "button"
                                        ]
                                        [ text (I18n.translate language (I18n.Language language))
                                        , span [ class "caret" ] []
                                        ]
                                    , ul [ attribute "aria-labelledby" "dropdownMenu1", class "dropdown-menu" ]
                                        [ li []
                                            [ aForPath Navigate
                                                (replaceLanguageInLocation I18n.English model.location)
                                                []
                                                [ text (I18n.translate I18n.English (I18n.Language I18n.English)) ]
                                            ]
                                        , li []
                                            [ aForPath Navigate
                                                (replaceLanguageInLocation I18n.French model.location)
                                                []
                                                [ text (I18n.translate I18n.French (I18n.Language I18n.French)) ]
                                            ]
                                        , li []
                                            [ aForPath Navigate
                                                (replaceLanguageInLocation I18n.Spanish model.location)
                                                []
                                                [ text (I18n.translate I18n.Spanish (I18n.Language I18n.Spanish)) ]
                                            ]
                                        ]
                                    ]
                                ]
                            ]
                        , p [ class "info-box" ]
                            [ text (I18n.translate language I18n.OpenGovParagraph) ]
                        ]
                    , div [ class "col-xs-6 col-md-3" ]
                        [ h4 []
                            [ text (I18n.translate language I18n.About) ]
                        , ul [ class "footer-menu" ]
                            [ li []
                                [ a [ href "#" ]
                                    [ text "Eligibility Criteria" ]
                                ]
                            , li []
                                [ a [ href "#" ]
                                    [ text "Develop a National Action Plan" ]
                                ]
                            , li []
                                [ a [ href "#" ]
                                    [ text "Self-Assessment Process" ]
                                ]
                            , li []
                                [ a [ href "#" ]
                                    [ text "Response Policy" ]
                                ]
                            , li []
                                [ a [ href "#" ]
                                    [ text "Civil Society Engagement" ]
                                ]
                            , li []
                                [ a [ href "#" ]
                                    [ text "Calendars and Deadlines" ]
                                ]
                            ]
                        ]
                    , div [ class "col-xs-6 col-md-3" ]
                        [ h4 []
                            [ text "How it works" ]
                        , ul [ class "footer-menu" ]
                            [ li []
                                [ a [ href "#" ]
                                    [ text "Home" ]
                                ]
                            , li []
                                [ a [ href "#" ]
                                    [ text "Profile" ]
                                ]
                            , li []
                                [ a [ href "#" ]
                                    [ text "Messages" ]
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
            case model.authenticationMaybe of
                Just authentication ->
                    li []
                        [ aForPathWithLanguage
                            Navigate
                            language
                            "/profile"
                            []
                            [ text authentication.name ]
                        ]

                Nothing ->
                    text ""

        signInOrOutNavItem =
            case model.authenticationMaybe of
                Just authentication ->
                    li []
                        [ a
                            [ href "#"
                            , onWithOptions
                                "click"
                                { preventDefault = True, stopPropagation = False }
                                (Json.Decode.succeed (AuthenticatorRouteMsg (Just Authenticator.Model.SignOutRoute)))
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
                                (Json.Decode.succeed (AuthenticatorRouteMsg (Just Authenticator.Model.SignInRoute)))
                            ]
                            [ text (I18n.translate language I18n.SignIn) ]
                        ]

        signUpNavItem =
            case model.authenticationMaybe of
                Just authentication ->
                    text ""

                Nothing ->
                    li []
                        [ a
                            [ href "#"
                            , onWithOptions
                                "click"
                                { preventDefault = True, stopPropagation = False }
                                (Json.Decode.succeed (AuthenticatorRouteMsg (Just Authenticator.Model.SignUpRoute)))
                            ]
                            [ text (I18n.translate language I18n.SignUp) ]
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
                            , attribute "data-target" "#navbar"
                            , attribute "data-toggle" "collapse"
                            , type' "button"
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
                        , aForPathWithLanguage
                            Navigate
                            language
                            "/"
                            [ class "navbar-brand" ]
                            [ text "OGPtoolbox" ]
                        , p [ class "navbar-text" ]
                            [ text (I18n.translate language I18n.HeaderTitle) ]
                        ]
                    , ul [ class "nav navbar-nav navbar-right" ]
                        [ profileNavItem
                        , signInOrOutNavItem
                        , signUpNavItem
                        , button
                            [ class "btn btn-default btn-action"
                            , onClick (DisplayAddNewModal True)
                            , type' "button"
                            ]
                            [ text (I18n.translate language I18n.AddNew) ]
                        ]
                    ]
                ]
            , nav [ class "navbar navbar-inverse" ]
                [ div [ class containerClass ]
                    [ div [ class "navbar-header" ]
                        [ button
                            [ attribute "aria-expanded" "false"
                            , class "navbar-toggle collapsed"
                            , attribute "data-target" "#bs-example-navbar-collapse-1"
                            , attribute "data-toggle" "collapse"
                            , type' "button"
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
                        ]
                    , div [ class "collapse navbar-collapse", id "bs-example-navbar-collapse-1" ]
                        [ ul [ class "nav navbar-nav" ]
                            [ li []
                                [ aForPathWithLanguage
                                    Navigate
                                    language
                                    "/tools"
                                    []
                                    [ text (I18n.translate language (I18n.Tool I18n.Plural)) ]
                                ]
                            , li []
                                [ aForPathWithLanguage
                                    Navigate
                                    language
                                    "/examples"
                                    []
                                    [ text (I18n.translate language (I18n.Example I18n.Plural)) ]
                                ]
                              -- , li []
                              --     [ aForPathWithLanguage
                              --         Navigate
                              --         language
                              --         "/organizations"
                              --         []
                              --         [ text (I18n.translate language (I18n.Organization I18n.Plural)) ]
                              --     ]
                            , li []
                                [ aForPathWithLanguage
                                    Navigate
                                    language
                                    "/collections"
                                    []
                                    [ text (I18n.translate language (I18n.Collection I18n.Plural)) ]
                                ]
                            , li []
                                [ aForPathWithLanguage
                                    Navigate
                                    language
                                    "/about"
                                    []
                                    [ text (I18n.translate language I18n.About) ]
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
                                    , type' "search"
                                    , value model.searchInputValue
                                    ]
                                    []
                                ]
                            ]
                        ]
                    ]
                ]
            ]



-- SUBSCRIPTIONS


port bubbleSelections : (String -> msg) -> Sub msg


port bubbleDeselections : (String -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ bubbleSelections SelectBubble
        , bubbleDeselections DeselectBubble
        , Sub.map ToolsMsg (Tools.subscriptions model.toolsModel)
        ]
