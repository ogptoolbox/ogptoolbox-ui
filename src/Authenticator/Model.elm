module Authenticator.Model exposing (..)

import Authenticator.ResetPassword as ResetPassword
import Authenticator.SignIn as SignIn
import Authenticator.SignOut as SignOut
import Authenticator.SignUp as SignUp
import Types exposing (User)


type alias Authentication =
    User


type alias Model =
    { authentication : Maybe Authentication
    , resetPassword : ResetPassword.Model
    , signIn : SignIn.Model
    , signOut : SignOut.Model
    , signUp : SignUp.Model
    }


type Route
    = ResetPasswordRoute
    | SignInRoute
    | SignOutRoute
    | SignUpRoute


init : Model
init =
    { authentication = Nothing
    , resetPassword = ResetPassword.init
    , signIn = SignIn.init
    , signOut = SignOut.init
    , signUp = SignUp.init
    }
