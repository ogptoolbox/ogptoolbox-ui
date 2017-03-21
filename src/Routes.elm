module Routes exposing (..)

import Authenticator.Routes
import I18n
import Navigation
import UrlParser exposing ((</>), map, oneOf, parsePath, Parser, remaining, s, string, top)


type CollectionsRoute
    = CollectionEditRoute (Maybe String)
    | CollectionRoute String
    | CollectionsIndexRoute


type LocalizedRoute
    = AboutRoute
    | AuthenticatorRoute Authenticator.Routes.Route
    | CollectionsRoute CollectionsRoute
    | FaqRoute
    | HomeRoute
    | NotFoundRoute (List String)
    | OgpRoute
    | OrganizationsRoute OrganizationsRoute
    | PressRoute
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
        , map (CollectionEditRoute Nothing) (s "new")
        , map CollectionRoute idParser
        , map (CollectionEditRoute << Just) (idParser </> s "edit")
        ]


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
        , map OgpRoute (s "ogp")
        , map OrganizationsRoute (s "organizations" </> organizationsRouteParser)
        , map PressRoute (s "press")
        , map UserProfileRoute (s "profile")
        , map ToolsRoute (s "tools" </> toolsRouteParser)
        , map UseCasesRoute (s "use-cases" </> useCasesRouteParser)
        , map
            (AuthenticatorRoute << Authenticator.Routes.ActivateRoute)
            (s "users" </> idParser </> s "activate")
        , map
            (AuthenticatorRoute << Authenticator.Routes.ChangePasswordRoute)
            (s "users" </> idParser </> s "reset-password")
        , map NotFoundRoute remaining
        ]


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


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        (List.map
            (\language ->
                map (I18nRouteWithLanguage language) (s (I18n.iso639_1FromLanguage language) </> localizedRouteParser)
            )
            [ I18n.Bulgarian
            , I18n.Croatian
            , I18n.Czech
            , I18n.Danish
            , I18n.Dutch
            , I18n.English
            , I18n.Estonian
            , I18n.Finnish
            , I18n.French
            , I18n.German
            , I18n.Greek
            , I18n.Hungarian
            , I18n.Irish
            , I18n.Italian
            , I18n.Latvian
            , I18n.Lithuanian
            , I18n.Maltese
            , I18n.Polish
            , I18n.Portuguese
            , I18n.Romanian
            , I18n.Slovak
            , I18n.Slovenian
            , I18n.Spanish
            , I18n.Swedish
            ]
        )


toolsRouteParser : Parser (ToolsRoute -> a) a
toolsRouteParser =
    oneOf
        [ map ToolsIndexRoute top
        , map NewToolRoute (s "new")
        , map ToolRoute idParser
        ]


useCasesRouteParser : Parser (UseCasesRoute -> a) a
useCasesRouteParser =
    oneOf
        [ map UseCasesIndexRoute top
        , map NewUseCaseRoute (s "new")
        , map UseCaseRoute idParser
        ]
