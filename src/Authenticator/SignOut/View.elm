module Authenticator.SignOut.View exposing (..)

import Authenticator.SignOut.Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import I18n


view : I18n.Language -> Model -> Html Msg
view language model =
    Html.form [ onSubmit (ForSelf <| Submit) ]
        [ button
            [ class "btn btn-primary"
            , type_ "submit"
            ]
            [ text "Sign Out" ]
        ]


viewModalBody : I18n.Language -> Model -> Html Msg
viewModalBody language model =
    div [ class "modal-body" ]
        [ view language model ]
