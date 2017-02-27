module About exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import I18n
import I18nHtml


view : I18n.Language -> Html msg
view language =
    div []
        [ header []
            [ div [ class "container" ]
                [ div [ class "intro-text" ]
                    [ div [ class "intro-heading" ]
                        [ text (I18n.translate language I18n.TheProject) ]
                    ]
                ]
            ]
        , section []
            [ div [ class "container" ]
                [ div [ class "row" ]
                    [ I18nHtml.translate language I18nHtml.TheProjectPresentationParagraphs
                    ]
                ]
            ]
        ]
