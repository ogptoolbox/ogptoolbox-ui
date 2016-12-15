module Authenticator.Types exposing (..)

import Authenticator.ResetPassword.Types
import Authenticator.Routes exposing (Route)
import Authenticator.SignIn.Types
import Authenticator.SignOut.Types
import Authenticator.SignUp.Types


type ExternalMsg
    = ChangeRoute (Maybe Route)
    | Navigate String


type InternalMsg
    = ResetPasswordMsg Authenticator.ResetPassword.Types.Msg
    | SignInMsg Authenticator.SignIn.Types.InternalMsg
    | SignOutMsg Authenticator.SignOut.Types.Msg
    | SignUpMsg Authenticator.SignUp.Types.Msg


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


navigate : String -> Msg
navigate path =
    ForParent (Navigate path)


signOutMsg : InternalMsg
signOutMsg =
    SignOutMsg Authenticator.SignOut.Types.Submit


translateMsg : MsgTranslation parentMsg -> MsgTranslator parentMsg
translateMsg { onChangeRoute, onInternalMsg, onNavigate } msg =
    case msg of
        ForParent (ChangeRoute route) ->
            onChangeRoute route

        ForParent (Navigate path) ->
            onNavigate path

        ForSelf internalMsg ->
            onInternalMsg internalMsg


translateSignInMsg : Authenticator.SignIn.Types.MsgTranslator Msg
translateSignInMsg =
    Authenticator.SignIn.Types.translateMsg
        { onChangeRoute = ForParent << ChangeRoute
        , onInternalMsg = ForSelf << SignInMsg
        }
