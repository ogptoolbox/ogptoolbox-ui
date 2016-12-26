module Authenticator.Types exposing (..)

import Authenticator.Activate.Types
import Authenticator.ChangePassword.Types
import Authenticator.ResetPassword.Types
import Authenticator.Routes exposing (..)
import Authenticator.SignIn.Types
import Authenticator.SignOut.Types
import Authenticator.SignUp.Types
import Types exposing (User)


type alias Authentication =
    User


type ExternalMsg
    = ChangeRoute Route
    | Navigate String
    | Terminated Route (Result () (Maybe Authentication))


type InternalMsg
    = ActivateMsg Authenticator.Activate.Types.InternalMsg
    | ChangePasswordMsg Authenticator.ChangePassword.Types.InternalMsg
    | ResetPasswordMsg Authenticator.ResetPassword.Types.InternalMsg
    | SignInMsg Authenticator.SignIn.Types.InternalMsg
    | SignOutMsg Authenticator.SignOut.Types.InternalMsg
    | SignUpMsg Authenticator.SignUp.Types.InternalMsg


type alias Model =
    { activate : Authenticator.Activate.Types.Model
    , changePassword : Authenticator.ChangePassword.Types.Model
    , resetPassword : Authenticator.ResetPassword.Types.Model
    , signIn : Authenticator.SignIn.Types.Model
    , signOut : Authenticator.SignOut.Types.Model
    , signUp : Authenticator.SignUp.Types.Model
    }


type Msg
    = ForParent ExternalMsg
    | ForSelf InternalMsg


type alias MsgTranslation parentMsg =
    { onChangeRoute : Route -> parentMsg
    , onInternalMsg : InternalMsg -> parentMsg
    , onNavigate : String -> parentMsg
    , onTerminated : Route -> Result () (Maybe Authentication) -> parentMsg
    }


type alias MsgTranslator parentMsg =
    Msg -> parentMsg


sendActivationMsg : Authentication -> InternalMsg
sendActivationMsg authentication =
    ActivateMsg <| Authenticator.Activate.Types.SendActivation authentication


signOutMsg : InternalMsg
signOutMsg =
    SignOutMsg Authenticator.SignOut.Types.Submit


translateActivateMsg : Authenticator.Activate.Types.MsgTranslator Msg
translateActivateMsg =
    Authenticator.Activate.Types.translateMsg
        { onInternalMsg = ForSelf << ActivateMsg
        , onTerminated = ForParent << (Terminated (ActivateRoute "dummy"))
        }


translateChangePasswordMsg : Authenticator.ChangePassword.Types.MsgTranslator Msg
translateChangePasswordMsg =
    Authenticator.ChangePassword.Types.translateMsg
        { onInternalMsg = ForSelf << ChangePasswordMsg
        , onTerminated = ForParent << (Terminated (ChangePasswordRoute "dummy"))
        }


translateMsg : MsgTranslation parentMsg -> MsgTranslator parentMsg
translateMsg { onChangeRoute, onInternalMsg, onNavigate, onTerminated } msg =
    case msg of
        ForParent (ChangeRoute route) ->
            onChangeRoute route

        ForParent (Navigate path) ->
            onNavigate path

        ForParent (Terminated route result) ->
            onTerminated route result

        ForSelf internalMsg ->
            onInternalMsg internalMsg


translateResetPasswordMsg : Authenticator.ResetPassword.Types.MsgTranslator Msg
translateResetPasswordMsg =
    Authenticator.ResetPassword.Types.translateMsg
        { onChangeRoute = ForParent << ChangeRoute
        , onInternalMsg = ForSelf << ResetPasswordMsg
        , onTerminated = ForParent << (Terminated ResetPasswordRoute)
        }


translateSignInMsg : Authenticator.SignIn.Types.MsgTranslator Msg
translateSignInMsg =
    Authenticator.SignIn.Types.translateMsg
        { onChangeRoute = ForParent << ChangeRoute
        , onInternalMsg = ForSelf << SignInMsg
        , onNavigate = ForParent << Navigate
        , onTerminated = ForParent << (Terminated SignInRoute)
        }


translateSignOutMsg : Authenticator.SignOut.Types.MsgTranslator Msg
translateSignOutMsg =
    Authenticator.SignOut.Types.translateMsg
        { onChangeRoute = ForParent << ChangeRoute
        , onInternalMsg = ForSelf << SignOutMsg
        , onNavigate = ForParent << Navigate
        , onTerminated = ForParent << (Terminated SignOutRoute)
        }


translateSignUpMsg : Authenticator.SignUp.Types.MsgTranslator Msg
translateSignUpMsg =
    Authenticator.SignUp.Types.translateMsg
        { onChangeRoute = ForParent << ChangeRoute
        , onInternalMsg = ForSelf << SignUpMsg
        , onNavigate = ForParent << Navigate
        , onTerminated = ForParent << (Terminated SignUpRoute)
        }
