module Authenticator.ResetPassword.Types exposing (..)

import Authenticator.Routes exposing (Route)
import Dict exposing (Dict)
import Http
import Types exposing (User)


type alias Authentication =
    User


type alias Errors =
    Dict String String


type ExternalMsg
    = ChangeRoute Route
    | Terminated (Result () (Maybe Authentication))


type InternalMsg
    = Cancel
    | EmailInput String
    | PasswordReset (Result Http.Error String)
    | Submit


type alias Model =
    { errors : Errors
    , email : String
    , httpError : Maybe Http.Error
    }


type Msg
    = ForParent ExternalMsg
    | ForSelf InternalMsg


type alias MsgTranslation parentMsg =
    { onChangeRoute : Route -> parentMsg
    , onInternalMsg : InternalMsg -> parentMsg
    , onTerminated : Result () (Maybe Authentication) -> parentMsg
    }


type alias MsgTranslator parentMsg =
    Msg -> parentMsg


translateMsg : MsgTranslation parentMsg -> MsgTranslator parentMsg
translateMsg { onChangeRoute, onInternalMsg, onTerminated } msg =
    case msg of
        ForParent (ChangeRoute route) ->
            onChangeRoute route

        ForParent (Terminated result) ->
            onTerminated result

        ForSelf internalMsg ->
            onInternalMsg internalMsg
