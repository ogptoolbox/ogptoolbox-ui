module Authenticator.ResetPassword.View exposing (..)

import Authenticator.ResetPassword.Types exposing (..)
import Authenticator.ViewsParts exposing (..)
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import I18n


viewModalBody : I18n.Language -> Model -> Html Msg
viewModalBody language model =
    div [ class "modal-body" ]
        [ div [ class "row" ]
            [ div [ class "col-xs-12" ]
                [ div [ class "well" ]
                    [ Html.form [ onSubmit (ForSelf <| Submit) ]
                        [ p []
                            [ text (I18n.translate language I18n.ResetPasswordExplanation) ]
                        , viewEmailField
                            (ForSelf << EmailInput)
                            language
                            (Dict.get "email" model.errors)
                            model.email
                        , button
                            [ class "btn btn-block btn-default grey", type_ "submit" ]
                            [ text (I18n.translate language I18n.Send) ]
                        ]
                    ]
                ]
            ]
        ]
