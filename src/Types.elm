module Types exposing (..)

import Dict exposing (Dict)
import Json.Decode as Decode exposing (..)
import Json.Decode.Extra as Json exposing ((|:))
import Result exposing (Result(..))
import Result.Extra exposing (combine)
import Set
import String


type alias Abuse =
    { statementId : String
    }


type alias Argument =
    { argumentType : ArgumentType
    , claimId : String
    , groundId : String
    }


type ArgumentType
    = Because
    | But
    | Comment
    | Example


type alias Ballot =
    { deleted : Bool
    , id : String
    , rating : Int
    , statementId : String
    , updatedAt : String
    , voterId : String
    }


type alias Card =
    Dict String CardField


type alias CardStringField =
    { format : Maybe CardStringFieldFormat
    , value : String
    , widget : Maybe CardWidget
    }


type CardStringFieldFormat
    = UriReference
    | Uri
    | Email


type CardField
    = StringField CardStringField
    | ArrayField (List CardField)
    | BijectiveUriReferenceField String


type alias CardWidget =
    { tag : String
    , type_ : Maybe String
    }


type alias DataId =
    { ballots : Dict String Ballot
    , id : String
    , statements : Dict String Statement
    , users : Dict String User
    }


type alias DataIdBody =
    { data : DataId
    }


type alias DataIds =
    { ballots : Dict String Ballot
    , ids : List String
    , statements : Dict String Statement
    , users : Dict String User
    }


type alias DataIdsBody =
    { data : DataIds
    }


type JsonCardSchema
    = StringSchema (Maybe CardStringFieldFormat)
    | ArraySchema JsonCardArraySchemaKind
    | BijectiveUriReferenceSchema


type JsonCardArraySchemaKind
    = ListArraySchema JsonCardSchema
    | TupleArraySchema (List JsonCardSchema)


type alias ModelFragment a =
    { a
        | ballotById : Dict String Ballot
        , statementById : Dict String Statement
        , statementIds : List String
    }


type alias Plain =
    { languageCode : String
    , name : String
    }


type alias Statement =
    { ballotIdMaybe : Maybe String
    , createdAt : String
    , custom : StatementCustom
    , deleted : Bool
    , groundIds : List String
    , id : String
    , isAbuse : Bool
    , ratingCount : Int
    , ratingSum : Int
    }


type StatementCustom
    = AbuseCustom Abuse
    | ArgumentCustom Argument
    | PlainCustom Plain
    | TagCustom Tag
    | CardCustom Card


type alias Tag =
    { name : String
    , statementId : String
    }


type alias User =
    { apiKey : String
    , email : String
    , name : String
    , urlName : String
    }


type alias UserBody =
    { data : User
    }



-- TO STRING FUNCTIONS


convertArgumentTypeToString : ArgumentType -> String
convertArgumentTypeToString argumentType =
    case argumentType of
        Because ->
            "because"

        But ->
            "but"

        Comment ->
            "comment"

        Example ->
            "example"


convertStatementCustomToKind : StatementCustom -> String
convertStatementCustomToKind statementCustom =
    case statementCustom of
        AbuseCustom abuse ->
            "Abuse"

        ArgumentCustom argument ->
            "Argument"

        CardCustom card ->
            "Card"

        PlainCustom plain ->
            "PlainStatement"

        TagCustom tag ->
            "Tag"


getManyStrings : String -> Card -> List String
getManyStrings propertyName card =
    let
        getStrings : CardField -> List String
        getStrings cardField =
            case cardField of
                StringField { value } ->
                    [ value ]

                ArrayField fields ->
                    List.concatMap getStrings fields

                BijectiveUriReferenceField _ ->
                    []
    in
        case Dict.get propertyName card of
            Nothing ->
                []

            Just cardField ->
                getStrings cardField


getOneString : String -> Card -> Maybe String
getOneString propertyName card =
    let
        getString : CardField -> Maybe String
        getString cardField =
            case cardField of
                StringField { value } ->
                    Just value

                ArrayField [] ->
                    Nothing

                ArrayField (field :: _) ->
                    getString field

                BijectiveUriReferenceField _ ->
                    Nothing
    in
        Dict.get propertyName card
            `Maybe.andThen` getString



