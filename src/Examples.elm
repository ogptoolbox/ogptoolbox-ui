module Examples exposing (..)

import Authenticator.Model
import Browse exposing (PillType(..))
import Hop.Types
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import RemoteData exposing (RemoteData(..), WebData)
import Requests exposing (newTaskGetExample, newTaskGetExamples)
import Routes exposing (getSearchQuery, ExamplesNestedRoute(..))
import Task
import Tool
import Types exposing (Statement, StatementCustom(..))
import Views exposing (viewWebData)


-- MODEL


type Model
    = Examples (WebData (List Statement))
    | Example (WebData Statement)


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
                ( Example NotAsked, loadOne exampleId )

            ExamplesIndexRoute ->
                ( Examples NotAsked, loadAll searchQuery )



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
                        Example _ ->
                            Example (Failure err)

                        Examples _ ->
                            Examples (Failure err)
            in
                ( model', Cmd.none )

        LoadAll searchQuery ->
            ( Examples Loading
            , Task.perform
                (ForSelf << Error)
                (ForSelf << LoadedAll)
                (newTaskGetExamples authenticationMaybe searchQuery)
            )

        LoadOne toolId ->
            ( Example Loading
            , Task.perform
                (ForSelf << Error)
                (ForSelf << LoadedOne)
                (newTaskGetExample authenticationMaybe toolId)
            )

        LoadedAll statements ->
            ( Examples (Success statements), Cmd.none )

        LoadedOne statement ->
            ( Example (Success statement), Cmd.none )



-- VIEW


view : Maybe Authenticator.Model.Authentication -> Model -> String -> List (Html Msg)
view authenticationMaybe model searchQuery =
    case model of
        Example webData ->
            [ div [ class "row section" ]
                [ div [ class "container" ]
                    (viewWebData
                        -- TODO Use Example.view, or rename Tool to Card
                        (\example -> [ Tool.view example ])
                        webData
                    )
                ]
            ]

        Examples webData ->
            viewWebData
                (\examples -> Browse.view Browse.Examples examples navigate searchQuery)
                webData
