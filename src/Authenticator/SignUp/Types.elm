module Authenticator.SignUp.Types exposing (..)

import Authenticator.Routes exposing (Route)
import Dict exposing (Dict)
import Http
import Types exposing (User, UserBody)


type alias Authentication =
    User


type alias Errors =
    Dict String String


type ExternalMsg
    = ChangeRoute Route
    | Navigate String
    | Terminated (Result () (Maybe Authentication))


type InternalMsg
    = Cancel
    | EmailInput String
    | Submit
    | UserCreated (Result Http.Error UserBody)
    | UsernameInput String
    | PasswordInput String


type alias Model =
    { email : String
    , errors : Errors
    , httpError : Maybe Http.Error
    , password : String
    , username : String
    }


type Msg
    = ForParent ExternalMsg
    | ForSelf InternalMsg


type alias MsgTranslation parentMsg =
    { onChangeRoute : Route -> parentMsg
    , onInternalMsg : InternalMsg -> parentMsg
    , onNavigate : String -> parentMsg
    , onTerminated : Result () (Maybe Authentication) -> parentMsg
    }


type alias MsgTranslator parentMsg =
    Msg -> parentMsg


translateMsg : MsgTranslation parentMsg -> MsgTranslator parentMsg
translateMsg { onChangeRoute, onInternalMsg, onNavigate, onTerminated } msg =
    case msg of
        ForParent (ChangeRoute route) ->
            onChangeRoute route

        ForSelf internalMsg ->
            onInternalMsg internalMsg

        ForParent (Navigate path) ->
            onNavigate path

        ForParent (Terminated result) ->
            onTerminated result
