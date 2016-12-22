module Authenticator.ChangePassword.View exposing (..)

import Authenticator.ChangePassword.Types exposing (..)
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Aria exposing (..)
import Html.Events exposing (..)
import I18n


view : I18n.Language -> Model -> Html Msg
view language model =
    div []
        [ header []
            [ div [ class "container" ]
                [ div [ class "intro-text" ]
                    [ div [ class "intro-heading" ]
                        -- [ text (I18n.translate language I18n.ChangePassword) ]
                        [ div [ class "intro-lead-in" ]
                            [ text (I18n.translate language I18n.ChangePassword) ]
                        ]
                    ]
                ]
            ]
        , div [ class "row" ]
            [ div [ class "col-xs-12" ]
                [ div [ class "well" ]
                    [ Html.form [ onSubmit (ForSelf <| Submit) ]
                        [ let
                            errorMaybe =
                                Dict.get "password" model.errors
                          in
                            case errorMaybe of
                                Just error ->
                                    div [ class "form-group has-error" ]
                                        [ p []
                                            [ text (I18n.translate language I18n.ChangePasswordExplanation) ]
                                        , label
                                            [ class "control-label", for "password" ]
                                            [ text (I18n.translate language I18n.Password) ]
                                        , input
                                            [ ariaDescribedby "password-error"
                                            , class "form-control"
                                            , id "password"
                                            , placeholder (I18n.translate language I18n.PasswordPlaceholder)
                                            , required True
                                            , title (I18n.translate language I18n.EnterPassword)
                                            , type_ "password"
                                            , value model.password
                                            , onInput (ForSelf << PasswordInput)
                                            ]
                                            []
                                        , span
                                            [ class "help-block"
                                            , id "password-error"
                                            ]
                                            [ text error ]
                                        ]

                                Nothing ->
                                    div [ class "form-group" ]
                                        [ p []
                                            [ text (I18n.translate language I18n.ChangePasswordExplanation) ]
                                        , label
                                            [ class "control-label", for "password" ]
                                            [ text (I18n.translate language I18n.Password) ]
                                        , input
                                            [ class "form-control"
                                            , id "password"
                                            , placeholder (I18n.translate language I18n.PasswordPlaceholder)
                                            , required True
                                            , title (I18n.translate language I18n.EnterPassword)
                                            , type_ "password"
                                            , value model.password
                                            , onInput (ForSelf << PasswordInput)
                                            ]
                                            []
                                        ]
                        , button
                            [ class "btn btn-block btn-default grey", type_ "submit" ]
                            [ text (I18n.translate language I18n.Save) ]
                        ]
                    ]
                ]
            ]
        ]
