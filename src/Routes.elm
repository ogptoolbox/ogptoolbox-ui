module Routes exposing (..)

-- import Authenticator.Model

import Combine exposing (Parser)
import Dict exposing (Dict)
import Hop
import Hop.Matchers exposing (match1, match2, nested1, regex)
import Hop.Types exposing (Location)
import I18n
import Navigation
import String
import Types exposing (..)


-- MAIN ROUTE


type Route
    = AboutRoute
      -- | AuthenticatorRoute Authenticator.Model.Route
    | ExamplesRoute ExamplesNestedRoute
    | HelpRoute
    | HomeRoute
    | NotFoundRoute String
    | OrganizationsRoute OrganizationsNestedRoute
    | ToolsRoute ToolsNestedRoute


type I18nRoute
    = I18nRouteWithLanguage I18n.Language Route
    | I18nRouteWithoutLanguage String



-- NESTED ROUTES


type ExamplesNestedRoute
    = ExampleRoute String
    | ExamplesIndexRoute
    | NewExampleRoute


type OrganizationsNestedRoute
    = OrganizationRoute String
    | OrganizationsIndexRoute
    | NewOrganizationRoute


type ToolsNestedRoute
    = ToolRoute String
    | ToolsIndexRoute
    | NewToolRoute


makeUrl : String -> String
makeUrl path =
    Hop.makeUrl routerConfig path


makeUrlFromLocation : Location -> String
makeUrlFromLocation location =
    Hop.makeUrlFromLocation routerConfig location


makeUrlWithLanguage : I18n.Language -> String -> String
makeUrlWithLanguage language urlPath =
    makeUrl ("/" ++ (I18n.iso639_1FromLanguage language) ++ urlPath)


matchers : List (Hop.Types.PathMatcher Route)
matchers =
    [ match1 HomeRoute ""
    , match1 AboutRoute "/about"
      -- , match1 (AuthenticatorRoute Authenticator.Model.SignInRoute) "/sign_in"
      -- , match1 (AuthenticatorRoute Authenticator.Model.SignOutRoute) "/sign_out"
      -- , match1 (AuthenticatorRoute Authenticator.Model.SignUpRoute) "/sign_up"
    , nested1 ExamplesRoute
        --   TODO rename all routes "examples" to "use-cases"
        "/examples"
        [ match1 ExamplesIndexRoute ""
        , match2 ExampleRoute "/" idParser
        , match1 NewExampleRoute "/new"
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
        , match1 NewToolRoute "/new"
        ]
    , match2 NotFoundRoute "" (regex ".*")
    ]


i18nMatchers : List (Hop.Types.PathMatcher I18nRoute)
i18nMatchers =
    (List.map
        (\language ->
            nested1 (I18nRouteWithLanguage language)
                ("/" ++ (I18n.iso639_1FromLanguage language))
                matchers
        )
        [ I18n.English
        , I18n.French
        , I18n.Spanish
        ]
    )
        ++ [ match2 I18nRouteWithoutLanguage "" (regex ".*") ]


routerConfig : Hop.Types.Config I18nRoute
routerConfig =
    -- Production:
    -- { hash = False
    -- , basePath = ""
    -- , matchers = matchers
    -- , notFound = I18nRouteWithoutLanguage ""
    -- }
    -- Development:
    { hash =
        -- Use with "devServer.historyApiFallback = true" in webpack config.
        False
    , basePath = ""
    , matchers = i18nMatchers
    , notFound = I18nRouteWithoutLanguage ""
    }


idParser : Parser String
idParser =
    Combine.regex "[0-9]+"


urlParser : Navigation.Parser ( I18nRoute, Hop.Types.Location )
urlParser =
    Navigation.makeParser (.href >> Hop.matchUrl routerConfig)



-- UPDATE LOCATION


addSearchQueryToLocation : String -> Location -> Cmd msg
addSearchQueryToLocation searchQuery location =
    Hop.addQuery (Dict.singleton "q" searchQuery) location
        |> makeUrlFromLocation
        |> Navigation.newUrl


getSearchQuery : Location -> String
getSearchQuery location =
    Dict.get "q" location.query |> Maybe.withDefault ""


replaceLanguageInLocation : I18n.Language -> Location -> String
replaceLanguageInLocation language location =
    let
        urlWithoutLanguage =
            makeUrlFromLocation location
                |> String.dropLeft 3
    in
        "/" ++ (I18n.iso639_1FromLanguage language) ++ urlWithoutLanguage



-- REVERSE


pathForCard : Card -> Maybe String
pathForCard card =
    List.head card.subTypeIds
        `Maybe.andThen`
            (\cardType ->
                if List.member cardType cardTypesForExample then
                    Just ("/examples/" ++ card.id)
                else if List.member cardType cardTypesForOrganization then
                    Just ("/organizations/" ++ card.id)
                else if List.member cardType cardTypesForTool then
                    Just ("/tools/" ++ card.id)
                else
                    Nothing
            )
