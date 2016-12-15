module Authenticator.ResetPassword.View exposing (..)

import Authenticator.ResetPassword.Types exposing (..)
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Aria exposing (..)
import Html.Events exposing (..)
import I18n


viewModalBody : I18n.Language -> Model -> Html Msg
viewModalBody language model =
    div [ class "modal-body" ]
        [ div [ class "row" ]
            [ div [ class "col-xs-6" ]
                [ div [ class "well" ]
                    [ Html.form [ onSubmit Submit ]
                        [ let
                            errorMaybe =
                                Dict.get "email" model.errors
                          in
                            case errorMaybe of
                                Just error ->
                                    div [ class "form-group has-error" ]
                                        [ label
                                            [ class "control-label", for "email" ]
                                            [ text (I18n.translate language I18n.Email) ]
                                        , input
                                            [ ariaDescribedby "email-error"
                                            , class "form-control"
                                            , id "email"
                                            , placeholder "john.doe@ogptoolbox.org"
                                            , required True
                                            , title (I18n.translate language I18n.EnterEmail)
                                            , type_ "text"
                                            , value model.email
                                            , onInput UsernameInput
                                            ]
                                            []
                                        , span
                                            [ class "help-block"
                                            , id "email-error"
                                            ]
                                            [ text error ]
                                        ]

                                Nothing ->
                                    div [ class "form-group" ]
                                        [ label
                                            [ class "control-label", for "email" ]
                                            [ text (I18n.translate language I18n.Email) ]
                                        , input
                                            [ class "form-control"
                                            , id "email"
                                            , placeholder "john.doe@ogptoolbox.org"
                                            , required True
                                            , title (I18n.translate language I18n.EnterEmail)
                                            , type_ "text"
                                            , value model.email
                                            , onInput UsernameInput
                                            ]
                                            []
                                        ]
                        , button
                            [ class "btn btn-block btn-default grey", type_ "submit" ]
                            [ text "Reset Password" ]
                        ]
                    ]
                ]
            , div [ class "col-xs-6" ]
                [ div [ class "well well-right" ]
                    [ p [ class "lead" ]
                        [ text "Password Lost?" ]
                    , ul [ class "list-unstyled", attribute "style" "line-height: 2" ]
                        [ li []
                            [ span [ class "fa fa-check text-success" ]
                                []
                            , text "Send an email to verify your account."
                            ]
                        ]
                    ]
                ]
            ]
        ]
