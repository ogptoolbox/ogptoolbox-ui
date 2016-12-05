module AddNew.State exposing (..)

import AddNew.Types exposing (..)
import Authenticator.Model
import Dict
import I18n
import Navigation
import Ports
import Requests
import Routes
import Task
import Types exposing (..)


init : Model
init =
    { error = Nothing
    , fields = Dict.empty
    , imageUploadStatus = NotUploaded
    }


subscriptions : Model -> Sub InternalMsg
subscriptions model =
    Ports.fileContentRead ImageRead


update : InternalMsg -> Model -> Maybe Authenticator.Model.Authentication -> I18n.Language -> ( Model, Cmd Msg )
update msg model authentication language =
    case msg of
        Error err ->
            let
                _ =
                    Debug.log "AddNew.State.update Error" err

                newModel =
                    { model | error = Just err }
            in
                ( newModel, Cmd.none )

        ImageSelected ->
            let
                cmd =
                    Ports.fileSelected "logoField"
            in
                ( model, cmd )

        ImageRead data ->
            let
                newModel =
                    { model | imageUploadStatus = Uploaded data }

                cmd =
                    Task.perform
                        ImageUploadError
                        ImageUploaded
                        (Requests.postUploadImage authentication data.contents)
                        |> Cmd.map ForSelf
            in
                ( newModel, cmd )

        ImageUploaded str ->
            -- TODO Add confirmation and unlock publish button
            ( model, Cmd.none )

        ImageUploadError err ->
            let
                newModel =
                    { model | imageUploadStatus = UploadError err }
            in
                ( newModel, Cmd.none )

        SetField name value ->
            let
                newModel =
                    { model | fields = Dict.insert name value model.fields }
            in
                ( newModel, Cmd.none )

        SubmitFields ->
            let
                cmd =
                    Task.perform
                        Error
                        SubmittedFields
                        (Requests.postCardsEasy authentication model.fields language)
                        |> Cmd.map ForSelf
            in
                ( model, cmd )

        SubmittedFields body ->
            let
                urlPath =
                    getCard body.data.cards body.data.id
                        |> Routes.urlPathForCard

                cmd =
                    Routes.makeUrlWithLanguage language urlPath
                        |> Navigation.newUrl
            in
                ( model, cmd )
