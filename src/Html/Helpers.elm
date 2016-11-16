module Html.Helpers exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onWithOptions)
import Json.Decode
import Routes exposing (makeUrl)


aExternal : List (Attribute msg) -> List (Html msg) -> Html msg
aExternal attributes children =
    a
        ([ rel "external"
         , target "_blank"
         ]
            ++ attributes
        )
        children


aForPath : (String -> msg) -> String -> List (Attribute msg) -> List (Html msg) -> Html msg
aForPath navigate path attributes children =
    a
        ([ href (makeUrl path)
         , onWithOptions
            "click"
            { stopPropagation = True, preventDefault = True }
            (Json.Decode.succeed (navigate path))
         ]
            ++ attributes
        )
        children
