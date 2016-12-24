module Main exposing (..)

import Navigation
import Root.State
import Root.Types
import Root.View
import Types exposing (..)


main : Program Flags Root.Types.Model Root.Types.Msg
main =
    Navigation.programWithFlags Root.Types.LocationChanged
        { init = Root.State.init
        , update = Root.State.update
        , view = Root.View.view
        , subscriptions = Root.State.subscriptions
        }
