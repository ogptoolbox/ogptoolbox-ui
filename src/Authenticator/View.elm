module Authenticator.View exposing (view)

import Authenticator.Model exposing (Model, Route(..))
import Authenticator.SignIn as SignIn
import Authenticator.SignOut as SignOut
import Authenticator.SignUp as SignUp
import Authenticator.Update exposing (Msg(..))
import Html exposing (Html)
import Html.App


view : Route -> Model -> Html Msg
view route model =
    case route of
        SignInRoute ->
            Html.App.map SignInMsg (SignIn.view model.signIn)
        SignOutRoute ->
            Html.App.map SignOutMsg (SignOut.view model.signOut)
        SignUpRoute ->
            Html.App.map SignUpMsg (SignUp.view model.signUp)
