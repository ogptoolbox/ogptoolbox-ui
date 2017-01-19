module About exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import I18n


view : I18n.Language -> Html msg
view language =
    div []
        [ header []
            [ div [ class "container" ]
                [ div [ class "intro-text" ]
                    [ div [ class "intro-heading" ]
                        [ text (I18n.translate language (I18n.About)) ]
                    , div [ class "intro-lead-in" ]
                        [ text (I18n.translate language (I18n.AboutLead)) ]
                    ]
                ]
            ]
        , section [ id "mentions" ]
            [ div [ class "container" ]
                [ div [ class "row" ]
                    [ div [ class "col-lg-12 text-center" ]
                        [ h2 [ class "section-heading" ]
                            [ text (I18n.translate language (I18n.AboutLegal)) ]
                        ]
                    ]
                , div [ class "row" ]
                    [ div [ class "col-md-12 text-center" ]
                        [ p []
                            [ text (I18n.translate language (I18n.AboutLegalContent)) ]
                        ]
                    ]
                ]
            ]
        , section [ id "mentions" ]
            [ div [ class "container" ]
                [ div [ class "row" ]
                    [ div [ class "col-lg-12 text-center" ]
                        [ h2 [ class "section-heading" ]
                            [ text (I18n.translate language (I18n.AboutCredits)) ]
                        ]
                    ]
                , div [ class "row" ]
                    [ div [ class "col-md-12 text-center" ]
                        [ p []
                            [ text (I18n.translate language (I18n.AboutCreditsContent))
                            , a [ href "https://github.com/WengerK/d3bubbles", target "_blank" ]
                                [ text "D3bubbles de Kevin Wenger." ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
