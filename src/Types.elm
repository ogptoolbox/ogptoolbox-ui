module Types exposing (..)

import Dict exposing (Dict)


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
    { id : String
    , statements : Dict String Statement
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
    { count : Int
    , data : DataIds
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
