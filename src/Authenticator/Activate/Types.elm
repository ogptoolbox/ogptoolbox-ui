module Authenticator.Activate.Types exposing (..)

import Http
import Types exposing (User, UserBody)
import WebData exposing (WebData)


type alias Authentication =
    User


type ExternalMsg
    = Terminated (Result () (Maybe Authentication))


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
    { onInternalMsg : InternalMsg -> parentMsg
    , onTerminated : Result () (Maybe Authentication) -> parentMsg
    }


type alias MsgTranslator parentMsg =
    Msg -> parentMsg


translateMsg : MsgTranslation parentMsg -> MsgTranslator parentMsg
translateMsg { onInternalMsg, onTerminated } msg =
    case msg of
        ForSelf internalMsg ->
            onInternalMsg internalMsg

        ForParent (Terminated result) ->
            onTerminated result
