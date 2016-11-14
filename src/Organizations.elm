module Organizations exposing (..)

import Authenticator.Model
import Browse exposing (PillType(..))
import Dict exposing (Dict)
import Hop.Types
import Html exposing (..)
import Http
import Organization
import Requests exposing (newTaskGetOrganization, newTaskGetOrganizations)
import Routes exposing (OrganizationsNestedRoute(..))
import Task
import Types exposing (DataIdBody, DataIdsBody, Statement, StatementCustom(..))
import Views exposing (viewNotFound)


-- MODEL


type alias Model =
    { route : OrganizationsNestedRoute
    , organizationById : Dict String Statement
    }


init : Model
init =
    { route = OrganizationsNotFoundRoute
    , organizationById = Dict.empty
    }



-- ROUTING


urlUpdate : ( OrganizationsNestedRoute, Hop.Types.Location ) -> Model -> ( Model, Cmd Msg )
urlUpdate ( route, location ) model =
    let
        model' =
            { model | route = route }
    in
        case route of
            OrganizationRoute organizationId ->
                ( model', loadOne organizationId )

            OrganizationsIndexRoute ->
                ( model', loadAll )

            OrganizationsNotFoundRoute ->
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
                    Debug.log "Organizations Error" err
            in
                ( model, Cmd.none )

        LoadAll ->
            let
                cmd =
                    Task.perform
                        (\msg -> ForSelf (Error msg))
                        (\msg -> ForSelf (LoadedAll msg))
                        (newTaskGetOrganizations authenticationMaybe "")
            in
                ( model, cmd )

        LoadOne organizationId ->
            let
                cmd =
                    Task.perform
                        (\msg -> ForSelf (Error msg))
                        (\msg -> ForSelf (LoadedOne msg))
                        (newTaskGetOrganization authenticationMaybe organizationId)
            in
                ( model, cmd )

        LoadedAll body ->
            ( { model | organizationById = body.data.statements }
            , Cmd.none
            )

        LoadedOne body ->
            ( { model | organizationById = body.data.statements }
            , Cmd.none
            )



-- VIEW


view : Maybe Authenticator.Model.Authentication -> Model -> List (Html Msg)
view authenticationMaybe model =
    case model.route of
        OrganizationRoute organizationId ->
            [ case Dict.get organizationId model.organizationById of
                Nothing ->
                    text "Loading..."

                Just organization ->
                    Organization.view organization
            ]

        OrganizationsIndexRoute ->
            let
                organizations =
                    Dict.values model.organizationById
            in
                Browse.view Organizations organizations navigate

        OrganizationsNotFoundRoute ->
            [ viewNotFound ]
