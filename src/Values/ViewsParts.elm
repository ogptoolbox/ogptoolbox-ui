module Values.ViewsParts exposing (..)

import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Helpers exposing (aForPath, aIfIsUrl)
import I18n
import Types exposing (..)
import Urls
import Values.Item.Types exposing (..)


viewCardIdLine : I18n.Language -> Maybe (String -> msg) -> DataProxy a -> String -> Html msg
viewCardIdLine language navigate data cardId =
    case Dict.get cardId data.cards of
        Just card ->
            viewCardLine language navigate data card

        Nothing ->
            i [ class "text-warning" ] [ text ("Missing card with ID: " ++ cardId) ]


viewCardLine : I18n.Language -> Maybe (String -> msg) -> DataProxy a -> Card -> Html msg
viewCardLine language navigate data card =
    let
        cardName =
            I18n.getOneString language nameKeys card data.values
                |> Maybe.withDefault card.id
    in
        case navigate of
            Just navigate ->
                aForPath navigate language (Urls.pathForCard card) [] [ text cardName ]

            Nothing ->
                text cardName


viewValueIdLine : I18n.Language -> Maybe (String -> msg) -> DataProxy a -> Bool -> String -> Html msg
viewValueIdLine language navigate data showDetails valueId =
    case Dict.get valueId data.values of
        Just typedValue ->
            viewValueTypeLine language navigate data showDetails typedValue.value

        Nothing ->
            i [ class "text-warning" ] [ text ("Missing value with ID: " ++ valueId) ]


viewValueTypeLine : I18n.Language -> Maybe (String -> msg) -> DataProxy a -> Bool -> ValueType -> Html msg
viewValueTypeLine language navigate data showDetails valueType =
    if showDetails then
        div []
            [ i [] [ text (valueTypeToTypeLabel language valueType) ]
            , text (I18n.translate language I18n.Colon)
            , viewValueTypeLineContent language navigate data showDetails valueType
            ]
    else
        viewValueTypeLineContent language navigate data showDetails valueType


viewValueTypeLineContent : I18n.Language -> Maybe (String -> msg) -> DataProxy a -> Bool -> ValueType -> Html msg
viewValueTypeLineContent language navigate data showDetails valueType =
    case valueType of
        BijectiveCardReferenceValue { targetId } ->
            viewCardIdLine language navigate data targetId

        BooleanValue bool ->
            text (toString bool)

        CardIdArrayValue childValues ->
            ul []
                (List.map
                    (\childValue ->
                        li
                            []
                            [ viewValueTypeLine language navigate data showDetails (CardIdValue childValue) ]
                    )
                    childValues
                )

        CardIdValue cardId ->
            viewCardIdLine language navigate data cardId

        EmailValue str ->
            aIfIsUrl [] str

        ImagePathValue path ->
            figure
                [ class "figure text-xs-center" ]
                [ img
                    [ alt <| I18n.translate language I18n.ImageAlt
                    , class "figure-img img-fluid rounded"
                    , src (Urls.fullApiUrl path ++ "?dim=96")
                    , style [ ( "max-width", "96px" ) ]
                    ]
                    []
                , figcaption [ class "figure-caption" ] [ text path ]
                ]

        LocalizedStringValue values ->
            let
                viewString languageCode string =
                    if showDetails || Dict.size values > 1 then
                        [ dt [] [ text languageCode ]
                        , dd [] [ aIfIsUrl [] string ]
                        ]
                    else
                        [ aIfIsUrl [] string ]
            in
                dl []
                    (values
                        |> Dict.toList
                        |> List.concatMap (\( languageCode, childValue ) -> viewString languageCode childValue)
                    )

        NumberValue float ->
            text (toString float)

        StringValue str ->
            aIfIsUrl [] str

        UrlValue str ->
            aIfIsUrl [] str

        ValueIdArrayValue childValues ->
            ul []
                (List.map
                    (\childValue ->
                        li
                            []
                            [ viewValueTypeLine language navigate data showDetails (ValueIdValue childValue) ]
                    )
                    childValues
                )

        ValueIdValue valueId ->
            case Dict.get valueId data.values of
                Just subValue ->
                    viewValueTypeLine language navigate data showDetails subValue.value

                Nothing ->
                    text ("Error: referenced value not found for valueId: " ++ valueId)

        WrongValue str schemaId ->
            div []
                [ p [ style [ ( "color", "red" ) ] ] [ text "Wrong value!" ]
                , pre [] [ text str ]
                , p [] [ text ("schemaId: " ++ schemaId) ]
                ]
