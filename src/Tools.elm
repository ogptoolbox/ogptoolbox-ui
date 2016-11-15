module Tools exposing (..)

import Authenticator.Model
import Browse exposing (PillType(..))
import Hop.Types
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import RemoteData exposing (RemoteData(..), WebData)
import Requests exposing (newTaskGetTool, newTaskGetTools)
import Routes exposing (getSearchQuery, ToolsNestedRoute(..))
import Task
import Tool
import Types exposing (Statement, StatementCustom(..))
import Views exposing (viewWebData)


-- MODEL


type Model
    = Tools (WebData (List Statement))
    | Tool (WebData Statement)


init : Model
init =
    Tools NotAsked



-- ROUTING


urlUpdate : ( ToolsNestedRoute, Hop.Types.Location ) -> Model -> ( Model, Cmd Msg )
urlUpdate ( route, location ) model =
    let
        searchQuery =
            getSearchQuery location
    in
        case route of
            ToolRoute toolId ->
                ( Tool NotAsked, loadOne toolId )

            ToolsIndexRoute ->
                ( Tools NotAsked, loadAll searchQuery )



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
                    Debug.log "Tools Error" err

                model' =
                    case model of
                        Tool _ ->
                            Tool (Failure err)

                        Tools _ ->
                            Tools (Failure err)
            in
                ( model', Cmd.none )

        LoadAll searchQuery ->
            ( Tools Loading
            , Task.perform
                (ForSelf << Error)
                (ForSelf << LoadedAll)
                (newTaskGetTools authenticationMaybe searchQuery)
            )

        LoadOne toolId ->
            ( Tool Loading
            , Task.perform
                (ForSelf << Error)
                (ForSelf << LoadedOne)
                (newTaskGetTool authenticationMaybe toolId)
            )

        LoadedAll statements ->
            ( Tools (Success statements), Cmd.none )

        LoadedOne statement ->
            ( Tool (Success statement), Cmd.none )



-- VIEW


view : Maybe Authenticator.Model.Authentication -> Model -> String -> List (Html Msg)
view authenticationMaybe model searchQuery =
    case model of
        Tool webData ->
            [ div [ class "row section" ]
                [ div [ class "container" ]
                    (viewWebData
                        (\tool -> [ Tool.view tool ])
                        webData
                    )
                ]
            ]

        Tools webData ->
            viewWebData
                (\tools -> Browse.view Browse.Tools tools navigate searchQuery)
                webData
