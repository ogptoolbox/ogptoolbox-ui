module Tools exposing (..)

import Authenticator.Model
import Dict exposing (Dict)
import Hop.Types
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App
import Http
import Task
import Footer
import Types exposing (DataIdsBody, Statement, StatementCustom(..))
import Requests exposing (newTaskGetCards)
import Routes exposing (ToolsNestedRoute(..))
import Tool
import Views exposing (viewNotFound)


-- MODEL


type alias Model =
    { route : ToolsNestedRoute
    , toolModel : Tool.Model
    , toolById : Dict String Statement
    , toolIds : List String
    }


init : Model
init =
    { route = ToolsNotFoundRoute
    , toolModel = Tool.init
    , toolById = Dict.empty
    , toolIds = []
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
                let
                    toolModel =
                        model'.toolModel

                    model'' =
                        { model'
                            | toolModel =
                                { toolModel
                                    | tool = Dict.get toolId model'.toolById
                                }
                        }
                in
                    ( model'', load )

            ToolsIndexRoute ->
                ( model', load )

            ToolsNotFoundRoute ->
                ( model', Cmd.none )



-- UPDATE


type ExternalMsg
    = Navigate String


type InternalMsg
    = Error Http.Error
    | Load
    | Loaded DataIdsBody
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


load : Cmd Msg
load =
    Task.perform (\_ -> Debug.crash "") (\_ -> ForSelf Load) (Task.succeed "")


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

        Load ->
            let
                cmd =
                    Task.perform
                        (\msg -> ForSelf (Error msg))
                        (\msg -> ForSelf (Loaded msg))
                        (newTaskGetCards authenticationMaybe)
            in
                ( model, cmd )

        Loaded body ->
            ( { model
                | toolById =
                    Dict.filter
                        (\id statement ->
                            case statement.custom of
                                CardCustom card ->
                                    List.member "Platform" card.cardTypes || List.member "Software" card.cardTypes

                                _ ->
                                    False
                        )
                        body.data.statements
                , toolIds = body.data.ids
              }
            , Cmd.none
            )

        ToolMsg childMsg ->
            case model.toolModel.tool of
                Nothing ->
                    ( model, Cmd.none )

                Just tool ->
                    let
                        toolModel =
                            model.toolModel

                        toolModel' =
                            { toolModel | tool = Dict.get tool.id model'.toolById }

                        ( toolModel'', childEffect ) =
                            Tool.update childMsg authenticationMaybe toolModel'

                        model' =
                            { model | toolModel = toolModel'' }
                    in
                        ( model', Cmd.map translateToolMsg childEffect )



-- VIEW


view : Maybe Authenticator.Model.Authentication -> Model -> Html Msg
view authenticationMaybe model =
    div []
        [ viewBreadcrumb
        , viewContainer authenticationMaybe model
        , Footer.view
        ]


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


viewContainer : Maybe Authenticator.Model.Authentication -> Model -> Html Msg
viewContainer authenticationMaybe model =
    case model.route of
        ToolRoute toolId ->
            let
                toolModel =
                    model.toolModel

                toolModel' =
                    { toolModel | tool = Dict.get toolId model.toolById }
            in
                Html.App.map translateToolMsg (Tool.view authenticationMaybe toolModel')

        ToolsIndexRoute ->
            text "TODO"

        ToolsNotFoundRoute ->
            viewNotFound
