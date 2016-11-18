module Authenticator.SignUp exposing (..)

import Configuration exposing (apiUrl)
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Aria exposing (..)
import Html.Events exposing (..)
import Http
import Json.Encode
import String
import Task
import Types exposing (userBodyDecoder, User, UserBody)


-- MODEL


type alias Errors = Dict String String


type alias Fields =
    { email : String
    , password : String
    , username : String
    }


type alias Model =
    { errors : Errors
    , email : String
    , password : String
    , username : String
    }


init : Model
init =
    { errors = Dict.empty
    , email = ""
    , password = ""
    , username = ""
    }


-- UPDATE


type Msg
    = EmailInput String
    | Error Http.Error
    | Submit
    | Success UserBody
    | UsernameInput String
    | PasswordInput String


update : Msg -> Model -> ( Model, Cmd Msg, Maybe User )
update msg model =
    case msg of
        EmailInput text ->
            ({ model | email = text }, Cmd.none, Nothing)

        Error err ->
            let
                _ = Debug.log "Sign Up Error" err
            in
                ( model, Cmd.none, Nothing )

        PasswordInput text ->
            ({ model | password = text }, Cmd.none, Nothing)

        Submit ->
            let
                errorsList = ( List.filterMap (
                    \(name, errorMaybe) ->
                        case errorMaybe of
                            Just error ->
                                Just (name, error)
                            Nothing ->
                                Nothing
                    )
                    [
                        ( "email"
                        , if String.isEmpty model.email then Just "Missing email" else Nothing
                        )
                    ,
                        ( "password"
                        , if String.isEmpty model.password then Just "Missing password" else Nothing
                        )
                    ,
                        ( "username"
                        , if String.isEmpty model.username then Just "Missing username" else Nothing
                        )
                    ] )

                cmd =
                    if List.isEmpty errorsList then
                        let
                            bodyJson = Json.Encode.object
                                [ ("email", Json.Encode.string model.email)
                                , ("name", Json.Encode.string model.username)
                                , ("urlName", Json.Encode.string model.username)
                                , ("password", Json.Encode.string model.password)
                                ]
                        in
                            Task.perform
                                Error
                                Success
                                ( Http.fromJson userBodyDecoder ( Http.send Http.defaultSettings
                                    { verb = "POST"
                                    , url = apiUrl ++ "users"
                                    , headers =
                                        [ ("Accept", "application/json")
                                        , ("Content-Type", "application/json")
                                        ]
                                    , body = Http.string ( Json.Encode.encode 2 bodyJson )
                                    } ) )
                    else
                        Cmd.none
            in
                ( { model | errors = Dict.fromList errorsList }, cmd, Nothing )

        Success body ->
            let
                user = body.data
            in
                ( model, Cmd.none, Just user )

        UsernameInput text ->
            ({ model | username = text }, Cmd.none, Nothing)


-- VIEW


viewModalBody : Model -> Html Msg
viewModalBody model =
    div [ class "modal-body" ]
        [ div [ class "row" ]
            [ div [ class "col-xs-6" ]
                [ div [ class "well" ]
                    [ Html.form [ onSubmit Submit ]
                        [
                            let
                                errorMaybe = Dict.get "username" model.errors
                            in
                                case errorMaybe of
                                    Just error ->
                                        div [ class "form-group has-error"]
                                            [ label [ class "control-label", for "username" ] [ text "Username" ]
                                            , input
                                                [ ariaDescribedby "username-error"
                                                , class "form-control"
                                                , id "username"
                                                , placeholder "John Doe"
                                                , required True
                                                , title "Please enter you username"
                                                , type' "text"
                                                , value model.username
                                                , onInput UsernameInput
                                                ]
                                                []
                                            , span
                                                [ class "help-block"
                                                , id "username-error"
                                                ]
                                                [ text error ]
                                            ]
                                    Nothing ->
                                        div [ class "form-group"]
                                            [ label [ class "control-label", for "username" ] [ text "Username" ]
                                            , input
                                                [ class "form-control"
                                                , id "username"
                                                , placeholder "John Doe"
                                                , required True
                                                , title "Please enter you username"
                                                , type' "text"
                                                , value model.username
                                                , onInput UsernameInput
                                                ]
                                                []
                                            ]
                        ,
                            let
                                errorMaybe = Dict.get "email" model.errors
                            in
                                case errorMaybe of
                                    Just error ->
                                        div [ class "form-group has-error"]
                                            [ label [ class "control-label", for "email" ] [ text "Email" ]
                                            , input
                                                [ ariaDescribedby "email-error"
                                                , class "form-control"
                                                , id "email"
                                                , placeholder "john.doe@ogptoolbox.org"
                                                , required True
                                                , title "Please enter you email"
                                                , type' "email"
                                                , value model.email
                                                , onInput EmailInput
                                                ]
                                                []
                                            , span
                                                [ class "help-block"
                                                , id "email-error"
                                                ]
                                                [ text error ]
                                            ]
                                    Nothing ->
                                        div [ class "form-group"]
                                            [ label [ class "control-label", for "email" ] [ text "Email" ]
                                            , input
                                                [ class "form-control"
                                                , id "email"
                                                , placeholder "john.doe@ogptoolbox.org"
                                                , required True
                                                , title "Please enter you email"
                                                , type' "email"
                                                , value model.email
                                                , onInput EmailInput
                                                ]
                                                []
                                            ]
                        ,
                            let
                                errorMaybe = Dict.get "password" model.errors
                            in
                                case errorMaybe of
                                    Just error ->
                                        div [ class "form-group has-error"]
                                            [ label [ class "control-label", for "password" ] [ text "Password" ]
                                            , input
                                                [ ariaDescribedby "password-error"
                                                , class "form-control"
                                                , id "password"
                                                , placeholder "Your secret password"
                                                , required True
                                                , title "Please enter you password"
                                                , type' "password"
                                                , value model.password
                                                , onInput PasswordInput
                                                ]
                                                []
                                            , span
                                                [ class "help-block"
                                                , id "password-error"
                                                ]
                                                [ text error ]
                                            ]
                                    Nothing ->
                                        div [ class "form-group"]
                                            [ label [ class "control-label", for "password" ] [ text "Password" ]
                                            , input
                                                [ class "form-control"
                                                , id "password"
                                                , placeholder "John Doe"
                                                , required True
                                                , title "Please enter you password"
                                                , type' "password"
                                                , value model.password
                                                , onInput PasswordInput
                                                ]
                                                []
                                            ]
                        , button
                            [ class "btn btn-primary", type' "submit" ]
                            [ text "Sign Up" ]
                        ]
                    ]
                ]
            ]
        ]
