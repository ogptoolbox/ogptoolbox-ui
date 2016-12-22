module Authenticator.Types exposing (..)

import Authenticator.Activate.Types
import Authenticator.ChangePassword.Types
import Authenticator.ResetPassword.Types
import Authenticator.Routes exposing (Route)
import Authenticator.SignIn.Types
import Authenticator.SignOut.Types
import Authenticator.SignUp.Types
import Types exposing (User)


type alias Authentication =
    User


type ExternalMsg
    = ChangeRoute (Maybe Route)
    | Navigate String
    | PasswordChanged


type InternalMsg
    = ActivateDone Authentication
    | ActivateMsg Authenticator.Activate.Types.InternalMsg
    | ChangePasswordDone Authentication
    | ChangePasswordMsg Authenticator.ChangePassword.Types.InternalMsg
    | ResetPasswordMsg Authenticator.ResetPassword.Types.InternalMsg
    | SignInMsg Authenticator.SignIn.Types.InternalMsg
    | SignOutMsg Authenticator.SignOut.Types.Msg
    | SignUpMsg Authenticator.SignUp.Types.InternalMsg


type alias Model =
    { activate : Authenticator.Activate.Types.Model
    , authentication : Maybe Authentication
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
    { onChangeRoute : Maybe Route -> parentMsg
    , onInternalMsg : InternalMsg -> parentMsg
    , onNavigate : String -> parentMsg
    , onPasswordChanged : parentMsg
    }


type alias MsgTranslator parentMsg =
    Msg -> parentMsg


navigate : String -> Msg
navigate path =
    ForParent (Navigate path)


sendActivationMsg : Authentication -> InternalMsg
sendActivationMsg authentication =
    ActivateMsg <| Authenticator.Activate.Types.SendActivation authentication


signOutMsg : InternalMsg
signOutMsg =
    SignOutMsg Authenticator.SignOut.Types.Submit


translateActivateMsg : Authenticator.Activate.Types.MsgTranslator Msg
translateActivateMsg =
    Authenticator.Activate.Types.translateMsg
        { onActivate = ForSelf << ActivateDone
        , onInternalMsg = ForSelf << ActivateMsg
        }


translateChangePasswordMsg : Authenticator.ChangePassword.Types.MsgTranslator Msg
translateChangePasswordMsg =
    Authenticator.ChangePassword.Types.translateMsg
        { onInternalMsg = ForSelf << ChangePasswordMsg
        , onPasswordChanged = ForSelf << ChangePasswordDone
        }


translateMsg : MsgTranslation parentMsg -> MsgTranslator parentMsg
translateMsg { onChangeRoute, onInternalMsg, onNavigate, onPasswordChanged } msg =
    case msg of
        ForParent (ChangeRoute route) ->
            onChangeRoute route

        ForParent (Navigate path) ->
            onNavigate path

        ForParent PasswordChanged ->
            onPasswordChanged

        ForSelf internalMsg ->
            onInternalMsg internalMsg


translateResetPasswordMsg : Authenticator.ResetPassword.Types.MsgTranslator Msg
translateResetPasswordMsg =
    Authenticator.ResetPassword.Types.translateMsg
        { onChangeRoute = ForParent << ChangeRoute
        , onInternalMsg = ForSelf << ResetPasswordMsg
        }


translateSignInMsg : Authenticator.SignIn.Types.MsgTranslator Msg
translateSignInMsg =
    Authenticator.SignIn.Types.translateMsg
        { onChangeRoute = ForParent << ChangeRoute
        , onInternalMsg = ForSelf << SignInMsg
        , onNavigate = ForParent << Navigate
        }


translateSignUpMsg : Authenticator.SignUp.Types.MsgTranslator Msg
translateSignUpMsg =
    Authenticator.SignUp.Types.translateMsg
        { onChangeRoute = ForParent << ChangeRoute
        , onInternalMsg = ForSelf << SignUpMsg
        , onNavigate = ForParent << Navigate
        }
