module Requests exposing (..)

import Authenticator.Model
import Configuration exposing (apiUrl)
import Decoders exposing (..)
import Dict exposing (Dict)
import Http
import I18n
import Json.Decode as Decode
import Json.Encode as Encode
import Set exposing (Set)
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
                , url = apiUrl ++ "objects/" ++ cardId ++ "?show=values&depth=1"
                , headers = ( "Accept", "application/json" ) :: authenticationHeaders
                , body = Http.empty
                }
            )


newTaskGetCardsOfType :
    List String
    -> Maybe Authenticator.Model.Authentication
    -> String
    -> String
    -> Set String
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
                                     , Just "depth=1"
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
                                        ++ (Set.map (\tag -> "tag=" ++ tag) tags |> Set.toList)
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
    -> Set String
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
    -> Set String
    -> Task Http.Error DataIdsBody
newTaskGetOrganizations =
    newTaskGetCardsOfType cardTypesForOrganization


newTaskGetTagsPopularity : I18n.Language -> Set String -> Task Http.Error (List PopularTag)
newTaskGetTagsPopularity language tags =
    let
        url =
            apiUrl
                ++ "cards/tags-popularity?type=type:use-case&language="
                ++ I18n.iso639_1FromLanguage language
                ++ "&"
                ++ ((Set.map (\tag -> "tag=" ++ tag) tags) |> Set.toList |> String.join "&")
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
    -> Set String
    -> Task Http.Error DataIdsBody
newTaskGetTools =
    newTaskGetCardsOfType cardTypesForTool


newTaskPostCardsEasy :
    Maybe Authenticator.Model.Authentication
    -> Dict String String
    -> I18n.Language
    -> Task Http.Error DataIdBody
newTaskPostCardsEasy authenticationMaybe fields language =
    let
        authenticationHeaders =
            case authenticationMaybe of
                Just authentication ->
                    [ ( "Retruco-API-Key", authentication.apiKey ) ]

                Nothing ->
                    []

        body =
            Encode.object
                [ ( "language", Encode.string (I18n.iso639_1FromLanguage language) )
                , ( "schemas"
                  , Encode.object
                        [ ( "Description", Encode.string "schema:string" )
                        , ( "Download", Encode.string "schema:uri" )
                        , ( "Logo", Encode.string "schema:uri" )
                        , ( "Name", Encode.string "schema:string" )
                        , ( "Types", Encode.string "schema:type-reference" )
                        , ( "Website", Encode.string "schema:uri" )
                        ]
                  )
                , ( "values"
                  , Encode.object
                        (fields
                            |> Dict.toList
                            |> List.map (\( name, value ) -> ( name, Encode.string value ))
                        )
                  )
                , ( "widgets", Encode.object [] )
                ]
                |> Encode.encode 2
                |> Http.string
    in
        Http.fromJson dataIdBodyDecoder
            (Http.send Http.defaultSettings
                { verb = "POST"
                , url = apiUrl ++ "cards/easy"
                , headers =
                    [ ( "Accept", "application/json" )
                    , ( "Content-Type", "application/json" )
                    ]
                        ++ authenticationHeaders
                , body = body
                }
            )


newTaskPostUploadImage : Maybe Authenticator.Model.Authentication -> String -> Task Http.Error String
newTaskPostUploadImage authenticationMaybe contents =
    let
        authenticationHeaders =
            case authenticationMaybe of
                Just authentication ->
                    [ ( "Retruco-API-Key", authentication.apiKey ) ]

                Nothing ->
                    []
    in
        Http.fromJson Decode.string
            (Http.send Http.defaultSettings
                { verb = "POST"
                , url = apiUrl ++ "uploads/images"
                , headers = ( "Accept", "application/json" ) :: authenticationHeaders
                , body = Http.multipart [ Http.stringData "file" contents ]
                }
            )
