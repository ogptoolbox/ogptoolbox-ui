module Search.State exposing (..)

import Authenticator.Types
import Constants exposing (cardTypesForOrganization, cardTypesForTool, cardTypesForUseCase)
import Dict exposing (Dict)
import Erl
import Http
import I18n
import Navigation
import Ports
import Requests
import Search.Types exposing (..)
import String
import Task
import Types exposing (..)
import Urls
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
    , ogpMode = False
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
    -> Maybe Authenticator.Types.Authentication
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
                    Result.Err httpError ->
                        let
                            _ =
                                Debug.log "Search.State GotCollections Error" httpError

                            newModel =
                                { model | collections = Failure httpError }
                        in
                            ( newModel, Cmd.none )

                    Result.Ok body ->
                        ( { model | collections = Data (Loaded body) }
                        , Cmd.none
                        )

            GotMoreOrganizations response ->
                case response of
                    Result.Err httpError ->
                        let
                            _ =
                                Debug.log "Search.State GotMoreOrganizations Error" httpError

                            newModel =
                                { model | organizations = Failure httpError }
                        in
                            ( newModel, Cmd.none )

                    Result.Ok body ->
                        let
                            oldBody =
                                getData model.organizations

                            newBody =
                                case oldBody of
                                    Just oldBody ->
                                        { oldBody | data = mergeDataIds body.data oldBody.data }

                                    Nothing ->
                                        body
                        in
                            ( { model | organizations = Data (Loaded newBody) }
                            , Cmd.none
                            )

            GotMoreTools response ->
                case response of
                    Result.Err httpError ->
                        let
                            _ =
                                Debug.log "Search.State GotMoreTools Error" httpError

                            newModel =
                                { model | tools = Failure httpError }
                        in
                            ( newModel, Cmd.none )

                    Result.Ok body ->
                        let
                            oldBody =
                                getData model.tools

                            newBody =
                                case oldBody of
                                    Just oldBody ->
                                        { oldBody | data = mergeDataIds body.data oldBody.data }

                                    Nothing ->
                                        body
                        in
                            ( { model | tools = Data (Loaded newBody) }
                            , Cmd.none
                            )

            GotMoreUseCases response ->
                case response of
                    Result.Err httpError ->
                        let
                            _ =
                                Debug.log "Search.State GotMoreUseCases Error" httpError

                            newModel =
                                { model | useCases = Failure httpError }
                        in
                            ( newModel, Cmd.none )

                    Result.Ok body ->
                        let
                            oldBody =
                                getData model.useCases

                            newBody =
                                case oldBody of
                                    Just oldBody ->
                                        { oldBody | data = mergeDataIds body.data oldBody.data }

                                    Nothing ->
                                        body
                        in
                            ( { model | useCases = Data (Loaded newBody) }
                            , Cmd.none
                            )

            GotOrganizations response ->
                case response of
                    Result.Err httpError ->
                        let
                            _ =
                                Debug.log "Search.State GotOrganizations Error" httpError

                            newModel =
                                { model | organizations = Failure httpError }
                        in
                            ( newModel, Cmd.none )

                    Result.Ok body ->
                        ( { model | organizations = Data (Loaded body) }
                        , Cmd.none
                        )

            GotTagsPopularity response ->
                case response of
                    Result.Err httpError ->
                        let
                            _ =
                                Debug.log "Search.State GotTagsPopularity Error" httpError

                            newModel =
                                { model | popularTagsData = Failure httpError }
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
                                case Urls.querySingleParameter "tagIds" location of
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
                    Result.Err httpError ->
                        let
                            _ =
                                Debug.log "Search.State GotTools Error" httpError

                            newModel =
                                { model | tools = Failure httpError }
                        in
                            ( newModel, Cmd.none )

                    Result.Ok body ->
                        ( { model | tools = Data (Loaded body) }
                        , Cmd.none
                        )

            GotUseCases response ->
                case response of
                    Result.Err httpError ->
                        let
                            _ =
                                Debug.log "Search.State GotUseCases Error" httpError

                            newModel =
                                { model | useCases = Failure httpError }
                        in
                            ( newModel, Cmd.none )

                    Result.Ok body ->
                        ( { model | useCases = Data (Loaded body) }
                        , Cmd.none
                        )

            Load ->
                let
                    limit =
                        8

                    newModel =
                        { model
                            | organizations = Data (Loading Nothing)
                            , tools = Data (Loading Nothing)
                            , useCases = Data (Loading Nothing)
                        }

                    selectedTagIds =
                        List.map .tagId model.selectedTags

                    term =
                        Urls.querySearchTerm location

                    requestsCmds =
                        [ Requests.getCollections authentication (Just 3)
                            |> Http.send (ForSelf << GotCollections)
                        , Requests.getCards
                            authentication
                            term
                            limit
                            0
                            selectedTagIds
                            cardTypesForOrganization
                            |> Http.send (ForSelf << GotOrganizations)
                        , Requests.getCards
                            authentication
                            term
                            limit
                            0
                            selectedTagIds
                            cardTypesForTool
                            |> Http.send (ForSelf << GotTools)
                        , Requests.getCards
                            authentication
                            term
                            limit
                            0
                            selectedTagIds
                            cardTypesForUseCase
                            |> Http.send (ForSelf << GotUseCases)
                        , Requests.getTagsPopularity authentication model.ogpMode selectedTagIds
                            |> Http.send (ForSelf << GotTagsPopularity)
                        ]
                in
                    newModel ! requestsCmds

            LoadMoreOrganizations ->
                let
                    body =
                        getData model.organizations

                    limit =
                        8

                    offset =
                        case body of
                            Just body ->
                                List.length body.data.ids

                            Nothing ->
                                0

                    selectedTagIds =
                        List.map .tagId model.selectedTags

                    term =
                        Urls.querySearchTerm location
                in
                    ( { model | organizations = Data (Loading body) }
                    , Requests.getCards
                        authentication
                        term
                        limit
                        offset
                        selectedTagIds
                        cardTypesForOrganization
                        |> Http.send (ForSelf << GotMoreOrganizations)
                    )

            LoadMoreTools ->
                let
                    body =
                        getData model.tools

                    limit =
                        8

                    offset =
                        case body of
                            Just body ->
                                List.length body.data.ids

                            Nothing ->
                                0

                    selectedTagIds =
                        List.map .tagId model.selectedTags

                    term =
                        Urls.querySearchTerm location
                in
                    ( { model | tools = Data (Loading body) }
                    , Requests.getCards
                        authentication
                        term
                        limit
                        offset
                        selectedTagIds
                        cardTypesForTool
                        |> Http.send (ForSelf << GotMoreTools)
                    )

            LoadMoreUseCases ->
                let
                    body =
                        getData model.useCases

                    limit =
                        8

                    offset =
                        case body of
                            Just body ->
                                List.length body.data.ids

                            Nothing ->
                                0

                    selectedTagIds =
                        List.map .tagId model.selectedTags

                    term =
                        Urls.querySearchTerm location
                in
                    ( { model | useCases = Data (Loading body) }
                    , Requests.getCards
                        authentication
                        term
                        limit
                        offset
                        selectedTagIds
                        cardTypesForUseCase
                        |> Http.send (ForSelf << GotMoreUseCases)
                    )