-- DECODERS


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
        mergeSchemasAndWidgets :
            Dict String JsonCardSchema
            -> Dict String CardWidget
            -> { errors : List String
               , schemasAndWidgets : Dict String ( JsonCardSchema, Maybe CardWidget )
               }
        mergeSchemasAndWidgets schemas widgets =
            Dict.merge
                (\propertyName schema accu ->
                    { accu
                        | schemasAndWidgets =
                            Dict.insert propertyName ( schema, Nothing ) accu.schemasAndWidgets
                    }
                )
                (\propertyName schema widget accu ->
                    { accu
                        | schemasAndWidgets =
                            Dict.insert propertyName ( schema, Just widget ) accu.schemasAndWidgets
                    }
                )
                (\propertyName _ accu ->
                    { accu | errors = ("Widget \"" ++ propertyName ++ "\" has no schema") :: accu.errors }
                )
                schemas
                widgets
                { errors = []
                , schemasAndWidgets = Dict.empty
                }

        mergeValues :
            Dict String ( JsonCardSchema, Maybe CardWidget )
            -> Dict String Value
            -> { errors : List String
               , valuesAndSchemasAndWidgets : Dict String ( Value, JsonCardSchema, Maybe CardWidget )
               }
        mergeValues schemasAndWidgets values =
            Dict.merge
                (\propertyName ( schema, widget ) accu -> accu)
                (\propertyName ( schema, widget ) value accu ->
                    { accu
                        | valuesAndSchemasAndWidgets =
                            Dict.insert
                                propertyName
                                ( value, schema, widget )
                                accu.valuesAndSchemasAndWidgets
                    }
                )
                (\propertyName _ accu ->
                    { accu
                        | errors =
                            ("Value \"" ++ propertyName ++ "\" has no schema") :: accu.errors
                    }
                )
                schemasAndWidgets
                values
                { errors = []
                , valuesAndSchemasAndWidgets = Dict.empty
                }

        toCardField : JsonCardSchema -> Maybe CardWidget -> Value -> Result String CardField
        toCardField schema widget value =
            case schema of
                StringSchema format ->
                    decodeValue string value
                        |> Result.map
                            (\value ->
                                StringField
                                    { format = format
                                    , value = value
                                    , widget = widget
                                    }
                            )

                ArraySchema kind ->
                    case kind of
                        ListArraySchema schema ->
                            case schema of
                                StringSchema format ->
                                    decodeValue (list string) value
                                        |> Result.map
                                            (\strings ->
                                                ArrayField
                                                    (List.map
                                                        (\stringValue ->
                                                            StringField
                                                                { format = format
                                                                , value = stringValue
                                                                , widget = Nothing
                                                                }
                                                        )
                                                        strings
                                                    )
                                            )

                                ArraySchema _ ->
                                    -- TODO There is recursion here apparently.
                                    Err "A1 ArraySchema not implemented"

                                BijectiveUriReferenceSchema ->
                                    -- decodeValue (list ("targetId" := string)) value
                                    --     |> Result.map (\refs -> ArrayField (List.map BijectiveUriReferenceField refs))
                                    Err "A2 BijectiveUriReferenceSchema not implemented"

                        TupleArraySchema schemas ->
                            decodeValue (list Decode.value) value
                                `Result.andThen`
                                    (\values ->
                                        let
                                            subFieldsResults : List (Result String CardField)
                                            subFieldsResults =
                                                List.map2
                                                    (\schema value ->
                                                        case schema of
                                                            StringSchema format ->
                                                                decodeValue string value
                                                                    |> Result.map
                                                                        (\stringValue ->
                                                                            StringField
                                                                                { format = format
                                                                                , value = stringValue
                                                                                , widget = Nothing
                                                                                }
                                                                        )

                                                            ArraySchema _ ->
                                                                Debug.crash "C1 ArraySchema not implemented"

                                                            BijectiveUriReferenceSchema ->
                                                                decodeValue bijectiveUriReferenceDecoder value
                                                                    |> Result.map BijectiveUriReferenceField
                                                    )
                                                    schemas
                                                    values

                                            subFieldsResult : Result String (List CardField)
                                            subFieldsResult =
                                                combine subFieldsResults
                                        in
                                            Result.map ArrayField subFieldsResult
                                    )

                BijectiveUriReferenceSchema ->
                    decodeValue bijectiveUriReferenceDecoder value
                        |> Result.map BijectiveUriReferenceField
    in
        object3 (,,)
            ("schemas" := dict jsonCardSchemaDecoder)
            ("values" := dict value)
            ("widgets" := dict cardWidgetDecoder)
            `andThen`
                (\( schemas, values, widgets ) ->
                    let
                        -- TODO Return Result (List String) (Dict String ( JsonCardSchema, Maybe CardWidget ))
                        -- instead of record.
                        { errors, schemasAndWidgets } =
                            mergeSchemasAndWidgets schemas widgets
                    in
                        if List.isEmpty errors then
                            let
                                { errors, valuesAndSchemasAndWidgets } =
                                    mergeValues schemasAndWidgets values
                            in
                                if List.isEmpty errors then
                                    let
                                        { errors, cardFields } =
                                            Dict.foldl
                                                (\propertyName ( value, schema, widget ) accu ->
                                                    case toCardField schema widget value of
                                                        Ok cardField ->
                                                            { accu
                                                                | cardFields =
                                                                    Dict.insert propertyName cardField accu.cardFields
                                                            }

                                                        Err err ->
                                                            { accu
                                                                | errors =
                                                                    ("\"" ++ propertyName ++ "\": " ++ err)
                                                                        :: accu.errors
                                                            }
                                                )
                                                { errors = [], cardFields = Dict.empty }
                                                valuesAndSchemasAndWidgets

                                        _ =
                                            Debug.log "errors" errors
                                    in
                                        succeed cardFields
                                    -- if List.isEmpty errors then
                                    --     succeed cardFields
                                    -- else
                                    --     fail ("Step 3: Multiple errors: " ++ (String.join "; " errors))
                                else
                                    fail ("Step 2: Multiple errors: " ++ (String.join "; " errors))
                        else
                            fail ("Step 1: Multiple errors: " ++ (String.join "; " errors))
                )


