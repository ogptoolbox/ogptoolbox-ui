module Requests exposing (..)

import Authenticator.Model
import Configuration exposing (apiUrl)
import Dict exposing (Dict)
import Http
import Json.Encode
import String
import Types exposing (..)
import Task exposing (Task)


newTaskCreateStatement : Authenticator.Model.Authentication -> StatementCustom -> Task Http.Error DataIdBody
newTaskCreateStatement authentication statementCustom =
    let
        bodyJson =
            Json.Encode.object
                ([ ( "type", Json.Encode.string (convertStatementCustomToKind statementCustom) ) ]
                    ++ case statementCustom of
                        AbuseCustom abuse ->
                            [ ( "statementId", Json.Encode.string abuse.statementId )
                            ]

                        ArgumentCustom argument ->
                            [ ( "argumentType", Json.Encode.string (convertArgumentTypeToString argument.argumentType) )
                            , ( "claimId", Json.Encode.string argument.claimId )
                            , ( "groundId", Json.Encode.string argument.groundId )
                            ]

                        CardCustom card ->
                            Debug.crash "TODO"

                        PlainCustom plain ->
                            [ ( "languageCode", Json.Encode.string plain.languageCode )
                            , ( "name", Json.Encode.string plain.name )
                            ]

                        TagCustom tag ->
                            [ ( "name", Json.Encode.string tag.name )
                            ]
                )
    in
        Http.fromJson dataIdBodyDecoder
            (Http.send Http.defaultSettings
                { verb = "POST"
                , url =
                    (apiUrl
                        ++ "statements"
                        ++ "?depth=1&show=abuse&show=author&show=ballot&show=grounds&show=properties&show=tags"
                    )
                , headers =
                    [ ( "Accept", "application/json" )
                    , ( "Content-Type", "application/json" )
                    , ( "Retruco-API-Key", authentication.apiKey )
                    ]
                , body = Http.string (Json.Encode.encode 2 bodyJson)
                }
            )


newTaskDeleteStatementRating : Authenticator.Model.Authentication -> String -> Task Http.Error DataIdBody
newTaskDeleteStatementRating authentication statementId =
    Http.fromJson dataIdBodyDecoder
        (Http.send Http.defaultSettings
            { verb = "DELETE"
            , url =
                (apiUrl
                    ++ "statements/"
                    ++ statementId
                    ++ "/rating?depth=1&show=abuse&show=author&show=ballot&show=grounds&show=properties&show=tags"
                )
            , headers =
                [ ( "Accept", "application/json" )
                , ( "Retruco-API-Key", authentication.apiKey )
                ]
            , body = Http.empty
            }
        )


newTaskFlagAbuse : Authenticator.Model.Authentication -> String -> Task Http.Error DataIdBody
newTaskFlagAbuse authentication statementId =
    Http.fromJson dataIdBodyDecoder
        (Http.send Http.defaultSettings
            { verb = "GET"
            , url =
                (apiUrl
                    ++ "statements/"
                    ++ statementId
                    ++ "/abuse?depth=1&show=abuse&show=author&show=ballot&show=grounds&show=properties&show=tags"
                )
            , headers =
                [ ( "Accept", "application/json" )
                , ( "Retruco-API-Key", authentication.apiKey )
                ]
            , body = Http.empty
            }
        )


newTaskGetCard : Maybe Authenticator.Model.Authentication -> String -> Task Http.Error DataIdBody
newTaskGetCard authenticationMaybe statementId =
    let
        authenticationHeaders =
            case authenticationMaybe of
                Just authentication ->
                    [ ( "Retruco-API-Key", authentication.apiKey )
                    ]

                Nothing ->
                    []
    in
        Http.fromJson dataIdBodyDecoder
            (Http.send Http.defaultSettings
                { verb = "GET"
                , url =
                    apiUrl ++ "statements/" ++ statementId
                , headers =
                    [ ( "Accept", "application/json" )
                    ]
                        ++ authenticationHeaders
                , body = Http.empty
                }
            )


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


