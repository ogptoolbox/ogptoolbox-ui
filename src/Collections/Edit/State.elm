module Collections.Edit.State exposing (..)

import Authenticator.Types exposing (Authentication)
import Cards.Autocomplete.State
import Collections.Edit.Types exposing (..)
import Dict exposing (Dict)
import Http
import Http.Error
import I18n
import Json.Encode as Encode
import Image.Types exposing (..)
import Navigation
import Ports
import Requests
import String
import Types exposing (..)
import Urls


convertControls : Model -> Model
convertControls model =
    let
        language =
            model.language

        conversion : List ( String, Maybe Encode.Value, Maybe I18n.TranslationId )
        conversion =
            [ ( "cardIds"
              , if List.isEmpty model.cardIds then
                    Nothing
                else
                    Just (Encode.list (List.map Encode.string model.cardIds))
              , Nothing
              )
            , let
                description =
                    String.trim model.description
              in
                if String.isEmpty description then
                    ( "description"
                    , Nothing
                    , Just I18n.MissingValue
                    )
                else
                    ( "description"
                    , Just (Encode.string description)
                    , Nothing
                    )
            , case model.imageUploadStatus of
                ImageNotUploadedStatus ->
                    ( "logo"
                    , Nothing
                    , Nothing
                      -- Image is not required.
                    )

                ImageSelectedStatus ->
                    ( "logo"
                    , Nothing
                    , Just I18n.ReadingSelectedImage
                    )

                ImageReadStatus { contents, filename } ->
                    ( "logo"
                    , Nothing
                    , Just (I18n.UploadingImage filename)
                    )

                ImageUploadedStatus path ->
                    ( "logo"
                    , Just (Encode.string path)
                    , Nothing
                    )

                ImageUploadErrorStatus httpError ->
                    ( "logo"
                    , Nothing
                    , Just (I18n.ImageUploadError (Http.Error.toString language httpError))
                    )
            , let
                name =
                    String.trim model.name
              in
                if String.isEmpty name then
                    ( "name"
                    , Nothing
                    , Just I18n.MissingValue
                    )
                else
                    ( "name"
                    , Just (Encode.string name)
                    , Nothing
                    )
            ]

        errors =
            Dict.fromList <|
                List.filterMap
                    (\( key, _, error ) ->
                        case error of
                            Just error ->
                                Just ( key, error )

                            Nothing ->
                                Nothing
                    )
                    conversion

        collectionJson =
            if Dict.isEmpty errors then
                Just <|
                    Encode.object <|
                        List.filterMap
                            (\( key, valueJson, _ ) ->
                                case valueJson of
                                    Just valueJson ->
                                        Just ( key, valueJson )

                                    Nothing ->
                                        Nothing
                            )
                            conversion
            else
                Nothing
    in
        { model
            | collectionJson = collectionJson
            , errors = errors
        }


init : Model
init =
    { authentication = Nothing
    , cardIds = []
    , collectionJson = Nothing
    , data = initData
    , description = ""
    , editedCollectionId = Nothing
    , errors = Dict.empty
    , httpError = Nothing
    , imageUploadStatus = ImageNotUploadedStatus
    , language = I18n.English
    , name = ""
    , toolsAutocompleteModel = Cards.Autocomplete.State.init cardTypesForTool
    , useCasesAutocompleteModel = Cards.Autocomplete.State.init cardTypesForUseCase
    }


subscriptions : Model -> Sub InternalMsg
subscriptions model =
    Sub.batch
        [ Ports.fileContentRead ImageRead
        , Sub.map ToolsAutocompleteMsg (Cards.Autocomplete.State.subscriptions model.toolsAutocompleteModel)
        , Sub.map UseCasesAutocompleteMsg (Cards.Autocomplete.State.subscriptions model.useCasesAutocompleteModel)
        ]


