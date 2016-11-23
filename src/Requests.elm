module Requests exposing (..)

import Authenticator.Model
import Configuration exposing (apiUrl)
import Decoders exposing (..)
import Http
import String
import Types exposing (..)
import Task exposing (Task)




newTaskGetCardOfType : List String -> Maybe Authenticator.Model.Authentication -> String -> Task Http.Error DataIdBody
newTaskGetCardOfType cardTypes authenticationMaybe statementId =
    let
        authenticationHeaders =
            case authenticationMaybe of
                Just authentication ->
                    [ ( "Retruco-API-Key", authentication.apiKey )
                    ]

                Nothing ->
                    []
    in
        Http.fromJson
            (dataIdBodyDecoder statementId cardTypes)
            (Http.send Http.defaultSettings
                { verb = "GET"
                , url = apiUrl ++ "statements/" ++ statementId ++ "?depth=1&show=references"
                , headers =
                    [ ( "Accept", "application/json" )
                    ]
                        ++ authenticationHeaders
                , body = Http.empty
                }
            )


newTaskGetCardsOfType :
    List String
    -> Maybe Authenticator.Model.Authentication
    -> String
    -> String
    -> Task Http.Error DataIdsBody
newTaskGetCardsOfType cardTypes authenticationMaybe searchQuery limit =
    let
        authenticationHeaders =
            case authenticationMaybe of
                Just authentication ->
                    [ ( "Retruco-API-Key", authentication.apiKey )
                    ]

                Nothing ->
                    []
    in
        Http.fromJson dataIdsBodyDecoder
            (Http.send Http.defaultSettings
                { verb = "GET"
                , url =
                    apiUrl
                        ++ "statements?"
                        ++ (List.map (\cardType -> "type=" ++ cardType) cardTypes
                                ++ ([ Just "depth=1"
                                    , Just "show=references"
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
                                |> String.join "&"
                           )
                , headers =
                    [ ( "Accept", "application/json" )
                    ]
                        ++ authenticationHeaders
                , body = Http.empty
                }
            )


newTaskGetExample :
    Maybe Authenticator.Model.Authentication
    -> String
    -> Task Http.Error DataIdBody
newTaskGetExample =
    newTaskGetCardOfType cardTypesForExample


newTaskGetExamples :
    Maybe Authenticator.Model.Authentication
    -> String
    -> String
    -> Task Http.Error DataIdsBody
newTaskGetExamples =
    newTaskGetCardsOfType cardTypesForExample


newTaskGetOrganization :
    Maybe Authenticator.Model.Authentication
    -> String
    -> Task Http.Error DataIdBody
newTaskGetOrganization =
    newTaskGetCardOfType cardTypesForOrganization


newTaskGetOrganizations :
    Maybe Authenticator.Model.Authentication
    -> String
    -> String
    -> Task Http.Error DataIdsBody
newTaskGetOrganizations =
    newTaskGetCardsOfType cardTypesForOrganization


newTaskGetTool :
    Maybe Authenticator.Model.Authentication
    -> String
    -> Task Http.Error DataIdBody
newTaskGetTool =
    newTaskGetCardOfType cardTypesForTool


newTaskGetTools :
    Maybe Authenticator.Model.Authentication
    -> String
    -> String
    -> Task Http.Error DataIdsBody
newTaskGetTools =
    newTaskGetCardsOfType cardTypesForTool
