module Authenticator.ResetPassword.Types exposing (..)

import Authenticator.Routes exposing (Route)
import Dict exposing (Dict)
import Http


type alias Errors =
    Dict String String


type ExternalMsg
    = ChangeRoute (Maybe Route)


type InternalMsg
    = EmailInput String
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
    { onInternalMsg : InternalMsg -> parentMsg
    , onChangeRoute : Maybe Route -> parentMsg
    }


type alias MsgTranslator parentMsg =
    Msg -> parentMsg


translateMsg : MsgTranslation parentMsg -> MsgTranslator parentMsg
translateMsg { onChangeRoute, onInternalMsg } msg =
    case msg of
        ForParent (ChangeRoute route) ->
            onChangeRoute route

        ForSelf internalMsg ->
            onInternalMsg internalMsg
