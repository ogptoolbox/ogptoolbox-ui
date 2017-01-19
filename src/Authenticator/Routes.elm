module Authenticator.Routes exposing (..)


type Route
    = ActivateRoute String
    | ChangePasswordRoute String
    | ResetPasswordRoute
    | SignInRoute
    | SignOutRoute
    | SignUpRoute
