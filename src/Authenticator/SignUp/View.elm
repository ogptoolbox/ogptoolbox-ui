module Authenticator.SignUp.View exposing (..)

import Authenticator.SignUp.Types exposing (..)
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Aria exposing (..)
import Html.Events exposing (..)
import Html.Helpers exposing (..)
import I18n


viewModalBody : I18n.Language -> Model -> Html Msg
viewModalBody language model =
    div [ class "modal-body" ]
        [ div [ class "row" ]
            [ div [ class "col-xs-7" ]
                [ div [ class "well" ]
                    [ Html.form [ onSubmit (ForSelf <| Submit) ]
                        [ let
                            errorMaybe =
                                Dict.get "username" model.errors
                          in
                            case errorMaybe of
                                Just error ->
                                    div [ class "form-group has-error" ]
                                        [ label
                                            [ class "control-label", for "username" ]
                                            [ text (I18n.translate language I18n.Username) ]
                                        , input
                                            [ ariaDescribedby "username-error"
                                            , class "form-control"
                                            , id "username"
                                            , placeholder (I18n.translate language I18n.UsernamePlaceholder)
                                            , required True
                                            , title (I18n.translate language I18n.EnterUsername)
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
                                            [ text (I18n.translate language I18n.Username) ]
                                        , input
                                            [ class "form-control"
                                            , id "username"
                                            , placeholder (I18n.translate language I18n.UsernamePlaceholder)
                                            , required True
                                            , title (I18n.translate language I18n.EnterUsername)
                                            , type_ "text"
                                            , value model.username
                                            , onInput (ForSelf << UsernameInput)
                                            ]
                                            []
                                        ]
                        , let
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
                                            , type_ "email"
                                            , value model.email
                                            , onInput (ForSelf << EmailInput)
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
                                            , type_ "email"
                                            , value model.email
                                            , onInput (ForSelf << EmailInput)
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
                                        [ label
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
