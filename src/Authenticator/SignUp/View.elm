module Authenticator.SignUp.View exposing (..)

import Authenticator.SignUp.Types exposing (..)
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
            [ div [ class "col-xs-7" ]
                [ div [ class "well" ]
                    [ Html.form [ onSubmit Submit ]
                        [ let
                            errorMaybe =
                                Dict.get "username" model.errors
                          in
                            case errorMaybe of
                                Just error ->
                                    div [ class "form-group has-error" ]
                                        [ label [ class "control-label", for "username" ] [ text "Username" ]
                                        , input
                                            [ ariaDescribedby "username-error"
                                            , class "form-control"
                                            , id "username"
                                            , placeholder "John Doe"
                                            , required True
                                            , title "Please enter you username"
                                            , type_ "text"
                                            , value model.username
                                            , onInput UsernameInput
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
                                        [ label [ class "control-label", for "username" ] [ text "Username" ]
                                        , input
                                            [ class "form-control"
                                            , id "username"
                                            , placeholder "John Doe"
                                            , required True
                                            , title "Please enter you username"
                                            , type_ "text"
                                            , value model.username
                                            , onInput UsernameInput
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
                                            , onInput EmailInput
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
                                            , onInput EmailInput
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
                                        [ label [ class "control-label", for "password" ] [ text "Password" ]
                                        , input
                                            [ ariaDescribedby "password-error"
                                            , class "form-control"
                                            , id "password"
                                            , placeholder "Your secret password"
                                            , required True
                                            , title "Please enter you password"
                                            , type_ "password"
                                            , value model.password
                                            , onInput PasswordInput
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
                                        [ label [ class "control-label", for "password" ] [ text "Password" ]
                                        , input
                                            [ class "form-control"
                                            , id "password"
                                            , placeholder "John Doe"
                                            , required True
                                            , title "Please enter you password"
                                            , type_ "password"
                                            , value model.password
                                            , onInput PasswordInput
                                            ]
                                            []
                                        ]
                        , button
                            [ class "btn btn-primary", type_ "submit" ]
                            [ text "Sign Up" ]
                        ]
                    ]
                ]
            , div [ class "col-xs-5" ]
                [ div [ class "well well-right" ]
                    [ p [ class "lead" ]
                        [ text "Create your account now" ]
                    , ul [ class "list-unstyled" ]
                        [ li []
                            [ span [ class "fa fa-check text-success" ]
                                []
                            , text "Improve existing content"
                            ]
                        , li []
                            [ span [ class "fa fa-check text-success" ]
                                []
                            , text "Vote the best contributions"
                            ]
                        , li []
                            [ span [ class "fa fa-check text-success" ]
                                []
                            , text "Add a new tool or usage"
                            ]
                        , li []
                            [ span [ class "fa fa-check text-success" ]
                                []
                            , text "Create a page for your organization "
                            ]
                          -- , li []
                          --     [ a [ href "/read-more/" ]
                          --         [ u []
                          --             [ text "Read more" ]
                          --         ]
                          --     ]
                        ]
                    ]
                ]
            ]
        ]
