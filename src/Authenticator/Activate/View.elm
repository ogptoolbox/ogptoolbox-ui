module Authenticator.Activate.View exposing (..)

import Authenticator.Activate.Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import I18n
import WebData exposing (..)


view : I18n.Language -> Model -> Html msg
view language model =
    let
        i18nMessage =
            case model of
                NotAsked ->
                    I18n.ActivationNotRequested

                Failure _ ->
                    I18n.ActivationFailed

                Data loadingStatus ->
                    case loadingStatus of
                        Loading _ ->
                            I18n.ActivationInProgress

                        Loaded _ ->
                            I18n.ActivationSucceeded
    in
        div []
            [ header []
                [ div [ class "container" ]
                    [ div [ class "intro-text" ]
                        [ div [ class "intro-heading" ]
                            [ text (I18n.translate language I18n.ActivationTitle) ]
                        , div [ class "intro-lead-in" ]
                            [ text (I18n.translate language i18nMessage) ]
                        ]
                    ]
                ]
            ]
