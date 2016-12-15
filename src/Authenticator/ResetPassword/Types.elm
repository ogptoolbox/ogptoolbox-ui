module Authenticator.ResetPassword.Types exposing (..)

import Dict exposing (Dict)
import Http


type alias Errors =
    Dict String String


type alias Model =
    { errors : Errors
    , email : String
    }


type Msg
    = PasswordReset (Result Http.Error String)
    | Submit
    | UsernameInput String
