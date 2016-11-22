module Requests exposing (..)

import Authenticator.Model
import Configuration exposing (apiUrl)
import Decoders exposing (..)
import Http
import String
import Types exposing (..)
import Task exposing (Task)


cardTypesForExample : List String
cardTypesForExample =
    [ "Final Use" ]


cardTypesForOrganization : List String
cardTypesForOrganization =
    [ "Organization" ]


cardTypesForTool : List String
cardTypesForTool =
    [ "Software", "Platform" ]


newTaskGetCardOfType : Maybe Authenticator.Model.Authentication -> List String -> String -> Task Http.Error Statement
newTaskGetCardOfType authenticationMaybe cardTypes statementId =
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
            (statementDecoderFromBody statementId cardTypes)
            (Http.send Http.defaultSettings
                { verb = "GET"
                , url = apiUrl ++ "statements/" ++ statementId
                , headers =
                    [ ( "Accept", "application/json" )
                    ]
                        ++ authenticationHeaders
                , body = Http.empty
                }
            )


newTaskGetCardsOfType :
    Maybe Authenticator.Model.Authentication
    -> List String
    -> String
    -> Task Http.Error (List Statement)
newTaskGetCardsOfType authenticationMaybe cardTypes searchQuery =
    let
        authenticationHeaders =
            case authenticationMaybe of
                Just authentication ->
                    [ ( "Retruco-API-Key", authentication.apiKey )
                    ]

                Nothing ->
                    []
    in
        Http.fromJson statementsDecoder
            (Http.send Http.defaultSettings
                { verb = "GET"
                , url =
                    apiUrl
                        ++ "statements?"
                        ++ (cardTypes
                                |> List.map (\cardType -> "type=" ++ cardType)
                                |> String.join "&"
                           )
                        ++ "&term="
                        ++ searchQuery
                , headers =
                    [ ( "Accept", "application/json" )
                    ]
                        ++ authenticationHeaders
                , body = Http.empty
                }
            )


newTaskGetExample : Maybe Authenticator.Model.Authentication -> String -> Task Http.Error Statement
newTaskGetExample authenticationMaybe statementId =
    newTaskGetCardOfType authenticationMaybe cardTypesForExample statementId


newTaskGetExamples : Maybe Authenticator.Model.Authentication -> String -> Task Http.Error (List Statement)
newTaskGetExamples authenticationMaybe searchQuery =
    newTaskGetCardsOfType authenticationMaybe cardTypesForExample searchQuery


newTaskGetOrganization : Maybe Authenticator.Model.Authentication -> String -> Task Http.Error Statement
newTaskGetOrganization authenticationMaybe statementId =
    newTaskGetCardOfType authenticationMaybe cardTypesForOrganization statementId


newTaskGetOrganizations : Maybe Authenticator.Model.Authentication -> String -> Task Http.Error (List Statement)
newTaskGetOrganizations authenticationMaybe searchQuery =
    newTaskGetCardsOfType authenticationMaybe cardTypesForOrganization searchQuery


newTaskGetTool : Maybe Authenticator.Model.Authentication -> String -> Task Http.Error Statement
newTaskGetTool authenticationMaybe statementId =
    newTaskGetCardOfType authenticationMaybe cardTypesForTool statementId


newTaskGetTools : Maybe Authenticator.Model.Authentication -> String -> Task Http.Error (List Statement)
newTaskGetTools authenticationMaybe searchQuery =
    newTaskGetCardsOfType authenticationMaybe cardTypesForTool searchQuery
