module AddNew.State exposing (..)

import AddNew.Types exposing (..)
import Authenticator.Types
import Dict
import Http
import I18n
import Image.Types exposing (..)
import Navigation
import Ports
import Requests
import Types exposing (..)
import Urls


init : Model
init =
    { error = Nothing
    , fields = Dict.empty
    , imageUploadStatus = ImageNotUploadedStatus
    }


subscriptions : Model -> Sub InternalMsg
subscriptions model =
    Ports.fileContentRead ImageRead


update : InternalMsg -> Model -> Maybe Authenticator.Types.Authentication -> I18n.Language -> ( Model, Cmd Msg )
update msg model authentication language =
    case msg of
        CardPosted response ->
            case response of
                Result.Err err ->
                    let
                        _ =
                            Debug.log "AddNew.State GotOrganizations CardPosted" err

                        newModel =
                            { model | error = Just err }
                    in
                        ( newModel, Cmd.none )

                Result.Ok body ->
                    let
                        path =
                            getCard body.data.cards body.data.id
                                |> Urls.pathForCard

                        cmd =
                            Urls.languagePath language path
                                |> Navigation.newUrl
                    in
                        ( model, cmd )

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
                    Debug.log "AddNew.State ImageUploaded Error" err

                newModel =
                    { model | imageUploadStatus = ImageUploadErrorStatus err }
            in
                ( newModel, Cmd.none )

        ImageUploaded (Result.Ok path) ->
            let
                newModel =
                    { model
                        | fields = Dict.insert "Logo" path model.fields
                        , imageUploadStatus = ImageUploadedStatus path
                    }
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
                    Requests.postCard authentication model.fields language
                        |> Http.send (ForSelf << CardPosted)
            in
                ( model, cmd )
