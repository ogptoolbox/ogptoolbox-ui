module Authenticator.ResetPassword exposing (..)

import Configuration exposing (apiUrl)
import Decoders exposing (userBodyDecoder)
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Aria exposing (..)
import Html.Events exposing (..)
import Http
import Json.Encode
import String
import Task
import Types exposing (User, UserBody)


-- MODEL


type alias Errors =
    Dict String String


type alias Fields =
    { email : String
    }


type alias Model =
    { errors : Errors
    , email : String
    }


init : Model
init =
    { errors = Dict.empty
    , email = ""
    }



-- UPDATE


type Msg
    = Error Http.Error
    | Submit
    | Success String
    | UsernameInput String


update : Msg -> Model -> ( Model, Cmd Msg, Maybe User )
update msg model =
    case msg of
        Error err ->
            let
                _ =
                    Debug.log "Authenticator.ResetPassword Error" err
            in
                ( model, Cmd.none, Nothing )

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
                            Task.perform
                                Error
                                Success
                                (Http.fromJson Decoders.messageBodyDecoder
                                    (Http.send Http.defaultSettings
                                        { verb = "POST"
                                        , url = apiUrl ++ "users/reset-password"
                                        , headers =
                                            [ ( "Accept", "application/json" )
                                            , ( "Content-Type", "application/json" )
                                            ]
                                        , body = Http.string (Json.Encode.encode 2 bodyJson)
                                        }
                                    )
                                )
                    else
                        Cmd.none
            in
                ( { model | errors = Dict.fromList errorsList }, cmd, Nothing )

        Success message ->
            let
                cmd =
                    Cmd.none

                -- authenticatorRouteMsg Nothing
                --     |> (\msg -> Task.perform (\_ -> Debug.crash "") (\_ -> msg) (Task.succeed ()))
            in
                ( model, cmd, Nothing )

        UsernameInput text ->
            ( { model | email = text }, Cmd.none, Nothing )



-- VIEW


viewModalBody : Model -> Html Msg
viewModalBody model =
    div [ class "modal-body" ]
        [ div [ class "row" ]
            [ div [ class "col-xs-6" ]
                [ div [ class "well" ]
                    [ Html.form [ onSubmit Submit ]
                        [ let
                            errorMaybe =
                                Dict.get "email" model.errors
                          in
                            case errorMaybe of
                                Just error ->
                                    div [ class "form-group has-error" ]
                                        [ label [ class "control-label", for "email" ] [ text "Email" ]
                                        , input
                                            [ ariaDescribedby "email-error"
                                            , class "form-control"
                                            , id "email"
                                            , placeholder "john.doe@ogptoolbox.org"
                                            , required True
                                            , title "Please enter you email"
                                            , type' "text"
                                            , value model.email
                                            , onInput UsernameInput
                                            ]
                                            []
                                        , span
                                            [ class "help-block"
                                            , id "email-error"
                                            ]
                                            [ text error ]
                                        ]

                                Nothing ->
                                    div [ class "form-group" ]
                                        [ label [ class "control-label", for "email" ] [ text "Email" ]
                                        , input
                                            [ class "form-control"
                                            , id "email"
                                            , placeholder "john.doe@ogptoolbox.org"
                                            , required True
                                            , title "Please enter you email"
                                            , type' "text"
                                            , value model.email
                                            , onInput UsernameInput
                                            ]
                                            []
                                        ]
                        , button
                            [ class "btn btn-block btn-default grey", type' "submit" ]
                            [ text "Reset Password" ]
                        ]
                    ]
                ]
            , div [ class "col-xs-6" ]
                [ div [ class "well well-right" ]
                    [ p [ class "lead" ]
                        [ text "Password Lost?" ]
                    , ul [ class "list-unstyled", attribute "style" "line-height: 2" ]
                        [ li []
                            [ span [ class "fa fa-check text-success" ]
                                []
                            , text "Send an email to verify your account."
                            ]
                        ]
                    ]
                ]
            ]
        ]
