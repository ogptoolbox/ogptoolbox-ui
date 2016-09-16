module Authenticator.SignOut exposing (Model, init, Msg, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


-- MODEL


type alias Model = {}


init : Model
init = {}


-- UPDATE


type Msg
    = Submit


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Submit ->
            ( model, Cmd.none )


-- VIEW


view : Model -> Html Msg
view model =
    Html.form [ onSubmit Submit ]
        [ button
            [ class "btn btn-primary", type' "submit" ]
            [ text "Sign Out" ]
        ]
