module Search.State exposing (..)

import Authenticator.Model
import I18n
import Ports
import Requests
import Search.Types exposing (..)
import Set exposing (Set)
import Task
import Types exposing (..)
import WebData exposing (LoadingStatus(..), getData, WebData(..))


init : Model
init =
    { organizations = NotAsked
    , popularTags = NotAsked
    , selectedTags = Set.empty
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
    -> String
    -> ( Model, Cmd Msg )
update msg model authentication language searchQuery =
    let
        limit =
            Just 8

        requestsCmds =
            List.map (Cmd.map ForSelf)
                [ Task.perform
                    OrganizationsLoadError
                    OrganizationsLoadSuccess
                    (Requests.getCards authentication searchQuery limit model.selectedTags cardTypesForOrganization)
                , Task.perform
                    ToolsLoadError
                    ToolsLoadSuccess
                    (Requests.getCards authentication searchQuery limit model.selectedTags cardTypesForTool)
                , Task.perform
                    UseCasesLoadError
                    UseCasesLoadSuccess
                    (Requests.getCards authentication searchQuery limit model.selectedTags cardTypesForUseCase)
                , Task.perform
                    PopularTagsLoadError
                    PopularTagsLoadSuccess
                    (Requests.getTagsPopularity language model.selectedTags)
                ]
    in
        case msg of
            BubbleDeselect deselectedTag ->
                case getData model.popularTags of
                    Nothing ->
                        ( model, Cmd.none )

                    Just _ ->
                        let
                            newSelectedTags =
                                Set.remove deselectedTag model.selectedTags

                            newModel =
                                { model
                                    | organizations = Data (Loading (getData model.organizations))
                                    , selectedTags = newSelectedTags
                                    , tools = Data (Loading (getData model.tools))
                                    , useCases = Data (Loading (getData model.useCases))
                                }
                        in
                            newModel ! requestsCmds

            BubbleSelect selectedTag ->
                case getData model.popularTags of
                    Nothing ->
                        ( model, Cmd.none )

                    Just _ ->
                        let
                            newSelectedTags =
                                Set.insert selectedTag model.selectedTags

                            newModel =
                                { model
                                    | organizations = Data (Loading (getData model.organizations))
                                    , selectedTags = newSelectedTags
                                    , tools = Data (Loading (getData model.tools))
                                    , useCases = Data (Loading (getData model.useCases))
                                }
                        in
                            newModel ! requestsCmds

            Load searchQuery ->
                let
                    model' =
                        { model
                            | organizations = Data (Loading (getData model.organizations))
                            , tools = Data (Loading (getData model.tools))
                            , useCases = Data (Loading (getData model.useCases))
                        }
                in
                    model' ! requestsCmds

            OrganizationsLoadError err ->
                let
                    _ =
                        Debug.log "Search.State OrganizationsLoadError" err

                    model' =
                        { model | organizations = Failure err }
                in
                    ( model', Cmd.none )

            OrganizationsLoadSuccess body ->
                ( { model | organizations = Data (Loaded body) }
                , Cmd.none
                )

            PopularTagsLoadError err ->
                let
                    _ =
                        Debug.log "Search.State PopularTagsLoadError" err

                    model' =
                        { model | popularTags = Failure err }
                in
                    ( model', Cmd.none )

            PopularTagsLoadSuccess popularTags ->
                ( { model | popularTags = Data (Loaded popularTags) }
                , Ports.mountd3bubbles
                    { popularTags = popularTags
                    , selectedTags = model.selectedTags |> Set.toList
                    }
                )

            ToolsLoadError err ->
                let
                    _ =
                        Debug.log "Search.State ToolsLoadError" err

                    model' =
                        { model | tools = Failure err }
                in
                    ( model', Cmd.none )

            ToolsLoadSuccess body ->
                ( { model | tools = Data (Loaded body) }
                , Cmd.none
                )

            UseCasesLoadError err ->
                let
                    _ =
                        Debug.log "Search.State UseCasesLoadError" err

                    model' =
                        { model | useCases = Failure err }
                in
                    ( model', Cmd.none )

            UseCasesLoadSuccess body ->
                ( { model | useCases = Data (Loaded body) }
                , Cmd.none
                )
