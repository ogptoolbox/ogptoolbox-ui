module Decoders exposing (..)

import Dict exposing (Dict)
import Json.Decode exposing (..)
import Json.Decode.Extra exposing ((|:))
import String
import Types exposing (..)


bijectiveUriReferenceDecoder : Decoder BijectiveUriReference
bijectiveUriReferenceDecoder =
    succeed BijectiveUriReference
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
                "schema:string" ->
                    string |> map StringValue

                "schema:number" ->
                    float |> map NumberValue

                "schema:localized-string" ->
                    dict string |> map LocalizedStringValue

                "schema:localized-strings-array" ->
                    list (dict string) |> map (\xs -> ArrayValue (List.map LocalizedStringValue xs))

                "schema:bijective-uri-reference" ->
                    bijectiveUriReferenceDecoder |> map BijectiveUriReferenceValue

                _ ->
                    -- oneOf
                    --     [ float |> map NumberValue
                    --     , string |> map StringValue
                    --       -- , list string |> map ArrayValue
                    --     , dict string
                    --         |> map
                    --             (\decodedValue ->
                    --                 if decodedValue |> Dict.keys |> List.all (\str -> String.length str == 2) then
                    --                     LocalizedStringValue decodedValue
                    --                 else
                    --                     StringValue (toString decodedValue)
                    --             )
                    --       -- , succeed |> map (\x -> StringValue ("TODO Unsupported schemaId, value as string is: " ++ (toString x)))
                    --     ]
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
