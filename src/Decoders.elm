module Decoders exposing (..)

import Dict exposing (Dict)
import Json.Decode as Decode exposing (..)
import Json.Decode.Extra exposing ((|:), sequence)
import PropertyKeys exposing (..)
import Result exposing (Result(..))
import Set
import String
import Types exposing (..)


argumentTypeDecoder : Decoder ArgumentType
argumentTypeDecoder =
    customDecoder string
        (\argumentType ->
            case argumentType of
                "because" ->
                    Ok Because

                "but" ->
                    Ok But

                "comment" ->
                    Ok Comment

                "example" ->
                    Ok Example

                _ ->
                    Err ("Unknown argument type: " ++ argumentType)
        )


ballotDecoder : Decoder Ballot
ballotDecoder =
    succeed Ballot
        |: oneOf [ ("rating" := int) `andThen` (\_ -> succeed False), succeed True ]
        |: ("id" := string)
        |: oneOf [ ("rating" := int), succeed 0 ]
        |: ("statementId" := string)
        |: oneOf [ ("updatedAt" := string), succeed "" ]
        |: ("voterId" := string)


bijectiveUriReferenceDecoder : Decoder String
bijectiveUriReferenceDecoder =
    ("targetId" := string)


cardDecoder : Decoder Card
cardDecoder =
    let
        partition : Dict comparable (Result error value) -> ( Dict comparable value, Dict comparable error )
        partition results =
            Dict.foldl
                (\key result ( values, errors ) ->
                    case result of
                        Ok value ->
                            ( Dict.insert key value values, errors )

                        Err error ->
                            ( values, Dict.insert key error errors )
                )
                ( Dict.empty, Dict.empty )
                results

        combineDict : Dict comparable (Result error value) -> Result (Dict comparable error) (Dict comparable value)
        combineDict results =
            results
                |> partition
                |> (\( values, errors ) ->
                        if Dict.isEmpty errors then
                            Ok values
                        else
                            Err errors
                   )

        mergeSchemasAndWidgets :
            Dict String JsonCardSchema
            -> Dict String CardWidget
            -> Result (Dict String String) (Dict String ( JsonCardSchema, Maybe CardWidget ))
        mergeSchemasAndWidgets schemas widgets =
            Dict.merge
                (\propertyKey schema accu -> Dict.insert propertyKey (Ok ( schema, Nothing )) accu)
                (\propertyKey schema widget accu -> Dict.insert propertyKey (Ok ( schema, Just widget )) accu)
                (\propertyKey _ accu -> Dict.insert propertyKey (Err ("Widget has no schema")) accu)
                schemas
                widgets
                Dict.empty
                |> combineDict

        mergeValues :
            Dict String Value
            -> Dict String ( JsonCardSchema, Maybe CardWidget )
            -> Result (Dict String String) (Dict String ( Value, JsonCardSchema, Maybe CardWidget ))
        mergeValues values schemasAndWidgets =
            Dict.merge
                (\propertyKey ( schema, widget ) accu -> accu)
                (\propertyKey ( schema, widget ) value accu ->
                    Dict.insert propertyKey (Ok ( value, schema, widget )) accu
                )
                (\propertyKey _ accu -> Dict.insert propertyKey (Err ("Value has no schema")) accu)
                schemasAndWidgets
                values
                Dict.empty
                |> combineDict

        toCardField : Maybe CardWidget -> JsonCardSchema -> Decoder CardField
        toCardField widget schema =
            case schema of
                StringSchema format ->
                    string
                        |> map
                            (\stringValue ->
                                StringField
                                    { format = format
                                    , value = stringValue
                                    , widget = widget
                                    }
                            )

                NumberSchema ->
                    float |> map NumberField

                ArraySchema kind ->
                    case kind of
                        ListArraySchema schema ->
                            list (toCardField Nothing schema) |> map ArrayField

                        TupleArraySchema schemas ->
                            sequence (List.map (toCardField Nothing) schemas) |> map ArrayField

                BijectiveUriReferenceSchema ->
                    bijectiveUriReferenceDecoder
                        |> map BijectiveUriReferenceField
    in
        object3 (,,)
            ("schemas" := dict jsonCardSchemaDecoder)
            ("values" := dict value)
            ("widgets" := dict cardWidgetDecoder)
            `customDecoder`
                (\( schemas, values, widgets ) ->
                    mergeSchemasAndWidgets schemas widgets
                        `Result.andThen` mergeValues values
                        `Result.andThen`
                            (Dict.map
                                (\propertyKey ( value, schema, widget ) ->
                                    decodeValue (toCardField widget schema) value
                                )
                                >> combineDict
                            )
                        |> Result.formatError (Dict.toList >> toString)
                )


cardWidgetDecoder : Decoder CardWidget
cardWidgetDecoder =
    succeed CardWidget
        |: ("tag" := string)
        |: (maybe ("type" := string))


dataIdDecoder : String -> List String -> Decoder DataId
dataIdDecoder statementId cardTypes =
    object2 (,)
        ("id" := string)
        ("statements" := dict statementDecoder)
        `customDecoder`
            (\( id, statements ) ->
                validateStatement statementId cardTypes statements
                    |> Result.map (\_ -> DataId id statements)
            )


