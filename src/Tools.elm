module Tools exposing (..)

import Authenticator.Model
import Browse exposing (PillType(..))
import Dict exposing (Dict)
import Hop.Types
import Html exposing (..)
import Http
import Requests exposing (newTaskGetTool, newTaskGetTools)
import Routes exposing (ToolsNestedRoute(..))
import Task
import Tool
import Types exposing (DataIdBody, DataIdsBody, Statement, StatementCustom(..))
import Views exposing (viewNotFound)


-- MODEL


type alias Model =
    { route : ToolsNestedRoute
    , toolById : Dict String Statement
    }


init : Model
init =
    { route = ToolsNotFoundRoute
    , toolById = Dict.empty
    }



-- ROUTING


urlUpdate : ( ToolsNestedRoute, Hop.Types.Location ) -> Model -> ( Model, Cmd Msg )
urlUpdate ( route, location ) model =
    let
        model' =
            { model | route = route }
    in
        case route of
            ToolRoute toolId ->
                ( model', loadOne toolId )

            ToolsIndexRoute ->
                ( model', loadAll )

            ToolsNotFoundRoute ->
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
                    Debug.log "Tools Error" err
            in
                ( model, Cmd.none )

        LoadAll ->
            let
                cmd =
                    Task.perform
                        (\msg -> ForSelf (Error msg))
                        (\msg -> ForSelf (LoadedAll msg))
                        (newTaskGetTools authenticationMaybe)
            in
                ( model, cmd )

        LoadOne toolId ->
            let
                cmd =
                    Task.perform
                        (\msg -> ForSelf (Error msg))
                        (\msg -> ForSelf (LoadedOne msg))
                        (newTaskGetTool authenticationMaybe toolId)
            in
                ( model, cmd )

        LoadedAll body ->
            ( { model | toolById = body.data.statements }
            , Cmd.none
            )

        LoadedOne body ->
            ( { model | toolById = body.data.statements }
            , Cmd.none
            )



-- VIEW


view : Maybe Authenticator.Model.Authentication -> Model -> List (Html Msg)
view authenticationMaybe model =
    case model.route of
        ToolRoute toolId ->
            [ case Dict.get toolId model.toolById of
                Nothing ->
                    text "Loading..."

                Just tool ->
                    Tool.view tool
            ]

        ToolsIndexRoute ->
            let
                tools =
                    Dict.values model.toolById
            in
                Browse.view Tools tools navigate

        ToolsNotFoundRoute ->
            [ viewNotFound ]
