module Authenticator.Update exposing (..)

import Authenticator.Model exposing (Authentication, Model)
import Authenticator.ResetPassword as ResetPassword
import Authenticator.SignIn as SignIn
import Authenticator.SignOut as SignOut
import Authenticator.SignUp as SignUp
import Authenticator.Types exposing (..)


update : InternalMsg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ResetPasswordMsg subMsg ->
            let
                ( resetPassword, resetPasswordEffect, authentication ) =
                    ResetPassword.update subMsg model.resetPassword

                model_ =
                    { model | authentication = authentication, resetPassword = resetPassword }
            in
                ( model_, Cmd.map (ForSelf << ResetPasswordMsg) resetPasswordEffect )

        SignInMsg subMsg ->
            let
                ( signIn, signInEffect, authentication ) =
                    SignIn.update subMsg model.signIn

                model_ =
                    { model | authentication = authentication, signIn = signIn }
            in
                ( model_, Cmd.map (ForSelf << SignInMsg) signInEffect )

        SignOutMsg subMsg ->
            let
                ( signOut, signOutEffect ) =
                    SignOut.update subMsg model.signOut

                model_ =
                    { model | authentication = Nothing, signOut = signOut }
            in
                ( model_, Cmd.map (ForSelf << SignOutMsg) signOutEffect )

        SignUpMsg subMsg ->
            let
                ( signUp, signUpEffect, authentication ) =
                    SignUp.update subMsg model.signUp

                model_ =
                    { model | authentication = authentication, signUp = signUp }
            in
                ( model_, Cmd.map (ForSelf << SignUpMsg) signUpEffect )
