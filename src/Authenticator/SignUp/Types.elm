module Authenticator.SignUp.Types exposing (..)

import Authenticator.Routes exposing (Route)
import Dict exposing (Dict)
import Http
import Types exposing (UserBody)


type alias Errors =
    Dict String String


type ExternalMsg
    = ChangeRoute (Maybe Route)
    | Navigate String


type InternalMsg
    = EmailInput String
    | Submit
    | UserCreated (Result Http.Error UserBody)
    | UsernameInput String
    | PasswordInput String


type alias Model =
    { email : String
    , errors : Errors
    , password : String
    , username : String
    }


type Msg
    = ForParent ExternalMsg
    | ForSelf InternalMsg


type alias MsgTranslation parentMsg =
    { onChangeRoute : Maybe Route -> parentMsg
    , onInternalMsg : InternalMsg -> parentMsg
    , onNavigate : String -> parentMsg
    }


type alias MsgTranslator parentMsg =
    Msg -> parentMsg


translateMsg : MsgTranslation parentMsg -> MsgTranslator parentMsg
translateMsg { onChangeRoute, onInternalMsg, onNavigate } msg =
    case msg of
        ForParent (ChangeRoute route) ->
            onChangeRoute route

        ForSelf internalMsg ->
            onInternalMsg internalMsg

        ForParent (Navigate path) ->
            onNavigate path
