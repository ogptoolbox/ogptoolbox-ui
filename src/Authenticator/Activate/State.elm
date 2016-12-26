module Authenticator.Activate.State exposing (..)

import Authenticator.Activate.Types exposing (..)
import Http
import I18n
import Requests
import Task
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

        UserActivated (Err httpError) ->
            ( Failure httpError
            , Task.perform (\_ -> ForParent (Terminated (Err ()))) (Task.succeed ())
            )

        UserActivated (Ok body) ->
            ( Data (Loaded body.data)
            , Task.perform (\_ -> ForParent (Terminated (Ok <| Just body.data))) (Task.succeed ())
            )
