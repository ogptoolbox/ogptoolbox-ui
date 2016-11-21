module Examples exposing (..)

import Authenticator.Model
import Browse exposing (PillType(..))
import Example
import Hop.Types
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Maybe.Helpers
import Requests exposing (newTaskGetExample, newTaskGetExamples)
import Routes exposing (getSearchQuery, ExamplesNestedRoute(..))
import Task
import Types exposing (Statement, StatementCustom(..))
import Views exposing (viewWebData)
import WebData exposing (LoadingStatus(..), getData, WebData(..))


-- MODEL


type alias ExampleOptions =
    { additionalInformationsCollapsed : Bool }


type Model
    = Examples (WebData (List Statement))
    | Example (WebData Statement) ExampleOptions


defaultExampleOptions : ExampleOptions
defaultExampleOptions =
    { additionalInformationsCollapsed = False }


init : Model
init =
    Examples NotAsked



-- ROUTING


urlUpdate : ( ExamplesNestedRoute, Hop.Types.Location ) -> Model -> ( Model, Cmd Msg )
urlUpdate ( route, location ) model =
    let
        searchQuery =
            getSearchQuery location
    in
        case route of
            ExampleRoute exampleId ->
                ( model, loadOne exampleId )

            ExamplesIndexRoute ->
                ( model, loadAll searchQuery )



-- UPDATE


type ExternalMsg
    = Navigate String


type InternalMsg
    = Error Http.Error
    | LoadAll String
    | LoadOne String
    | LoadedAll (List Statement)
    | LoadedOne Statement


type Msg
    = ForParent ExternalMsg
    | ForSelf InternalMsg


type alias MsgTranslation parentMsg =
    { onInternalMsg : InternalMsg -> parentMsg
    , onNavigate : String -> parentMsg
    }


type alias MsgTranslator parentMsg =
    Msg -> parentMsg


loadAll : String -> Cmd Msg
loadAll searchQuery =
    Task.perform (\_ -> Debug.crash "") (\_ -> ForSelf (LoadAll searchQuery)) (Task.succeed "")


loadOne : String -> Cmd Msg
loadOne id =
    Task.perform (\_ -> Debug.crash "") (\_ -> ForSelf (LoadOne id)) (Task.succeed "")


navigate : String -> Msg
navigate path =
    ForParent (Navigate path)


translateMsg : MsgTranslation parentMsg -> MsgTranslator parentMsg
translateMsg { onInternalMsg, onNavigate } msg =
    case msg of
        ForParent (Navigate path) ->
            onNavigate path

        ForSelf internalMsg ->
            onInternalMsg internalMsg


update : InternalMsg -> Maybe Authenticator.Model.Authentication -> Model -> ( Model, Cmd Msg )
update msg authenticationMaybe model =
    case msg of
        Error err ->
            let
                _ =
                    Debug.log "Examples Error" err

                model' =
                    case model of
                        Example _ options ->
                            Example (Failure err) options

                        Examples _ ->
                            Examples (Failure err)
            in
                ( model', Cmd.none )

        LoadAll searchQuery ->
            let
                loadingStatus =
                    Loading
                        (case model of
                            Example _ _ ->
                                Nothing

                            Examples webData ->
                                getData webData
                        )

                model' =
                    Examples (Data loadingStatus)

                cmd =
                    Task.perform Error LoadedAll (newTaskGetExamples authenticationMaybe searchQuery)
                        |> Cmd.map ForSelf
            in
                ( model', cmd )

        LoadOne exampleId ->
            let
                model' =
                    case model of
                        Example webData options ->
                            Example (Data (Loading (getData webData))) options

                        Examples _ ->
                            Example (Data (Loading Nothing)) defaultExampleOptions

                cmd =
                    Task.perform Error LoadedOne (newTaskGetExample authenticationMaybe exampleId)
                        |> Cmd.map ForSelf
            in
                ( model', cmd )

        LoadedAll statements ->
            ( Examples (Data (Loaded statements)), Cmd.none )

        LoadedOne statement ->
            ( Example (Data (Loaded statement)) defaultExampleOptions, Cmd.none )



-- VIEW


view : Maybe Authenticator.Model.Authentication -> Model -> String -> List (Html Msg)
view authenticationMaybe model searchQuery =
    case model of
        Example webData options ->
            [ div [ class "row section" ]
                [ div [ class "container" ]
                    (viewWebData
                        (Example.view options.additionalInformationsCollapsed >> Maybe.Helpers.toList)
                        webData
                    )
                ]
            ]

        Examples webData ->
            viewWebData (Browse.view Browse.Examples navigate searchQuery) webData
