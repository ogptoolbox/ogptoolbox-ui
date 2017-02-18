module Authenticator.ChangePassword.View exposing (..)

import Authenticator.ChangePassword.Types exposing (..)
import Authenticator.ViewsHelpers exposing (..)
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Aria exposing (..)
import Html.Events exposing (..)
import Http exposing (Error(BadStatus))
import Http.Error
import I18n


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
                                    if response.status.code == 400 then
                                        I18n.translate language I18n.BadAuthorization
                                    else if response.status.code == 404 then
                                        I18n.translate language I18n.UnknownUser
                                    else
                                        Http.Error.toString language httpError

                                _ ->
                                    Http.Error.toString language httpError
                            )
                        ]
    in
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
                            [ viewPasswordControl
                                (ForSelf << PasswordInput)
                                language
                                (Dict.get "password" model.errors)
                                model.password
                            , alert
                            , button
                                [ class "btn btn-block btn-default grey"
                                , type_ "submit"
                                ]
                                [ text (I18n.translate language I18n.Save) ]
                            ]
                        ]
                    ]
                ]
            ]


viewModalBody : I18n.Language -> Model -> Html Msg
viewModalBody language model =
    div [ class "modal-body" ]
        [ view language model ]
