module Organization exposing (..)

import Html exposing (..)
import Tool.View
import Types exposing (Statement)
import WebData exposing (LoadingStatus)


view : Bool -> LoadingStatus Statement -> Maybe (Html a)
view =
    -- TODO Use real Organization.view, from the designer mockup.
    Tool.View.root
