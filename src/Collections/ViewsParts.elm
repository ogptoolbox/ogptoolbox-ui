module Collections.ViewsParts exposing (..)

import Cards.ViewsParts exposing (..)
import Html exposing (Html)
import I18n
import Types exposing (..)


viewToolsThumbnailsPanel : I18n.Language -> (String -> msg) -> DataProxy a -> List String -> Html msg
viewToolsThumbnailsPanel language navigate data cardIds =
    viewCardsThumbnailsPanel
        language
        navigate
        (I18n.Tool I18n.Plural)
        data
        (cardIds
            |> List.filterMap
                (\cardId ->
                    let
                        card =
                            getCard data.cards cardId
                    in
                        if cardSubTypeIdsIntersect card.subTypeIds cardTypesForTool then
                            Just card
                        else
                            Nothing
                )
        )
