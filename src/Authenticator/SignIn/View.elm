module Authenticator.SignIn.View exposing (..)

import Authenticator.Routes
import Authenticator.SignIn.Types exposing (..)
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Aria exposing (..)
import Html.Events exposing (..)
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
                        ([ let
                            errorMaybe =
                                Dict.get "username" model.errors
                           in
                            case errorMaybe of
                                Just error ->
                                    div [ class "form-group has-error" ]
                                        [ label
                                            [ class "control-label", for "username" ]
                                            [ text (I18n.translate language I18n.Email) ]
                                        , input
                                            [ ariaDescribedby "username-error"
                                            , class "form-control"
                                            , id "username"
                                            , placeholder "john.doe@ogptoolbox.org"
                                            , required True
                                            , title (I18n.translate language I18n.EnterEmail)
                                            , type_ "text"
                                            , value model.username
                                            , onInput (ForSelf << UsernameInput)
                                            ]
                                            []
                                        , span
                                            [ class "help-block"
                                            , id "username-error"
                                            ]
                                            [ text error ]
                                        ]

                                Nothing ->
                                    div [ class "form-group" ]
                                        [ label
                                            [ class "control-label", for "username" ]
                                            [ text (I18n.translate language I18n.Email) ]
                                        , input
                                            [ class "form-control"
                                            , id "username"
                                            , placeholder "john.doe@ogptoolbox.org"
                                            , required True
                                            , title (I18n.translate language I18n.EnterEmail)
                                            , type_ "text"
                                            , value model.username
                                            , onInput (ForSelf << UsernameInput)
                                            ]
                                            []
                                        ]
                         , let
                            errorMaybe =
                                Dict.get "password" model.errors
                           in
                            case errorMaybe of
                                Just error ->
                                    div [ class "form-group has-error" ]
                                        [ label
                                            [ class "control-label", for "password" ]
                                            [ text (I18n.translate language I18n.Password) ]
                                        , input
                                            [ ariaDescribedby "password-error"
                                            , class "form-control"
                                            , id "password"
                                            , placeholder "John Doe"
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
                                        [ label
                                            [ class "control-label", for "password" ]
                                            [ text (I18n.translate language I18n.Password) ]
                                        , input
                                            [ class "form-control"
                                            , id "password"
                                            , placeholder "Your secret password"
                                            , required True
                                            , title (I18n.translate language I18n.EnterPassword)
                                            , type_ "password"
                                            , value model.password
                                            , onInput (ForSelf << PasswordInput)
                                            ]
                                            []
                                        ]
                         , a
                            [ class "forgot"
                            , href "#"
                              -- , onWithOptions
                              --     "click"
                              --     { preventDefault = True, stopPropagation = False }
                              --     (Json.Decode.succeed (Authenticator.Types.AuthenticatorRouteMsg (Just Authenticator.Types.SignUpRoute)))
                            ]
                            [ small [] [ text (I18n.translate language I18n.ResetPasswordLink) ] ]
                           -- , div [ class "alert alert-error hide", id "loginErrorMsg" ]
                           --     [ text "Wrong username og password" ]
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
                            [ a [ href "#" ]
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
