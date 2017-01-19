module Authenticator.SignIn.Types exposing (..)

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
    | SignedIn (Result Http.Error UserBody)
    | Submit
    | PasswordInput String


type alias Model =
    { email : String
    , errors : Errors
    , httpError : Maybe Http.Error
    , password : String
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

        ForParent (Navigate path) ->
            onNavigate path

        ForParent (Terminated result) ->
            onTerminated result

        ForSelf internalMsg ->
            onInternalMsg internalMsg
