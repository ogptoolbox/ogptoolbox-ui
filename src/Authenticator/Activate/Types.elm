module Authenticator.Activate.Types exposing (..)

import Http
import Types exposing (User, UserBody)
import WebData exposing (WebData)


type alias Authentication =
    User


type ExternalMsg
    = Activate Authentication


type InternalMsg
    = ActivateUser String String
    | ActivationSent (Result Http.Error UserBody)
    | SendActivation Authentication
    | UserActivated (Result Http.Error UserBody)


type alias Model =
    WebData Authentication


type Msg
    = ForParent ExternalMsg
    | ForSelf InternalMsg


type alias MsgTranslation parentMsg =
    { onActivate : Authentication -> parentMsg
    , onInternalMsg : InternalMsg -> parentMsg
    }


type alias MsgTranslator parentMsg =
    Msg -> parentMsg


translateMsg : MsgTranslation parentMsg -> MsgTranslator parentMsg
translateMsg { onInternalMsg, onActivate } msg =
    case msg of
        ForParent (Activate authentication) ->
            onActivate authentication

        ForSelf internalMsg ->
            onInternalMsg internalMsg