newTaskGetCards : Maybe Authenticator.Model.Authentication -> Task Http.Error DataIdsBody
newTaskGetCards authenticationMaybe =
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
                    apiUrl ++ "statements?type=Card"
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
    newTaskGetCardOfType authenticationMaybe [ "Final Use" ] statementId


newTaskGetExamples : Maybe Authenticator.Model.Authentication -> String -> Task Http.Error (List Statement)
newTaskGetExamples authenticationMaybe searchQuery =
    newTaskGetCardsOfType authenticationMaybe [ "Final Use" ] searchQuery


newTaskGetOrganization : Maybe Authenticator.Model.Authentication -> String -> Task Http.Error Statement
newTaskGetOrganization authenticationMaybe statementId =
    newTaskGetCardOfType authenticationMaybe [ "Organization" ] statementId


newTaskGetOrganizations : Maybe Authenticator.Model.Authentication -> String -> Task Http.Error (List Statement)
newTaskGetOrganizations authenticationMaybe searchQuery =
    newTaskGetCardsOfType authenticationMaybe [ "Organization" ] searchQuery


newTaskGetStatements : Maybe Authenticator.Model.Authentication -> Task Http.Error DataIdsBody
newTaskGetStatements authenticationMaybe =
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
                    (apiUrl
                        ++ "statements"
                        ++ "?depth=1&show=abuse&show=author&show=ballot&show=grounds&show=properties&show=tags"
                    )
                , headers =
                    [ ( "Accept", "application/json" )
                    ]
                        ++ authenticationHeaders
                , body = Http.empty
                }
            )


newTaskGetTool : Maybe Authenticator.Model.Authentication -> String -> Task Http.Error Statement
newTaskGetTool authenticationMaybe statementId =
    newTaskGetCardOfType authenticationMaybe [ "Software", "Platform" ] statementId


newTaskGetTools : Maybe Authenticator.Model.Authentication -> String -> Task Http.Error (List Statement)
newTaskGetTools authenticationMaybe searchQuery =
    newTaskGetCardsOfType authenticationMaybe [ "Software", "Platform" ] searchQuery


newTaskRateStatement : Authenticator.Model.Authentication -> Int -> String -> Task Http.Error DataIdBody
newTaskRateStatement authentication rating statementId =
    let
        bodyJson =
            Json.Encode.object
                [ ( "rating", Json.Encode.int rating ) ]
    in
        Http.fromJson dataIdBodyDecoder
            (Http.send Http.defaultSettings
                { verb = "POST"
                , url =
                    (apiUrl
                        ++ "statements/"
                        ++ statementId
                        ++ "/rating?depth=1&show=abuse&show=author&show=ballot&show=grounds&show=properties&show=tags"
                    )
                , headers =
                    [ ( "Accept", "application/json" )
                    , ( "Content-Type", "application/json" )
                    , ( "Retruco-API-Key", authentication.apiKey )
                    ]
                , body = Http.string (Json.Encode.encode 2 bodyJson)
                }
            )


updateFromDataId : DataId -> ModelFragment a -> ModelFragment a
updateFromDataId data model =
    { model
        | ballotById =
            Dict.merge
                (\id ballot ballotById ->
                    if ballot.deleted then
                        ballotById
                    else
                        Dict.insert id ballot ballotById
                )
                (\id leftBallot rightBallot ballotById ->
                    if leftBallot.deleted then
                        ballotById
                    else
                        Dict.insert id leftBallot ballotById
                )
                Dict.insert
                data.ballots
                model.ballotById
                Dict.empty
        , statementById =
            Dict.merge
                (\id statement statementById ->
                    if statement.deleted then
                        statementById
                    else
                        Dict.insert id statement statementById
                )
                (\id leftStatement rightStatement statementById ->
                    if leftStatement.deleted then
                        statementById
                    else
                        Dict.insert id leftStatement statementById
                )
                Dict.insert
                data.statements
                model.statementById
                Dict.empty
        , statementIds =
            if Dict.member data.id data.statements then
                if List.member data.id model.statementIds then
                    model.statementIds
                else
                    data.id :: model.statementIds
            else
                -- data.id is not the ID of a statement (but a ballot ID, etc).
                model.statementIds
    }