dataIdBodyDecoder : String -> List String -> Decoder DataIdBody
dataIdBodyDecoder statementId cardTypes =
    succeed DataIdBody
        |: ("data" := (dataIdDecoder statementId cardTypes))


dataIdsDecoder : Decoder DataIds
dataIdsDecoder =
    object3 (,,)
        (oneOf [ ("ballots" := dict ballotDecoder), succeed Dict.empty ])
        ("ids" := list string)
        (oneOf [ ("users" := dict userDecoder), succeed Dict.empty ])
        `andThen`
            (\( ballots, ids, users ) ->
                (if List.isEmpty ids then
                    succeed Dict.empty
                 else
                    ("statements" := dict statementDecoder)
                )
                    |> map (\statements -> DataIds ballots ids statements users)
            )


dataIdsBodyDecoder : Decoder DataIdsBody
dataIdsBodyDecoder =
    succeed DataIdsBody
        |: ("count" := string `customDecoder` String.toInt)
        |: ("data" := dataIdsDecoder)


jsonCardSchemaDecoder : Decoder JsonCardSchema
jsonCardSchemaDecoder =
    oneOf
        [ ("type" := string)
            `andThen`
                (\schemaType ->
                    case schemaType of
                        "string" ->
                            succeed StringSchema
                                |: (maybe ("format" := string)
                                        `andThen`
                                            (\schemaFormat ->
                                                case schemaFormat of
                                                    Nothing ->
                                                        succeed Nothing

                                                    Just schemaFormat ->
                                                        case schemaFormat of
                                                            "email" ->
                                                                succeed (Just Email)

                                                            "uri" ->
                                                                succeed (Just Uri)

                                                            "uriref" ->
                                                                succeed (Just UriReference)

                                                            _ ->
                                                                fail ("Unknown card schema format: " ++ schemaFormat)
                                            )
                                   )

                        "array" ->
                            succeed ArraySchema
                                |: ("items"
                                        := oneOf
                                            [ jsonCardSchemaDecoder |> map ListArraySchema
                                            , list jsonCardSchemaDecoder |> map TupleArraySchema
                                            ]
                                   )

                        "number" ->
                            succeed NumberSchema

                        _ ->
                            fail ("Unknown card schema type: " ++ schemaType)
                )
        , ("$ref" := string) |> map (\_ -> BijectiveUriReferenceSchema)
        ]


statementDecoder : Decoder Statement
statementDecoder =
    succeed Statement
        |: maybe ("ballotId" := string)
        |: ("createdAt" := string)
        |: (("type" := string)
                `andThen`
                    (\statementType ->
                        case statementType of
                            "Abuse" ->
                                succeed Abuse
                                    |: ("statementId" := string)
                                    |> map AbuseCustom

                            "Argument" ->
                                succeed Argument
                                    |: ("argumentType" := argumentTypeDecoder)
                                    |: ("claimId" := string)
                                    |: ("groundId" := string)
                                    |> map ArgumentCustom

                            "Card" ->
                                cardDecoder
                                    |> map CardCustom

                            "PlainStatement" ->
                                succeed Plain
                                    |: ("languageCode" := string)
                                    |: ("name" := string)
                                    |> map PlainCustom

                            "Tag" ->
                                succeed Tag
                                    |: ("name" := string)
                                    |: ("statementId" := string)
                                    |> map TagCustom

                            _ ->
                                fail ("Unknown statement type: " ++ statementType)
                    )
           )
        |: oneOf [ ("deleted" := bool), succeed False ]
        |: oneOf [ ("groundIds" := list string), succeed [] ]
        |: ("id" := string)
        |: oneOf [ ("isAbuse" := bool), succeed False ]
        |: oneOf [ ("ratingCount" := int), succeed 0 ]
        |: oneOf [ ("ratingSum" := int), succeed 0 ]


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



-- VALIDATORS


validateHasOneOfCardTypes : List String -> Card -> Result String ()
validateHasOneOfCardTypes expectedCardTypes card =
    let
        existingCardTypes =
            getManyStrings cardTypeKeys card

        intersection =
            Set.intersect (Set.fromList expectedCardTypes) (Set.fromList existingCardTypes)
    in
        if Set.isEmpty intersection then
            Err
                ("Expected one card type among "
                    ++ (toString expectedCardTypes)
                    ++ " but found "
                    ++ (toString existingCardTypes)
                )
        else
            Ok ()


validateStatement : String -> List String -> Dict String Statement -> Result String ()
validateStatement statementId cardTypes statements =
    (Dict.get statementId statements
        |> Result.fromMaybe
            ("Statement ID \""
                ++ statementId
                ++ "\" is not in body.data.statements; received "
                ++ (toString (Dict.keys statements))
            )
    )
        `Result.andThen`
            (\statement ->
                case statement.custom of
                    CardCustom card ->
                        Ok card

                    _ ->
                        Err "statement.custom is not a Card"
            )
        `Result.andThen` (\card -> validateHasOneOfCardTypes cardTypes card)
