module Requests exposing (..)

import AddNewCollection.Types exposing (..)
import Authenticator.Model
import Configuration exposing (apiUrl)
import Decoders exposing (..)
import Dict exposing (Dict)
import Http
import I18n
import Json.Decode as Decode
import Json.Encode as Encode
import Regex
import String
import Types exposing (..)
import Task exposing (Task)


idRegex : Regex.Regex
idRegex =
    Regex.regex "(^|/)(\\d+)(\\?|$)"


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


authenticationHeaders : Maybe Authenticator.Model.Authentication -> List ( String, String )
authenticationHeaders authentication =
    case authentication of
        Just authentication ->
            [ ( "Retruco-API-Key", authentication.apiKey )
            , ( "Cache-Control", "no-cache" )
              -- Don't cache API requests when user is logged.
            ]

        Nothing ->
            []


extractId : String -> Maybe String
extractId url =
    (Regex.find Regex.All idRegex url
        |> List.head
    )
        `Maybe.andThen`
            (\match ->
                case match.submatches |> List.drop 1 |> List.head of
                    Nothing ->
                        Nothing

                    Just maybe ->
                        maybe
            )


getCard : Maybe Authenticator.Model.Authentication -> String -> Task Http.Error DataIdBody
getCard authentication cardId =
    Http.fromJson dataIdBodyDecoder
        (Http.send Http.defaultSettings
            { verb = "GET"
            , url = apiUrl ++ "objects/" ++ cardId ++ "?show=references&show=values&depth=2"
            , headers = ( "Accept", "application/json" ) :: authenticationHeaders authentication
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
            , headers = ( "Accept", "application/json" ) :: authenticationHeaders authentication
            , body = Http.empty
            }
        )


getCollection : String -> Task Http.Error DataIdBody
getCollection collectionId =
    Http.fromJson dataIdBodyDecoder
        (Http.send Http.defaultSettings
            { verb = "GET"
            , url = apiUrl ++ "collections/" ++ collectionId ++ "?show=values&depth=2"
            , headers = [ ( "Accept", "application/json" ) ]
            , body = Http.empty
            }
        )


getCollections : Maybe Int -> Task Http.Error DataIdsBody
getCollections limit =
    Http.fromJson dataIdsBodyDecoder
        (Http.send Http.defaultSettings
            { verb = "GET"
            , url =
                apiUrl
                    ++ "collections?show=values&depth=1"
                    ++ (case limit of
                            Nothing ->
                                ""

                            Just limit ->
                                "&limit=" ++ (toString limit)
                       )
            , headers = [ ( "Accept", "application/json" ) ]
            , body = Http.empty
            }
        )


getCollectionsForAuthor : Authenticator.Model.Authentication -> Task Http.Error DataIdsBody
getCollectionsForAuthor authentication =
    Http.fromJson dataIdsBodyDecoder
        (Http.send Http.defaultSettings
            { verb = "GET"
            , url = apiUrl ++ "users/" ++ authentication.urlName ++ "/collections?show=values&depth=1"
            , headers =
                [ ( "Accept", "application/json" )
                , ( "Retruco-API-Key", authentication.apiKey )
                ]
            , body = Http.empty
            }
        )


