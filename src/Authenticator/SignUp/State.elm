module Authenticator.SignUp.State exposing (..)

import Authenticator.SignUp.Types exposing (..)
import Configuration exposing (apiUrl)
import Decoders
import Dict exposing (Dict)
import Http
import Json.Encode
import Ports
import Types exposing (User)


init : Model
init =
    { email = ""
    , errors = Dict.empty
    , password = ""
    , username = ""
    }


update : InternalMsg -> Model -> ( Model, Cmd Msg, Maybe User )
update msg model =
    case msg of
        EmailInput text ->
            ( { model | email = text }, Cmd.none, Nothing )

        PasswordInput text ->
            ( { model | password = text }, Cmd.none, Nothing )

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
                        , ( "password"
                          , if String.isEmpty model.password then
                                Just "Missing password"
                            else
                                Nothing
                          )
                        , ( "username"
                          , if String.isEmpty model.username then
                                Just "Missing username"
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
                                    , ( "name", Json.Encode.string model.username )
                                    , ( "urlName", Json.Encode.string model.username )
                                    , ( "password", Json.Encode.string model.password )
                                    ]
                        in
                            Http.post
                                (apiUrl ++ "users")
                                (Http.stringBody "application/json" <| Json.Encode.encode 2 bodyJson)
                                Decoders.userBodyDecoder
                                |> Http.send (ForSelf << UserCreated)
                    else
                        Cmd.none
            in
                ( { model | errors = Dict.fromList errorsList }, cmd, Nothing )

        UserCreated response ->
            case response of
                Result.Err err ->
                    let
                        _ =
                            Debug.log "Authenticator.UserCreated Error" err
                    in
                        ( model, Cmd.none, Nothing )

                Result.Ok body ->
                    let
                        user =
                            Just body.data
                    in
                        ( model, Ports.storeAuthentication (Ports.userToUserForPort user), user )

        UsernameInput text ->
            ( { model | username = text }, Cmd.none, Nothing )
