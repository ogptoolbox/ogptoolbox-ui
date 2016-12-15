module Authenticator.Update exposing (..)

import Authenticator.Model exposing (Authentication, Model)
import Authenticator.ResetPassword.State
import Authenticator.SignIn.State
import Authenticator.SignOut.State
import Authenticator.SignUp.State
import Authenticator.Types exposing (..)


update : InternalMsg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ResetPasswordMsg subMsg ->
            let
                ( resetPassword, resetPasswordEffect, authentication ) =
                    Authenticator.ResetPassword.State.update subMsg model.resetPassword

                model_ =
                    { model | authentication = authentication, resetPassword = resetPassword }
            in
                ( model_, Cmd.map (ForSelf << ResetPasswordMsg) resetPasswordEffect )

        SignInMsg subMsg ->
            let
                ( signIn, signInEffect, authentication ) =
                    Authenticator.SignIn.State.update subMsg model.signIn

                model_ =
                    { model | authentication = authentication, signIn = signIn }
            in
                ( model_, Cmd.map (ForSelf << SignInMsg) signInEffect )

        SignOutMsg subMsg ->
            let
                ( signOut, signOutEffect ) =
                    Authenticator.SignOut.State.update subMsg model.signOut

                model_ =
                    { model | authentication = Nothing, signOut = signOut }
            in
                ( model_, Cmd.map (ForSelf << SignOutMsg) signOutEffect )

        SignUpMsg subMsg ->
            let
                ( signUp, signUpEffect, authentication ) =
                    Authenticator.SignUp.State.update subMsg model.signUp

                model_ =
                    { model | authentication = authentication, signUp = signUp }
            in
                ( model_, Cmd.map (ForSelf << SignUpMsg) signUpEffect )
