module Main exposing (..)

import About
import AddNew.State
import AddNew.Types
import AddNew.View
import Authenticator.Activate
import Authenticator.Model
import Authenticator.Update
import Authenticator.View
import Card.State
import Card.Types
import Card.View
import Constants
import Decoders
import Dict exposing (Dict)
import Dom.Scroll
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
    , authentication : Json.Decode.Value
    }



-- MODEL


type alias Model =
    { addNewModel : AddNew.Types.Model
    , activationModel : Authenticator.Activate.Model
    , authentication : Maybe Authenticator.Model.Authentication
    , authenticatorModel : Authenticator.Model.Model
    , authenticatorRouteMaybe : Maybe Authenticator.Model.Route
    , cardModel : Card.Types.Model
    , displayAddNewModal : Bool
    , i18nRoute : I18nRoute
    , location : Hop.Types.Location
    , navigatorLanguage : Maybe I18n.Language
    , searchInputValue : String
    , searchModel : Search.Types.Model
    }


init : Flags -> ( I18nRoute, Hop.Types.Location ) -> ( Model, Cmd Msg )
init flags ( i18nRoute, location ) =
    { addNewModel = AddNew.State.init
    , activationModel = Authenticator.Activate.init
    , authentication =
        Json.Decode.decodeValue Decoders.userForPortDecoder flags.authentication
            |> Result.toMaybe
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
                        indexRoute translationId =
                            let
                                getLocalizedString value =
                                    case value.value of
                                        LocalizedStringValue valueByLanguage ->
                                            case I18n.getValueByPreferredLanguage language valueByLanguage of
                                                Nothing ->
                                                    Debug.crash "indexRoute"

                                                Just tag ->
                                                    tag

                                        _ ->
                                            Debug.crash "indexRoute"

                                selectedTags =
                                    case Dict.get "tagIds" location.query of
                                        Nothing ->
                                            []

                                        Just tagIds ->
                                            tagIds
                                                |> String.split ","
                                                |> List.map
                                                    (\tagId ->
                                                        { count = 50
                                                        , tag = ""
                                                        , tagId = tagId
                                                        }
                                                    )

                                searchModel =
                                    model.searchModel

                                newSearchModel =
                                    { searchModel | selectedTags = selectedTags }

                                ( newSearchModel2, searchCmd ) =
                                    Search.State.update
                                        Search.Types.Load
                                        newSearchModel
                                        model.authentication
                                        language
                                        location

                                newModel =
                                    { model
                                        | searchModel = newSearchModel2
                                        , searchInputValue = searchQuery
                                    }
                            in
                                newModel
                                    ! [ Cmd.map translateSearchMsg searchCmd
                                      , Ports.setDocumentMetatags
                                            { title = I18n.translate language translationId
                                            , imageUrl = Constants.logoUrl
                                            }
                                      ]
                    in
                        case route of
                            AboutRoute ->
                                ( model
                                , Ports.setDocumentMetatags
                                    { title = I18n.translate language I18n.About
                                    , imageUrl = Constants.logoUrl
                                    }
                                )

                            ActivationRoute userId ->
                                let
                                    ( activationModel, childCmd ) =
                                        Authenticator.Activate.update
                                            (Authenticator.Activate.Load
                                                userId
                                                (Dict.get "authorization" location.query |> Maybe.withDefault "")
                                            )
                                            model.activationModel
                                            language

                                    newModel =
                                        { model | activationModel = activationModel }
                                in
                                    ( model, Cmd.map translateActivationMsg childCmd )

                            HomeRoute ->
                                indexRoute I18n.Home

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
                                        indexRoute (I18n.Organization I18n.Plural)

                                    NewOrganizationRoute ->
                                        let
                                            addNewModel =
                                                model.addNewModel

                                            newAddNewModel =
                                                { addNewModel
                                                    | fields = Dict.fromList [ ( "Types", "organization" ) ]
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
                                        indexRoute (I18n.Tool I18n.Plural)

                                    NewToolRoute ->
                                        let
                                            addNewModel =
                                                model.addNewModel

                                            newAddNewModel =
                                                { addNewModel
                                                    | fields = Dict.fromList [ ( "Types", "software" ) ]
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
                                        indexRoute (I18n.UseCase I18n.Plural)

                                    NewUseCaseRoute ->
                                        let
                                            addNewModel =
                                                model.addNewModel

                                            newAddNewModel =
                                                { addNewModel
                                                    | fields = Dict.fromList [ ( "Types", "use-case" ) ]
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
                                (urlPath ++ (queryStringForParams [ "q", "tagIds" ] location))
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
    = Activate User
    | ActivationMsg Authenticator.Activate.InternalMsg
    | AddNewMsg AddNew.Types.InternalMsg
    | AuthenticatorMsg Authenticator.Update.Msg
    | AuthenticatorRouteMsg (Maybe Authenticator.Model.Route)
    | CardMsg Card.Types.InternalMsg
    | DisplayAddNewModal Bool
    | Navigate String
    | NoOp
    | Search
    | SearchInputChanged String
    | SearchMsg Search.Types.InternalMsg


translateActivationMsg : Authenticator.Activate.MsgTranslator Msg
translateActivationMsg =
    Authenticator.Activate.translateMsg
        { onInternalMsg = ActivationMsg
        , onActivate = Activate
        }


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

        navigate urlPath =
            let
                currentUrlPath =
                    makeUrlFromLocation model.location
            in
                if currentUrlPath /= urlPath then
                    makeUrl urlPath
                        |> Navigation.newUrl
                else
                    Cmd.none
    in
        case msg of
            Activate authentication ->
                ( { model | authentication = Just authentication }
                , Cmd.none
                )

            ActivationMsg childMsg ->
                let
                    ( activationModel, childCmd ) =
                        Authenticator.Activate.update childMsg model.activationModel language
                in
                    ( { model | activationModel = activationModel }
                    , Cmd.map translateActivationMsg childCmd
                    )

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

            Navigate urlPath ->
                let
                    cmd =
                        navigate urlPath
                in
                    ( model, cmd )

            NoOp ->
                ( model, Cmd.none )

            Search ->
                let
                    keptParams =
                        ( "q", model.searchInputValue )
                            :: (case Dict.get "tagIds" model.location.query of
                                    Nothing ->
                                        []

                                    Just tagIds ->
                                        [ ( "tagIds", tagIds ) ]
                               )

                    urlPath =
                        "/tools?"
                            ++ (keptParams
                                    |> List.map (\( k, v ) -> k ++ "=" ++ v)
                                    |> String.join "&"
                               )

                    cmd =
                        navigate urlPath
                in
                    ( model, cmd )

            SearchInputChanged searchInputValue ->
                ( { model | searchInputValue = searchInputValue }, Cmd.none )

            SearchMsg childMsg ->
                let
                    ( newSearchModel, childCmd ) =
                        Search.State.update
                            childMsg
                            model.searchModel
                            model.authentication
                            language
                            model.location

                    newModel =
                        { model | searchModel = newSearchModel }
                in
                    ( newModel
                    , Cmd.map translateSearchMsg childCmd
                    )



-- VIEW


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
            getSearchQuery model.location
    in
        case model.i18nRoute of
            I18nRouteWithLanguage language route ->
                case route of
                    AboutRoute ->
                        About.view language
                            |> standardLayout language

                    ActivationRoute userId ->
                        Authenticator.Activate.view model.activationModel language userId
                            |> Html.App.map translateActivationMsg
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
                                Search.View.view model.searchModel OrganizationCard language model.location
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
                                Search.View.view model.searchModel ToolCard language model.location
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
                                Search.View.view model.searchModel UseCaseCard language model.location
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
                        [ button [ attribute "aria-label" "Close", class "close", attribute "data-dismiss" "alert", type' "button" ]
                            [ span [ attribute "aria-hidden" "true" ]
                                [ text "×" ]
                            ]
                        , text (I18n.translate language I18n.EmailSentForAccountActivation)
                        ]
                    ]


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
                                        (let
                                            aForPath urlPath children =
                                                a
                                                    [ href (makeUrl urlPath)
                                                    , onWithOptions
                                                        "click"
                                                        { stopPropagation = True, preventDefault = True }
                                                        (Json.Decode.succeed (Navigate urlPath))
                                                    ]
                                                    children
                                         in
                                            [ li []
                                                [ aForPath
                                                    (replaceLanguageInLocation I18n.English model.location)
                                                    [ text (I18n.translate I18n.English (I18n.Language I18n.English)) ]
                                                ]
                                            , li []
                                                [ aForPath
                                                    (replaceLanguageInLocation I18n.French model.location)
                                                    [ text (I18n.translate I18n.French (I18n.Language I18n.French)) ]
                                                ]
                                            , li []
                                                [ aForPath
                                                    (replaceLanguageInLocation I18n.Spanish model.location)
                                                    [ text (I18n.translate I18n.Spanish (I18n.Language I18n.Spanish)) ]
                                                ]
                                            ]
                                        )
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
                                    "/help"
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


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map AddNewMsg (AddNew.State.subscriptions model.addNewModel)
        , Sub.map SearchMsg (Search.State.subscriptions model.searchModel)
        ]
