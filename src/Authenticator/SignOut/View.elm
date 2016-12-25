module Authenticator.SignOut.View exposing (..)

import Authenticator.SignOut.Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import I18n


viewModalBody : I18n.Language -> Model -> Html Msg
viewModalBody language model =
    div [ class "modal-body" ]
        [ Html.form [ onSubmit Submit ]
            [ button
                [ class "btn btn-primary", type_ "submit" ]
                [ text "Sign Out" ]
            ]
        ]
