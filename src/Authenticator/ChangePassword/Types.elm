module Authenticator.ChangePassword.Types exposing (..)

import Dict exposing (Dict)
import Http
import Types exposing (User, UserBody)


type alias Authentication =
    User


type ExternalMsg
    = Terminated (Result () (Maybe Authentication))


type InternalMsg
    = Cancel
    | PasswordInput String
    | PasswordReset (Result Http.Error UserBody)
    | Submit


type alias Errors =
    Dict String String


type alias Model =
    { authorization : String
    , errors : Errors
    , httpError : Maybe Http.Error
    , password : String
    , userId : String
    }


type Msg
    = ForParent ExternalMsg
    | ForSelf InternalMsg


type alias MsgTranslation parentMsg =
    { onInternalMsg : InternalMsg -> parentMsg
    , onTerminated : Result () (Maybe Authentication) -> parentMsg
    }


type alias MsgTranslator parentMsg =
    Msg -> parentMsg


translateMsg : MsgTranslation parentMsg -> MsgTranslator parentMsg
translateMsg { onInternalMsg, onTerminated } msg =
    case msg of
        ForParent (Terminated result) ->
            onTerminated result

        ForSelf internalMsg ->
            onInternalMsg internalMsg
