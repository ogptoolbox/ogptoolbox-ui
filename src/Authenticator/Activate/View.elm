module Authenticator.Activate.View exposing (..)

import Authenticator.Activate.Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Aria exposing (..)
import Http exposing (Error(BadStatus))
import I18n
import Views exposing (getHttpErrorAsString)
import WebData exposing (..)


view : I18n.Language -> Model -> Html msg
view language model =
    let
        alert =
            case model of
                NotAsked ->
                    div
                        [ class "alert alert-warning"
                        , role "alert"
                        ]
                        [ strong [] [ text <| I18n.translate language I18n.ActivationNotRequested ] ]

                Failure httpError ->
                    div
                        [ class "alert alert-danger"
                        , role "alert"
                        ]
                        [ strong []
                            [ text <|
                                I18n.translate language I18n.ActivationFailed
                                    ++ I18n.translate language I18n.Colon
                            ]
                        , text
                            (case httpError of
                                BadStatus response ->
                                    if response.status.code == 400 then
                                        I18n.translate language I18n.BadAuthorization
                                    else if response.status.code == 404 then
                                        I18n.translate language I18n.UnknownUser
                                    else
                                        getHttpErrorAsString language httpError

                                _ ->
                                    getHttpErrorAsString language httpError
                            )
                        ]

                Data loadingStatus ->
                    case loadingStatus of
                        Loading _ ->
                            div
                                [ class "alert alert-info"
                                , role "alert"
                                ]
                                [ strong [] [ text <| I18n.translate language I18n.ActivationInProgress ] ]

                        Loaded _ ->
                            div
                                [ class "alert alert-success"
                                , role "alert"
                                ]
                                [ strong [] [ text <| I18n.translate language I18n.ActivationSucceeded ] ]
    in
        div []
            [ header []
                [ div [ class "container" ]
                    [ div [ class "intro-text" ]
                        [ div [ class "intro-heading" ]
                            [ text (I18n.translate language I18n.ActivationTitle) ]

                        ]
                    ]
                ]
            , alert
            ]


viewModalBody : I18n.Language -> Model -> Html Msg
viewModalBody language model =
    div [ class "modal-body" ]
        [ view language model ]
