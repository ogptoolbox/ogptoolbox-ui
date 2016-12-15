module Authenticator.SignUp.Types exposing (..)

import Dict exposing (Dict)
import Http
import Types exposing (UserBody)


type alias Errors =
    Dict String String


type alias Model =
    { errors : Errors
    , email : String
    , password : String
    , username : String
    }


type Msg
    = EmailInput String
    | Submit
    | UserCreated (Result Http.Error UserBody)
    | UsernameInput String
    | PasswordInput String
