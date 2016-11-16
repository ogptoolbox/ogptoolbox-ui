module Maybe.Helpers exposing (..)


toList : Maybe a -> List a
toList maybe =
    case maybe of
        Nothing ->
            []

        Just x ->
            [ x ]
