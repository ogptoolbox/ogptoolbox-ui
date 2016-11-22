module Example exposing (..)

import Html exposing (..)
import Tool.View
import Types exposing (..)
import WebData exposing (..)


view : LoadingStatus DataIdBody -> List (Html a)
view =
    -- TODO Use real Example.view, when designer gives the mockup.
    Tool.View.root
