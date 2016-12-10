module Authenticator.Types exposing (..)

import Authenticator.ResetPassword as ResetPassword
import Authenticator.SignIn as SignIn
import Authenticator.SignOut as SignOut
import Authenticator.SignUp as SignUp


type ExternalMsg
    = Navigate String


type InternalMsg
    = ResetPasswordMsg ResetPassword.Msg
    | SignInMsg SignIn.Msg
    | SignOutMsg SignOut.Msg
    | SignUpMsg SignUp.Msg


type Msg
    = ForParent ExternalMsg
    | ForSelf InternalMsg


type alias MsgTranslation parentMsg =
    { onInternalMsg : InternalMsg -> parentMsg
    , onNavigate : String -> parentMsg
    }


type alias MsgTranslator parentMsg =
    Msg -> parentMsg


navigate : String -> Msg
navigate path =
    ForParent (Navigate path)


signOutMsg : InternalMsg
signOutMsg =
    SignOutMsg SignOut.Submit


translateMsg : MsgTranslation parentMsg -> MsgTranslator parentMsg
translateMsg { onInternalMsg, onNavigate } msg =
    case msg of
        ForParent (Navigate path) ->
            onNavigate path

        ForSelf internalMsg ->
            onInternalMsg internalMsg
