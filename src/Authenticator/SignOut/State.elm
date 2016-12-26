module Authenticator.SignOut.State exposing (..)

import Authenticator.SignOut.Types exposing (..)
import Task


init : Model
init =
    {}


update : InternalMsg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Cancel ->
            ( model
            , Task.perform (\_ -> ForParent (Terminated (Err ()))) (Task.succeed ())
            )

        Submit ->
            ( model
            , Task.perform (\_ -> ForParent (Terminated (Ok Nothing))) (Task.succeed ())
            )
