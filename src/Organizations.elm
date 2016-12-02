module Organizations exposing (..)

import Authenticator.Model
import Browse
import Constants
import Hop.Types
import Html exposing (..)
import Http
import I18n exposing (getImageUrlOrOgpLogo, getName)
import Organization
import Requests exposing (..)
import Routes exposing (getSearchQuery, OrganizationsNestedRoute(..))
import Set exposing (Set)
import Task
import Types exposing (..)
import Views exposing (viewWebData)
import WebData exposing (..)


-- MODEL


type Model
    = Organizations
        { webData :
            WebData
                { examplesCount : Int
                , organizations : DataIdsBody
                , popularTags : List PopularTag
                , toolsCount : Int
                }
        , selectedTags : Set String
        }
    | Organization (WebData DataIdBody)


init : Model
init =
    Organizations { webData = NotAsked, selectedTags = Set.empty }



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
    = DeselectBubble String
    | Error Http.Error
    | LoadAll String
    | LoadOne String
    | LoadedAll ( DataIdsBody, DataIdsBody, List PopularTag, DataIdsBody )
    | LoadedOne DataIdBody
    | SelectBubble String


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


update :
    InternalMsg
    -> Model
    -> Maybe Authenticator.Model.Authentication
    -> I18n.Language
    -> String
    -> (DocumentMetatags -> Cmd Msg)
    -> (( List PopularTag, List String ) -> Cmd Msg)
    -> ( Model, Cmd Msg )
update msg model authenticationMaybe language searchQuery setDocumentMetatags mountd3bubbles =
    case msg of
        DeselectBubble deselectedTag ->
            let
                subModel =
                    case model of
                        Organization _ ->
                            Debug.crash "Should not happen"

                        Organizations subModel ->
                            subModel

                ( newSubModel, cmd ) =
                    case getData subModel.webData of
                        Nothing ->
                            ( subModel, Cmd.none )

                        Just webData ->
                            let
                                newSelectedTags =
                                    Set.remove deselectedTag subModel.selectedTags

                                newWebData =
                                    Data
                                        (Loading
                                            (Just
                                                { webData
                                                    | examplesCount = webData.examplesCount
                                                    , organizations = webData.organizations
                                                    , popularTags = webData.popularTags
                                                    , toolsCount = webData.toolsCount
                                                }
                                            )
                                        )

                                newSubModel =
                                    { webData = newWebData
                                    , selectedTags = newSelectedTags
                                    }

                                cmd =
                                    Cmd.map ForSelf
                                        (Task.perform
                                            Error
                                            LoadedAll
                                            (Task.map4 (,,,)
                                                (newTaskGetExamples authenticationMaybe searchQuery "1" newSelectedTags)
                                                (newTaskGetOrganizations authenticationMaybe searchQuery "" newSelectedTags)
                                                (newTaskGetTagsPopularity language newSelectedTags)
                                                (newTaskGetTools authenticationMaybe searchQuery "1" newSelectedTags)
                                            )
                                        )
                            in
                                ( newSubModel, cmd )
            in
                ( Organizations newSubModel, cmd )

        Error err ->
            let
                _ =
                    Debug.log "Organizations Error" err

                model' =
                    case model of
                        Organization _ ->
                            Organization (Failure err)

                        Organizations x ->
                            Organizations { x | webData = Failure err }
            in
                ( model', Cmd.none )

        LoadAll searchQuery ->
            let
                loadingStatus =
                    Loading
                        (case model of
                            Organization _ ->
                                Nothing

                            Organizations { webData } ->
                                getData webData
                        )

                model' =
                    case model of
                        Organizations x ->
                            Organizations { x | webData = Data loadingStatus }

                        Organization _ ->
                            Debug.crash "Should never happen"

                cmd =
                    Cmd.map ForSelf
                        (Task.perform
                            Error
                            LoadedAll
                            (Task.map4 (,,,)
                                (newTaskGetExamples authenticationMaybe searchQuery "1" Set.empty)
                                (newTaskGetOrganizations authenticationMaybe searchQuery "" Set.empty)
                                (newTaskGetTagsPopularity language Set.empty)
                                (newTaskGetTools authenticationMaybe searchQuery "1" Set.empty)
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

        LoadedAll ( examples, organizations, popularTags, tools ) ->
            let
                subModel =
                    case model of
                        Organization _ ->
                            Debug.crash "Should not happen"

                        Organizations subModel ->
                            subModel

                newSubModel =
                    { subModel
                        | webData =
                            Data
                                (Loading
                                    (Just
                                        { examplesCount = examples.count
                                        , organizations = organizations
                                        , popularTags = popularTags
                                        , toolsCount = tools.count
                                        }
                                    )
                                )
                    }

                newModel =
                    Organizations newSubModel

                cmds =
                    [ setDocumentMetatags
                        { title = I18n.translate language (I18n.Organization I18n.Plural)
                        , imageUrl = Constants.logoUrl
                        }
                    , mountd3bubbles ( popularTags, newSubModel.selectedTags |> Set.toList )
                    ]
            in
                newModel ! cmds

        LoadedOne body ->
            let
                cmd =
                    setDocumentMetatags
                        { title = getName language body.data.id body.data.cards body.data.values
                        , imageUrl = getImageUrlOrOgpLogo language body.data.id body.data.cards body.data.values
                        }
            in
                ( Organization (Data (Loaded body)), cmd )

        SelectBubble selectedTag ->
            let
                subModel =
                    case model of
                        Organization _ ->
                            Debug.crash "Should not happen"

                        Organizations subModel ->
                            subModel

                ( newSubModel, cmd ) =
                    case getData subModel.webData of
                        Nothing ->
                            let
                                _ =
                                    Debug.log "Organizations Nothing" True
                            in
                                ( subModel, Cmd.none )

                        Just webData ->
                            let
                                newSelectedTags =
                                    Set.insert selectedTag subModel.selectedTags

                                newWebData =
                                    Data
                                        (Loading
                                            (Just
                                                { webData
                                                    | examplesCount = webData.examplesCount
                                                    , organizations = webData.organizations
                                                    , popularTags = webData.popularTags
                                                    , toolsCount = webData.toolsCount
                                                }
                                            )
                                        )

                                newSubModel =
                                    { webData = newWebData
                                    , selectedTags = newSelectedTags
                                    }

                                cmd =
                                    Cmd.map ForSelf
                                        (Task.perform
                                            Error
                                            LoadedAll
                                            (Task.map4 (,,,)
                                                (newTaskGetExamples authenticationMaybe searchQuery "1" newSelectedTags)
                                                (newTaskGetOrganizations authenticationMaybe searchQuery "" newSelectedTags)
                                                (newTaskGetTagsPopularity language newSelectedTags)
                                                (newTaskGetTools authenticationMaybe searchQuery "1" newSelectedTags)
                                            )
                                        )
                            in
                                ( newSubModel, cmd )
            in
                ( Organizations newSubModel, cmd )



-- VIEW


view : Maybe Authenticator.Model.Authentication -> Model -> String -> I18n.Language -> List (Html Msg)
view authenticationMaybe model searchQuery language =
    case model of
        Organization webData ->
            viewWebData
                language
                (\loadingStatus -> [ Organization.view navigate language loadingStatus ])
                webData

        Organizations { webData } ->
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