update : InternalMsg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddCard card ->
            ( model
            , Requests.getCard model.authentication card.id
                |> Http.send (ForSelf << CardAdded)
            )

        CardAdded (Err httpError) ->
            let
                _ =
                    Debug.log "Collections.Edit.State GotCard Err" httpError
            in
                ( model, Cmd.none )

        CardAdded (Ok { data }) ->
            ( convertControls
                { model
                    | cardIds =
                        if List.member data.id model.cardIds then
                            model.cardIds
                        else
                            List.append model.cardIds [ data.id ]
                    , data = mergeData data model.data
                }
            , Cmd.none
            )

        CollectionPosted (Err httpError) ->
            ( { model | httpError = Just httpError }, Cmd.none )

        CollectionPosted (Ok body) ->
            let
                newModel =
                    { model | data = mergeData body.data model.data }

                path =
                    "/collections/" ++ body.data.id

                cmd =
                    Urls.languagePath model.language path
                        |> Navigation.newUrl
            in
                ( newModel, cmd )

        CreateCard cardTypes cardName ->
            ( model
            , Requests.postCard
                model.authentication
                (Dict.fromList
                    [ ( "Name", cardName )
                    , ( "Types", Maybe.withDefault "software" (List.head cardTypes) )
                    ]
                )
                model.language
                |> Http.send (ForSelf << CardAdded)
            )

        GotCollection (Err httpError) ->
            ( { model | httpError = Just httpError }, Cmd.none )

        GotCollection (Ok body) ->
            let
                collection =
                    case Dict.get body.data.id body.data.collections of
                        Nothing ->
                            Debug.crash ("Collection not found id=" ++ body.data.id)

                        Just collection ->
                            collection

                newModel =
                    convertControls
                        { model
                            | cardIds = collection.cardIds
                            , data = mergeData body.data model.data
                            , description = collection.description
                            , imageUploadStatus =
                                case collection.logo of
                                    Nothing ->
                                        ImageNotUploadedStatus

                                    Just path ->
                                        ImageUploadedStatus path
                            , name = collection.name
                        }

                cmd =
                    Ports.setDocumentMetadata
                        { description = I18n.translate model.language I18n.EditCollectionDescription
                        , imageUrl = Urls.appLogoFullUrl
                        , title = I18n.translate model.language I18n.EditCollectionTitle
                        }
            in
                ( newModel, cmd )

        ImageRead data ->
            let
                newModel =
                    convertControls { model | imageUploadStatus = ImageReadStatus data }

                cmd =
                    case model.imageUploadStatus of
                        ImageNotUploadedStatus ->
                            Cmd.none

                        ImageSelectedStatus ->
                            Requests.postUploadImage model.authentication data.contents
                                |> Http.send ImageUploaded
                                |> Cmd.map ForSelf

                        ImageReadStatus _ ->
                            Cmd.none

                        ImageUploadedStatus _ ->
                            Cmd.none

                        ImageUploadErrorStatus _ ->
                            Cmd.none
            in
                ( newModel, cmd )

        ImageSelected ->
            let
                cmd =
                    Ports.fileSelected "logoField"

                newModel =
                    convertControls { model | imageUploadStatus = ImageSelectedStatus }
            in
                ( newModel, cmd )

        ImageUploaded (Result.Err err) ->
            let
                newModel =
                    convertControls { model | imageUploadStatus = ImageUploadErrorStatus err }
            in
                ( newModel, Cmd.none )

        ImageUploaded (Result.Ok path) ->
            let
                newModel =
                    convertControls { model | imageUploadStatus = ImageUploadedStatus path }
            in
                ( newModel, Cmd.none )

        LoadCollection collectionId ->
            let
                newModel =
                    { model
                        | editedCollectionId = Just collectionId
                        , httpError = Nothing
                    }

                cmd =
                    Requests.getCollection model.authentication collectionId
                        |> Http.send (ForSelf << GotCollection)
            in
                ( newModel, cmd )

        PostCollection ->
            let
                newModel =
                    convertControls { model | httpError = Nothing }

                cmd =
                    case newModel.collectionJson of
                        Just collectionJson ->
                            Requests.postCollection
                                newModel.authentication
                                newModel.editedCollectionId
                                collectionJson
                                |> Http.send (ForSelf << CollectionPosted)

                        Nothing ->
                            Cmd.none
            in
                ( newModel, cmd )

        RemoveCard cardId ->
            ( { model | cardIds = List.filter (\cardId1 -> cardId1 /= cardId) model.cardIds }, Cmd.none )

        SetDescription description ->
            ( convertControls { model | description = description }, Cmd.none )

        SetName name ->
            ( convertControls { model | name = name }, Cmd.none )

        ToolsAutocompleteMsg childMsg ->
            let
                ( toolsAutocompleteModel, childCmd ) =
                    Cards.Autocomplete.State.update childMsg
                        model.language
                        "toolsAutocomplete"
                        model.toolsAutocompleteModel
            in
                ( convertControls { model | toolsAutocompleteModel = toolsAutocompleteModel }
                , Cmd.map translateToolsAutocompleteMsg childCmd
                )

        UseCasesAutocompleteMsg childMsg ->
            let
                ( useCasesAutocompleteModel, childCmd ) =
                    Cards.Autocomplete.State.update childMsg
                        model.language
                        "useCasesAutocomplete"
                        model.useCasesAutocompleteModel
            in
                ( convertControls { model | useCasesAutocompleteModel = useCasesAutocompleteModel }
                , Cmd.map translateUseCasesAutocompleteMsg childCmd
                )


urlUpdate : Maybe Authentication -> I18n.Language -> Maybe String -> Model -> ( Model, Cmd Msg )
urlUpdate authentication language collectionId model =
    let
        newModel =
            { init
                | authentication = authentication
                , language = language
            }
    in
        case collectionId of
            Just collectionId ->
                update (LoadCollection collectionId) newModel

            Nothing ->
                ( newModel, Cmd.none )
