module Authenticator.View exposing (..)

import Authenticator.Activate.View
import Authenticator.ChangePassword.View
import Authenticator.ResetPassword.View
import Authenticator.Routes exposing (Route(..))
import Authenticator.SignIn.View
import Authenticator.SignOut.View
import Authenticator.SignUp.View
import Authenticator.Types exposing (..)
import Html exposing (Html, text)
import I18n


modalTitle : I18n.Language -> Route -> String
modalTitle language route =
    case route of
        ActivateRoute _ ->
            (I18n.translate language I18n.ActivationTitle)

        ChangePasswordRoute _ ->
            (I18n.translate language I18n.ChangePassword)

        ResetPasswordRoute ->
            (I18n.translate language I18n.PasswordLost)

        SignInRoute ->
            (I18n.translate language I18n.SignInToContribute)

        SignOutRoute ->
            (I18n.translate language I18n.SignOutAndContributeLater)

        SignUpRoute ->
            (I18n.translate language I18n.CreateYourAccount)


view : I18n.Language -> Route -> Model -> Html Msg
view language route model =
    case route of
        ActivateRoute _ ->
            Html.map
                translateActivateMsg
                (Authenticator.Activate.View.view language model.activate)

        ChangePasswordRoute _ ->
            Html.map
                translateChangePasswordMsg
                (Authenticator.ChangePassword.View.view language model.changePassword)

        ResetPasswordRoute ->
            -- Html.map
            --     translateResetPasswordMsg
            --     (Authenticator.ResetPassword.View.viewModalBody language model.resetPassword)
            viewNotImplemented

        SignInRoute ->
            -- Html.map
            --     translateSignInMsg
            --     (Authenticator.SignIn.View.viewModalBody language model.signIn)
            viewNotImplemented

        SignOutRoute ->
            -- Html.map
            --     (ForSelf << SignOutMsg)
            --     (Authenticator.SignOut.View.viewModalBody language model.signOut)
            viewNotImplemented

        SignUpRoute ->
            -- Html.map
            --     translateSignUpMsg
            --     (Authenticator.SignUp.View.viewModalBody language model.signUp)
            viewNotImplemented


viewModalBody : I18n.Language -> Route -> Model -> Html Msg
viewModalBody language route model =
    case route of
        ActivateRoute _ ->
            -- Html.map
            --     translateActivateMsg
            --     (Authenticator.Activate.View.viewModalBody language model.activate)
            viewNotImplemented

        ChangePasswordRoute _ ->
            -- Html.map
            --     translateChangePasswordMsg
            --     (Authenticator.ChangePassword.View.viewModalBody language model.changePassword)
            viewNotImplemented

        ResetPasswordRoute ->
            Html.map
                translateResetPasswordMsg
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


viewNotImplemented : Html Msg
viewNotImplemented =
    text "Not implemented"
