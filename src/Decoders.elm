module Decoders exposing (..)

import Dict exposing (Dict)
import Json.Decode exposing (..)
import Json.Decode.Extra exposing ((|:))
import String
import Types exposing (..)


bijectiveCardReferenceDecoder : Decoder BijectiveCardReference
bijectiveCardReferenceDecoder =
    succeed BijectiveCardReference
        |: ("targetId" := string)
        |: ("reverseKeyId" := string)


popularTagDecoder : Decoder PopularTag
popularTagDecoder =
    succeed PopularTag
        |: ("count" := (string `customDecoder` String.toFloat))
        |: ("tag" := string)


popularTagsDecoder : Decoder (List PopularTag)
popularTagsDecoder =
    ("data" := list popularTagDecoder)


cardDecoder : Decoder Card
cardDecoder =
    succeed Card
        |: ("createdAt" := string)
        |: oneOf [ ("deleted" := bool), succeed False ]
        |: ("id" := string)
        |: ("properties" := dict string)
        |: oneOf [ ("rating" := int), succeed 0 ]
        |: oneOf [ ("ratingCount" := int), succeed 0 ]
        |: oneOf [ ("ratingSum" := int), succeed 0 ]
        |: ("subTypeIds" := list string)
        |: oneOf [ ("tags" := list (dict string)), succeed [] ]
        |: ("type" := string)


dataIdDecoder : Decoder DataId
dataIdDecoder =
    succeed DataId
        |: ("cards" := dict cardDecoder)
        |: ("id" := string)
        |: oneOf [ ("values" := dict valueDecoder), succeed Dict.empty ]


dataIdBodyDecoder : Decoder DataIdBody
dataIdBodyDecoder =
    succeed DataIdBody
        |: ("data" := dataIdDecoder)


dataIdsDecoder : Decoder DataIds
dataIdsDecoder =
    object2 (,)
        ("ids" := list string)
        (oneOf [ ("users" := dict userDecoder), succeed Dict.empty ])
        `andThen`
            (\( ids, users ) ->
                (if List.isEmpty ids then
                    succeed ( Dict.empty, Dict.empty )
                 else
                    object2 (,)
                        ("cards" := dict cardDecoder)
                        ("values" := dict valueDecoder)
                )
                    |> map (\( cards, values ) -> DataIds cards ids users values)
            )


dataIdsBodyDecoder : Decoder DataIdsBody
dataIdsBodyDecoder =
    succeed DataIdsBody
        |: ("count" := string `customDecoder` String.toInt)
        |: ("data" := dataIdsDecoder)
        |: ("limit" := int)
        |: ("offset" := int)


userDecoder : Decoder User
userDecoder =
    succeed User
        |: ("apiKey" := string)
        |: ("email" := string)
        |: ("name" := string)
        |: ("urlName" := string)


userBodyDecoder : Decoder UserBody
userBodyDecoder =
    succeed UserBody
        |: ("data" := userDecoder)


valueDecoder : Decoder Types.Value
valueDecoder =
    object5 (,,,,)
        ("createdAt" := string)
        ("id" := string)
        ("schemaId" := string)
        ("type" := string)
        (oneOf [ ("widgetId" := string), succeed "" ])
        `andThen`
            (\( createdAt, id, schemaId, type_, widgetId ) ->
                ("value" := valueValueDecoder schemaId)
                    |> map (\value -> Types.Value createdAt id schemaId type_ value widgetId)
            )


valueValueDecoder : String -> Decoder ValueType
valueValueDecoder schemaId =
    let
        decoder =
            case schemaId of
                "schema:bijective-card-reference" ->
                    bijectiveCardReferenceDecoder |> map BijectiveCardReferenceValue

                "schema:localized-string" ->
                    dict string |> map LocalizedStringValue

                "schema:localized-strings-array" ->
                    list (dict string) |> map (\xs -> ArrayValue (List.map LocalizedStringValue xs))

                "schema:number" ->
                    float |> map NumberValue

                "schema:string" ->
                    string |> map StringValue

                "schema:strings-array" ->
                    list string |> map (\xs -> ArrayValue (List.map StringValue xs))

                "schema:type-reference" ->
                    string |> map ReferenceValue

                "schema:type-references-array" ->
                    list string |> map (\xs -> ArrayValue (List.map ReferenceValue xs))

                "schema:uri" ->
                    string |> map StringValue

                "schema:uris-array" ->
                    list string |> map (\xs -> ArrayValue (List.map StringValue xs))

                _ ->
                    fail ("TODO Unsupported schemaId: " ++ schemaId)
    in
        oneOf
            [ decoder
            , value
                |> map
                    (\value ->
                        let
                            str =
                                toString value

                            -- _ =
                            --     Debug.log ("WrongValue \"" ++ str ++ "\", schemaId: " ++ schemaId)
                        in
                            WrongValue str schemaId
                    )
            ]
