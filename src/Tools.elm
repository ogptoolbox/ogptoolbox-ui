module Tools exposing (..)

import Authenticator.Model
import Browse
import Constants
import Dict exposing (Dict)
import Hop.Types
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onClick, onInput, onSubmit, targetValue)
import Http
import I18n exposing (getImageUrlOrOgpLogo, getName)
import Json.Decode as Decode
import Navigation
import Ports exposing (ImagePortData, fileSelected, fileContentRead, setDocumentMetatags)
import Requests exposing (..)
import Routes exposing (getSearchQuery, I18nRoute(..), makeUrlWithLanguage, ToolsNestedRoute(..))
import Set exposing (Set)
import Task
import Tool.View
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
    = Tools
        (WebData
            { examplesCount : Int
            , organizationsCount : Int
            , tools : DataIdsBody
            }
        )
    | Tool (WebData DataIdBody)
    | NewTool
        { fields : Dict String String
        , imageUploadStatus : UploadStatus
        }


init : Model
init =
    Tools NotAsked



-- ROUTING


urlUpdate : ( ToolsNestedRoute, Hop.Types.Location ) -> I18n.Language -> Model -> ( Model, Cmd Msg )
urlUpdate ( route, location ) language model =
    let
        searchQuery =
            getSearchQuery location
    in
        case route of
            ToolRoute toolId ->
                ( model, loadOne toolId )

            ToolsIndexRoute ->
                let
                    cmds =
                        [ loadAll searchQuery
                        , setDocumentMetatags
                            { title = I18n.translate language (I18n.Tool I18n.Plural)
                            , imageUrl = Constants.logoUrl
                            }
                        ]
                in
                    model ! cmds

            NewToolRoute ->
                ( NewTool
                    { fields = Dict.fromList [ ( "Types", "type:software" ) ]
                    , imageUploadStatus = NotUploaded
                    }
                , setDocumentMetatags
                    { title = I18n.translate language I18n.AddNewTool
                    , imageUrl = Constants.logoUrl
                    }
                )



-- UPDATE


type ExternalMsg
    = Navigate String


type InternalMsg
    = Error Http.Error
    | LoadAll String
    | LoadOne String
    | LoadedAll ( DataIdsBody, DataIdsBody, DataIdsBody )
    | LoadedOne DataIdBody
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


update :
    InternalMsg
    -> Model
    -> Maybe Authenticator.Model.Authentication
    -> I18n.Language
    -> ( Model, Cmd Msg )
