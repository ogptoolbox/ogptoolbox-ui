module Examples exposing (..)

import Authenticator.Model
import Browse exposing (PillType(..))
import Dict exposing (Dict)
import Hop.Types
import Html exposing (..)
import Http
import Requests exposing (newTaskGetExample, newTaskGetExamples)
import Routes exposing (ExamplesNestedRoute(..))
import Task
import Tool
import Types exposing (DataIdBody, DataIdsBody, Statement, StatementCustom(..))
import Views exposing (viewNotFound)


-- MODEL


type alias Model =
    { route : ExamplesNestedRoute
    , exampleById : Dict String Statement
    }


init : Model
init =
    { route = ExamplesNotFoundRoute
    , exampleById = Dict.empty
    }



-- ROUTING


urlUpdate : ( ExamplesNestedRoute, Hop.Types.Location ) -> Model -> ( Model, Cmd Msg )
urlUpdate ( route, location ) model =
    let
        model' =
            { model | route = route }
    in
        case route of
            ExampleRoute exampleId ->
                ( model', loadOne exampleId )

            ExamplesIndexRoute ->
                ( model', loadAll )

            ExamplesNotFoundRoute ->
                ( model', Cmd.none )



-- UPDATE


type ExternalMsg
    = Navigate String


type InternalMsg
    = Error Http.Error
    | LoadAll
    | LoadOne String
    | LoadedAll DataIdsBody
    | LoadedOne DataIdBody


type Msg
    = ForParent ExternalMsg
    | ForSelf InternalMsg


type alias MsgTranslation parentMsg =
    { onInternalMsg : InternalMsg -> parentMsg
    , onNavigate : String -> parentMsg
    }


type alias MsgTranslator parentMsg =
    Msg -> parentMsg


loadAll : Cmd Msg
loadAll =
    Task.perform (\_ -> Debug.crash "") (\_ -> ForSelf LoadAll) (Task.succeed "")


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
            in
                ( model, Cmd.none )

        LoadAll ->
            let
                cmd =
                    Task.perform
                        (\msg -> ForSelf (Error msg))
                        (\msg -> ForSelf (LoadedAll msg))
                        (newTaskGetExamples authenticationMaybe)
            in
                ( model, cmd )

        LoadOne toolId ->
            let
                cmd =
                    Task.perform
                        (\msg -> ForSelf (Error msg))
                        (\msg -> ForSelf (LoadedOne msg))
                        (newTaskGetExample authenticationMaybe toolId)
            in
                ( model, cmd )

        LoadedAll body ->
            ( { model | exampleById = body.data.statements }
            , Cmd.none
            )

        LoadedOne body ->
            ( { model | exampleById = body.data.statements }
            , Cmd.none
            )



-- VIEW


view : Maybe Authenticator.Model.Authentication -> Model -> Html Msg
view authenticationMaybe model =
    case model.route of
        ExampleRoute exampleId ->
            case Dict.get exampleId model.exampleById of
                Nothing ->
                    text "Loading..."

                Just example ->
                    -- TODO Use Example.view, or rename Tool to Card
                    Tool.view example

        ExamplesIndexRoute ->
            let
                examples =
                    Dict.values model.exampleById
            in
                Browse.view Examples examples navigate

        ExamplesNotFoundRoute ->
            viewNotFound
