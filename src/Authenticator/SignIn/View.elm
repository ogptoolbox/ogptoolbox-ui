module Authenticator.SignIn.View exposing (..)

import Authenticator.Routes
import Authenticator.SignIn.Types exposing (..)
import Authenticator.ViewsParts exposing (..)
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Helpers exposing (..)
import I18n
import Json.Decode
import Views exposing (getHttpErrorAsString)


viewModalBody : I18n.Language -> Model -> Html Msg
viewModalBody language model =
    div [ class "modal-body" ]
        [ div [ class "row" ]
            [ div [ class "col-xs-6" ]
                [ div [ class "well" ]
                    [ Html.form [ onSubmit (ForSelf <| Submit) ]
                        ([ viewEmailField
                            (ForSelf << EmailInput)
                            language
                            (Dict.get "email" model.errors)
                            model.email
                         , viewPasswordField
                            (ForSelf << PasswordInput)
                            language
                            (Dict.get "password" model.errors)
                            model.password
                         , a
                            [ class "forgot"
                            , href "#"
                            , onWithOptions
                                "click"
                                { preventDefault = True, stopPropagation = False }
                                (Json.Decode.succeed
                                    (ForParent (ChangeRoute (Just Authenticator.Routes.ResetPasswordRoute)))
                                )
                            ]
                            [ small [] [ text (I18n.translate language I18n.ResetPasswordLink) ] ]
                           -- , div [ class "alert alert-error hide", id "loginErrorMsg" ]
                           --     [ text "Wrong email or password" ]
                         , button
                            [ class "btn btn-block btn-default grey", type_ "submit" ]
                            [ text (I18n.translate language I18n.SignIn) ]
                         ]
                            ++ (case model.httpError of
                                    Nothing ->
                                        []

                                    Just err ->
                                        [ text (getHttpErrorAsString language err) ]
                               )
                        )
                    ]
                ]
            , div [ class "col-xs-6" ]
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
                    , a
                        [ class "btn btn-block btn-default "
                        , href "#"
                        , onWithOptions
                            "click"
                            { preventDefault = True, stopPropagation = False }
                            (Json.Decode.succeed (ForParent (ChangeRoute (Just Authenticator.Routes.SignUpRoute))))
                        ]
                        [ text (I18n.translate language I18n.RegisterNow) ]
                    ]
                ]
            ]
        ]
