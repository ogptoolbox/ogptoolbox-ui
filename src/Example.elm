module Example exposing (..)

import Html exposing (..)
import Tool.View
import Types exposing (Statement)
import WebData exposing (LoadingStatus)


view : Bool -> LoadingStatus Statement -> Maybe (Html a)
view =
    -- TODO Use real Example.view, when designer gives the mockup.
    Tool.View.root
