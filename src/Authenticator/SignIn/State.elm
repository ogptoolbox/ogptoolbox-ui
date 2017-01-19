module Authenticator.SignIn.State exposing (..)

import Authenticator.SignIn.Types exposing (..)
import Configuration exposing (apiUrl)
import Decoders
import Dict exposing (Dict)
import Http
import Json.Encode
import Task


init : Model
init =
    { email = ""
    , errors = Dict.empty
    , httpError = Nothing
    , password = ""
    }


update : InternalMsg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Cancel ->
            ( { model | httpError = Nothing }
            , Task.perform (\_ -> ForParent (Terminated (Err ()))) (Task.succeed ())
            )

        EmailInput text ->
            ( { model | email = text }, Cmd.none )

        PasswordInput text ->
            ( { model | password = text }, Cmd.none )

        SignedIn (Err httpError) ->
            ( { model | httpError = Just httpError }, Cmd.none )

        SignedIn (Ok body) ->
            ( { model | httpError = Nothing }
            , Task.perform (\_ -> ForParent (Terminated (Ok <| Just body.data))) (Task.succeed ())
            )

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
                        ]
                    )

                cmd =
                    if List.isEmpty errorsList then
                        let
                            bodyJson =
                                Json.Encode.object
                                    [ ( "userName", Json.Encode.string model.email )
                                    , ( "password", Json.Encode.string model.password )
                                    ]
                        in
                            Http.post
                                (apiUrl ++ "login")
                                (Http.stringBody "application/json" <| Json.Encode.encode 2 bodyJson)
                                Decoders.userBodyDecoder
                                |> Http.send (ForSelf << SignedIn)
                    else
                        Cmd.none
            in
                ( { model | errors = Dict.fromList errorsList }, cmd )
