module AddNewCollection.State exposing (..)

import AddNewCollection.Types exposing (..)
import Authenticator.Types
import Dict exposing (Dict)
import Http
import I18n
import Image.Types exposing (..)
import Navigation
import Ports
import Requests
import String
import Urls
import WebData exposing (..)


init : Model
init =
    { editedCollectionId = Nothing
    , fields =
        { cardIds = ""
        , description = ""
        , name = ""
        }
    , imageUploadStatus = ImageNotUploadedStatus
    , webData = NotAsked
    }


subscriptions : Model -> Sub InternalMsg
subscriptions model =
    Ports.fileContentRead ImageRead


update : InternalMsg -> Model -> Maybe Authenticator.Types.Authentication -> I18n.Language -> ( Model, Cmd Msg )
update msg ({ fields } as model) authentication language =
    case msg of
        CollectionPosted response ->
            case response of
                Result.Err err ->
                    let
                        _ =
                            Debug.log "AddNewCollection.State CollectionPosted Error" err

                        newModel =
                            { model | webData = Failure err }
                    in
                        ( newModel, Cmd.none )

                Result.Ok body ->
                    let
                        newModel =
                            { model | webData = Data (Loaded body) }

                        path =
                            "/collections/" ++ body.data.id

                        cmd =
                            Urls.languagePath language path
                                |> Navigation.newUrl
                    in
                        ( newModel, cmd )

        GotCollection response ->
            case response of
                Result.Err err ->
                    let
                        _ =
                            Debug.log "AddNewCollection.State GotCollection Error" err

                        newModel =
                            { model | webData = Failure err }
                    in
                        ( newModel, Cmd.none )

                Result.Ok body ->
                    let
                        collection =
                            case Dict.get body.data.id body.data.collections of
                                Nothing ->
                                    Debug.crash ("Collection not found id=" ++ body.data.id)

                                Just collection ->
                                    collection

                        cardIds =
                            String.join "\n" collection.cardIds

                        newModel =
                            { model
                                | fields =
                                    { cardIds = cardIds
                                    , description = collection.description
                                    , name = collection.name
                                    }
                                , imageUploadStatus =
                                    case collection.logo of
                                        Nothing ->
                                            ImageNotUploadedStatus

                                        Just path ->
                                            ImageUploadedStatus path
                                , webData = Data (Loaded body)
                            }

                        cmd =
                            Ports.setDocumentMetadata
                                { description = I18n.translate language I18n.CollectionEditDescription
                                , imageUrl = Urls.appLogoFullUrl
                                , title = I18n.translate language I18n.CollectionEditTitle
                                }
                    in
                        ( newModel, cmd )

        ImageSelected ->
            let
                cmd =
                    Ports.fileSelected "logoField"

                newModel =
                    { model | imageUploadStatus = ImageSelectedStatus }
            in
                ( newModel, cmd )

        ImageRead data ->
            let
                newModel =
                    { model | imageUploadStatus = ImageReadStatus data }

                cmd =
                    case model.imageUploadStatus of
                        ImageNotUploadedStatus ->
                            Cmd.none

                        ImageSelectedStatus ->
                            Requests.postUploadImage authentication data.contents
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

        ImageUploaded (Result.Err err) ->
            let
                _ =
                    Debug.log "AddNewCollection.State ImageUploaded Error" err

                newModel =
                    { model | imageUploadStatus = ImageUploadErrorStatus err }
            in
                ( newModel, Cmd.none )

        ImageUploaded (Result.Ok path) ->
            let
                newModel =
                    { model | imageUploadStatus = ImageUploadedStatus path }
            in
                ( newModel, Cmd.none )

        LoadCollection collectionId ->
            let
                newModel =
                    { model
                        | editedCollectionId = Just collectionId
                        , webData = Data (Loading Nothing)
                    }

                cmd =
                    Requests.getCollection authentication collectionId
                        |> Http.send (ForSelf << GotCollection)
            in
                ( newModel, cmd )

        PostNewCollection ->
            let
                newModel =
                    { model | webData = Data (Loading Nothing) }

                imagePath =
                    case model.imageUploadStatus of
                        ImageNotUploadedStatus ->
                            ""

                        ImageSelectedStatus ->
                            ""

                        ImageReadStatus _ ->
                            ""

                        ImageUploadedStatus path ->
                            path

                        ImageUploadErrorStatus _ ->
                            ""

                cmd =
                    Requests.postCollection
                        authentication
                        model.editedCollectionId
                        model.fields
                        imagePath
                        |> Http.send (ForSelf << CollectionPosted)
            in
                ( newModel, cmd )

        SetCardIds cardIds ->
            let
                newModel =
                    { model | fields = { fields | cardIds = cardIds } }
            in
                ( newModel, Cmd.none )

        SetDescription description ->
            let
                newModel =
                    { model | fields = { fields | description = description } }
            in
                ( newModel, Cmd.none )

        SetName name ->
            let
                newModel =
                    { model | fields = { fields | name = name } }
            in
                ( newModel, Cmd.none )
