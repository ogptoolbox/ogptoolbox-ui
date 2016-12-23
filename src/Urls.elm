module Urls exposing (..)

import Configuration
import Dict exposing (Dict)
import Erl
import Http
import I18n
import List.Extra
import Navigation
import Types exposing (..)


absoluteUrlPathWithLanguage : I18n.Language -> String -> String
absoluteUrlPathWithLanguage language urlPath =
    "/" ++ (I18n.iso639_1FromLanguage language) ++ urlPath


appLogoFullUrl : String
appLogoFullUrl =
    Configuration.appUrl ++ "img/ogptoolbox-logo.png"


fullApiUrl : String -> String
fullApiUrl url =
    let
        parsedApiUrl =
            Erl.parse Configuration.apiUrl

        parsedUrl =
            Erl.parse <| String.trim url
    in
        if List.isEmpty <| List.filter (not << String.isEmpty) parsedUrl.host then
            Erl.toString <|
                { parsedUrl
                    | host = parsedApiUrl.host
                    , port_ = parsedApiUrl.port_
                    , protocol = parsedApiUrl.protocol
                }
        else
            url


fullUrl : String -> String
fullUrl url =
    let
        parsedAppUrl =
            Erl.parse Configuration.appUrl

        parsedUrl =
            Erl.parse <| String.trim url
    in
        if List.isEmpty <| List.filter (not << String.isEmpty) parsedUrl.host then
            Erl.toString <|
                { parsedUrl
                    | host = parsedAppUrl.host
                    , port_ = parsedAppUrl.port_
                    , protocol = parsedAppUrl.protocol
                }
        else
            url


imageFullUrl : I18n.Language -> String -> Card -> Dict String Value -> Maybe String
imageFullUrl language dim card values =
    case logoFullUrl language dim card values of
        Nothing ->
            screenshotFullUrl language dim card values

        Just url ->
            Just url


imageOrAppLogoFullUrl : I18n.Language -> String -> Dict String Card -> Dict String Value -> String
imageOrAppLogoFullUrl language cardId cards values =
    case Dict.get cardId cards of
        Nothing ->
            appLogoFullUrl

        Just card ->
            case I18n.getOneString language imageUrlPathKeys card values of
                Nothing ->
                    appLogoFullUrl

                Just urlPath ->
                    fullApiUrl urlPath


logoFullUrl : I18n.Language -> String -> Card -> Dict String Value -> Maybe String
logoFullUrl language dim card values =
    I18n.getOneString language imageLogoUrlPathKeys card values
        |> Maybe.map
            (\urlPath -> fullApiUrl urlPath ++ "?dim=" ++ dim)


parentUrl : String -> String
parentUrl url =
    let
        parsedUrl =
            Erl.parse url
    in
        if List.isEmpty <| List.filter (not << String.isEmpty) parsedUrl.path then
            url
        else
            Erl.toString <| { parsedUrl | path = List.Extra.init parsedUrl.path |> Maybe.withDefault [] }


querySearchTerm : Navigation.Location -> String
querySearchTerm location =
    querySingleParameter "q" location
        |> Maybe.withDefault ""


querySingleParameter : String -> Navigation.Location -> Maybe String
querySingleParameter key location =
    (Erl.parse location.href).query
        |> List.filter (\( k, v ) -> k == key)
        |> List.map (\( k, v ) -> v)
        |> List.head


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


screenshotFullUrl : I18n.Language -> String -> Card -> Dict String Value -> Maybe String
screenshotFullUrl language dim card values =
    I18n.getOneString language imageScreenshotUrlPathKeys card values
        |> Maybe.map
            (\urlPath -> fullApiUrl urlPath ++ "?dim=" ++ dim)


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
