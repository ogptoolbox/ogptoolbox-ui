module Authenticator.ChangePassword.View exposing (..)

import Authenticator.ChangePassword.Types exposing (..)
import Authenticator.ViewsParts exposing (..)
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
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
                        [ viewPasswordField
                            (ForSelf << PasswordInput)
                            language
                            (Dict.get "password" model.errors)
                            model.password
                        , button
                            [ class "btn btn-block btn-default grey", type_ "submit" ]
                            [ text (I18n.translate language I18n.Save) ]
                        ]
                    ]
                ]
            ]
        ]
