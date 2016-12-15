module Authenticator.ResetPassword.State exposing (..)

import Authenticator.ResetPassword.Types exposing (..)
import Configuration exposing (apiUrl)
import Decoders
import Dict exposing (Dict)
import Http
import Json.Encode
import Types exposing (User)


init : Model
init =
    { errors = Dict.empty
    , email = ""
    }


update : Msg -> Model -> ( Model, Cmd Msg, Maybe User )
update msg model =
    case msg of
        PasswordReset response ->
            case response of
                Result.Err err ->
                    let
                        _ =
                            Debug.log "Authenticator.PasswordReset Error" err
                    in
                        ( model, Cmd.none, Nothing )

                Result.Ok message ->
                    let
                        cmd =
                            Cmd.none

                        -- authenticatorRouteMsg Nothing
                        --     |> (\msg -> Task.perform (\_ -> Debug.crash "") (\_ -> msg) (Task.succeed ()))
                    in
                        ( model, cmd, Nothing )

        Submit ->
            let
                errorsList =
                    (List.filterMap
                        (\( name, errorMaybe ) ->
                            case errorMaybe of
                                Just error ->
                                    Just ( name, error )

                                Nothing ->
                                    Nothing
                        )
                        [ ( "email"
                          , if String.isEmpty model.email then
                                Just "Missing email"
                            else
                                Nothing
                          )
                        ]
                    )

                cmd =
                    if List.isEmpty errorsList then
                        let
                            bodyJson =
                                Json.Encode.object
                                    [ ( "email", Json.Encode.string model.email )
                                    ]
                        in
                            Http.post
                                (apiUrl ++ "users/reset-password")
                                (Http.stringBody "application/json" <| Json.Encode.encode 2 bodyJson)
                                Decoders.messageBodyDecoder
                                |> Http.send PasswordReset
                    else
                        Cmd.none
            in
                ( { model | errors = Dict.fromList errorsList }, cmd, Nothing )

        UsernameInput text ->
            ( { model | email = text }, Cmd.none, Nothing )
