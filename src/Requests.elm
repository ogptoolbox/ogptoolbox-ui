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


idRegex : Regex.Regex
idRegex =
    Regex.regex "(^|/)(\\d+)(\\?|$)"


activateUser : String -> String -> Http.Request UserBody
activateUser userId authorization =
    Http.request
        { method = "GET"
        , headers = [ Http.header "Cache-Control" "no-cache" ]
        , url = apiUrl ++ "users/" ++ userId ++ "/activate?authorization=" ++ authorization
        , body = Http.emptyBody
        , expect = Http.expectJson userBodyDecoder
        , timeout = Nothing
        , withCredentials = False
        }


authenticationHeaders : Maybe Authenticator.Model.Authentication -> List Http.Header
authenticationHeaders authentication =
    case authentication of
        Just authentication ->
            [ Http.header "Retruco-API-Key" authentication.apiKey
            , Http.header "Cache-Control" "no-cache"
              -- Don't cache API requests when user is logged.
            ]

        Nothing ->
            []


extractId : String -> Maybe String
extractId url =
    (Regex.find Regex.All idRegex url
        |> List.head
    )
        |> Maybe.andThen
            (\match ->
                case match.submatches |> List.drop 1 |> List.head of
                    Nothing ->
                        Nothing

                    Just maybe ->
                        maybe
            )


getCard : Maybe Authenticator.Model.Authentication -> String -> Http.Request DataIdBody
getCard authentication cardId =
    Http.request
        { method = "GET"
        , headers = authenticationHeaders authentication
        , url = apiUrl ++ "objects/" ++ cardId ++ "?show=references&show=values&depth=2"
        , body = Http.emptyBody
        , expect = Http.expectJson dataIdBodyDecoder
        , timeout = Nothing
        , withCredentials = False
        }


getCards :
    Maybe Authenticator.Model.Authentication
    -> String
    -> Maybe Int
    -> List String
    -> List String
    -> Http.Request DataIdsBody
getCards authentication searchQuery limit tagIds cardTypes =
    Http.request
        { method = "GET"
        , headers = authenticationHeaders authentication
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
        , body = Http.emptyBody
        , expect = Http.expectJson dataIdsBodyDecoder
        , timeout = Nothing
        , withCredentials = False
        }


getCollection :
    Maybe Authenticator.Model.Authentication
    -> String
    -> Http.Request DataIdBody
getCollection authentication collectionId =
    Http.request
        { method = "GET"
        , headers = authenticationHeaders authentication
        , url = apiUrl ++ "collections/" ++ collectionId ++ "?show=values&depth=3"
        , body = Http.emptyBody
        , expect = Http.expectJson dataIdBodyDecoder
        , timeout = Nothing
        , withCredentials = False
        }


getCollections :
    Maybe Authenticator.Model.Authentication
    -> Maybe Int
    -> Http.Request DataIdsBody
getCollections authentication limit =
    Http.request
        { method = "GET"
        , headers = authenticationHeaders authentication
        , url =
            apiUrl
                ++ "collections?show=values&depth=1"
                ++ (case limit of
                        Nothing ->
                            ""

                        Just limit ->
                            "&limit=" ++ (toString limit)
                   )
        , body = Http.emptyBody
        , expect = Http.expectJson dataIdsBodyDecoder
        , timeout = Nothing
        , withCredentials = False
        }


getCollectionsForAuthor : Authenticator.Model.Authentication -> Http.Request DataIdsBody
getCollectionsForAuthor authentication =
    Http.request
        { method = "GET"
        , headers = authenticationHeaders (Just authentication)
        , url = apiUrl ++ "users/" ++ authentication.urlName ++ "/collections?show=values&depth=1"
        , body = Http.emptyBody
        , expect = Http.expectJson dataIdsBodyDecoder
        , timeout = Nothing
        , withCredentials = False
        }


getObjectProperties :
    Maybe Authenticator.Model.Authentication
    -> String
    -> String
    -> Http.Request DataIdsBody
getObjectProperties authentication objectId keyId =
    Http.request
        { method = "GET"
        , headers = authenticationHeaders authentication
        , url = apiUrl ++ "objects/" ++ objectId ++ "/properties/" ++ keyId ++ "?show=ballots&show=values&depth=1"
        , body = Http.emptyBody
        , expect = Http.expectJson dataIdsBodyDecoder
        , timeout = Nothing
        , withCredentials = False
        }


