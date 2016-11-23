module Organization exposing (..)

import Html exposing (..)
import Tool.View
import Types exposing (..)
import WebData exposing (..)


view : (String -> msg) -> LoadingStatus DataIdBody -> Html msg
view =
    -- TODO Use real Organization.view, when designer gives the mockup.
    Tool.View.root
