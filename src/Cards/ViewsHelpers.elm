module Cards.ViewsHelpers exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Aria exposing (..)
import Html.Events exposing (..)
import Html.Helpers exposing (aForPath)
import I18n
import Json.Decode
import Tags.ViewsHelpers exposing (..)
import Types exposing (..)
import Urls


viewCardThumbnail :
    I18n.Language
    -> (String -> msg)
    -> Maybe (String -> msg)
    -> String
    -> DataProxy a
    -> Card
    -> Html msg
viewCardThumbnail language navigate onRemoveCard extraClass data card =
    let
        name =
            I18n.getName language card data.values

        path =
            Urls.pathForCard card

        cardType =
            getCardType card
    in
        div [ class "col-xs-12 col-sm-6 col-md-4 col-lg-3" ]
            [ let
                ( element, elementAttributes ) =
                    case onRemoveCard of
                        Just onRemoveCard ->
                            ( a
                            , [ href <| Urls.languagePath language path
                              , target "_blank"
                              ]
                            )

                        Nothing ->
                            ( aForPath
                                navigate
                                language
                                path
                            , []
                            )
              in
                element
                    ([ class ("thumbnail " ++ extraClass) ] ++ elementAttributes)
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
                    , case onRemoveCard of
                        Just onRemoveCard ->
                            div [ class "text-center" ]
                                [ button
                                    [ class "btn btn-danger btn-xs"
                                    , onWithOptions "click"
                                        { preventDefault = True, stopPropagation = False }
                                        (Json.Decode.succeed (onRemoveCard card.id))
                                    , type_ "button"
                                    ]
                                    [ span [ class "glyphicon glyphicon-remove", ariaHidden True ] []
                                    , text " "
                                    , text <| I18n.translate language I18n.Remove
                                    ]
                                ]

                        Nothing ->
                            text ""
                    ]
            ]


viewCardsThumbnailsPanel :
    I18n.Language
    -> (String -> msg)
    -> Maybe (String -> msg)
    -> I18n.TranslationId
    -> DataProxy a
    -> List Card
    -> Html msg
viewCardsThumbnailsPanel language navigate onRemoveCard titleI18n data cards =
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
                    (viewCardThumbnail language navigate onRemoveCard "tool grey" data)
                    cards
                )
            ]
        ]
