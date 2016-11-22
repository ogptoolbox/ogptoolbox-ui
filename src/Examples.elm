module Examples exposing (..)

import Authenticator.Model
import Browse exposing (ActivePill(..))
import Example
import Hop.Types
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Requests exposing (..)
import Routes exposing (getSearchQuery, ExamplesNestedRoute(..))
import Task
import Types exposing (..)
import Views exposing (viewWebData)
import WebData exposing (..)


-- MODEL


type Model
    = Examples
        (WebData
            { examples : DataIdsBody
            , organizationsCount : Int
            , toolsCount : Int
            }
        )
    | Example (WebData DataIdBody)


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
    | LoadedAll ( DataIdsBody, DataIdsBody, DataIdsBody )
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
            let
                loadingStatus =
                    Loading
                        (case model of
                            Example _ ->
                                Nothing

                            Examples webData ->
                                getData webData
                        )

                model' =
                    Examples (Data loadingStatus)

                cmd =
                    Cmd.map ForSelf
                        (Task.perform
                            Error
                            LoadedAll
                            (Task.map3 (,,)
                                (newTaskGetExamples authenticationMaybe searchQuery "")
                                (newTaskGetOrganizations authenticationMaybe searchQuery "1")
                                (newTaskGetTools authenticationMaybe searchQuery "1")
                            )
                        )
            in
                ( model', cmd )

        LoadOne exampleId ->
            let
                model' =
                    case model of
                        Example webData ->
                            Example (Data (Loading (getData webData)))

                        Examples _ ->
                            Example (Data (Loading Nothing))

                cmd =
                    Task.perform Error LoadedOne (newTaskGetExample authenticationMaybe exampleId)
                        |> Cmd.map ForSelf
            in
                ( model', cmd )

        LoadedAll ( examples, organizations, tools ) ->
            let
                model' =
                    Examples
                        (Data
                            (Loaded
                                { examples = examples
                                , organizationsCount = organizations.count
                                , toolsCount = tools.count
                                }
                            )
                        )
            in
                ( model', Cmd.none )

        LoadedOne body ->
            ( Example (Data (Loaded body)), Cmd.none )



-- VIEW


view : Maybe Authenticator.Model.Authentication -> Model -> String -> List (Html Msg)
view authenticationMaybe model searchQuery =
    case model of
        Example webData ->
            [ div [ class "row section" ]
                [ div [ class "container" ]
                    (viewWebData Example.view webData)
                ]
            ]

        Examples webData ->
            viewWebData
                (\loadingStatus ->
                    let
                        counts =
                            getLoadingStatusData loadingStatus
                                |> Maybe.map
                                    (\loadingStatus ->
                                        { examples = loadingStatus.examples.count
                                        , organizations = loadingStatus.organizationsCount
                                        , tools = loadingStatus.toolsCount
                                        }
                                    )
                    in
                        Browse.view
                            Browse.Examples
                            counts
                            navigate
                            searchQuery
                            (mapLoadingStatus .examples loadingStatus)
                )
                webData
