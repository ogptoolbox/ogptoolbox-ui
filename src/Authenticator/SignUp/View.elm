module Authenticator.SignUp.View exposing (..)

import Authenticator.Routes
import Authenticator.SignUp.Types exposing (..)
import Authenticator.ViewsParts exposing (..)
import Authenticator.Routes
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Aria exposing (..)
import Html.Events exposing (..)
import Html.Helpers exposing (aForPath)
import Http exposing (Error(BadStatus))
import Http.Error
import I18n
import Json.Decode


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
                                I18n.translate language I18n.AccountCreationFailed
                                    ++ I18n.translate language I18n.Colon
                            ]
                        , text
                            (case httpError of
                                BadStatus response ->
                                    if response.status.code == 400 then
                                        I18n.translate language I18n.UsernameOrEmailAlreadyExist
                                    else
                                        Http.Error.toString language httpError

                                _ ->
                                    Http.Error.toString language httpError
                            )
                        ]
    in
        div [ class "modal-body" ]
            [ div [ class "row" ]
                [ div [ class "col-xs-6" ]
                    [ div [ class "well well-left" ]
                        [ ul [ class "list-unstyled" ]
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
                        , a
                            [ class "btn btn-block btn-default grey haveanaccount"
                            , href "#"
                            , onWithOptions
                                "click"
                                { preventDefault = True, stopPropagation = False }
                                (Json.Decode.succeed (ForParent (ChangeRoute Authenticator.Routes.SignInRoute)))
                            ]
                            [ text (I18n.translate language I18n.HaveAnAccount) ]
                        ]
                    ]
                , div [ class "col-xs-6" ]
                    [ div [ class "well" ]
                        [ Html.form [ onSubmit (ForSelf <| Submit) ]
                            [ viewUsernameControl
                                (ForSelf << UsernameInput)
                                language
                                (Dict.get "username" model.errors)
                                model.username
                            , viewEmailControl
                                (ForSelf << EmailInput)
                                language
                                (Dict.get "email" model.errors)
                                model.email
                            , viewPasswordControl
                                (ForSelf << PasswordInput)
                                language
                                (Dict.get "password" model.errors)
                                model.password
                            , alert
                            , button
                                [ class "btn btn-block btn-default", type_ "submit" ]
                                [ text (I18n.translate language I18n.Register) ]
                            ]
                        ]
                    ]
                ]
            ]


viewModalBody : I18n.Language -> Model -> Html Msg
viewModalBody language model =
    div [ class "modal-body" ]
        [ view language model ]
