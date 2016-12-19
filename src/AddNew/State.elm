module AddNew.State exposing (..)

import AddNew.Types exposing (..)
import Authenticator.Types
import Dict
import Http
import I18n
import Navigation
import Ports
import Requests
import Routes
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
                        urlPath =
                            getCard body.data.cards body.data.id
                                |> Routes.urlPathForCard

                        cmd =
                            Routes.makeUrlWithLanguage language urlPath
                                |> Navigation.newUrl
                    in
                        ( model, cmd )

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
                            Requests.postUploadImage authentication data.contents
                                |> Http.send ImageUploaded
                                |> Cmd.map ForSelf

                        Read _ ->
                            Cmd.none

                        Uploaded _ ->
                            Cmd.none

                        UploadError _ ->
                            Cmd.none
            in
                ( newModel, cmd )

        ImageUploaded (Result.Err err) ->
            let
                _ =
                    Debug.log "AddNew.State ImageUploaded Error" err

                newModel =
                    { model | imageUploadStatus = UploadError err }
            in
                ( newModel, Cmd.none )

        ImageUploaded (Result.Ok urlPath) ->
            let
                newModel =
                    { model
                        | fields = Dict.insert "Logo" urlPath model.fields
                        , imageUploadStatus = Uploaded urlPath
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
