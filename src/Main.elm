module Main exposing (..)

import About
import AddNew.State
import AddNew.Types
import AddNew.View
import Authenticator.Model
import Authenticator.Update
import Authenticator.View
import Card.State
import Card.Types
import Card.View
import Constants
import Dict exposing (Dict)
import Dom.Scroll
import Help
import Home
import Hop.Types exposing (Location)
import Html exposing (..)
import Html.App
import Html.Attributes exposing (..)
import Html.Attributes.Aria exposing (ariaHidden, ariaLabelledby)
import Html.Events exposing (onClick, onInput, onSubmit, onWithOptions)
import Html.Helpers exposing (aForPath)
import I18n
import Json.Decode
import Navigation
import Ports
import Routes exposing (..)
import Search.State
import Search.Types
import Search.View
import String
import Task
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
    { addNewModel : AddNew.Types.Model
    , authentication : Maybe Authenticator.Model.Authentication
    , authenticatorModel : Authenticator.Model.Model
    , authenticatorRouteMaybe : Maybe Authenticator.Model.Route
    , cardModel : Card.Types.Model
    , displayAddNewModal : Bool
    , searchModel : Search.Types.Model
    , i18nRoute : I18nRoute
    , location : Hop.Types.Location
    , navigatorLanguage : Maybe I18n.Language
    , searchInputValue : String
    }


init : Flags -> ( I18nRoute, Hop.Types.Location ) -> ( Model, Cmd Msg )
init flags ( i18nRoute, location ) =
    { addNewModel = AddNew.State.init
    , authentication = flags.authentication
    , authenticatorModel = Authenticator.Model.init
    , authenticatorRouteMaybe = Nothing
    , cardModel = Card.State.init
    , displayAddNewModal = False
    , i18nRoute = i18nRoute
    , location = location
    , navigatorLanguage =
        flags.language
            |> String.left 2
            |> String.toLower
            |> I18n.languageFromIso639_1
    , searchInputValue = ""
    , searchModel = Search.State.init
    }
        |> urlUpdate ( i18nRoute, location )



-- ROUTING


