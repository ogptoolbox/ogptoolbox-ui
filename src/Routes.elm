module Routes exposing (makeUrl, Route(..), StatementsNestedRoute(..), urlParser)

import Authenticator.Model
import Combine exposing (Parser)
import Hop
import Hop.Matchers exposing (match1, match2, nested1)
import Hop.Types
import Navigation


type Route
    = AboutRoute
    | AuthenticatorRoute Authenticator.Model.Route
    | HomeRoute
    | NotFoundRoute
    | StatementsRoute StatementsNestedRoute


type StatementsNestedRoute
    = StatementRoute String
    | StatementsIndexRoute
    | StatementsNotFoundRoute


makeUrl : String -> String
makeUrl path = Hop.makeUrl routerConfig path


matchers : List (Hop.Types.PathMatcher Route)
matchers =
    [ match1 HomeRoute ""
    , match1 AboutRoute "/about"
    , match1 (AuthenticatorRoute Authenticator.Model.SignInRoute) "/sign_in"
    , match1 (AuthenticatorRoute Authenticator.Model.SignOutRoute) "/sign_out"
    , match1 (AuthenticatorRoute Authenticator.Model.SignUpRoute) "/sign_up"
    , nested1 StatementsRoute "/statements"
        [ match1 StatementsIndexRoute ""
        , match2 StatementRoute "/" statementIdParser
        ]
    ]


routerConfig : Hop.Types.Config Route
routerConfig =
    -- Production:
    -- { hash = False
    -- , basePath = ""
    -- , matchers = matchers
    -- , notFound = NotFoundRoute
    -- }
    -- Development:
    { hash = True
    , basePath = ""
    , matchers = matchers
    , notFound = NotFoundRoute
    }


statementIdParser : Parser String
statementIdParser =
    Combine.regex "[0-9]+"


urlParser : Navigation.Parser ( Route, Hop.Types.Location )
urlParser =
    Navigation.makeParser (.href >> Hop.matchUrl routerConfig)
