module Authenticator.SignOut.Types exposing (..)

import Authenticator.Routes exposing (Route)
import Types exposing (User)


type alias Authentication =
    User


type ExternalMsg
    = ChangeRoute Route
    | Navigate String
    | Terminated (Result () (Maybe Authentication))


type alias Model =
    {}


type InternalMsg
    = Cancel
    | Submit


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
