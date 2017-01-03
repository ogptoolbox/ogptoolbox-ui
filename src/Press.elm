module Press exposing (..)

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
                        [ text (I18n.translate language (I18n.Press)) ]
                    , div [ class "intro-lead-in" ]
                        [ text (I18n.translate language (I18n.PressLead)) ]
                    ]
                ]
            ]
        ]
