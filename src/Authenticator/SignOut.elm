module Authenticator.SignOut exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Ports exposing (storeAuthentication)


-- MODEL


type alias Model =
    {}


init : Model
init =
    {}



-- UPDATE


type Msg
    = Submit


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Submit ->
            ( model, storeAuthentication Nothing )



-- VIEW


viewModalBody : Model -> Html Msg
viewModalBody model =
    div [ class "modal-body" ]
        [ Html.form [ onSubmit Submit ]
            [ button
                [ class "btn btn-primary", type' "submit" ]
                [ text "Sign Out" ]
            ]
        ]
