module Organizations exposing (..)

import Authenticator.Model
import Browse exposing (PillType(..))
import Hop.Types
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Maybe.Helpers
import Organization
import Requests exposing (newTaskGetOrganization, newTaskGetOrganizations)
import Routes exposing (getSearchQuery, OrganizationsNestedRoute(..))
import Task
import Types exposing (Statement, StatementCustom(..))
import Views exposing (viewWebData)
import WebData exposing (LoadingStatus(..), maybeData, WebData(..))


-- MODEL


type Model
    = Organizations (WebData (List Statement))
    | Organization (WebData Statement)


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
                                maybeData webData
                        )

                model' =
                    Organizations (Data loadingStatus)

                cmd =
                    Task.perform Error LoadedAll (newTaskGetOrganizations authenticationMaybe searchQuery)
                        |> Cmd.map ForSelf
            in
                ( model', cmd )

        LoadOne organizationId ->
            let
                loadingStatus =
                    Loading
                        (case model of
                            Organization webData ->
                                maybeData webData

                            Organizations _ ->
                                Nothing
                        )

                model' =
                    Organization (Data loadingStatus)

                cmd =
                    Task.perform Error LoadedOne (newTaskGetOrganization authenticationMaybe organizationId)
                        |> Cmd.map ForSelf
            in
                ( model', cmd )

        LoadedAll statements ->
            ( Organizations (Data (Loaded statements)), Cmd.none )

        LoadedOne statement ->
            ( Organization (Data (Loaded statement)), Cmd.none )



-- VIEW


view : Maybe Authenticator.Model.Authentication -> Model -> String -> List (Html Msg)
view authenticationMaybe model searchQuery =
    case model of
        Organization webData ->
            [ div [ class "row section" ]
                [ div [ class "container" ]
                    (viewWebData (Organization.view >> Maybe.Helpers.toList) webData)
                ]
            ]

        Organizations webData ->
            viewWebData (Browse.view Browse.Organizations navigate searchQuery) webData
