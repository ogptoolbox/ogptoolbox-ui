module Routes exposing (..)

import Combine exposing (Parser)
import Dict exposing (Dict)
import Hop
import Hop.Matchers exposing (match1, match2, match3, nested1, regex)
import Hop.Types
import I18n
import Navigation
import String
import Types exposing (..)


-- MAIN ROUTE


type Route
    = AboutRoute
    | ActivationRoute String
    | HomeRoute
    | NotFoundRoute String
    | OrganizationsRoute OrganizationsNestedRoute
    | ToolsRoute ToolsNestedRoute
    | UseCasesRoute UseCasesNestedRoute


type I18nRoute
    = I18nRouteWithLanguage I18n.Language Route
    | I18nRouteWithoutLanguage String



-- NESTED ROUTES


type OrganizationsNestedRoute
    = OrganizationRoute String
    | OrganizationsIndexRoute
    | NewOrganizationRoute


type ToolsNestedRoute
    = ToolRoute String
    | ToolsIndexRoute
    | NewToolRoute


type UseCasesNestedRoute
    = UseCaseRoute String
    | UseCasesIndexRoute
    | NewUseCaseRoute


makeUrl : String -> String
makeUrl path =
    Hop.makeUrl routerConfig path


makeUrlFromLocation : Hop.Types.Location -> String
makeUrlFromLocation location =
    Hop.makeUrlFromLocation routerConfig location


makeUrlWithLanguage : I18n.Language -> String -> String
makeUrlWithLanguage language urlPath =
    makeUrl ("/" ++ (I18n.iso639_1FromLanguage language) ++ urlPath)


matchers : List (Hop.Types.PathMatcher Route)
matchers =
    [ match1 HomeRoute ""
    , match1 AboutRoute "/help"
    , nested1 OrganizationsRoute
        "/organizations"
        [ match1 OrganizationsIndexRoute ""
        , match1 NewOrganizationRoute "/new"
        , match2 OrganizationRoute "/" idParser
        ]
    , nested1 ToolsRoute
        "/tools"
        [ match1 ToolsIndexRoute ""
        , match1 NewToolRoute "/new"
        , match2 ToolRoute "/" idParser
        ]
    , nested1 UseCasesRoute
        "/use-cases"
        [ match1 UseCasesIndexRoute ""
        , match1 NewUseCaseRoute "/new"
        , match2 UseCaseRoute "/" idParser
        ]
    , match3 ActivationRoute "/users/" idParser "/activate"
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


getSearchQuery : Hop.Types.Location -> String
getSearchQuery location =
    Dict.get "q" location.query |> Maybe.withDefault ""


queryStringForParams : List String -> Hop.Types.Location -> String
queryStringForParams params location =
    let
        keptParams =
            params
                |> List.filterMap
                    (\k ->
                        Dict.get k location.query
                            |> Maybe.map (\v -> ( k, v ))
                    )
    in
        if List.isEmpty keptParams then
            ""
        else
            "?"
                ++ (keptParams
                        |> List.map (\( k, v ) -> k ++ "=" ++ v)
                        |> String.join "&"
                   )


replaceLanguageInLocation : I18n.Language -> Hop.Types.Location -> String
replaceLanguageInLocation language location =
    let
        urlWithoutLanguage =
            makeUrlFromLocation location
                |> String.dropLeft 3
    in
        "/" ++ (I18n.iso639_1FromLanguage language) ++ urlWithoutLanguage



-- REVERSE


urlBasePathForCardType : CardType -> String
urlBasePathForCardType cardType =
    case cardType of
        UseCaseCard ->
            "/use-cases/"

        OrganizationCard ->
            "/organizations/"

        ToolCard ->
            "/tools/"


urlBasePathForCard : Card -> String
urlBasePathForCard card =
    urlBasePathForCardType (getCardType card)


urlPathForCard : Card -> String
urlPathForCard card =
    (urlBasePathForCard card) ++ card.id
