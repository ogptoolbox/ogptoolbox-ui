module Authenticator.ChangePassword.State exposing (..)

import Authenticator.ChangePassword.Types exposing (..)
import Dict exposing (Dict)
import Http
import I18n
import Ports
import Requests
import Task


init : String -> String -> Model
init userId authorization =
    { authorization = authorization
    , errors = Dict.empty
    , password = ""
    , userId = userId
    }


update : InternalMsg -> Model -> I18n.Language -> ( Model, Cmd Msg )
update msg model language =
    case msg of
        PasswordReset response ->
            case response of
                Result.Err err ->
                    let
                        _ =
                            Debug.log "Authenticator.PasswordChanged Error" err
                    in
                        ( model, Cmd.none )

                Result.Ok body ->
                    let
                        user =
                            body.data

                        cmds =
                            [ Ports.storeAuthentication (Ports.userToUserForPort (Just user))
                            , ForParent (PasswordChanged user)
                                |> (\msg -> Task.perform (\_ -> msg) (Task.succeed ()))
                            ]
                    in
                        model ! cmds

        PasswordInput text ->
            ( { model | password = text }, Cmd.none )

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
                        [ ( "password"
                          , if String.isEmpty model.password then
                                Just "Missing password"
                            else
                                Nothing
                          )
                        ]
                    )

                cmd =
                    if List.isEmpty errorsList then
                        Requests.resetPassword model.userId model.authorization model.password
                            |> Http.send (ForSelf << PasswordReset)
                    else
                        Cmd.none
            in
                ( { model | errors = Dict.fromList errorsList }, cmd )
