module Examples.State exposing (..)

import Authenticator.Model
import Examples.Types exposing (..)
import Hop.Types
import I18n
import Requests exposing (..)
import Routes exposing (getSearchQuery, ExamplesNestedRoute(..))
import Task
import WebData exposing (..)


init : Model
init =
    Examples NotAsked



-- ROUTING


urlUpdate :
    ( ExamplesNestedRoute, Hop.Types.Location )
    -> Model
    -> I18n.Language
    -> (String -> Cmd Msg)
    -> ( Model, Cmd Msg )
urlUpdate ( route, location ) model language setDocumentTitle =
    let
        searchQuery =
            getSearchQuery location
    in
        case route of
            ExampleRoute exampleId ->
                model
                    ! [ loadOne exampleId
                      , setDocumentTitle (I18n.translate language (I18n.Example I18n.Singular))
                      ]

            ExamplesIndexRoute ->
                model
                    ! [ loadAll searchQuery
                      , setDocumentTitle (I18n.translate language (I18n.Example I18n.Plural))
                      ]



-- UPDATE


loadAll : String -> Cmd Msg
loadAll searchQuery =
    Task.perform (\_ -> Debug.crash "") (\_ -> ForSelf (LoadAll searchQuery)) (Task.succeed "")


loadOne : String -> Cmd Msg
loadOne id =
    Task.perform (\_ -> Debug.crash "") (\_ -> ForSelf (LoadOne id)) (Task.succeed "")


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
