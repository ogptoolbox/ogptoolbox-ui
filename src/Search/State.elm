module Search.State exposing (..)

import Authenticator.Model
import Dict exposing (Dict)
import Erl
import Http
import I18n
import Navigation
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
    { collections = NotAsked
    , organizations = NotAsked
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
    -> Navigation.Location
    -> ( Model, Cmd Msg )
update msg model authentication language location =
    let
        navigateCmd selectedTags =
            Erl.parse location.href
                |> Erl.setQuery "tagIds" (selectedTags |> List.map .tagId |> String.join ",")
                |> Erl.toString
                |> navigate
                |> (\msg -> Task.perform (\_ -> msg) (Task.succeed ()))
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

            GotCollections response ->
                case response of
                    Result.Err err ->
                        let
                            _ =
                                Debug.log "Search.State GotCollections Error" err

                            newModel =
                                { model | collections = Failure err }
                        in
                            ( newModel, Cmd.none )

                    Result.Ok body ->
                        ( { model | collections = Data (Loaded body) }
                        , Cmd.none
                        )

            GotOrganizations response ->
                case response of
                    Result.Err err ->
                        let
                            _ =
                                Debug.log "Search.State GotOrganizations Error" err

                            newModel =
                                { model | organizations = Failure err }
                        in
                            ( newModel, Cmd.none )

                    Result.Ok body ->
                        ( { model | organizations = Data (Loaded body) }
                        , Cmd.none
                        )

            GotTagsPopularity response ->
                case response of
                    Result.Err err ->
                        let
                            _ =
                                Debug.log "Search.State GotTagsPopularity Error" err

                            newModel =
                                { model | popularTagsData = Failure err }
                        in
                            ( newModel, Cmd.none )

                    Result.Ok popularTagsData ->
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
                                case Routes.getQuerySingleParameter "tagIds" location of
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

            GotTools response ->
                case response of
                    Result.Err err ->
                        let
                            _ =
                                Debug.log "Search.State GotTools Error" err

                            newModel =
                                { model | tools = Failure err }
                        in
                            ( newModel, Cmd.none )

                    Result.Ok body ->
                        ( { model | tools = Data (Loaded body) }
                        , Cmd.none
                        )

            GotUseCases response ->
                case response of
                    Result.Err err ->
                        let
                            _ =
                                Debug.log "Search.State GotUseCases Error" err

                            newModel =
                                { model | useCases = Failure err }
                        in
                            ( newModel, Cmd.none )

                    Result.Ok body ->
                        ( { model | useCases = Data (Loaded body) }
                        , Cmd.none
                        )

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
                                Routes.getQuerySearchTerm location
                        in
                            [ Requests.getCollections authentication (Just 3)
                                |> Http.send (ForSelf << GotCollections)
                            , Requests.getCards
                                authentication
                                searchQuery
                                limit
                                selectedTagIds
                                cardTypesForOrganization
                                |> Http.send (ForSelf << GotOrganizations)
                            , Requests.getCards
                                authentication
                                searchQuery
                                limit
                                selectedTagIds
                                cardTypesForTool
                                |> Http.send (ForSelf << GotTools)
                            , Requests.getCards
                                authentication
                                searchQuery
                                limit
                                selectedTagIds
                                cardTypesForUseCase
                                |> Http.send (ForSelf << GotUseCases)
                            , Requests.getTagsPopularity authentication selectedTagIds
                                |> Http.send (ForSelf << GotTagsPopularity)
                            ]
                in
                    newModel ! requestsCmds
