module Html.Helpers exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onWithOptions)
import Json.Decode
import Regex
import Routes exposing (makeUrl, makeUrlWithLanguage)


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
aForPath navigate urlPath attributes children =
    a
        ([ href (makeUrl urlPath)
         , onWithOptions
            "click"
            { stopPropagation = True, preventDefault = True }
            (Json.Decode.succeed (navigate urlPath))
         ]
            ++ attributes
        )
        children


aIfIsUrl : List (Attribute msg) -> String -> Html msg
aIfIsUrl attributes s =
    let
        -- Adapted from https://github.com/etaque/elm-form/blob/349c0da619b59da36b1274c4232f78d5ceaddeba/src/Form/Validate.elm#L400-L403
        validUrlPattern =
            Regex.regex "^https?://([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\w \\.-]*)*/?"
                |> Regex.caseInsensitive
    in
        if Regex.contains validUrlPattern s then
            aExternal ([ href s ] ++ attributes) [ text s ]
        else
            text s
