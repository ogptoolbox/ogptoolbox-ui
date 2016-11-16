module Types exposing (..)

import Dict exposing (Dict)
import Json.Decode as Decode exposing (..)
import Json.Decode.Extra as Json exposing ((|:))
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
    { cardTypes : List String
    , descriptions : List String
    , name : String
    , tags : List String
    , urls :
        List String
        -- , values : Dict String ValuesValue
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


type alias ModelFragment a =
    { a
        | ballotById : Dict String Ballot
        , statementById : Dict String Statement
        , statementIds : List String
    }


type alias FormErrors =
    Dict String String


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
    , schemas : Dict String StatementSchema
    }


type StatementCustom
    = AbuseCustom Abuse
    | ArgumentCustom Argument
    | PlainCustom Plain
    | TagCustom Tag
    | CardCustom Card


type alias StatementForm =
    { argumentType : String
    , claimId : String
    , errors : FormErrors
    , groundId : String
    , kind : String
    , languageCode : String
    , name : String
    , statementId : String
    }


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


type ValuesValue
    = String
    | List String



-- SCHEMA TYPES


type StatementSchema
    = StringSchema (Maybe StringFormat)
    | ArraySchema ArrayItemsSchema


type StringFormat
    = UriReference
    | Uri
    | Email


type ArrayItemsSchema
    = ArrayItemSchema StatementSchema
    | ArrayItemsArraySchema (List StatementSchema)


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


convertStatementFormToCustom : StatementForm -> StatementCustom
convertStatementFormToCustom form =
    case form.kind of
        "Abuse" ->
            AbuseCustom
                { statementId = form.statementId
                }

        "Argument" ->
            ArgumentCustom
                { argumentType =
                    case form.argumentType of
                        "because" ->
                            Because

                        "but" ->
                            But

                        "comment" ->
                            Comment

                        "example" ->
                            Example

                        _ ->
                            Comment
                , claimId = form.claimId
                , groundId = form.groundId
                }

        "PlainStatement" ->
            PlainCustom
                { languageCode = form.languageCode
                , name = form.name
                }

        "Tag" ->
            TagCustom
                { name = form.name
                , statementId = form.statementId
                }

        _ ->
            -- TODO: Return a Result instead of a dummy PlainCustom.
            PlainCustom
                { languageCode = "en"
                , name = "Unknown kind: " ++ form.kind
                }


decodeAndValidateStatement : String -> List String -> Decoder Statement
decodeAndValidateStatement statementId cardTypes =
    decodeDataIdBody
        `andThen` getStatementOfId statementId
        `andThen`
            (\statement ->
                getCard statement
                    `andThen` validateHasOneOfCardTypes cardTypes
                    |> map (always statement)
            )


decodeArgumentType : Decoder ArgumentType
decodeArgumentType =
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
                    Err ("Unkown argument type: " ++ argumentType)
        )


decodeBallot : Decoder Ballot
decodeBallot =
    succeed Ballot
        |: oneOf [ ("rating" := int) `andThen` (\_ -> succeed False), succeed True ]
        |: ("id" := string)
        |: oneOf [ ("rating" := int), succeed 0 ]
        |: ("statementId" := string)
        |: oneOf [ ("updatedAt" := string), succeed "" ]
        |: ("voterId" := string)


decodeDataId : Decoder DataId
decodeDataId =
    succeed DataId
        |: oneOf [ ("ballots" := dict decodeBallot), succeed Dict.empty ]
        |: ("id" := string)
        |: ("statements" := dict decodeStatement)
        -- |: oneOf [ ("statements" := dict decodeStatement), succeed Dict.empty ]
        |:
            oneOf [ ("users" := dict decodeUser), succeed Dict.empty ]


decodeDataIds : Decoder DataIds
decodeDataIds =
    succeed DataIds
        |: oneOf [ ("ballots" := dict decodeBallot), succeed Dict.empty ]
        |: ("ids" := list string)
        |: oneOf [ ("statements" := dict decodeStatement), succeed Dict.empty ]
        |: oneOf [ ("users" := dict decodeUser), succeed Dict.empty ]


decodeDataIdBody : Decoder DataIdBody
decodeDataIdBody =
    succeed DataIdBody
        |: ("data" := decodeDataId)


decodeDataIdsBody : Decoder DataIdsBody
decodeDataIdsBody =
    succeed DataIdsBody
        |: ("data" := decodeDataIds)