getTagsPopularity :
    Maybe Authenticator.Model.Authentication
    -> List String
    -> Http.Request PopularTagsData
getTagsPopularity authentication tagIds =
    Http.request
        { method = "GET"
        , headers = authenticationHeaders authentication
        , url =
            apiUrl
                ++ "cards/tags-popularity?type=use-case&"
                ++ (tagIds
                        |> List.filter (\s -> not (String.isEmpty s))
                        |> List.map (\tagId -> "tag=" ++ tagId)
                        |> String.join "&"
                   )
        , body = Http.emptyBody
        , expect = Http.expectJson popularTagsDataDecoder
        , timeout = Nothing
        , withCredentials = False
        }


postCard :
    Maybe Authenticator.Model.Authentication
    -> Dict String String
    -> I18n.Language
    -> Http.Request DataIdBody
postCard authentication fields language =
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
                |> Http.jsonBody
    in
        Http.request
            { method = "POST"
            , headers = authenticationHeaders authentication
            , url = apiUrl ++ "cards/easy"
            , body = body
            , expect = Http.expectJson dataIdBodyDecoder
            , timeout = Nothing
            , withCredentials = False
            }


postCollection :
    Maybe Authenticator.Model.Authentication
    -> Maybe String
    -> AddNewCollectionFields
    -> String
    -> Http.Request DataIdBody
postCollection authentication editedCollectionId fields imageUrlPath =
    let
        cardIds : List String
        cardIds =
            String.words fields.cardIds |> List.filterMap extractId

        url =
            case editedCollectionId of
                Just collectionId ->
                    apiUrl ++ "collections/" ++ collectionId

                Nothing ->
                    apiUrl ++ "collections"
    in
        Http.request
            { method = "POST"
            , headers = authenticationHeaders authentication
            , url = url
            , body =
                Encode.object
                    [ ( "cardIds", Encode.list (List.map Encode.string cardIds) )
                    , ( "description", Encode.string fields.description )
                    , ( "logo", Encode.string imageUrlPath )
                    , ( "name", Encode.string fields.name )
                    ]
                    |> Http.jsonBody
            , expect = Http.expectJson dataIdBodyDecoder
            , timeout = Nothing
            , withCredentials = False
            }


postProperty :
    Maybe Authenticator.Model.Authentication
    -> String
    -> String
    -> String
    -> Http.Request DataIdBody
postProperty authentication objectId keyId valueId =
    Http.request
        { method = "POST"
        , headers = authenticationHeaders authentication
        , url = apiUrl ++ "properties?show=ballots&show=values&depth=3"
        , body =
            Encode.object
                [ ( "keyId", Encode.string keyId )
                , ( "objectId", Encode.string objectId )
                , ( "valueId", Encode.string valueId )
                ]
                |> Http.jsonBody
        , expect = Http.expectJson dataIdBodyDecoder
        , timeout = Nothing
        , withCredentials = False
        }


postRating : Maybe Authenticator.Model.Authentication -> String -> Int -> Http.Request DataIdBody
postRating authentication propertyId rating =
    Http.request
        { method = "POST"
        , headers = authenticationHeaders authentication
        , url = apiUrl ++ "statements/" ++ propertyId ++ "/rating?show=ballots&depth=1"
        , body = Encode.object [ ( "rating", Encode.int rating ) ] |> Http.jsonBody
        , expect = Http.expectJson dataIdBodyDecoder
        , timeout = Nothing
        , withCredentials = False
        }


postUploadImage : Maybe Authenticator.Model.Authentication -> String -> Http.Request String
postUploadImage authentication contents =
    Http.request
        { method = "POST"
        , headers = authenticationHeaders authentication
        , url = apiUrl ++ "uploads/images/json"
        , body =
            Encode.object [ ( "file", Encode.string contents ) ]
                |> Http.jsonBody
        , expect = Http.expectJson (Decode.at [ "data", "path" ] Decode.string)
        , timeout = Nothing
        , withCredentials = False
        }


postValue : Maybe Authenticator.Model.Authentication -> Field -> Http.Request DataIdBody
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
        Http.request
            { method = "POST"
            , headers = authenticationHeaders authentication
            , url = apiUrl ++ "values"
            , body =
                Encode.object
                    [ ( "schema", Encode.string schemaId )
                    , ( "value", encodedValue )
                    , ( "widget", Encode.string widgetId )
                    ]
                    |> Http.jsonBody
            , expect = Http.expectJson dataIdBodyDecoder
            , timeout = Nothing
            , withCredentials = False
            }
