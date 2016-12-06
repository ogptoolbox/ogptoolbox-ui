module Search.State exposing (..)

import Authenticator.Model
import Dict exposing (Dict)
import Hop
import Hop.Types
import I18n
import Ports
import Requests
import Routes
import Search.Types exposing (..)
import String
import Task
import Types exposing (..)
import WebData exposing (LoadingStatus(..), getData, WebData(..))


{-| Remove the first occurrence of a value from a list.
from List.Extra
-}
remove : a -> List a -> List a
remove x xs =
    case xs of
        [] ->
            []

        y :: ys ->
            if x == y then
                ys
            else
                y :: remove x ys


init : Model
init =
    { organizations = NotAsked
    , popularTagsData = NotAsked
    , selectedTags = []
    , tools = NotAsked
    , useCases = NotAsked
    }


subscriptions : Model -> Sub InternalMsg
subscriptions model =
    Sub.batch
        [ Ports.bubbleSelections BubbleSelect
        , Ports.bubbleDeselections BubbleDeselect
        ]


update :
    InternalMsg
    -> Model
    -> Maybe Authenticator.Model.Authentication
    -> I18n.Language
    -> Hop.Types.Location
    -> ( Model, Cmd Msg )
update msg model authentication language location =
    let
        navigateCmd selectedTags =
            location
                |> Hop.removeQuery "tagIds"
                |> Hop.addQuery
                    (Dict.fromList [ ( "tagIds", selectedTags |> List.map .tagId |> String.join "," ) ])
                |> Routes.makeUrlFromLocation
                |> navigate
                |> (\msg -> Task.perform (\_ -> Debug.crash "") (\_ -> msg) (Task.succeed ()))
    in
        case msg of
            BubbleDeselect deselectedTag ->
                let
                    newSelectedTags =
                        remove deselectedTag model.selectedTags

                    newModel =
                        { model
                            | organizations = Data (Loading (getData model.organizations))
                            , selectedTags = newSelectedTags
                            , tools = Data (Loading (getData model.tools))
                            , useCases = Data (Loading (getData model.useCases))
                        }
                in
                    ( newModel, navigateCmd newSelectedTags )

            BubbleSelect selectedTag ->
                let
                    newSelectedTags =
                        if List.member selectedTag.tagId (List.map .tagId model.selectedTags) then
                            model.selectedTags
                        else
                            selectedTag :: model.selectedTags

                    newModel =
                        { model
                            | organizations = Data (Loading (getData model.organizations))
                            , selectedTags = newSelectedTags
                            , tools = Data (Loading (getData model.tools))
                            , useCases = Data (Loading (getData model.useCases))
                        }
                in
                    ( newModel, navigateCmd newSelectedTags )

            Load ->
                let
                    newModel =
                        { model
                            | organizations = Data (Loading (getData model.organizations))
                            , tools = Data (Loading (getData model.tools))
                            , useCases = Data (Loading (getData model.useCases))
                        }

                    requestsCmds =
                        let
                            limit =
                                Just 8

                            selectedTagIds =
                                List.map .tagId model.selectedTags

                            searchQuery =
                                Routes.getSearchQuery location
                        in
                            List.map (Cmd.map ForSelf)
                                [ Task.perform
                                    OrganizationsLoadError
                                    OrganizationsLoadSuccess
                                    (Requests.getCards
                                        authentication
                                        searchQuery
                                        limit
                                        selectedTagIds
                                        cardTypesForOrganization
                                    )
                                , Task.perform
                                    ToolsLoadError
                                    ToolsLoadSuccess
                                    (Requests.getCards
                                        authentication
                                        searchQuery
                                        limit
                                        selectedTagIds
                                        cardTypesForTool
                                    )
                                , Task.perform
                                    UseCasesLoadError
                                    UseCasesLoadSuccess
                                    (Requests.getCards
                                        authentication
                                        searchQuery
                                        limit
                                        selectedTagIds
                                        cardTypesForUseCase
                                    )
                                , Task.perform
                                    PopularTagsLoadError
                                    PopularTagsLoadSuccess
                                    (Requests.getTagsPopularity selectedTagIds)
                                ]
                in
                    newModel ! requestsCmds

            OrganizationsLoadError err ->
                let
                    _ =
                        Debug.log "Search.State OrganizationsLoadError" err

                    newModel =
                        { model | organizations = Failure err }
                in
                    ( newModel, Cmd.none )

            OrganizationsLoadSuccess body ->
                ( { model | organizations = Data (Loaded body) }
                , Cmd.none
                )

            PopularTagsLoadError err ->
                let
                    _ =
                        Debug.log "Search.State PopularTagsLoadError" err

                    newModel =
                        { model | popularTagsData = Failure err }
                in
                    ( newModel, Cmd.none )

            PopularTagsLoadSuccess popularTagsData ->
                let
                    getLocalizedString value =
                        case value.value of
                            LocalizedStringValue valueByLanguage ->
                                case I18n.getValueByPreferredLanguage language valueByLanguage of
                                    Nothing ->
                                        Debug.crash "update PopularTagsLoadSuccess"

                                    Just tag ->
                                        tag

                            _ ->
                                Debug.crash "update PopularTagsLoadSuccess"

                    selectedTags =
                        case Dict.get "tagIds" location.query of
                            Nothing ->
                                []

                            Just tagIds ->
                                tagIds
                                    |> String.split ","
                                    |> List.filterMap
                                        (\tagId ->
                                            Dict.get tagId popularTagsData.values
                                                |> Maybe.map
                                                    (\value ->
                                                        { count = 50
                                                        , tag = getLocalizedString value
                                                        , tagId = tagId
                                                        }
                                                    )
                                        )

                    newModel =
                        { model
                            | popularTagsData = Data (Loaded popularTagsData)
                            , selectedTags = selectedTags
                        }

                    popularTags =
                        List.map
                            (\{ count, tagId } ->
                                { count = count
                                , tag =
                                    getValue popularTagsData.values tagId
                                        |> getLocalizedString
                                , tagId = tagId
                                }
                            )
                            popularTagsData.popularity

                    cmd =
                        Ports.mountd3bubbles
                            { popularTags = popularTags
                            , selectedTags = selectedTags
                            }
                in
                    ( newModel, cmd )

            ToolsLoadError err ->
                let
                    _ =
                        Debug.log "Search.State ToolsLoadError" err

                    newModel =
                        { model | tools = Failure err }
                in
                    ( newModel, Cmd.none )

            ToolsLoadSuccess body ->
                ( { model | tools = Data (Loaded body) }
                , Cmd.none
                )

            UseCasesLoadError err ->
                let
                    _ =
                        Debug.log "Search.State UseCasesLoadError" err

                    newModel =
                        { model | useCases = Failure err }
                in
                    ( newModel, Cmd.none )

            UseCasesLoadSuccess body ->
                ( { model | useCases = Data (Loaded body) }
                , Cmd.none
                )
