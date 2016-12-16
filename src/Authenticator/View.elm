module Authenticator.View exposing (..)

import Authenticator.Model exposing (Model)
import Authenticator.ResetPassword.View
import Authenticator.Routes exposing (Route(..))
import Authenticator.SignIn.View
import Authenticator.SignOut.View
import Authenticator.SignUp.View
import Authenticator.Types exposing (InternalMsg(..), Msg(..), translateSignInMsg, translateSignUpMsg)
import Html exposing (Html)
import I18n


modalTitle : I18n.Language -> Route -> String
modalTitle language route =
    case route of
        ResetPasswordRoute ->
            "Password lost?"

        SignInRoute ->
            (I18n.translate language I18n.SignInToContribute)

        SignOutRoute ->
            "Sign out and contribute later"

        SignUpRoute ->
            "Create your account"


viewModalBody : I18n.Language -> Route -> Model -> Html Msg
viewModalBody language route model =
    case route of
        ResetPasswordRoute ->
            Html.map
                (ForSelf << ResetPasswordMsg)
                (Authenticator.ResetPassword.View.viewModalBody language model.resetPassword)

        SignInRoute ->
            Html.map
                translateSignInMsg
                (Authenticator.SignIn.View.viewModalBody language model.signIn)

        SignOutRoute ->
            Html.map
                (ForSelf << SignOutMsg)
                (Authenticator.SignOut.View.viewModalBody language model.signOut)

        SignUpRoute ->
            Html.map
                translateSignUpMsg
                (Authenticator.SignUp.View.viewModalBody language model.signUp)
