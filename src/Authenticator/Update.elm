module Authenticator.Update exposing (..)

import Authenticator.Model exposing (Authentication, Model)
import Authenticator.SignIn as SignIn
import Authenticator.SignOut as SignOut
import Authenticator.SignUp as SignUp


type Msg
    = SignInMsg SignIn.Msg
    | SignOutMsg SignOut.Msg
    | SignUpMsg SignUp.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SignInMsg subMsg ->
            let
                ( signIn, signInEffect, authentication ) =
                    SignIn.update subMsg model.signIn

                model' =
                    { model | authentication = authentication, signIn = signIn }
            in
                ( model', Cmd.map SignInMsg signInEffect )

        SignOutMsg subMsg ->
            let
                ( signOut, signOutEffect ) =
                    SignOut.update subMsg model.signOut

                model' =
                    { model | authentication = Nothing, signOut = signOut }
            in
                ( model', Cmd.map SignOutMsg signOutEffect )

        SignUpMsg subMsg ->
            let
                ( signUp, signUpEffect, authentication ) =
                    SignUp.update subMsg model.signUp

                model' =
                    { model | authentication = authentication, signUp = signUp }
            in
                ( model', Cmd.map SignUpMsg signUpEffect )
