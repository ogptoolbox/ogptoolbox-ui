module Html.Helpers exposing (..)

import Configuration exposing (apiUrl)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onWithOptions)
import Json.Decode
import Regex
import Routes exposing (makeUrl)
import String
import Types exposing (..)


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


imgForCard : List (Attribute msg) -> String -> Card -> Html msg
imgForCard attributes dim card =
    img
        ([ alt "Logo"
         , src
            (case getOneString imageUrlPathKeys card of
                Just urlPath ->
                    apiUrl
                        ++ (if String.startsWith "/" urlPath then
                                String.dropLeft 1 urlPath
                            else
                                urlPath
                           )
                        ++ "?dim="
                        ++ dim

                Nothing ->
                    "TODO"
            )
         ]
            ++ attributes
        )
        []
