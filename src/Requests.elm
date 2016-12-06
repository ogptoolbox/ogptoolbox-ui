module Requests exposing (..)

import Authenticator.Model
import Configuration exposing (apiUrl)
import Decoders exposing (..)
import Dict exposing (Dict)
import Http
import I18n
import Json.Decode as Decode
import Json.Encode as Encode
import String
import Types exposing (..)
import Task exposing (Task)


activateUser : String -> String -> Task Http.Error UserBody
activateUser userId authorization =
    Http.fromJson userBodyDecoder
        (Http.send Http.defaultSettings
            { verb = "GET"
            , url = apiUrl ++ "users/" ++ userId ++ "/activate?authorization=" ++ authorization
            , headers = [ ( "Accept", "application/json" ) ]
            , body = Http.empty
            }
        )


getCard : Maybe Authenticator.Model.Authentication -> String -> Task Http.Error DataIdBody
getCard authentication cardId =
    let
        authenticationHeaders =
            case authentication of
                Just authentication ->
                    [ ( "Retruco-API-Key", authentication.apiKey ) ]

                Nothing ->
                    []
    in
        Http.fromJson dataIdBodyDecoder
            (Http.send Http.defaultSettings
                { verb = "GET"
                , url = apiUrl ++ "objects/" ++ cardId ++ "?show=references&show=values&depth=2"
                , headers = ( "Accept", "application/json" ) :: authenticationHeaders
                , body = Http.empty
                }
            )


getCards :
    Maybe Authenticator.Model.Authentication
    -> String
    -> Maybe Int
    -> List String
    -> List String
    -> Task Http.Error DataIdsBody
getCards authentication searchQuery limit tagIds cardTypes =
    let
        authenticationHeaders =
            case authentication of
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
                                     , limit |> Maybe.map (\limit -> "limit=" ++ (toString limit))
                                     ]
                                        |> List.filterMap identity
                                    )
                                        ++ (tagIds
                                                |> List.filter (\s -> not (String.isEmpty s))
                                                |> List.map (\tagId -> "tag=" ++ tagId)
                                           )
                                   )
                                |> String.join "&"
                           )
                , headers = ( "Accept", "application/json" ) :: authenticationHeaders
                , body = Http.empty
                }
            )


getTagsPopularity : List String -> Task Http.Error PopularTagsData
getTagsPopularity tagIds =
    let
        url =
            apiUrl
                ++ "cards/tags-popularity?type=use-case&"
                ++ (tagIds
                        |> List.filter (\s -> not (String.isEmpty s))
                        |> List.map (\tagId -> "tag=" ++ tagId)
                        |> String.join "&"
                   )
    in
        Http.fromJson popularTagsDataDecoder
            (Http.send Http.defaultSettings
                { verb = "GET"
                , url = url
                , headers = [ ( "Accept", "application/json" ) ]
                , body = Http.empty
                }
            )


postCardsEasy :
    Maybe Authenticator.Model.Authentication
    -> Dict String String
    -> I18n.Language
    -> Task Http.Error DataIdBody
postCardsEasy authentication fields language =
    let
        authenticationHeaders =
            case authentication of
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


postUploadImage : Maybe Authenticator.Model.Authentication -> String -> Task Http.Error String
postUploadImage authentication contents =
    let
        authenticationHeaders =
            case authentication of
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
