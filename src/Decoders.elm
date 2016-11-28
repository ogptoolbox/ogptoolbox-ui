module Decoders exposing (..)

import Dict exposing (Dict)
import Json.Decode exposing (..)
import Json.Decode.Extra exposing ((|:))
import String
import Types exposing (..)


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
        |: ("subTypes" := list string)
        |: oneOf [ ("tags" := list (dict string)), succeed [] ]
        |: ("type" := string)


dataIdDecoder : String -> List String -> Decoder DataId
dataIdDecoder cardId cardTypes =
    -- object2 (,)
    --     ("cards" := dict cardDecoder)
    --     ("id" := string)
    --     `customDecoder`
    --         (\( id, cards ) ->
    --             validateCard cardId cardTypes cards
    --                 |> Result.map (\_ -> DataId id cards)
    --         )
    succeed DataId
        |: ("cards" := dict cardDecoder)
        |: ("id" := string)
        |: ("values" := dict valueDecoder)


dataIdBodyDecoder : String -> List String -> Decoder DataIdBody
dataIdBodyDecoder statementId cardTypes =
    succeed DataIdBody
        |: ("data" := (dataIdDecoder statementId cardTypes))


dataIdsDecoder : Decoder DataIds
dataIdsDecoder =
    object3 (,,)
        ("ids" := list string)
        (oneOf [ ("users" := dict userDecoder), succeed Dict.empty ])
        ("values" := dict valueDecoder)
        `andThen`
            (\( ids, users, values ) ->
                (if List.isEmpty ids then
                    succeed Dict.empty
                 else
                    ("cards" := dict cardDecoder)
                )
                    |> map (\cards -> DataIds cards ids users values)
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
                ("value" := valueTypeDecoder schemaId)
                    |> map
                        (\value ->
                            let
                                v : Types.Value
                                v =
                                    Types.Value createdAt id schemaId type_ value widgetId
                            in
                                v
                        )
            )


valueTypeDecoder : String -> Decoder ValueType
valueTypeDecoder schemaId =
    case schemaId of
        "/types/string" ->
            string |> map StringValue

        _ ->
            -- fail ("Unsupported schemaId: " ++ schemaId)
            oneOf
                [ int |> map IntValue
                , float |> map FloatValue
                , string |> map StringValue
                , list string |> map (\x -> StringValue (toString x))
                , dict string |> map (\x -> StringValue (toString x))
                , list (dict string) |> map (\x -> StringValue (toString x))
                , succeed (StringValue "TODO Unsupported schemaId")
                ]
