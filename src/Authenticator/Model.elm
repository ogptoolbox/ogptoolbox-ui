module Authenticator.Model exposing (..)

import Authenticator.SignIn as SignIn
import Authenticator.SignOut as SignOut
import Authenticator.SignUp as SignUp
import Types exposing (User)


type alias Authentication =
    User


type alias Model =
    { authentication : Maybe Authentication
    , signIn : SignIn.Model
    , signOut : SignOut.Model
    , signUp : SignUp.Model
    }


type Route
    = SignInRoute
    | SignOutRoute
    | SignUpRoute


init : Model
init =
    { authentication = Nothing
    , signIn = SignIn.init
    , signOut = SignOut.init
    , signUp = SignUp.init
    }
