module Authenticator.View exposing (..)

import Authenticator.Model exposing (Model, Route(..))
import Authenticator.SignIn as SignIn
import Authenticator.SignOut as SignOut
import Authenticator.SignUp as SignUp
import Authenticator.Update exposing (Msg(..))
import Html exposing (Html)
import Html.App


modalTitle : Route -> String
modalTitle route =
    case route of
        SignInRoute ->
            "Sign in to contribute"
        SignOutRoute ->
            "Sign out and contribute later"
        SignUpRoute ->
            "Sign up to contribute"


viewModalBody : Route -> Model -> Html Msg
viewModalBody route model =
    case route of
        SignInRoute ->
            Html.App.map SignInMsg (SignIn.viewModalBody model.signIn)
        SignOutRoute ->
            Html.App.map SignOutMsg (SignOut.viewModalBody model.signOut)
        SignUpRoute ->
            Html.App.map SignUpMsg (SignUp.viewModalBody model.signUp)
