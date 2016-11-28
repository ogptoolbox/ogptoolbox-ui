module Requests exposing (..)

import Authenticator.Model
import Configuration exposing (apiUrl)
import Decoders exposing (..)
import Http
import I18n
import String
import Types exposing (..)
import Task exposing (Task)


newTaskGetCardOfType : Maybe Authenticator.Model.Authentication -> String -> Task Http.Error DataIdBody
newTaskGetCardOfType authenticationMaybe cardId =
    let
        authenticationHeaders =
            case authenticationMaybe of
                Just authentication ->
                    [ ( "Retruco-API-Key", authentication.apiKey ) ]

                Nothing ->
                    []
    in
        Http.fromJson dataIdBodyDecoder
            (Http.send Http.defaultSettings
                { verb = "GET"
                , url = apiUrl ++ "objects/" ++ cardId ++ "?show=values"
                , headers = ( "Accept", "application/json" ) :: authenticationHeaders
                , body = Http.empty
                }
            )


newTaskGetCardsOfType :
    List String
    -> Maybe Authenticator.Model.Authentication
    -> String
    -> String
    -> List String
    -> Task Http.Error DataIdsBody
newTaskGetCardsOfType cardTypes authenticationMaybe searchQuery limit tags =
    let
        authenticationHeaders =
            case authenticationMaybe of
                Just authentication ->
                    [ ( "Retruco-API-Key", authentication.apiKey ) ]

                Nothing ->
                    []
    in
        Http.fromJson dataIdsBodyDecoder
            (Http.send Http.defaultSettings
                { verb = "GET"
                , url =
                    apiUrl
                        ++ "cards?"
                        ++ (List.map (\cardType -> "type=" ++ cardType) cardTypes
                                ++ (([ Just "show=values"
                                     , (if String.isEmpty searchQuery then
                                            Nothing
                                        else
                                            Just ("term=" ++ searchQuery)
                                       )
                                     , (if String.isEmpty limit then
                                            Nothing
                                        else
                                            Just ("limit=" ++ limit)
                                       )
                                     ]
                                        |> List.filterMap identity
                                    )
                                        ++ (List.map (\tag -> "tag=" ++ tag) tags)
                                   )
                                |> String.join "&"
                           )
                , headers = ( "Accept", "application/json" ) :: authenticationHeaders
                , body = Http.empty
                }
            )


newTaskGetExample :
    Maybe Authenticator.Model.Authentication
    -> String
    -> Task Http.Error DataIdBody
newTaskGetExample =
    newTaskGetCardOfType


newTaskGetExamples :
    Maybe Authenticator.Model.Authentication
    -> String
    -> String
    -> List String
    -> Task Http.Error DataIdsBody
newTaskGetExamples =
    newTaskGetCardsOfType cardTypesForExample


newTaskGetOrganization :
    Maybe Authenticator.Model.Authentication
    -> String
    -> Task Http.Error DataIdBody
newTaskGetOrganization =
    newTaskGetCardOfType


newTaskGetOrganizations :
    Maybe Authenticator.Model.Authentication
    -> String
    -> String
    -> List String
    -> Task Http.Error DataIdsBody
newTaskGetOrganizations =
    newTaskGetCardsOfType cardTypesForOrganization


newTaskGetTagsPopularity : I18n.Language -> List String -> Task Http.Error (List PopularTag)
newTaskGetTagsPopularity language tags =
    let
        url =
            apiUrl
                ++ "cards/tags-popularity?type=Final+Use&language="
                ++ I18n.iso639_1FromLanguage language
                ++ "&"
                ++ ((List.map (\tag -> "tag=" ++ tag) tags) |> String.join "&")
    in
        Http.fromJson popularTagsDecoder
            (Http.send Http.defaultSettings
                { verb = "GET"
                , url = url
                , headers = [ ( "Accept", "application/json" ) ]
                , body = Http.empty
                }
            )


newTaskGetTool :
    Maybe Authenticator.Model.Authentication
    -> String
    -> Task Http.Error DataIdBody
newTaskGetTool =
    newTaskGetCardOfType


newTaskGetTools :
    Maybe Authenticator.Model.Authentication
    -> String
    -> String
    -> List String
    -> Task Http.Error DataIdsBody
newTaskGetTools =
    newTaskGetCardsOfType cardTypesForTool
