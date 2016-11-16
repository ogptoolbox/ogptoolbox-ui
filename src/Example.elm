module Example exposing (..)

import Html exposing (..)
import Tool
import Types exposing (Statement)
import WebData exposing (LoadingStatus)


view : LoadingStatus Statement -> Maybe (Html msg)
view =
    -- TODO Use real Example.view, when designer gives the mockup.
    Tool.view
