module Authenticator.SignIn exposing (Model, init, Msg, update, view)

-- import Converters exposing (Converter)
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Aria exposing (..)
import Html.Events exposing (..)
import Http
import Json.Encode
import String
import Task
import Types exposing (decodeUserBody, User, UserBody)


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
                                ( Http.fromJson decodeUserBody ( Http.send Http.defaultSettings
                                    { verb = "POST"
                                    , url = "http://localhost:3000/login"
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


view : Model -> Html Msg
view model =
    Html.form [ onSubmit Submit ]
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
                                , type' "password"
                                , value model.password
                                , onInput PasswordInput
                                ]
                                []
                            ]
        , button
            [ class "btn btn-primary", type' "submit" ]
            [ text "Sign In" ]
        ]
