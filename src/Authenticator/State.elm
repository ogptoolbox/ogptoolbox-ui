module Authenticator.State exposing (..)

import Authenticator.Types exposing (Authentication, Model)
import Authenticator.Activate.State
import Authenticator.Activate.Types
import Authenticator.ChangePassword.State
import Authenticator.ResetPassword.State
import Authenticator.Routes exposing (..)
import Authenticator.SignIn.State
import Authenticator.SignOut.State
import Authenticator.SignUp.State
import Authenticator.Types exposing (..)
import I18n
import Navigation
import Task
import Urls


init : Model
init =
    { activate = Authenticator.Activate.State.init
    , authentication = Nothing
    , changePassword = Authenticator.ChangePassword.State.init "" ""
    , resetPassword = Authenticator.ResetPassword.State.init
    , signIn = Authenticator.SignIn.State.init
    , signOut = Authenticator.SignOut.State.init
    , signUp = Authenticator.SignUp.State.init
    }


update : InternalMsg -> Model -> I18n.Language -> ( Model, Cmd Msg )
update msg model language =
    case msg of
        ActivateDone authentication ->
            ( { model | authentication = Just authentication }, Cmd.none )

        ActivateMsg subMsg ->
            let
                ( activate, activateCmd ) =
                    Authenticator.Activate.State.update subMsg model.activate language

                model_ =
                    { model | activate = activate }
            in
                ( model_, Cmd.map translateActivateMsg activateCmd )

        ChangePasswordDone authentication ->
            ( { model | authentication = Just authentication }
            , ForParent PasswordChanged
                |> (\msg -> Task.perform (\_ -> msg) (Task.succeed ()))
            )

        ChangePasswordMsg subMsg ->
            let
                ( changePassword, changePasswordCmd ) =
                    Authenticator.ChangePassword.State.update subMsg model.changePassword language

                model_ =
                    { model | changePassword = changePassword }
            in
                ( model_, Cmd.map translateChangePasswordMsg changePasswordCmd )

        ResetPasswordMsg subMsg ->
            let
                ( resetPassword, resetPasswordCmd ) =
                    Authenticator.ResetPassword.State.update subMsg model.resetPassword

                model_ =
                    { model | resetPassword = resetPassword }
            in
                ( model_, Cmd.map translateResetPasswordMsg resetPasswordCmd )

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


urlUpdate : I18n.Language -> Navigation.Location -> Route -> Model -> ( Model, Cmd Msg )
urlUpdate language location route model =
    case route of
        ActivateRoute userId ->
            let
                authorization =
                    Urls.querySingleParameter
                        "authorization"
                        location
                        |> Maybe.withDefault ""
            in
                update
                    (ActivateMsg <| Authenticator.Activate.Types.ActivateUser userId authorization)
                    model
                    language

        ChangePasswordRoute userId ->
            let
                authorization =
                    Urls.querySingleParameter
                        "authorization"
                        location
                        |> Maybe.withDefault ""
            in
                ( { model | changePassword = Authenticator.ChangePassword.State.init userId authorization }
                , Cmd.none
                )

        ResetPasswordRoute ->
            -- TODO
            ( model, Cmd.none )

        SignInRoute ->
            -- TODO
            ( model, Cmd.none )

        SignOutRoute ->
            -- TODO
            ( model, Cmd.none )

        SignUpRoute ->
            -- TODO
            ( model, Cmd.none )
