module Authenticator.ResetPassword.View exposing (..)

import Authenticator.ResetPassword.Types exposing (..)
import Authenticator.ViewsParts exposing (..)
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Aria exposing (..)
import Html.Events exposing (..)
import Http exposing (Error(BadStatus))
import I18n
import Views exposing (getHttpErrorAsString)


view : I18n.Language -> Model -> Html Msg
view language model =
    let
        alert =
            case model.httpError of
                Nothing ->
                    text ""

                Just httpError ->
                    div
                        [ class "alert alert-danger"
                        , role "alert"
                        ]
                        [ strong []
                            [ text <|
                                I18n.translate language I18n.PasswordChangeFailed
                                    ++ I18n.translate language I18n.Colon
                            ]
                        , text
                            (case httpError of
                                BadStatus response ->
                                    if response.status.code == 404 then
                                        I18n.translate language I18n.UnknownUser
                                    else
                                        getHttpErrorAsString language httpError

                                _ ->
                                    getHttpErrorAsString language httpError
                            )
                        ]
    in
        div [ class "row" ]
            [ div [ class "col-xs-12" ]
                [ div [ class "well" ]
                    [ Html.form [ onSubmit (ForSelf <| Submit) ]
                        [ p []
                            [ text (I18n.translate language I18n.ResetPasswordExplanation) ]
                        , viewEmailControl
                            (ForSelf << EmailInput)
                            language
                            (Dict.get "email" model.errors)
                            model.email
                        , alert
                        , button
                            [ class "btn btn-block btn-default grey"
                            , type_ "submit"
                            ]
                            [ text (I18n.translate language I18n.Send) ]
                        ]
                    ]
                ]
            ]


viewModalBody : I18n.Language -> Model -> Html Msg
viewModalBody language model =
    div [ class "modal-body" ]
        [ view language model ]
