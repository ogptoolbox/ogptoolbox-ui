module Authenticator.SignUp.View exposing (..)

import Authenticator.SignUp.Types exposing (..)
import Authenticator.ViewsParts exposing (..)
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Helpers exposing (..)
import I18n


viewModalBody : I18n.Language -> Model -> Html Msg
viewModalBody language model =
    div [ class "modal-body" ]
        [ div [ class "row" ]
            [ div [ class "col-xs-7" ]
                [ div [ class "well" ]
                    [ Html.form []
                        [ viewUsernameField
                            (ForSelf << UsernameInput)
                            language
                            (Dict.get "username" model.errors)
                            model.username
                        , viewEmailField
                            (ForSelf << EmailInput)
                            language
                            (Dict.get "email" model.errors)
                            model.email
                        , viewPasswordField
                            (ForSelf << PasswordInput)
                            language
                            (Dict.get "password" model.errors)
                            model.password
                        , button
                            [ class "btn btn-block btn-default grey"
                            , onClick (ForSelf <| Submit)
                            , type_ "submit"
                            ]
                            [ text (I18n.translate language I18n.Register) ]
                        ]
                    ]
                ]
            , div [ class "col-xs-5" ]
                [ div [ class "well well-right" ]
                    [ p [ class "lead" ]
                        [ text (I18n.translate language I18n.CreateAccountNow) ]
                    , ul [ class "list-unstyled" ]
                        [ li []
                            [ span [ class "fa fa-check text-success" ]
                                []
                            , text (I18n.translate language I18n.ImproveExistingContent)
                            ]
                        , li []
                            [ span [ class "fa fa-check text-success" ]
                                []
                            , text (I18n.translate language I18n.VoteBestContributions)
                            ]
                        , li []
                            [ span [ class "fa fa-check text-success" ]
                                []
                            , text (I18n.translate language I18n.AddToolOrUseCase)
                            ]
                        , li []
                            [ span [ class "fa fa-check text-success" ]
                                []
                            , text (I18n.translate language I18n.CreateOrganizationPage)
                            ]
                        , li []
                            [ aForPath
                                (ForParent << Navigate)
                                language
                                "/faq"
                                []
                                [ u []
                                    [ text (I18n.translate language I18n.ReadMore) ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
