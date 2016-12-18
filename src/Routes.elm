module Routes exposing (..)

import Erl
import Http
import I18n
import Navigation
import String
import Types exposing (..)
import UrlParser exposing ((</>), map, oneOf, parsePath, Parser, remaining, s, string, top)


type CollectionsRoute
    = CollectionRoute String
    | CollectionsIndexRoute
    | NewCollectionRoute
    | EditCollectionRoute String


type LocalizedRoute
    = AboutRoute
    | ActivationRoute String
    | CollectionsRoute CollectionsRoute
    | FaqRoute
    | HomeRoute
    | NotFoundRoute (List String)
    | OrganizationsRoute OrganizationsRoute
    | ToolsRoute ToolsRoute
    | UseCasesRoute UseCasesRoute
    | UserProfileRoute


type OrganizationsRoute
    = OrganizationRoute String
    | OrganizationsIndexRoute
    | NewOrganizationRoute


type Route
    = I18nRouteWithLanguage I18n.Language LocalizedRoute
    | I18nRouteWithoutLanguage String


type ToolsRoute
    = ToolRoute String
    | ToolsIndexRoute
    | NewToolRoute


type UseCasesRoute
    = UseCaseRoute String
    | UseCasesIndexRoute
    | NewUseCaseRoute


collectionsRouteParser : Parser (CollectionsRoute -> a) a
collectionsRouteParser =
    oneOf
        [ map CollectionsIndexRoute top
        , map NewCollectionRoute (s "new")
        , map CollectionRoute idParser
        , map EditCollectionRoute (idParser </> s "edit")
        ]


getQuerySearchTerm : Navigation.Location -> String
getQuerySearchTerm location =
    getQuerySingleParameter "q" location
        |> Maybe.withDefault ""


getQuerySingleParameter : String -> Navigation.Location -> Maybe String
getQuerySingleParameter key location =
    (Erl.parse location.href).query
        |> List.filter (\( k, v ) -> k == key)
        |> List.map (\( k, v ) -> v)
        |> List.head


idParser : Parser (String -> a) a
idParser =
    string


localizedRouteParser : Parser (LocalizedRoute -> a) a
localizedRouteParser =
    oneOf
        [ map HomeRoute top
        , map AboutRoute (s "about")
        , map CollectionsRoute (s "collections" </> collectionsRouteParser)
        , map FaqRoute (s "faq")
        , map OrganizationsRoute (s "organizations" </> organizationsRouteParser)
        , map UserProfileRoute (s "profile")
        , map ToolsRoute (s "tools" </> toolsRouteParser)
        , map UseCasesRoute (s "use-cases" </> useCasesRouteParser)
        , map ActivationRoute (s "users" </> idParser </> s "activate")
        , map NotFoundRoute remaining
        ]


makeUrl : String -> String
makeUrl path =
    path


makeUrlFromLocation : Navigation.Location -> String
makeUrlFromLocation location =
    location.href


makeUrlWithLanguage : I18n.Language -> String -> String
makeUrlWithLanguage language urlPath =
    makeUrl ("/" ++ (I18n.iso639_1FromLanguage language) ++ urlPath)


organizationsRouteParser : Parser (OrganizationsRoute -> a) a
organizationsRouteParser =
    oneOf
        [ map OrganizationsIndexRoute top
        , map NewOrganizationRoute (s "new")
        , map OrganizationRoute idParser
        ]


parseLocation : Navigation.Location -> Maybe Route
parseLocation location =
    UrlParser.parsePath routeParser location


queryStringForParams : List String -> Navigation.Location -> String
queryStringForParams params location =
    let
        keptQuery =
            (Erl.parse location.href).query
                |> List.filter (\( k, v ) -> List.member k params)
    in
        if List.isEmpty keptQuery then
            ""
        else
            let
                encodedTuples =
                    List.map (\( x, y ) -> ( Http.encodeUri x, Http.encodeUri y )) keptQuery

                parts =
                    List.map (\( a, b ) -> a ++ "=" ++ b) encodedTuples
            in
                "?" ++ (String.join "&" parts)


replaceLanguageInLocation : I18n.Language -> Navigation.Location -> String
replaceLanguageInLocation language location =
    let
        url =
            Erl.parse location.href

        path =
            List.tail url.path
                |> Maybe.withDefault []
                |> (::) (I18n.iso639_1FromLanguage language)

        newUrl =
            { url | path = path }
    in
        Erl.toString newUrl


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        (List.map
            (\language ->
                map (I18nRouteWithLanguage language) (s (I18n.iso639_1FromLanguage language) </> localizedRouteParser)
            )
            [ I18n.English
            , I18n.French
            , I18n.Spanish
            ]
        )


toolsRouteParser : Parser (ToolsRoute -> a) a
toolsRouteParser =
    oneOf
        [ map ToolsIndexRoute top
        , map NewToolRoute (s "new")
        , map ToolRoute idParser
        ]


urlBasePathForCardType : CardType -> String
urlBasePathForCardType cardType =
    case cardType of
        OrganizationCard ->
            "/organizations/"

        ToolCard ->
            "/tools/"

        UseCaseCard ->
            "/use-cases/"


urlBasePathForCard : Card -> String
urlBasePathForCard card =
    urlBasePathForCardType (getCardType card)


urlPathForCard : Card -> String
urlPathForCard card =
    (urlBasePathForCard card) ++ card.id


useCasesRouteParser : Parser (UseCasesRoute -> a) a
useCasesRouteParser =
    oneOf
        [ map UseCasesIndexRoute top
        , map NewUseCaseRoute (s "new")
        , map UseCaseRoute idParser
        ]
