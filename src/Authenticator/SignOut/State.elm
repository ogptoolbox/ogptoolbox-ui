module Authenticator.SignOut.State exposing (..)

import Authenticator.SignOut.Types exposing (..)
import Ports


init : Model
init =
    {}


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Submit ->
            ( model, Ports.storeAuthentication Nothing )