decodeStatement : Decoder Statement
decodeStatement =
    succeed Statement
        |: maybe ("ballotId" := string)
        |: ("createdAt" := string)
        |: (("type" := string) `andThen` decodeStatementCustomFromType)
        |: oneOf [ ("deleted" := bool), succeed False ]
        |: oneOf [ ("groundIds" := list string), succeed [] ]
        |: ("id" := string)
        |: oneOf [ ("isAbuse" := bool), succeed False ]
        |: oneOf [ ("ratingCount" := int), succeed 0 ]
        |: oneOf [ ("ratingSum" := int), succeed 0 ]
        -- |: oneOf [ ("schemas" := dict decodeStatementSchema), succeed Dict.empty ]
        |:
            ("schemas" := dict decodeStatementSchema)


decodeStatementCustomFromType : String -> Decoder StatementCustom
decodeStatementCustomFromType statementType =
    case statementType of
        "Abuse" ->
            succeed Abuse
                |: ("statementId" := string)
                `andThen` \abuse -> succeed (AbuseCustom abuse)

        "Argument" ->
            succeed Argument
                |: ("argumentType" := decodeArgumentType)
                |: ("claimId" := string)
                |: ("groundId" := string)
                `andThen` \argument -> succeed (ArgumentCustom argument)

        "Card" ->
            succeed Card
                |: oneOf [ at [ "values", "Card Type" ] (list string), succeed [] ]
                |: oneOf [ at [ "values", "Description-EN" ] (list string), succeed [] ]
                |: oneOf [ at [ "values", "Name" ] string, succeed "" ]
                |: oneOf [ at [ "values", "Tag" ] (list string), succeed [] ]
                |: oneOf [ at [ "values", "URL" ] (list string), succeed [] ]
                `andThen` \card -> succeed (CardCustom card)

        "PlainStatement" ->
            succeed Plain
                |: ("languageCode" := string)
                |: ("name" := string)
                `andThen` \plain -> succeed (PlainCustom plain)

        "Tag" ->
            succeed Tag
                |: ("name" := string)
                |: ("statementId" := string)
                `andThen` \tag -> succeed (TagCustom tag)

        _ ->
            fail ("Unkown statement type: " ++ statementType)


decodeStatements : Decoder (List Statement)
decodeStatements =
    decodeDataIdsBody |> map (\body -> Dict.values body.data.statements)


decodeStatementSchema : Decoder StatementSchema
decodeStatementSchema =
    ("type" := string)
        `andThen` decodeStatementSchemaFromType


decodeStatementSchemaFromType : String -> Decoder StatementSchema
decodeStatementSchemaFromType type_ =
    case type_ of
        "array" ->
            succeed ArraySchema
                |: ("items"
                        := oneOf
                            [ decodeStatementSchema |> map ArrayItemSchema
                              -- TODO ArrayItemsArraySchema
                            ]
                   )

        "string" ->
            succeed StringSchema
                |: (maybe ("format" := string)
                        `andThen`
                            (\format ->
                                case format of
                                    Nothing ->
                                        succeed Nothing

                                    Just format ->
                                        case format of
                                            "email" ->
                                                succeed (Just Email)

                                            "uri" ->
                                                succeed (Just Uri)

                                            "uriref" ->
                                                succeed (Just UriReference)

                                            _ ->
                                                fail ("Unkown statement schema format type: " ++ format)
                            )
                   )

        _ ->
            fail ("Unkown statement schema type: " ++ type_)


decodeUser : Decoder User
decodeUser =
    succeed User
        |: ("apiKey" := string)
        |: ("email" := string)
        |: ("name" := string)
        |: ("urlName" := string)


decodeUserBody : Decoder UserBody
decodeUserBody =
    succeed UserBody
        |: ("data" := decodeUser)


getCard : Statement -> Decoder Card
getCard statement =
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


initStatementForm : StatementForm
initStatementForm =
    { argumentType = ""
    , claimId = ""
    , errors = Dict.empty
    , groundId = ""
    , kind = "PlainStatement"
    , languageCode = "en"
    , name = ""
    , statementId = ""
    }


validateHasOneOfCardTypes : List String -> Card -> Decoder Card
validateHasOneOfCardTypes cardTypes card =
    let
        set1 =
            Set.fromList card.cardTypes

        set2 =
            Set.fromList cardTypes

        intersection =
            Set.intersect set1 set2
    in
        if Set.isEmpty intersection then
            fail ("Expected one card type of " ++ (toString cardTypes) ++ " but found " ++ (toString card.cardTypes))
        else
            succeed card
