module Types exposing (..)

import Dict exposing (Dict)
import Json.Decode as Decode exposing (..)
import Json.Decode.Extra exposing ((|:), sequence)
import Result exposing (Result(..))
import Set


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
    | NumberField Float
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
    | NumberSchema
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

                NumberField _ ->
                    []

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

                NumberField _ ->
                    Nothing

                BijectiveUriReferenceField _ ->
                    Nothing
    in
        Dict.get propertyName card
            `Maybe.andThen` getString


getOneImageUrlPath : Card -> Maybe String
getOneImageUrlPath card =
    Maybe.oneOf
        [ getOneString "Logo" card
        , getOneString "Screenshot" card
        ]



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
                (\propertyName schema accu -> Dict.insert propertyName (Ok ( schema, Nothing )) accu)
                (\propertyName schema widget accu -> Dict.insert propertyName (Ok ( schema, Just widget )) accu)
                (\propertyName _ accu -> Dict.insert propertyName (Err ("Widget has no schema")) accu)
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
                (\propertyName ( schema, widget ) accu -> accu)
                (\propertyName ( schema, widget ) value accu ->
                    Dict.insert propertyName (Ok ( value, schema, widget )) accu
                )
                (\propertyName _ accu -> Dict.insert propertyName (Err ("Value has no schema")) accu)
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
            `andThen`
                (\( schemas, values, widgets ) ->
                    mergeSchemasAndWidgets schemas widgets
                        `Result.andThen` mergeValues values
                        `Result.andThen`
                            (Dict.map
                                (\propertyName ( value, schema, widget ) ->
                                    decodeValue (toCardField widget schema) value
                                )
                                >> combineDict
                            )
                        |> Result.formatError (Dict.toList >> toString)
                        |> fromResult
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
        |: ("statements" := dict statementDecoder)
        |: oneOf [ ("users" := dict userDecoder), succeed Dict.empty ]


dataIdsDecoder : Decoder DataIds
dataIdsDecoder =
    succeed DataIds
        |: oneOf [ ("ballots" := dict ballotDecoder), succeed Dict.empty ]
        |: ("ids" := list string)
        |: ("statements" := dict statementDecoder)
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



-- HELPERS


fromResult : Result String a -> Decoder a
fromResult result =
    -- TODO Use http://package.elm-lang.org/packages/elm-community/json-extra/latest/Json-Decode-Extra#fromResult
    -- when migrating to Elm 0.18
    case result of
        Ok successValue ->
            succeed successValue

        Err errorMessage ->
            fail errorMessage
