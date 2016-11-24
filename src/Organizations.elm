module Organizations exposing (..)

import Authenticator.Model
import Browse
import Hop.Types
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import I18n

import Organization
import Requests exposing (..)
import Routes exposing (getSearchQuery, OrganizationsNestedRoute(..))
import Task
import Types exposing (..)
import Views exposing (viewWebData)
import WebData exposing (..)


-- MODEL


type Model
    = Organizations
        (WebData
            { examplesCount : Int
            , organizations : DataIdsBody
            , toolsCount : Int
            }
        )
    | Organization (WebData DataIdBody)


init : Model
init =
    Organizations NotAsked



-- ROUTING


urlUpdate : ( OrganizationsNestedRoute, Hop.Types.Location ) -> Model -> ( Model, Cmd Msg )
urlUpdate ( route, location ) model =
    let
        searchQuery =
            getSearchQuery location
    in
        case route of
            OrganizationRoute organizationId ->
                ( model, loadOne organizationId )

            OrganizationsIndexRoute ->
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
                    Debug.log "Organizations Error" err

                model' =
                    case model of
                        Organization _ ->
                            Organization (Failure err)

                        Organizations _ ->
                            Organizations (Failure err)
            in
                ( model', Cmd.none )

        LoadAll searchQuery ->
            let
                loadingStatus =
                    Loading
                        (case model of
                            Organization _ ->
                                Nothing

                            Organizations webData ->
                                getData webData
                        )

                model' =
                    Organizations (Data loadingStatus)

                cmd =
                    Cmd.map ForSelf
                        (Task.perform
                            Error
                            LoadedAll
                            (Task.map3 (,,)
                                (newTaskGetExamples authenticationMaybe searchQuery "1")
                                (newTaskGetOrganizations authenticationMaybe searchQuery "")
                                (newTaskGetTools authenticationMaybe searchQuery "1")
                            )
                        )
            in
                ( model', cmd )

        LoadOne organizationId ->
            let
                model' =
                    case model of
                        Organization webData ->
                            Organization (Data (Loading (getData webData)))

                        Organizations _ ->
                            Organization (Data (Loading Nothing))

                cmd =
                    Task.perform Error LoadedOne (newTaskGetOrganization authenticationMaybe organizationId)
                        |> Cmd.map ForSelf
            in
                ( model', cmd )

        LoadedAll ( examples, organizations, tools ) ->
            let
                model' =
                    Organizations
                        (Data
                            (Loaded
                                { examplesCount = examples.count
                                , organizations = organizations
                                , toolsCount = tools.count
                                }
                            )
                        )
            in
                ( model', Cmd.none )

        LoadedOne body ->
            ( Organization (Data (Loaded body)), Cmd.none )



-- VIEW


view : Maybe Authenticator.Model.Authentication -> Model -> String -> I18n.Language-> List (Html Msg)
view authenticationMaybe model searchQuery language =
    case model of
        Organization webData ->
            [ div [ class "row section" ]
                [ div [ class "container" ]
                    (viewWebData
                        language
                        (\loadingStatus -> [ Organization.view navigate language loadingStatus ])
                        webData
                    )
                ]
            ]

        Organizations webData ->
            viewWebData
                language
                (\loadingStatus ->
                    let
                        counts =
                            getLoadingStatusData loadingStatus
                                |> Maybe.map
                                    (\loadingStatus ->
                                        { examples = loadingStatus.examplesCount
                                        , organizations = loadingStatus.organizations.count
                                        , tools = loadingStatus.toolsCount
                                        }
                                    )
                    in
                        Browse.view
                            Types.Organization
                            counts
                            navigate
                            searchQuery
                            language
                            (mapLoadingStatus .organizations loadingStatus)
                )
                webData
