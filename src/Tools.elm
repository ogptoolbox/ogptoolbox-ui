module Tools
    exposing
        ( init
        , InternalMsg
        , isTool
        , Model
        , MsgTranslation
        , MsgTranslator
        , translateMsg
        , update
        , urlUpdate
        , view
        )

import Authenticator.Model
import Browse exposing (PillType(..))
import Dict exposing (Dict)
import Hop.Types
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App
import Http
import Task
import Types exposing (DataIdBody, DataIdsBody, Statement, StatementCustom(..))
import Requests exposing (newTaskGetCard, newTaskGetCards)
import Routes exposing (ToolsNestedRoute(..))
import Tool
import Views exposing (viewNotFound)


-- HELPERS


isTool : Statement -> Bool
isTool statement =
    case statement.custom of
        CardCustom card ->
            List.member "Platform" card.cardTypes || List.member "Software" card.cardTypes

        _ ->
            False



-- MODEL


type alias Model =
    { route : ToolsNestedRoute
    , toolModel : Tool.Model
    , toolById : Dict String Statement
    }


init : Model
init =
    { route = ToolsNotFoundRoute
    , toolModel = Tool.init
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
    | ToolMsg Tool.InternalMsg


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


toolMsgTranslation : Tool.MsgTranslation Msg
toolMsgTranslation =
    { onInternalMsg = \internalMsg -> ForSelf (ToolMsg internalMsg)
    , onNavigate = \path -> ForParent (Navigate path)
    }


translateToolMsg : Tool.MsgTranslator Msg
translateToolMsg =
    Tool.translateMsg toolMsgTranslation


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
                    Debug.log "Cards Error" err
            in
                ( model, Cmd.none )

        LoadAll ->
            let
                cmd =
                    Task.perform
                        (\msg -> ForSelf (Error msg))
                        (\msg -> ForSelf (LoadedAll msg))
                        (newTaskGetCards authenticationMaybe)
            in
                ( model, cmd )

        LoadOne toolId ->
            let
                cmd =
                    Task.perform
                        (\msg -> ForSelf (Error msg))
                        (\msg -> ForSelf (LoadedOne msg))
                        (newTaskGetCard authenticationMaybe toolId)
            in
                ( model, cmd )

        LoadedAll body ->
            ( { model
                | toolById =
                    Dict.filter (\_ statement -> isTool statement) body.data.statements
              }
            , Cmd.none
            )

        LoadedOne body ->
            ( { model
                | toolById =
                    Dict.filter (\_ statement -> isTool statement) body.data.statements
              }
            , Cmd.none
            )

        ToolMsg childMsg ->
            ( model, Cmd.none )



-- VIEW


view : Maybe Authenticator.Model.Authentication -> Model -> Html Msg
view authenticationMaybe model =
    let
        layout container =
            div []
                [ viewBreadcrumb
                , container
                ]
    in
        case model.route of
            ToolRoute toolId ->
                case Dict.get toolId model.toolById of
                    Nothing ->
                        text "Loading..."

                    Just tool ->
                        Html.App.map translateToolMsg (Tool.view tool) |> layout

            ToolsIndexRoute ->
                let
                    tools =
                        Dict.values model.toolById
                in
                    Browse.view Tools tools navigate

            ToolsNotFoundRoute ->
                viewNotFound |> layout


viewBreadcrumb : Html msg
viewBreadcrumb =
    div [ class "row" ]
        [ div [ class "container" ]
            [ div [ class "row" ]
                [ div [ class "col-xs-12" ]
                    [ ol [ class "breadcrumb" ]
                        [ li []
                            [ a [ href "#" ]
                                [ text "Home" ]
                            ]
                        , li []
                            [ a [ href "#" ]
                                [ text "Library" ]
                            ]
                        , li [ class "active" ]
                            [ text "Data" ]
                        ]
                    ]
                ]
            ]
        ]
