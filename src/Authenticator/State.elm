module Authenticator.State exposing (..)

import Authenticator.Types exposing (Authentication, Model)
import Authenticator.ResetPassword.State
import Authenticator.SignIn.State
import Authenticator.SignOut.State
import Authenticator.SignUp.State
import Authenticator.Types exposing (..)


init : Model
init =
    { authentication = Nothing
    , resetPassword = Authenticator.ResetPassword.State.init
    , signIn = Authenticator.SignIn.State.init
    , signOut = Authenticator.SignOut.State.init
    , signUp = Authenticator.SignUp.State.init
    }


update : InternalMsg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ResetPasswordMsg subMsg ->
            let
                ( resetPassword, resetPasswordCmd, authentication ) =
                    Authenticator.ResetPassword.State.update subMsg model.resetPassword

                model_ =
                    { model | authentication = authentication, resetPassword = resetPassword }
            in
                ( model_, Cmd.map (ForSelf << ResetPasswordMsg) resetPasswordCmd )

        SignInMsg subMsg ->
            let
                ( signIn, signInCmd, authentication ) =
                    Authenticator.SignIn.State.update subMsg model.signIn

                model_ =
                    { model | authentication = authentication, signIn = signIn }
            in
                ( model_, Cmd.map translateSignInMsg signInCmd )

        SignOutMsg subMsg ->
            let
                ( signOut, signOutCmd ) =
                    Authenticator.SignOut.State.update subMsg model.signOut

                model_ =
                    { model | authentication = Nothing, signOut = signOut }
            in
                ( model_, Cmd.map (ForSelf << SignOutMsg) signOutCmd )

        SignUpMsg subMsg ->
            let
                ( signUp, signUpCmd, authentication ) =
                    Authenticator.SignUp.State.update subMsg model.signUp

                model_ =
                    { model | authentication = authentication, signUp = signUp }
            in
                ( model_, Cmd.map translateSignUpMsg signUpCmd )
