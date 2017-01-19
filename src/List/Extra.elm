module List.Extra exposing (..)

{-| Return all elements of the list except the last one.
    init [1,2,3] == Just [1,2]
    init [] == Nothing

    Function taken from https://github.com/elm-community/list-extra, because it was not yet ported to Elm 0.18.
-}


init : List a -> Maybe (List a)
init =
    let
        maybe : b -> (List a -> b) -> Maybe (List a) -> b
        maybe d f =
            Maybe.withDefault d << Maybe.map f
    in
        List.foldr (\x -> maybe [] ((::) x) >> Just) Nothing
