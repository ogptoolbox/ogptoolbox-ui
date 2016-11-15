module Organizations exposing (..)

import Authenticator.Model
import Browse exposing (PillType(..))
import Hop.Types
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Organization
import RemoteData exposing (RemoteData(..), WebData)
import Requests exposing (newTaskGetOrganization, newTaskGetOrganizations)
import Routes exposing (getSearchQuery, OrganizationsNestedRoute(..))
import Task
import Types exposing (Statement, StatementCustom(..))
import Views exposing (viewWebData)


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
                ( Organization NotAsked, loadOne organizationId )

            OrganizationsIndexRoute ->
                ( Organizations NotAsked, loadAll searchQuery )



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
            ( Organizations Loading
            , Task.perform
                (ForSelf << Error)
                (ForSelf << LoadedAll)
                (newTaskGetOrganizations authenticationMaybe searchQuery)
            )

        LoadOne toolId ->
            ( Organization Loading
            , Task.perform
                (ForSelf << Error)
                (ForSelf << LoadedOne)
                (newTaskGetOrganization authenticationMaybe toolId)
            )

        LoadedAll statements ->
            ( Organizations (Success statements), Cmd.none )

        LoadedOne statement ->
            ( Organization (Success statement), Cmd.none )



-- VIEW


view : Maybe Authenticator.Model.Authentication -> Model -> String -> List (Html Msg)
view authenticationMaybe model searchQuery =
    case model of
        Organization webData ->
            [ div [ class "row section" ]
                [ div [ class "container" ]
                    (viewWebData
                        (\organization -> [ Organization.view organization ])
                        webData
                    )
                ]
            ]

        Organizations webData ->
            viewWebData
                (\organizations -> Browse.view Browse.Organizations organizations navigate searchQuery)
                webData
