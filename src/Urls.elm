module Urls exposing (..)

import Configuration
import Dict exposing (Dict)
import Erl
import I18n
import List.Extra
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


screenshotFullUrl : I18n.Language -> String -> Card -> Dict String Value -> Maybe String
screenshotFullUrl language dim card values =
    I18n.getOneString language imageScreenshotUrlPathKeys card values
        |> Maybe.map
            (\urlPath -> fullApiUrl urlPath ++ "?dim=" ++ dim)
