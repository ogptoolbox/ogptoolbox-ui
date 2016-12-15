module Authenticator.Types exposing (..)

import Authenticator.ResetPassword.Types
import Authenticator.SignIn.Types
import Authenticator.SignOut.Types
import Authenticator.SignUp.Types


type ExternalMsg
    = AuthenticatorRouteMsg (Maybe Route)
    | Navigate String


type InternalMsg
    = ResetPasswordMsg Authenticator.ResetPassword.Types.Msg
    | SignInMsg Authenticator.SignIn.Types.Msg
    | SignOutMsg Authenticator.SignOut.Types.Msg
    | SignUpMsg Authenticator.SignUp.Types.Msg


type Msg
    = ForParent ExternalMsg
    | ForSelf InternalMsg


type alias MsgTranslation parentMsg =
    { onAuthenticatorRouteMsg : Maybe Route -> parentMsg
    , onInternalMsg : InternalMsg -> parentMsg
    , onNavigate : String -> parentMsg
    }


type alias MsgTranslator parentMsg =
    Msg -> parentMsg


type Route
    = ResetPasswordRoute
    | SignInRoute
    | SignOutRoute
    | SignUpRoute


navigate : String -> Msg
navigate path =
    ForParent (Navigate path)


signOutMsg : InternalMsg
signOutMsg =
    SignOutMsg Authenticator.SignOut.Types.Submit


translateMsg : MsgTranslation parentMsg -> MsgTranslator parentMsg
translateMsg { onAuthenticatorRouteMsg, onInternalMsg, onNavigate } msg =
    case msg of
        ForParent (AuthenticatorRouteMsg route) ->
            onAuthenticatorRouteMsg route

        ForParent (Navigate path) ->
            onNavigate path

        ForSelf internalMsg ->
            onInternalMsg internalMsg