cardWidgetDecoder : Decoder CardWidget
cardWidgetDecoder =
    succeed CardWidget
        |: ("tag" := string)
        |: (maybe ("type" := string))


dataIdDecoder : Decoder DataId
dataIdDecoder =
    succeed DataId
        |: oneOf [ ("ballots" := dict ballotDecoder), succeed Dict.empty ]
        |: ("id" := string)
        |: ((maybe ("statements" := dict statementDecoder))
                |> map (Maybe.withDefault Dict.empty)
           )
        |: oneOf [ ("users" := dict userDecoder), succeed Dict.empty ]


dataIdsDecoder : Decoder DataIds
dataIdsDecoder =
    succeed DataIds
        |: oneOf [ ("ballots" := dict ballotDecoder), succeed Dict.empty ]
        |: ("ids" := list string)
        |: ((maybe ("statements" := dict statementDecoder))
                |> map (Maybe.withDefault Dict.empty)
           )
        |: oneOf [ ("users" := dict userDecoder), succeed Dict.empty ]


dataIdBodyDecoder : Decoder DataIdBody
dataIdBodyDecoder =
    succeed DataIdBody
        |: ("data" := dataIdDecoder)


dataIdsBodyDecoder : Decoder DataIdsBody
dataIdsBodyDecoder =
    succeed DataIdsBody
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

                        _ ->
                            fail ("Unknown card schema type: " ++ schemaType)
                )
        , ("$ref" := string) |> map (always BijectiveUriReferenceSchema)
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


statementDecoderFromBody : String -> List String -> Decoder Statement
statementDecoderFromBody statementId cardTypes =
    let
        validateHasOneOfCardTypes : List String -> Card -> Result String ()
        validateHasOneOfCardTypes expectedCardTypes card =
            let
                existingCardTypes =
                    getManyStrings "Card Type" card

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

        getStatementCard : Statement -> Decoder Card
        getStatementCard statement =
            case statement.custom of
                CardCustom card ->
                    succeed card

                _ ->
                    fail ("statement.custom is not a Card")

        getStatementOfId :
            String
            -> { a | data : { b | statements : Dict String Statement } }
            -> Decoder Statement
        getStatementOfId statementId body =
            let
                statements =
                    body.data.statements
            in
                case Dict.get statementId statements of
                    Nothing ->
                        fail
                            ("Statement ID \""
                                ++ statementId
                                ++ "\" is not in body.data.statements; received "
                                ++ (toString (Dict.keys statements))
                            )

                    Just statement ->
                        succeed statement
    in
        dataIdBodyDecoder
            `andThen` getStatementOfId statementId
            `andThen`
                (\statement ->
                    getStatementCard statement
                        `andThen`
                            (\card ->
                                case validateHasOneOfCardTypes cardTypes card of
                                    Ok _ ->
                                        succeed statement

                                    Err err ->
                                        fail err
                            )
                )


statementsDecoder : Decoder (List Statement)
statementsDecoder =
    dataIdsBodyDecoder |> map (\body -> Dict.values body.data.statements)


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
