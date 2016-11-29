module Example exposing (..)

import Html exposing (..)
import I18n
import Tool.View
import Types exposing (..)
import WebData exposing (..)


view : (String -> msg) -> I18n.Language -> LoadingStatus DataIdBody -> Html msg
view =
    -- TODO Use real Example.view, when designer gives the mockup.
    Tool.View.root
