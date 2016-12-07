module Decoders exposing (..)

import Dict exposing (Dict)
import Json.Decode exposing (..)
import Json.Decode.Extra exposing ((|:))
import String
import Types exposing (..)


ballotDecoder : Decoder Ballot
ballotDecoder =
    succeed Ballot
        |: oneOf [ ("rating" := int) `andThen` (\_ -> succeed False), succeed True ]
        |: ("id" := string)
        |: oneOf [ ("rating" := int), succeed 0 ]
        |: ("statementId" := string)
        |: oneOf [ ("updatedAt" := string), succeed "" ]
        |: ("voterId" := string)


bijectiveCardReferenceDecoder : Decoder BijectiveCardReference
bijectiveCardReferenceDecoder =
    succeed BijectiveCardReference
        |: ("targetId" := string)
        |: ("reverseKeyId" := string)


popularTagDecoder : Decoder PopularTag
popularTagDecoder =
    succeed PopularTag
        |: ("count" := (string `customDecoder` String.toFloat))
        |: ("tagId" := string)


popularTagsDataDecoder : Decoder PopularTagsData
popularTagsDataDecoder =
    ("data"
        := (succeed PopularTagsData
                |: ("popularity" := list popularTagDecoder)
                |: (oneOf [ ("values" := dict valueDecoder), succeed Dict.empty ])
           )
    )


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
        |: oneOf [ ("references" := dict (list string)), succeed Dict.empty ]
        |: oneOf [ ("subTypeIds" := list string), succeed [] ]
        |: oneOf [ ("tagIds" := list string), succeed [] ]
        |: ("type" := string)
        |: oneOf [ ("usageIds" := list string), succeed [] ]


collectionDecoder : Decoder Collection
collectionDecoder =
    succeed Collection
        |: ("authorId" := string)
        |: ("cardIds" := list string)
        |: ("description" := string)
        |: ("id" := string)
        |: ("logo" := string)
        |: ("name" := string)


dataIdDecoder : Decoder DataId
dataIdDecoder =
    succeed DataId
        |: oneOf [ ("ballots" := dict ballotDecoder), succeed Dict.empty ]
        |: oneOf [ ("cards" := dict cardDecoder), succeed Dict.empty ]
        |: oneOf [ ("collections" := dict collectionDecoder), succeed Dict.empty ]
        |: ("id" := string)
        |: (oneOf [ ("properties" := dict propertyDecoder), succeed Dict.empty ])
        |: (oneOf [ ("users" := dict userDecoder), succeed Dict.empty ])
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
                    succeed ( Dict.empty, Dict.empty, Dict.empty, Dict.empty, Dict.empty )
                 else
                    object5 (,,,,)
                        (oneOf [ ("ballots" := dict ballotDecoder), succeed Dict.empty ])
                        (oneOf [ ("cards" := dict cardDecoder), succeed Dict.empty ])
                        (oneOf [ ("collections" := dict collectionDecoder), succeed Dict.empty ])
                        (oneOf [ ("properties" := dict propertyDecoder), succeed Dict.empty ])
                        ("values" := dict valueDecoder)
                )
                    |> map
                        (\( ballots, cards, collections, properties, values ) ->
                            DataIds ballots cards collections ids properties users values
                        )
            )


dataIdsBodyDecoder : Decoder DataIdsBody
dataIdsBodyDecoder =
    succeed DataIdsBody
        |: oneOf [ ("count" := string `customDecoder` String.toInt), succeed 0 ]
        |: ("data" := dataIdsDecoder)
        |: oneOf [ ("limit" := int), succeed 0 ]
        |: oneOf [ ("offset" := int), succeed 0 ]


messageBodyDecoder : Decoder String
messageBodyDecoder =
    ("data" := string)


propertyDecoder : Decoder Property
propertyDecoder =
    succeed Property
        |: oneOf [ ("ballotId" := string), succeed "" ]
        |: ("createdAt" := string)
        |: oneOf [ ("deleted" := bool), succeed False ]
        |: ("id" := string)
        |: ("keyId" := string)
        |: ("objectId" := string)
        |: oneOf [ ("properties" := dict string), succeed Dict.empty ]
        |: oneOf [ ("rating" := int), succeed 0 ]
        |: oneOf [ ("ratingCount" := int), succeed 0 ]
        |: oneOf [ ("ratingSum" := int), succeed 0 ]
        |: oneOf [ ("references" := dict (list string)), succeed Dict.empty ]
        |: oneOf [ ("subTypeIds" := list string), succeed [] ]
        |: oneOf [ ("tags" := list (dict string)), succeed [] ]
        |: ("type" := string)
        |: ("valueId" := string)


userBodyDecoder : Decoder UserBody
userBodyDecoder =
    succeed UserBody
        |: ("data" := userDecoder)


userDecoder : Decoder User
userDecoder =
    succeed User
        |: ("activated" := bool)
        |: oneOf [ ("apiKey" := string), succeed "" ]
        |: oneOf [ ("email" := string), succeed "" ]
        |: ("name" := string)
        |: ("urlName" := string)


userForPortDecoder : Decoder User
userForPortDecoder =
    succeed User
        -- Workaround a bug in ports that removes boolean values.
        |:
            (("activated" := string)
                `andThen`
                    (\activated ->
                        succeed (not (String.isEmpty activated))
                    )
            )
        |: ("apiKey" := string)
        |: ("email" := string)
        |: ("name" := string)
        |: ("urlName" := string)


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
                    |> map (\value -> Types.Value createdAt id schemaId type_ value widgetId)
            )


valueTypeDecoder : String -> Decoder ValueType
valueTypeDecoder schemaId =
    let
        decoder =
            case schemaId of
                "schema:bijective-card-reference" ->
                    bijectiveCardReferenceDecoder |> map BijectiveCardReferenceValue

                "schema:boolean" ->
                    bool |> map BooleanValue

                "schema:card-id" ->
                    string |> map CardIdValue

                "schema:card-ids-array" ->
                    list string |> map CardIdArrayValue

                "schema:localized-string" ->
                    dict string |> map LocalizedStringValue

                "schema:number" ->
                    float |> map NumberValue

                "schema:string" ->
                    string |> map StringValue

                "schema:uri" ->
                    string |> map StringValue

                "schema:value-ids-array" ->
                    list string |> map ValueIdArrayValue

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
