module Authenticator.SignIn exposing (..)

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
    { password : String
    , username : String
    }


type alias Model =
    { errors : Errors
    , password : String
    , username : String
    }


init : Model
init =
    { errors = Dict.empty
    , password = ""
    , username = ""
    }


-- UPDATE


type Msg
    = Error Http.Error
    | Submit
    | Success UserBody
    | UsernameInput String
    | PasswordInput String


update : Msg -> Model -> ( Model, Cmd Msg, Maybe User )
update msg model =
    case msg of
        Error err ->
            let
                _ = Debug.log "Sign In Error" err
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
                                [ ("userName", Json.Encode.string model.username)
                                , ("password", Json.Encode.string model.password)
                                ]
                        in
                            Task.perform
                                Error
                                Success
                                ( Http.fromJson userBodyDecoder ( Http.send Http.defaultSettings
                                    { verb = "POST"
                                    , url = apiUrl ++ "login"
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
                                            [ label [ class "control-label", for "username" ] [ text "Email" ]
                                            , input
                                                [ ariaDescribedby "username-error"
                                                , class "form-control"
                                                , id "username"
                                                , placeholder "john.doe@ogptoolbox.org"
                                                , required True
                                                , title "Please enter you email"
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
                                            [ label [ class "control-label", for "username" ] [ text "Email" ]
                                            , input
                                                [ class "form-control"
                                                , id "username"
                                                , placeholder "john.doe@ogptoolbox.org"
                                                , required True
                                                , title "Please enter you email"
                                                , type' "text"
                                                , value model.username
                                                , onInput UsernameInput
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
                                                , placeholder "John Doe"
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
                                                , placeholder "Your secret password"
                                                , required True
                                                , title "Please enter you password"
                                                , type' "password"
                                                , value model.password
                                                , onInput PasswordInput
                                                ]
                                                []
                                            ]
                        -- , div [ class "alert alert-error hide", id "loginErrorMsg" ]
                        --     [ text "Wrong username og password" ]
                        -- , div [ class "checkbox" ]
                        --     [ label []
                        --         [ input [ id "remember", name "remember", type' "checkbox" ]
                        --             []
                        --         , text "Remember login                                  "
                        --         ]
                        --     ]
                        , button
                            [ class "btn btn-block btn-default grey", type' "submit" ]
                            [ text "Sign In" ]
                        ]
                    ]
                ]
            , div [ class "col-xs-6" ]
                [ div [ class "well well-right" ]
                    [ p [ class "lead" ]
                        [ text "Create your account now" ]
                    , ul [ class "list-unstyled", attribute "style" "line-height: 2" ]
                        [ li []
                            [ span [ class "fa fa-check text-success" ]
                                []
                            , text "Improve existing content"
                            ]
                        , li []
                            [ span [ class "fa fa-check text-success" ]
                                []
                            , text "Vote the best contributions"
                            ]
                        , li []
                            [ span [ class "fa fa-check text-success" ]
                                []
                            , text "Add a new tool or usage"
                            ]
                        , li []
                            [ span [ class "fa fa-check text-success" ]
                                []
                            , text "Create a page for your organization "
                            ]
                        , li []
                            [ a [ href "/read-more/" ]
                                [ u []
                                    [ text "Read more" ]
                                ]
                            ]
                        ]
                    , p []
                        [ a [ class "btn btn-block btn-default ", href "/new-customer/" ]
                            [ text "Register now!" ]
                        ]
                    ]
                ]
            ]
        ]
