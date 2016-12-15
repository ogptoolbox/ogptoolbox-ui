module Authenticator.SignIn.Types exposing (..)

import Dict exposing (Dict)
import Http
import Types exposing (UserBody)


type alias Errors =
    Dict String String


type alias Fields =
    { password : String
    , username : String
    }


type alias Model =
    { httpError : Maybe Http.Error
    , errors : Errors
    , password : String
    , username : String
    }


type Msg
    = SignedIn (Result Http.Error UserBody)
    | Submit
    | UsernameInput String
    | PasswordInput String
