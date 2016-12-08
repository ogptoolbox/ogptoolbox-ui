module AddNewCollection.State exposing (..)

import Authenticator.Model
import Constants
import Dict exposing (Dict)
import I18n exposing (getImageUrlOrOgpLogo, getName)
import Navigation
import Ports
import Requests
import Routes
import String
import Task
import AddNewCollection.Types exposing (..)
import WebData exposing (..)


init : Model
init =
    { editedCollectionId = Nothing
    , fields =
        { cardIds = ""
        , description = ""
        , name = ""
        }
    , imageUploadStatus = NotUploaded
    , webData = NotAsked
    }


subscriptions : Model -> Sub InternalMsg
subscriptions model =
    Ports.fileContentRead ImageRead


update : InternalMsg -> Model -> Maybe Authenticator.Model.Authentication -> I18n.Language -> ( Model, Cmd Msg )
update msg ({ fields } as model) authentication language =
    case msg of
        ImageSelected ->
            let
                cmd =
                    Ports.fileSelected "logoField"

                newModel =
                    { model | imageUploadStatus = Selected }
            in
                ( newModel, cmd )

        ImageRead data ->
            let
                newModel =
                    { model | imageUploadStatus = Read data }

                cmd =
                    case model.imageUploadStatus of
                        NotUploaded ->
                            Cmd.none

                        Selected ->
                            Task.perform
                                ImageUploadError
                                ImageUploadSuccess
                                (Requests.postUploadImage authentication data.contents)
                                |> Cmd.map ForSelf

                        Read _ ->
                            Cmd.none

                        Uploaded _ ->
                            Cmd.none

                        UploadError _ ->
                            Cmd.none
            in
                ( newModel, cmd )

        ImageUploadError err ->
            let
                newModel =
                    { model | imageUploadStatus = UploadError err }
            in
                ( newModel, Cmd.none )

        ImageUploadSuccess urlPath ->
            let
                newModel =
                    { model | imageUploadStatus = Uploaded urlPath }
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
                    Task.perform
                        LoadCollectionError
                        LoadCollectionSuccess
                        (Requests.getCollection collectionId)
                        |> Cmd.map ForSelf
            in
                ( newModel, cmd )

        LoadCollectionError err ->
            let
                _ =
                    Debug.log "AddNewCollection.State LoadCollectionError" err

                newModel =
                    { model | webData = Failure err }
            in
                ( newModel, Cmd.none )

        LoadCollectionSuccess body ->
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
                                    NotUploaded

                                Just urlPath ->
                                    Uploaded urlPath
                        , webData = Data (Loaded body)
                    }

                cmd =
                    Ports.setDocumentMetatags
                        { title =
                            "Edit Collection"
                            -- TODO i18n
                        , imageUrl = Constants.logoUrl
                        }
            in
                ( newModel, cmd )

        PostNewCollection ->
            let
                newModel =
                    { model | webData = Data (Loading Nothing) }

                imageUrlPath =
                    case model.imageUploadStatus of
                        NotUploaded ->
                            ""

                        Selected ->
                            ""

                        Read _ ->
                            ""

                        Uploaded urlPath ->
                            urlPath

                        UploadError _ ->
                            ""

                cmd =
                    Task.perform
                        PostNewCollectionError
                        PostNewCollectionSuccess
                        (Requests.postCollection authentication model.editedCollectionId model.fields imageUrlPath)
                        |> Cmd.map ForSelf
            in
                ( newModel, cmd )

        PostNewCollectionError err ->
            let
                _ =
                    Debug.log "AddNewCollection.State PostNewCollectionError" err

                newModel =
                    { model | webData = Failure err }
            in
                ( newModel, Cmd.none )

        PostNewCollectionSuccess body ->
            let
                newModel =
                    { model | webData = Data (Loaded body) }

                urlPath =
                    "/collections/" ++ body.data.id

                cmd =
                    Routes.makeUrlWithLanguage language urlPath
                        |> Navigation.newUrl
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
