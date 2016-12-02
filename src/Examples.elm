module Examples exposing (..)

import Authenticator.Model
import Browse
import Constants
import Dict exposing (Dict)
import Example
import Hop.Types
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onClick, onInput, onSubmit, targetValue)
import Http
import I18n exposing (getImageUrlOrOgpLogo, getName)
import Json.Decode as Decode
import Navigation
import Ports exposing (ImagePortData, fileSelected, fileContentRead, mountd3bubbles, setDocumentMetatags)
import Requests exposing (..)
import Routes exposing (getSearchQuery, I18nRoute(..), makeUrlWithLanguage, ExamplesNestedRoute(..))
import Set exposing (Set)
import Task
import Types exposing (..)
import Views exposing (viewWebData)
import WebData exposing (..)


-- SUBSCRIPTIONS


subscriptions : Model -> Sub InternalMsg
subscriptions model =
    fileContentRead ImageRead



-- MODEL


type UploadStatus
    = NotUploaded
    | Uploaded ImagePortData
    | UploadError Http.Error


type Model
    = Examples
        { webData :
            WebData
                { examples : DataIdsBody
                , organizationsCount : Int
                , popularTags : List PopularTag
                , toolsCount : Int
                }
        , selectedTags : Set String
        }
    | Example (WebData DataIdBody)
    | NewExample
        { fields : Dict String String
        , imageUploadStatus : UploadStatus
        }


init : Model
init =
    Examples { webData = NotAsked, selectedTags = Set.empty }



-- ROUTING


urlUpdate : ( ExamplesNestedRoute, Hop.Types.Location ) -> I18n.Language -> Model -> ( Model, Cmd Msg )
urlUpdate ( route, location ) language model =
    let
        searchQuery =
            getSearchQuery location
    in
        case route of
            ExampleRoute exampleId ->
                ( model, loadOne exampleId )

            ExamplesIndexRoute ->
                let
                    cmds =
                        [ loadAll searchQuery
                        , setDocumentMetatags
                            { title = I18n.translate language (I18n.Example I18n.Plural)
                            , imageUrl = Constants.logoUrl
                            }
                        ]
                in
                    model ! cmds

            NewExampleRoute ->
                ( NewExample
                    { fields = Dict.fromList [ ( "Types", "type:use-case" ) ]
                    , imageUploadStatus = NotUploaded
                    }
                , setDocumentMetatags
                    { title = I18n.translate language I18n.AddNewExample
                    , imageUrl = Constants.logoUrl
                    }
                )



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
    | SetField String String
    | SubmitFields
    | SubmittedFields DataIdBody
    | ImageSelected
    | ImageRead ImagePortData
    | ImageUploaded String
    | ImageUploadError Http.Error


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


