module Collections.ViewsHelpers exposing (..)

import Cards.ViewsHelpers exposing (..)
import Html exposing (Html)
import I18n
import Types exposing (..)


viewToolsThumbnailsPanel :
    I18n.Language
    -> (String -> msg)
    -> Maybe (String -> msg)
    -> DataProxy a
    -> List String
    -> Html msg
viewToolsThumbnailsPanel language navigate onRemoveCard data cardIds =
    viewCardsThumbnailsPanel
        language
        navigate
        onRemoveCard
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


viewUseCasesThumbnailsPanel :
    I18n.Language
    -> (String -> msg)
    -> Maybe (String -> msg)
    -> DataProxy a
    -> List String
    -> Html msg
viewUseCasesThumbnailsPanel language navigate onRemoveCard data cardIds =
    viewCardsThumbnailsPanel
        language
        navigate
        onRemoveCard
        (I18n.UseCase I18n.Plural)
        data
        (cardIds
            |> List.filterMap
                (\cardId ->
                    let
                        card =
                            getCard data.cards cardId
                    in
                        if cardSubTypeIdsIntersect card.subTypeIds cardTypesForUseCase then
                            Just card
                        else
                            Nothing
                )
        )
