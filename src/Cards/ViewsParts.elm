module Cards.ViewsParts exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Helpers exposing (aForPath)
import I18n
import Tags.ViewsParts exposing (..)
import Types exposing (..)
import Urls


viewCardThumbnail : I18n.Language -> (String -> msg) -> String -> DataProxy a -> Card -> Html msg
viewCardThumbnail language navigate extraClass data card =
    let
        name =
            I18n.getName language card data.values

        path =
            Urls.pathForCard card

        cardType =
            getCardType card
    in
        div [ class "col-xs-12 col-sm-6 col-md-4 col-lg-3" ]
            [ aForPath
                navigate
                language
                path
                [ class ("thumbnail " ++ extraClass) ]
                [ div [ class "visual" ]
                    [ case Urls.imageFullUrl language "500" card data.values of
                        Just url ->
                            img [ alt "logo", src url ] []

                        Nothing ->
                            h1 [ class "dynamic" ]
                                [ text
                                    (case cardType of
                                        OrganizationCard ->
                                            String.left 1 name

                                        ToolCard ->
                                            String.left 2 name

                                        UseCaseCard ->
                                            name
                                    )
                                ]
                    ]
                , div [ class "caption" ]
                    [ h4 []
                        [ text name ]
                    , case I18n.getOneString language descriptionKeys card data.values of
                        Just description ->
                            p [] [ text description ]

                        Nothing ->
                            p
                                [ class "call" ]
                                [ text (I18n.translate language (I18n.CallToActionForDescription cardType)) ]
                    ]
                , viewTagsWithCallToAction navigate language data.values card
                ]
            ]


viewCardsThumbnailsPanel : I18n.Language -> (String -> msg) -> I18n.TranslationId -> DataProxy a -> List Card -> Html msg
viewCardsThumbnailsPanel language navigate titleI18n data cards =
    div [ class "panel panel-default" ]
        [ div [ class "row" ]
            [ div [ class "col-xs-8 text-left" ]
                [ h4 [ class "zone-label" ]
                    [ text (I18n.translate language titleI18n) ]
                ]
              -- , div [ class "col-xs-4 text-right up7" ]
              --     [ a [ class "btn btn-default btn-xs btn-action", href "compare.html", type' "button" ]
              --         [ text (I18n.translate language I18n.Compare) ]
              --     ]
            ]
        , div [ class "panel-body" ]
            [ div [ class "row" ]
                (List.map
                    (viewCardThumbnail language navigate "tool grey" data)
                    cards
                )
            ]
        ]
