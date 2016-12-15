module Authenticator.Model exposing (..)

import Authenticator.ResetPassword.State
import Authenticator.ResetPassword.Types
import Authenticator.SignIn.State
import Authenticator.SignIn.Types
import Authenticator.SignOut.State
import Authenticator.SignOut.Types
import Authenticator.SignUp.State
import Authenticator.SignUp.Types
import Types exposing (User)


type alias Authentication =
    User


type alias Model =
    { authentication : Maybe Authentication
    , resetPassword : Authenticator.ResetPassword.Types.Model
    , signIn : Authenticator.SignIn.Types.Model
    , signOut : Authenticator.SignOut.Types.Model
    , signUp : Authenticator.SignUp.Types.Model
    }


init : Model
init =
    { authentication = Nothing
    , resetPassword = Authenticator.ResetPassword.State.init
    , signIn = Authenticator.SignIn.State.init
    , signOut = Authenticator.SignOut.State.init
    , signUp = Authenticator.SignUp.State.init
    }