update : InternalMsg -> Model -> Maybe Authenticator.Model.Authentication -> I18n.Language -> String -> ( Model, Cmd Msg )
update msg model authenticationMaybe language searchQuery =
    case msg of
        DeselectBubble deselectedTag ->
            let
                subModel =
                    case model of
                        Examples subModel ->
                            subModel

                        _ ->
                            Debug.crash "Should not happen"

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
                                                    | examples = webData.examples
                                                    , organizationsCount = webData.organizationsCount
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
                                                (newTaskGetExamples authenticationMaybe searchQuery "" newSelectedTags)
                                                (newTaskGetOrganizations authenticationMaybe searchQuery "1" newSelectedTags)
                                                (newTaskGetTagsPopularity language newSelectedTags)
                                                (newTaskGetTools authenticationMaybe searchQuery "1" newSelectedTags)
                                            )
                                        )
                            in
                                ( newSubModel, cmd )
            in
                ( Examples newSubModel, cmd )

        Error err ->
            let
                _ =
                    Debug.log "Examples Error" err

                model' =
                    case model of
                        Example _ ->
                            Example (Failure err)

                        Examples x ->
                            Examples { x | webData = Failure err }

                        NewExample _ ->
                            model
            in
                ( model', Cmd.none )

        ImageSelected ->
            case model of
                NewExample _ ->
                    ( model, fileSelected "logoField" )

                _ ->
                    Debug.crash "Should never happen"

        ImageRead data ->
            case model of
                NewExample subModel ->
                    let
                        newModel =
                            NewExample { subModel | imageUploadStatus = Uploaded data }

                        cmd =
                            Cmd.map ForSelf
                                (Task.perform
                                    ImageUploadError
                                    ImageUploaded
                                    (newTaskPostUploadImage authenticationMaybe data.contents)
                                )
                    in
                        ( newModel, cmd )

                _ ->
                    Debug.crash "Should never happen"

        ImageUploaded str ->
            -- TODO
            ( model, Cmd.none )

        ImageUploadError err ->
            case model of
                NewExample subModel ->
                    let
                        newModel =
                            NewExample { subModel | imageUploadStatus = UploadError err }
                    in
                        ( newModel, Cmd.none )

                _ ->
                    Debug.crash "Should never happen"

        LoadAll searchQuery ->
            let
                loadingStatus =
                    Loading
                        (case model of
                            Example _ ->
                                Nothing

                            NewExample _ ->
                                Nothing

                            Examples { webData } ->
                                getData webData
                        )

                newModel =
                    case model of
                        Examples x ->
                            Examples { x | webData = Data loadingStatus }

                        _ ->
                            Debug.crash "Should never happen"

                cmd =
                    Cmd.map ForSelf
                        (Task.perform
                            Error
                            LoadedAll
                            (Task.map4 (,,,)
                                (newTaskGetExamples authenticationMaybe searchQuery "" Set.empty)
                                (newTaskGetOrganizations authenticationMaybe searchQuery "1" Set.empty)
                                (newTaskGetTagsPopularity language Set.empty)
                                (newTaskGetTools authenticationMaybe searchQuery "1" Set.empty)
                            )
                        )
            in
                ( newModel, cmd )

        LoadOne exampleId ->
            let
                model' =
                    case model of
                        Example webData ->
                            Example (Data (Loading (getData webData)))

                        Examples _ ->
                            Example (Data (Loading Nothing))

                        NewExample _ ->
                            Example (Data (Loading Nothing))

                cmd =
                    Task.perform Error LoadedOne (newTaskGetExample authenticationMaybe exampleId)
                        |> Cmd.map ForSelf
            in
                ( model', cmd )

        LoadedAll ( examples, organizations, popularTags, tools ) ->
            let
                subModel =
                    case model of
                        Examples subModel ->
                            subModel

                        _ ->
                            Debug.crash "Should not happen"

                newSubModel =
                    { subModel
                        | webData =
                            Data
                                (Loading
                                    (Just
                                        { examples = examples
                                        , organizationsCount = organizations.count
                                        , popularTags = popularTags
                                        , toolsCount = tools.count
                                        }
                                    )
                                )
                    }

                newModel =
                    Examples newSubModel

                cmds =
                    [ setDocumentMetatags
                        { title = I18n.translate language (I18n.Example I18n.Plural)
                        , imageUrl = Constants.logoUrl
                        }
                    , mountd3bubbles
                        { popularTags = popularTags
                        , selectedTags = newSubModel.selectedTags |> Set.toList
                        }
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
                ( Example (Data (Loaded body)), cmd )

        SelectBubble selectedTag ->
            let
                subModel =
                    case model of
                        Examples subModel ->
                            subModel

                        _ ->
                            Debug.crash "Should not happen"

                ( newSubModel, cmd ) =
                    case getData subModel.webData of
                        Nothing ->
                            let
                                _ =
                                    Debug.log "Examples Nothing" True
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
                                                    | examples = webData.examples
                                                    , organizationsCount = webData.organizationsCount
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
                                                (newTaskGetExamples authenticationMaybe searchQuery "" newSelectedTags)
                                                (newTaskGetOrganizations authenticationMaybe searchQuery "1" newSelectedTags)
                                                (newTaskGetTagsPopularity language newSelectedTags)
                                                (newTaskGetTools authenticationMaybe searchQuery "1" newSelectedTags)
                                            )
                                        )
                            in
                                ( newSubModel, cmd )
            in
                ( Examples newSubModel, cmd )

        SetField name value ->
            case model of
                NewExample subModel ->
                    ( NewExample { subModel | fields = Dict.insert name value subModel.fields }, Cmd.none )

                _ ->
                    Debug.crash "Should never happen"

        SubmitFields ->
            case model of
                NewExample { fields } ->
                    let
                        cmd =
                            Task.perform
                                Error
                                SubmittedFields
                                (newTaskPostCardsEasy authenticationMaybe fields language)
                                |> Cmd.map ForSelf
                    in
                        ( model, cmd )

                _ ->
                    Debug.crash "Should never happen"

        SubmittedFields body ->
            case model of
                NewExample { fields } ->
                    let
                        urlPath =
                            "/examples/" ++ body.data.id

                        cmd =
                            makeUrlWithLanguage language urlPath
                                |> Navigation.newUrl
                    in
                        ( model, cmd )

                _ ->
                    Debug.crash "Should never happen"



-- VIEW


view : Maybe Authenticator.Model.Authentication -> Model -> String -> I18n.Language -> List (Html Msg)
view authenticationMaybe model searchQuery language =
    case model of
        Example webData ->
            viewWebData
                language
                (\loadingStatus -> [ Example.view navigate language loadingStatus ])
                webData

        Examples { webData } ->
            viewWebData
                language
                (\loadingStatus ->
                    let
                        counts =
                            getLoadingStatusData loadingStatus
                                |> Maybe.map
                                    (\loadingStatus ->
                                        { examples = loadingStatus.examples.count
                                        , organizations = loadingStatus.organizationsCount
                                        , tools = loadingStatus.toolsCount
                                        }
                                    )
                    in
                        Browse.view
                            Types.Example
                            counts
                            navigate
                            searchQuery
                            language
                            (mapLoadingStatus .examples loadingStatus)
                )
                webData

        NewExample { fields, imageUploadStatus } ->
            [ viewAddNew language fields imageUploadStatus ]


viewAddNew : I18n.Language -> Dict String String -> UploadStatus -> Html Msg
viewAddNew language fields imageUploadStatus =
    let
        setField =
            (\k v -> ForSelf (SetField k v))

        viewForm =
            div [ class "col-xs-12" ]
                [ div [ class "row section-form" ]
                    [ div [ class "col-xs-12" ]
                        [ div [ class "form-group" ]
                            [ label [ for "nameField" ]
                                [ text "Name" ]
                            , input
                                [ class "form-control"
                                , id "nameField"
                                , onInput (setField "Name")
                                , placeholder "What's the official name of the use case?"
                                , required True
                                , type' "text"
                                ]
                                []
                            ]
                        , div [ class "form-group" ]
                            [ label [ for "aboutField" ]
                                [ text "About" ]
                            , input
                                [ class "form-control"
                                , id "aboutField"
                                , onInput (setField "Description")
                                , placeholder "Add a complete description"
                                , type' "text"
                                ]
                                []
                            ]
                        ]
                    ]
                , div [ class "row section-form" ]
                    [ -- TODO input text
                      -- , div [ class "col-xs-6" ]
                      --     [ div [ class "form-group" ]
                      --         [ label [ for "licenseField" ]
                      --             [ text "License" ]
                      --         , select [ class "form-control", id "licenseField" ]
                      --             [ option []
                      --                 [ text "1" ]
                      --             , option []
                      --                 [ text "2" ]
                      --             , option []
                      --                 [ text "3" ]
                      --             , option []
                      --                 [ text "4" ]
                      --             , option []
                      --                 [ text "5" ]
                      --             ]
                      --         ]
                      --     ]
                      div [ class "col-xs-12" ]
                        [ div [ class "form-group" ]
                            [ label [ for "websiteLinkField" ]
                                [ text "Website link" ]
                            , input
                                [ class "form-control"
                                , id "websiteLinkField"
                                , onInput (setField "Website")
                                , placeholder "Enter the address of the informational website"
                                , type' "url"
                                ]
                                []
                            ]
                        ]
                    ]
                ]
    in
        Html.form
            [ onSubmit (ForSelf SubmitFields)
            ]
            [ div [ class "row section" ]
                [ div [ class "container" ]
                    [ div [ class "row" ]
                        [ div [ class "col-md-12 content content-left" ]
                            [ div [ class "row" ]
                                [ div [ class "col-xs-12" ]
                                    [ h1 []
                                        [ text (I18n.translate language I18n.AddNewExample) ]
                                    ]
                                ]
                            ]
                        ]
                    , div [ class "row" ]
                        [ div [ class "col-md-9 content content-left" ]
                            [ div [ class "row" ]
                                [ viewForm
                                ]
                            ]
                        , div [ class "col-md-3 sidebar" ]
                            [ div [ class "row" ]
                                [ div [ class "col-xs-12" ]
                                    [ div [ class "thumbnail orga grey" ]
                                        [ div [ class "upload-container" ]
                                            [ label [ for "logoField" ]
                                                [ text "Logo" ]
                                            , div [ class "upload-zone" ]
                                                (case imageUploadStatus of
                                                    NotUploaded ->
                                                        [ span
                                                            [ attribute "aria-hidden" "true"
                                                            , class "glyphicon glyphicon-camera"
                                                            ]
                                                            []
                                                        , text "Upload image"
                                                        ]

                                                    Uploaded { contents, filename } ->
                                                        [ -- img [ src ("data:" ++ contents) ] []
                                                          p [] [ text filename ]
                                                        ]

                                                    UploadError err ->
                                                        [ span
                                                            [ attribute "aria-hidden" "true"
                                                            , class "glyphicon glyphicon-camera"
                                                            ]
                                                            []
                                                        , text ("Error: " ++ (toString err))
                                                          -- TODO
                                                        ]
                                                )
                                            , input
                                                [ id "logoField"
                                                , on "change" (Decode.succeed (ForSelf ImageSelected))
                                                , type' "file"
                                                ]
                                                []
                                            ]
                                        ]
                                    ]
                                ]
                              -- , div [ class "row" ]
                              --     [ div [ class "col-xs-12" ]
                              --         [ i []
                              --             [ text "Maecenas " ]
                              --         ]
                              --     ]
                            ]
                        ]
                    ]
                ]
            , div [ class "row section-form last" ]
                [ div [ class "container" ]
                    [ div [ class "col-md-9 content content-left" ]
                        [ button
                            [ class "btn btn-default pull-right"
                            , disabled
                                (case imageUploadStatus of
                                    NotUploaded ->
                                        False

                                    Uploaded _ ->
                                        False

                                    UploadError _ ->
                                        True
                                )
                            , type' "submit"
                            ]
                            [ text (I18n.translate language I18n.PublishExample) ]
                        ]
                    ]
                ]
            ]
