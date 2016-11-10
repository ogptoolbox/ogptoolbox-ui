module Routes
    exposing
        ( ExamplesNestedRoute(..)
        , makeUrl
        , Route(..)
        , StatementsNestedRoute(..)
        , ToolsNestedRoute(..)
        , urlParser
        )

-- import Authenticator.Model

import Combine exposing (Parser)
import Hop
import Hop.Matchers exposing (match1, match2, nested1)
import Hop.Types
import Navigation


-- MAIN ROUTE


type Route
    = AboutRoute
      -- | AuthenticatorRoute Authenticator.Model.Route
    | ExamplesRoute ExamplesNestedRoute
    | HelpRoute
    | HomeRoute
    | NotFoundRoute
    | OrganizationsRoute
    | StatementsRoute StatementsNestedRoute
    | ToolsRoute ToolsNestedRoute



-- NESTED ROUTES


type ExamplesNestedRoute
    = ExampleRoute String
    | ExamplesIndexRoute
    | ExamplesNotFoundRoute


type StatementsNestedRoute
    = StatementRoute String
    | StatementsIndexRoute
    | StatementsNotFoundRoute


type ToolsNestedRoute
    = ToolRoute String
    | ToolsIndexRoute
    | ToolsNotFoundRoute


makeUrl : String -> String
makeUrl path =
    Hop.makeUrl routerConfig path


matchers : List (Hop.Types.PathMatcher Route)
matchers =
    [ match1 HomeRoute ""
    , match1 AboutRoute "/about"
      -- , match1 (AuthenticatorRoute Authenticator.Model.SignInRoute) "/sign_in"
      -- , match1 (AuthenticatorRoute Authenticator.Model.SignOutRoute) "/sign_out"
      -- , match1 (AuthenticatorRoute Authenticator.Model.SignUpRoute) "/sign_up"
    , nested1 ExamplesRoute
        "/examples"
        [ match1 ExamplesIndexRoute ""
        , match2 ExampleRoute "/" idParser
        ]
    , match1 HelpRoute "/help"
    , match1 OrganizationsRoute "/organizations"
    , nested1 StatementsRoute
        "/statements"
        [ match1 StatementsIndexRoute ""
        , match2 StatementRoute "/" idParser
        ]
    , nested1 ToolsRoute
        "/tools"
        [ match1 ToolsIndexRoute ""
        , match2 ToolRoute "/" idParser
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


idParser : Parser String
idParser =
    Combine.regex "[0-9]+"


urlParser : Navigation.Parser ( Route, Hop.Types.Location )
urlParser =
    Navigation.makeParser (.href >> Hop.matchUrl routerConfig)
