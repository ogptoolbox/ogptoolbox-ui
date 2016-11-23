module Routes exposing (..)

-- import Authenticator.Model

import Combine exposing (Parser)
import Dict
import Hop
import Hop.Matchers exposing (match1, match2, nested1)
import Hop.Types exposing (Location)
import Navigation
import PropertyKeys exposing (..)
import Requests exposing (cardTypesForExample, cardTypesForOrganization, cardTypesForTool)
import Types exposing (..)


-- MAIN ROUTE


type Route
    = AboutRoute
      -- | AuthenticatorRoute Authenticator.Model.Route
    | ExamplesRoute ExamplesNestedRoute
    | HelpRoute
    | HomeRoute
    | NotFoundRoute
    | OrganizationsRoute OrganizationsNestedRoute
    | ToolsRoute ToolsNestedRoute



-- NESTED ROUTES


type ExamplesNestedRoute
    = ExampleRoute String
    | ExamplesIndexRoute


type OrganizationsNestedRoute
    = OrganizationRoute String
    | OrganizationsIndexRoute


type ToolsNestedRoute
    = ToolRoute String
    | ToolsIndexRoute


makeUrl : String -> String
makeUrl path =
    Hop.makeUrl routerConfig path


makeUrlFromLocation : Location -> String
makeUrlFromLocation location =
    Hop.makeUrlFromLocation routerConfig location


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
    , nested1 OrganizationsRoute
        "/organizations"
        [ match1 OrganizationsIndexRoute ""
        , match2 OrganizationRoute "/" idParser
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
    { hash =
        -- Use with "devServer.historyApiFallback = true" in webpack config.
        False
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



-- QUERY STRING


addSearchQueryToLocation : String -> Location -> Cmd msg
addSearchQueryToLocation searchQuery location =
    Hop.addQuery (Dict.singleton "q" searchQuery) location
        |> makeUrlFromLocation
        |> Navigation.newUrl


getSearchQuery : Location -> String
getSearchQuery location =
    Dict.get "q" location.query |> Maybe.withDefault ""



-- REVERSE


pathForStatement : Statement -> Maybe String
pathForStatement statement =
    case statement.custom of
        CardCustom card ->
            getOneString cardTypeKeys card
                `Maybe.andThen`
                    (\cardType ->
                        if List.member cardType cardTypesForExample then
                            Just ("/examples/" ++ statement.id)
                        else if List.member cardType cardTypesForOrganization then
                            Just ("/organizations/" ++ statement.id)
                        else if List.member cardType cardTypesForTool then
                            Just ("/tools/" ++ statement.id)
                        else
                            Nothing
                    )

        _ ->
            Nothing
