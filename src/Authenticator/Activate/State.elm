module Authenticator.Activate.State exposing (..)

import Authenticator.Activate.Types exposing (..)
import Http
import I18n
import Ports
import Requests
import Task
import Urls
import WebData exposing (..)


init : Model
init =
    NotAsked


update : InternalMsg -> Model -> I18n.Language -> ( Model, Cmd Msg )
update msg model language =
    case msg of
        ActivateUser userId authorization ->
            let
                newModel =
                    Data (Loading (getData model))

                cmd =
                    Requests.activateUser userId authorization
                        |> Http.send (ForSelf << UserActivated)
            in
                ( newModel, cmd )

        ActivationSent response ->
            case response of
                Result.Err err ->
                    let
                        _ =
                            Debug.log "Authenticator.ActivationSent Error" err
                    in
                        ( model, Cmd.none )

                Result.Ok body ->
                    ( model, Cmd.none )

        SendActivation authentication ->
            let
                cmd =
                    Requests.sendActivation authentication
                        |> Http.send (ForSelf << ActivationSent)
            in
                ( model, cmd )

        UserActivated response ->
            case response of
                Result.Err err ->
                    let
                        _ =
                            Debug.log "Authenticator.UserActivated Error" err
                    in
                        ( Failure err, Cmd.none )

                Result.Ok body ->
                    let
                        user =
                            body.data

                        cmds =
                            [ Ports.setDocumentMetadata
                                { description = I18n.translate language I18n.ActivationDescription
                                , imageUrl = Urls.appLogoFullUrl
                                , title = I18n.translate language I18n.ActivationTitle
                                }
                            , Ports.storeAuthentication (Ports.userToUserForPort (Just user))
                            , ForParent (Activate user)
                                |> (\msg -> Task.perform (\_ -> msg) (Task.succeed ()))
                            ]
                    in
                        Data (Loaded user) ! cmds