update msg model authenticationMaybe language =
    case msg of
        Error err ->
            let
                _ =
                    Debug.log "Tools Error" err

                model' =
                    case model of
                        Tool _ ->
                            Tool (Failure err)

                        Tools _ ->
                            Tools (Failure err)

                        NewTool _ ->
                            model
            in
                ( model', Cmd.none )

        ImageSelected ->
            case model of
                NewTool _ ->
                    ( model, fileSelected "logoField" )

                _ ->
                    Debug.crash "Should never happen"

        ImageRead data ->
            case model of
                NewTool subModel ->
                    let
                        newModel =
                            NewTool { subModel | imageUploadStatus = Uploaded data }

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
                NewTool subModel ->
                    let
                        newModel =
                            NewTool { subModel | imageUploadStatus = UploadError err }
                    in
                        ( newModel, Cmd.none )

                _ ->
                    Debug.crash "Should never happen"

        LoadAll searchQuery ->
            let
                loadingStatus =
                    Loading
                        (case model of
                            Tool _ ->
                                Nothing

                            NewTool _ ->
                                Nothing

                            Tools webData ->
                                getData webData
                        )

                model' =
                    Tools (Data loadingStatus)

                cmd =
                    Cmd.map ForSelf
                        (Task.perform
                            Error
                            LoadedAll
                            (Task.map3 (,,)
                                (newTaskGetExamples authenticationMaybe searchQuery "1" Set.empty)
                                (newTaskGetOrganizations authenticationMaybe searchQuery "1" Set.empty)
                                (newTaskGetTools authenticationMaybe searchQuery "" Set.empty)
                            )
                        )
            in
                ( model', cmd )

        LoadOne toolId ->
            let
                model' =
                    case model of
                        Tool webData ->
                            Tool (Data (Loading (getData webData)))

                        Tools _ ->
                            Tool (Data (Loading Nothing))

                        NewTool _ ->
                            Tool (Data (Loading Nothing))

                cmd =
                    Task.perform Error LoadedOne (newTaskGetTool authenticationMaybe toolId)
                        |> Cmd.map ForSelf
            in
                ( model', cmd )

        LoadedAll ( examples, organizations, tools ) ->
            let
                model' =
                    Tools
                        (Data
                            (Loaded
                                { examplesCount = examples.count
                                , organizationsCount = organizations.count
                                , tools = tools
                                }
                            )
                        )
            in
                ( model', Cmd.none )

        LoadedOne body ->
            let
                cmd =
                    setDocumentMetatags
                        { title = getName language body.data.id body.data.cards body.data.values
                        , imageUrl = getImageUrlOrOgpLogo language body.data.id body.data.cards body.data.values
                        }
            in
                ( Tool (Data (Loaded body)), cmd )

        SetField name value ->
            case model of
                NewTool subModel ->
                    ( NewTool { subModel | fields = Dict.insert name value subModel.fields }, Cmd.none )

                _ ->
                    Debug.crash "Should never happen"

        SubmitFields ->
            case model of
                NewTool { fields } ->
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
                NewTool { fields } ->
                    let
                        urlPath =
                            "/tools/" ++ body.data.id

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
        Tool webData ->
            viewWebData
                language
                (\loadingStatus -> [ Tool.View.root navigate language loadingStatus ] )
                webData

        Tools webData ->
            viewWebData
                language
                (\loadingStatus ->
                    let
                        counts =
                            getLoadingStatusData loadingStatus
                                |> Maybe.map
                                    (\loadingStatus ->
                                        { examples = loadingStatus.examplesCount
                                        , organizations = loadingStatus.organizationsCount
                                        , tools = loadingStatus.tools.count
                                        }
                                    )
                    in
                        Browse.view
                            Types.Tool
                            counts
                            navigate
                            searchQuery
                            language
                            (mapLoadingStatus .tools loadingStatus)
                )
                webData

        NewTool { fields, imageUploadStatus } ->
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
                                , placeholder "What's the official name of the tool?"
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
                    [ div [ class "col-xs-6" ]
                        [ div [ class "form-group" ]
                            [ label [ for "typeField" ]
                                [ text "Type" ]
                            , select
                                [ class "form-control"
                                , id "typeField"
                                , on "change" (Html.Events.targetValue |> Decode.map (setField "Types"))
                                ]
                                [ option [ value "type:software" ]
                                    [ text "Software" ]
                                , option [ value "type:platform" ]
                                    [ text "Platform" ]
                                ]
                            ]
                        ]
                      -- TODO input text
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
                    , div [ class "col-xs-12" ]
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
                        , div [ class "form-group" ]
                            [ label [ for "downloadLinkField" ]
                                [ text "Download link" ]
                            , input
                                [ class "form-control"
                                , id "downloadLinkField"
                                , onInput (setField "Download")
                                , placeholder "Enter the address to download the tool"
                                , type' "url"
                                ]
                                []
                            ]
                        ]
                    ]
                , div [ class "row section-form" ]
                    [ div [ class "col-xs-12" ]
                        [ div [ class "panel panel-default panel-collapse" ]
                            [ div
                                [ attribute "aria-controls" "collapseTwo"
                                , attribute "aria-expanded" "false"
                                , attribute "data-parent" "#accordion"
                                , attribute "data-target" "#collapseTwo"
                                , attribute "data-toggle" "collapse"
                                , attribute "role" "tab"
                                , class "panel-heading"
                                , id "headingTwo"
                                ]
                                [ div [ class "row" ]
                                    [ div [ class "col-xs-8 text-left" ]
                                        [ h3 [ class "panel-title" ]
                                            [ text "Additional informations" ]
                                        ]
                                    , div [ class "col-xs-4 text-right" ]
                                        [ a [ class "show-more pull-right" ]
                                            [ text "Show more"
                                            , span [ class "glyphicon glyphicon-menu-down" ]
                                                []
                                            ]
                                        ]
                                    ]
                                ]
                            , div
                                [ attribute "aria-labelledby" "headingTwo"
                                , class "panel-collapse collapse"
                                , id "collapseTwo"
                                , attribute "role" "tabpanel"
                                ]
                                [ div [ class "panel-body nomargin" ]
                                    [ div [ class "form-group" ]
                                        [ label [ for "releaseDateField" ]
                                            [ text "Release date" ]
                                        , input
                                            [ class "form-control"
                                            , id "releaseDateField"
                                            , onInput (setField "Release Date")
                                              -- , placeholder "What's the official name of the tool?" -- TODO
                                            , type' "date"
                                            ]
                                            []
                                        ]
                                    , div [ class "form-group" ]
                                        [ label [ for "publisherField" ]
                                            [ text "Publisher" ]
                                        , input
                                            [ class "form-control"
                                            , id "publisherField"
                                            , onInput (setField "Publisher")
                                              -- , placeholder "What's the official name of the tool?" -- TODO
                                            , type' "text"
                                            ]
                                            []
                                        ]
                                      -- , div [ class "form-group" ]
                                      --     [ label [ for "exampleInputFile" ]
                                      --         [ text "File input" ]
                                      --     , input [ id "exampleInputFile", type' "file" ]
                                      --         []
                                      --     , p [ class "help-block" ]
                                      --         [ text "Example block-level help text here." ]
                                      --     ]
                                      -- , div [ class "checkbox" ]
                                      --     [ label []
                                      --         [ input [ type' "checkbox" ]
                                      --             []
                                      --         , text "Check me out"
                                      --         ]
                                      --     ]
                                    ]
                                ]
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
                                        [ text (I18n.translate language I18n.AddNewTool) ]
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
                            [ text (I18n.translate language I18n.PublishTool) ]
                        ]
                    ]
                ]
            ]