getObjectProperties : Maybe Authenticator.Model.Authentication -> String -> String -> Task Http.Error DataIdsBody
getObjectProperties authentication objectId keyId =
    Http.fromJson dataIdsBodyDecoder
        (Http.send Http.defaultSettings
            { verb = "GET"
            , url = apiUrl ++ "objects/" ++ objectId ++ "/properties/" ++ keyId ++ "?show=ballots&show=values&depth=1"
            , headers = ( "Accept", "application/json" ) :: authenticationHeaders authentication
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
        languageCode =
            I18n.iso639_1FromLanguage language

        localizedStringEncoder x =
            Encode.object [ ( languageCode, Encode.string x ) ]

        body =
            Encode.object
                -- Always use en(glish) language because this is the language of the labels below.
                -- [ ( "language", Encode.string (I18n.iso639_1FromLanguage language) )
                [ ( "language", Encode.string "en" )
                , ( "schemas"
                  , Encode.object
                        [ ( "Description", Encode.string "schema:localized-string" )
                        , ( "Download", Encode.string "schema:uri" )
                        , ( "Logo", Encode.string "schema:uri" )
                        , ( "Name", Encode.string "schema:localized-string" )
                        , ( "Types", Encode.string "schema:value-id" )
                        , ( "Website", Encode.string "schema:uri" )
                        ]
                  )
                , ( "values"
                  , [ ( "Description", localizedStringEncoder )
                    , ( "Download", Encode.string )
                    , ( "Logo", Encode.string )
                    , ( "Name", localizedStringEncoder )
                    , ( "Types", Encode.string )
                    , ( "Website", Encode.string )
                    ]
                        |> List.filterMap
                            (\( k, encoder ) ->
                                Maybe.map (\v -> ( k, encoder v )) (Dict.get k fields)
                            )
                        |> Encode.object
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
                        ++ authenticationHeaders authentication
                , body = body
                }
            )


postCollection : Maybe Authenticator.Model.Authentication -> Maybe String -> AddNewCollectionFields -> String -> Task Http.Error DataIdBody
postCollection authentication editedCollectionId fields imageUrlPath =
    let
        cardIds : List String
        cardIds =
            String.words fields.cardIds |> List.filterMap extractId

        url =
            (case editedCollectionId of
                Just collectionId ->
                    apiUrl ++ "collections/" ++ collectionId

                Nothing ->
                    apiUrl ++ "collections"
            )
    in
        Http.fromJson dataIdBodyDecoder
            (Http.send Http.defaultSettings
                { verb = "POST"
                , url = url
                , headers =
                    [ ( "Accept", "application/json" )
                    , ( "Content-Type", "application/json" )
                    ]
                        ++ authenticationHeaders authentication
                , body =
                    Encode.object
                        [ ( "cardIds", Encode.list (List.map Encode.string cardIds) )
                        , ( "description", Encode.string fields.description )
                        , ( "logo", Encode.string imageUrlPath )
                        , ( "name", Encode.string fields.name )
                        ]
                        |> Encode.encode 2
                        |> Http.string
                }
            )


postProperty : Maybe Authenticator.Model.Authentication -> String -> String -> String -> Task Http.Error DataIdBody
postProperty authentication objectId keyId valueId =
    Http.fromJson dataIdBodyDecoder
        (Http.send Http.defaultSettings
            { verb = "POST"
            , url = apiUrl ++ "properties?show=ballots&show=values&depth=1"
            , headers =
                [ ( "Accept", "application/json" )
                , ( "Content-Type", "application/json" )
                ]
                    ++ authenticationHeaders authentication
            , body =
                Encode.object
                    [ ( "keyId", Encode.string keyId )
                    , ( "objectId", Encode.string objectId )
                    , ( "valueId", Encode.string valueId )
                    ]
                    |> Encode.encode 2
                    |> Http.string
            }
        )


postRating : Maybe Authenticator.Model.Authentication -> String -> Int -> Task Http.Error DataIdBody
postRating authentication propertyId rating =
    Http.fromJson dataIdBodyDecoder
        (Http.send Http.defaultSettings
            { verb = "POST"
            , url = apiUrl ++ "statements/" ++ propertyId ++ "/rating?show=ballots&depth=1"
            , headers =
                [ ( "Accept", "application/json" )
                , ( "Content-Type", "application/json" )
                ]
                    ++ authenticationHeaders authentication
            , body = Encode.object [ ( "rating", Encode.int rating ) ] |> Encode.encode 2 |> Http.string
            }
        )


postUploadImage : Maybe Authenticator.Model.Authentication -> String -> Task Http.Error String
postUploadImage authentication contents =
    Http.fromJson (Decode.at [ "data", "path" ] Decode.string)
        (Http.send Http.defaultSettings
            { verb = "POST"
            , url = apiUrl ++ "uploads/images/json"
            , headers =
                [ ( "Accept", "application/json" )
                , ( "Content-Type", "application/json" )
                ]
                    ++ authenticationHeaders authentication
            , body =
                Encode.object [ ( "file", Encode.string contents ) ]
                    |> Encode.encode 2
                    |> Http.string
            }
        )


postValue : Maybe Authenticator.Model.Authentication -> Field -> Task Http.Error DataIdBody
postValue authentication field =
    let
        ( schemaId, widgetId, encodedValue ) =
            case field of
                LocalizedInputTextField language string ->
                    ( "schema:localized-string"
                    , "widget:input-text"
                    , Encode.object
                        [ ( language, Encode.string string )
                        ]
                    )

                LocalizedTextareaField language string ->
                    ( "schema:localized-string"
                    , "widget:textarea"
                    , Encode.object
                        [ ( language, Encode.string string )
                        ]
                    )

                InputNumberField float ->
                    ( "schema:number", "widget:input-number", Encode.float float )

                BooleanField bool ->
                    ( "schema:boolean", "widget:input-checkbox", Encode.bool bool )

                InputEmailField string ->
                    ( "schema:email", "widget:input-email", Encode.string string )

                InputUrlField string ->
                    ( "schema:uri", "widget:input-url", Encode.string string )

                ImageField string ->
                    ( "schema:uri", "widget:image", Encode.string string )

                CardIdField string ->
                    case extractId string of
                        Just cardId ->
                            ( "schema:card-id", "widget:autocomplete", Encode.string cardId )

                        Nothing ->
                            -- TODO: Improve errors handling.
                            ( "schema:string", "widget:input-text", Encode.string string )
    in
        Http.fromJson dataIdBodyDecoder
            (Http.send Http.defaultSettings
                { verb = "POST"
                , url = apiUrl ++ "values"
                , headers =
                    [ ( "Accept", "application/json" )
                    , ( "Content-Type", "application/json" )
                    ]
                        ++ authenticationHeaders authentication
                , body =
                    Encode.object
                        [ ( "schema", Encode.string schemaId )
                        , ( "value", encodedValue )
                        , ( "widget", Encode.string widgetId )
                        ]
                        |> Encode.encode 2
                        |> Http.string
                }
            )