urlUpdate : ( I18nRoute, Hop.Types.Location ) -> Model -> ( Model, Cmd Msg )
urlUpdate ( i18nRoute, location ) model =
    let
        searchQuery =
            getSearchQuery location

        ( newModel, cmd ) =
            case i18nRoute of
                I18nRouteWithLanguage language route ->
                    let
                        ( searchModel, searchCmd ) =
                            Search.State.update
                                (Search.Types.Load searchQuery)
                                model.searchModel
                                model.authentication
                                language
                                searchQuery
                    in
                        case route of
                            AboutRoute ->
                                ( model
                                , Ports.setDocumentMetatags
                                    { title = I18n.translate language I18n.About
                                    , imageUrl = Constants.logoUrl
                                    }
                                )

                            HelpRoute ->
                                ( model
                                , Ports.setDocumentMetatags
                                    { title = I18n.translate language I18n.Help
                                    , imageUrl = Constants.logoUrl
                                    }
                                )

                            HomeRoute ->
                                let
                                    newModel =
                                        { model
                                            | searchModel = searchModel
                                            , searchInputValue = searchQuery
                                        }
                                in
                                    newModel
                                        ! [ Cmd.map translateSearchMsg searchCmd
                                          , Ports.setDocumentMetatags
                                                { title = I18n.translate language I18n.Home
                                                , imageUrl = Constants.logoUrl
                                                }
                                          ]

                            NotFoundRoute _ ->
                                ( model
                                , Ports.setDocumentMetatags
                                    { title = I18n.translate language I18n.PageNotFound
                                    , imageUrl = Constants.logoUrl
                                    }
                                )

                            OrganizationsRoute childRoute ->
                                case childRoute of
                                    OrganizationRoute cardId ->
                                        let
                                            ( cardModel, childCmd ) =
                                                Card.State.update
                                                    (Card.Types.Load cardId)
                                                    model.cardModel
                                                    model.authentication
                                                    language

                                            newModel =
                                                { model | cardModel = cardModel }
                                        in
                                            ( model, Cmd.map translateCardMsg childCmd )

                                    OrganizationsIndexRoute ->
                                        let
                                            newModel =
                                                { model
                                                    | searchModel = searchModel
                                                    , searchInputValue = searchQuery
                                                }
                                        in
                                            newModel
                                                ! [ Cmd.map translateSearchMsg searchCmd
                                                  , Ports.setDocumentMetatags
                                                        { title = I18n.translate language (I18n.Organization I18n.Plural)
                                                        , imageUrl = Constants.logoUrl
                                                        }
                                                  ]

                                    NewOrganizationRoute ->
                                        let
                                            addNewModel =
                                                model.addNewModel

                                            newAddNewModel =
                                                { addNewModel
                                                    | fields = Dict.fromList [ ( "Types", "type:organization" ) ]
                                                }

                                            newModel =
                                                { model | addNewModel = newAddNewModel }

                                            cmd =
                                                Ports.setDocumentMetatags
                                                    { title = I18n.translate language I18n.AddNewOrganization
                                                    , imageUrl = Constants.logoUrl
                                                    }
                                        in
                                            ( newModel, cmd )

                            ToolsRoute childRoute ->
                                case childRoute of
                                    ToolRoute cardId ->
                                        let
                                            ( cardModel, childCmd ) =
                                                Card.State.update
                                                    (Card.Types.Load cardId)
                                                    model.cardModel
                                                    model.authentication
                                                    language

                                            newModel =
                                                { model | cardModel = cardModel }
                                        in
                                            ( model, Cmd.map translateCardMsg childCmd )

                                    ToolsIndexRoute ->
                                        let
                                            newModel =
                                                { model
                                                    | searchModel = searchModel
                                                    , searchInputValue = searchQuery
                                                }
                                        in
                                            newModel
                                                ! [ Cmd.map translateSearchMsg searchCmd
                                                  , Ports.setDocumentMetatags
                                                        { title = I18n.translate language (I18n.Tool I18n.Plural)
                                                        , imageUrl = Constants.logoUrl
                                                        }
                                                  ]

                                    NewToolRoute ->
                                        let
                                            addNewModel =
                                                model.addNewModel

                                            newAddNewModel =
                                                { addNewModel
                                                    | fields = Dict.fromList [ ( "Types", "type:software" ) ]
                                                }

                                            newModel =
                                                { model | addNewModel = newAddNewModel }

                                            cmd =
                                                Ports.setDocumentMetatags
                                                    { title = I18n.translate language I18n.AddNewTool
                                                    , imageUrl = Constants.logoUrl
                                                    }
                                        in
                                            ( newModel, cmd )

                            UseCasesRoute childRoute ->
                                case childRoute of
                                    UseCaseRoute cardId ->
                                        let
                                            ( cardModel, childCmd ) =
                                                Card.State.update
                                                    (Card.Types.Load cardId)
                                                    model.cardModel
                                                    model.authentication
                                                    language

                                            newModel =
                                                { model | cardModel = cardModel }
                                        in
                                            ( model, Cmd.map translateCardMsg childCmd )

                                    UseCasesIndexRoute ->
                                        let
                                            newModel =
                                                { model
                                                    | searchModel = searchModel
                                                    , searchInputValue = searchQuery
                                                }
                                        in
                                            newModel
                                                ! [ Cmd.map translateSearchMsg searchCmd
                                                  , Ports.setDocumentMetatags
                                                        { title = I18n.translate language (I18n.UseCase I18n.Plural)
                                                        , imageUrl = Constants.logoUrl
                                                        }
                                                  ]

                                    NewUseCaseRoute ->
                                        let
                                            addNewModel =
                                                model.addNewModel

                                            newAddNewModel =
                                                { addNewModel
                                                    | fields = Dict.fromList [ ( "Types", "type:use-case" ) ]
                                                }

                                            newModel =
                                                { model | addNewModel = newAddNewModel }

                                            cmd =
                                                Ports.setDocumentMetatags
                                                    { title = I18n.translate language I18n.AddNewUseCase
                                                    , imageUrl = Constants.logoUrl
                                                    }
                                        in
                                            ( newModel, cmd )

                I18nRouteWithoutLanguage urlPath ->
                    let
                        language =
                            model.navigatorLanguage |> Maybe.withDefault I18n.English

                        command =
                            makeUrlWithLanguage language
                                (urlPath
                                    ++ (let
                                            searchQuery =
                                                getSearchQuery location
                                        in
                                            if String.isEmpty searchQuery then
                                                ""
                                            else
                                                "?q=" ++ searchQuery
                                       )
                                )
                                |> Navigation.modifyUrl
                    in
                        ( model, command )
    in
        { newModel
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
    = AddNewMsg AddNew.Types.InternalMsg
    | AuthenticatorMsg Authenticator.Update.Msg
    | AuthenticatorRouteMsg (Maybe Authenticator.Model.Route)
    | CardMsg Card.Types.InternalMsg
    | DisplayAddNewModal Bool
    | Navigate String
    | NoOp
    | Search
    | SearchInputChanged String
    | SearchMsg Search.Types.InternalMsg


translateAddNewMsg : AddNew.Types.MsgTranslator Msg
translateAddNewMsg =
    AddNew.Types.translateMsg
        { onInternalMsg = AddNewMsg
        , onNavigate = Navigate
        }


translateCardMsg : Card.Types.MsgTranslator Msg
translateCardMsg =
    Card.Types.translateMsg
        { onInternalMsg = CardMsg
        , onNavigate = Navigate
        }


translateSearchMsg : Search.Types.MsgTranslator Msg
translateSearchMsg =
    Search.Types.translateMsg
        { onInternalMsg = SearchMsg
        , onNavigate = Navigate
        }


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
            AddNewMsg childMsg ->
                let
                    ( addNewModel, childCmd ) =
                        AddNew.State.update childMsg model.addNewModel model.authentication language
                in
                    ( { model | addNewModel = addNewModel }
                    , Cmd.map translateAddNewMsg childCmd
                    )

            AuthenticatorMsg childMsg ->
                let
                    ( authenticatorModel, childCmd ) =
                        Authenticator.Update.update childMsg model.authenticatorModel

                    changed =
                        authenticatorModel.authentication /= model.authentication

                    model' =
                        { model
                            | authentication = authenticatorModel.authentication
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
                ( { model | authenticatorRouteMaybe = authenticatorRouteMaybe }
                , Cmd.none
                )

            CardMsg childMsg ->
                let
                    ( cardModel, childCmd ) =
                        Card.State.update childMsg model.cardModel model.authentication language
                in
                    ( { model | cardModel = cardModel }
                    , Cmd.map translateCardMsg childCmd
                    )

            DisplayAddNewModal displayAddNewModal ->
                ( { model | displayAddNewModal = displayAddNewModal }
                , Cmd.none
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

            Search ->
                let
                    urlPath =
                        "/tools?q=" ++ model.searchInputValue

                    command =
                        makeUrl urlPath
                            |> Navigation.newUrl
                in
                    ( model, command )

            SearchInputChanged searchInputValue ->
                ( { model | searchInputValue = searchInputValue }, Cmd.none )

            SearchMsg childMsg ->
                let
                    ( searchModel, childCmd ) =
                        Search.State.update childMsg model.searchModel model.authentication language searchQuery
                in
                    ( { model | searchModel = searchModel }
                    , Cmd.map translateSearchMsg childCmd
                    )



-- VIEW


view : Model -> Html Msg
view model =
    let
        standardLayout language content =
            div []
                ([ viewHeader model language "container" ]
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
                    [ viewHeader model language "container-fluid" ]
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
            getSearchQuery model.location
    in
        case model.i18nRoute of
            I18nRouteWithLanguage language route ->
                case route of
                    AboutRoute ->
                        About.view language
                            |> standardLayout language

                    HelpRoute ->
                        Help.view language
                            |> standardLayout language

                    HomeRoute ->
                        Home.view model.searchModel (getSearchQuery model.location) language
                            |> Html.App.map translateSearchMsg
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
                                    |> Html.App.map translateCardMsg
                                    |> standardLayout language

                            OrganizationsIndexRoute ->
                                Search.View.view model.searchModel OrganizationCard (getSearchQuery model.location) language
                                    |> Html.App.map translateSearchMsg
                                    |> fullscreenLayout language

                            NewOrganizationRoute ->
                                AddNew.View.viewOrganization model.addNewModel language
                                    |> Html.App.map translateAddNewMsg
                                    |> standardLayout language

                    ToolsRoute childRoute ->
                        case childRoute of
                            ToolRoute _ ->
                                Card.View.view model.cardModel language
                                    |> Html.App.map translateCardMsg
                                    |> standardLayout language

                            ToolsIndexRoute ->
                                Search.View.view model.searchModel ToolCard (getSearchQuery model.location) language
                                    |> Html.App.map translateSearchMsg
                                    |> fullscreenLayout language

                            NewToolRoute ->
                                AddNew.View.viewTool model.addNewModel language
                                    |> Html.App.map translateAddNewMsg
                                    |> standardLayout language

                    UseCasesRoute childRoute ->
                        case childRoute of
                            UseCaseRoute _ ->
                                Card.View.view model.cardModel language
                                    |> Html.App.map translateCardMsg
                                    |> standardLayout language

                            UseCasesIndexRoute ->
                                Search.View.view model.searchModel UseCaseCard (getSearchQuery model.location) language
                                    |> Html.App.map translateSearchMsg
                                    |> fullscreenLayout language

                            NewUseCaseRoute ->
                                AddNew.View.viewUseCase model.addNewModel language
                                    |> Html.App.map translateAddNewMsg
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
                                [ aForPath
                                    Navigate
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
            case model.authentication of
                Just authentication ->
                    li []
                        [ aForPath
                            Navigate
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
            case model.authentication of
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
                        , aForPath
                            Navigate
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
                                [ aForPath
                                    Navigate
                                    "/"
                                    []
                                    [ text (I18n.translate language I18n.Home) ]
                                ]
                            , li []
                                [ aForPath
                                    Navigate
                                    "/about"
                                    []
                                    [ text (I18n.translate language I18n.About) ]
                                ]
                            , li []
                                [ aForPath
                                    Navigate
                                    "/tools"
                                    []
                                    [ text (I18n.translate language (I18n.Tool I18n.Plural)) ]
                                ]
                            , li []
                                [ aForPath
                                    Navigate
                                    "/use-cases"
                                    []
                                    [ text (I18n.translate language (I18n.UseCase I18n.Plural)) ]
                                ]
                              -- , li []
                              --     [ aForPath
                              --         Navigate
                              --         "/organizations"
                              --         []
                              --         [ text (I18n.translate language (I18n.Organization I18n.Plural)) ]
                              --     ]
                            , li []
                                [ aForPath
                                    Navigate
                                    "/collections"
                                    []
                                    [ text (I18n.translate language (I18n.Collection I18n.Plural)) ]
                                ]
                            , li []
                                [ aForPath
                                    Navigate
                                    "/help"
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


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map AddNewMsg (AddNew.State.subscriptions model.addNewModel)
        , Sub.map SearchMsg (Search.State.subscriptions model.searchModel)
        ]
