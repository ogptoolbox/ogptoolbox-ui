module Types exposing (..)

import Constants exposing (..)
import Dict exposing (Dict)
import Json.Decode


type alias Argument =
    { keyId : String
    , rating : Int
    , ratingCount : Int
    , ratingSum : Int
    , valueId : String
    }


type alias Ballot =
    { deleted : Bool
    , id : String
    , rating : Int
    , statementId : String
    , updatedAt : String
    , voterId : String
    }


type alias BijectiveCardReference =
    { targetId : String
    , reverseKeyId : String
    }


type alias Card =
    { arguments : List Argument
    , createdAt : String
    , deleted : Bool
    , id : String
    , properties : Dict String String
    , rating : Int
    , ratingCount : Int
    , ratingSum : Int
    , references : Dict String (List String)
    , subTypeIds : List String
    , tagIds : List String
    , type_ : String
    , usageIds : List String
    }


type alias CardAutocompletion =
    { autocomplete : String
    , card : Card
    , distance : Float
    }


type alias CardsAutocompletionBody =
    { data : List CardAutocompletion
    }


type CardType
    = OrganizationCard
    | ToolCard
    | UseCaseCard


type alias Collection =
    { authorId : String
    , cardIds : List String
    , description : String
    , id : String
    , logo : Maybe String
    , name : String
    }


type alias DataId =
    { ballots : Dict String Ballot
    , cards : Dict String Card
    , collections : Dict String Collection
    , id : String
    , properties : Dict String Property
    , users : Dict String User
    , values : Dict String TypedValue
    }


type alias DataIdBody =
    { data : DataId
    }


type alias DataIds =
    { ballots : Dict String Ballot
    , cards : Dict String Card
    , collections : Dict String Collection
    , ids : List String
    , properties : Dict String Property
    , users : Dict String User
    , values : Dict String TypedValue
    }


type alias DataIdsBody =
    { count : Int
    , data : DataIds
    , limit : Int
    , offset : Int
    }


type alias DataProxy a =
    { a
        | ballots : Dict String Ballot
        , cards : Dict String Card
        , collections : Dict String Collection
        , properties : Dict String Property
        , users : Dict String User
        , values : Dict String TypedValue
    }


type alias DocumentMetadata =
    { description : String
    , imageUrl : String
    , title : String
    }


type Field
    = BooleanField Bool
    | CardIdField String
    | ImageField String
    | InputEmailField String
    | InputNumberField Float
    | InputTextField String
    | InputUrlField String
    | LocalizedInputTextField String String
    | LocalizedTextareaField String String
    | TextareaField String


type alias Flags =
    { language : String
    , authentication : Json.Decode.Value
    }


type alias PopularTag =
    { count : Float
    , tagId : String
    }


type alias PopularTagsData =
    { popularity : List PopularTag
    , values : Dict String TypedValue
    }


type alias Property =
    { arguments : List Argument
    , ballotId :
        String

    -- TODO Use Maybe
    , createdAt : String
    , deleted : Bool
    , id : String
    , keyId : String
    , objectId : String
    , properties : Dict String String
    , rating : Int
    , ratingCount : Int
    , ratingSum : Int
    , references : Dict String (List String)
    , subTypeIds : List String
    , tags : List (Dict String String)
    , type_ : String
    , valueId : String
    }


type alias TypedValue =
    { createdAt : String
    , id : String
    , schemaId : String
    , type_ : String
    , value : ValueType
    , widgetId : String
    }


type alias TypedValueAutocompletion =
    { autocomplete : String
    , distance : Float
    , value : TypedValue
    }


type alias TypedValuesAutocompletionBody =
    { data : List TypedValueAutocompletion
    }


type alias User =
    { activated : Bool
    , apiKey : String
    , email : String
    , id : String
    , isAdmin : Bool
    , name : String
    , urlName : String
    }


type alias UserBody =
    { data : User
    }


type ValueType
    = BijectiveCardReferenceValue BijectiveCardReference
    | BooleanValue Bool
    | CardIdArrayValue (List String)
    | CardIdValue String
    | EmailValue String
    | ImagePathValue String
    | LocalizedStringValue (Dict String String)
    | NumberValue Float
    | StringValue String
    | UrlValue String
    | ValueIdArrayValue (List String)
    | ValueIdValue String
    | WrongValue String String


cardSubTypeIdsIntersect : List String -> List String -> Bool
cardSubTypeIdsIntersect cardSubTypeIds1 cardSubTypeIds2 =
    List.any (\subTypeId -> List.member subTypeId cardSubTypeIds2)
        cardSubTypeIds1


getCard : Dict String Card -> String -> Card
getCard cards id =
    case Dict.get id cards of
        Nothing ->
            Debug.crash "getCard: Should never happen"

        Just card ->
            card


getCardType : Card -> CardType
getCardType card =
    -- Caution: getCardType is an abusive simplification, because a card may have several subtypes.
    case List.head card.subTypeIds of
        Nothing ->
            Debug.crash "getCardType: unhandled case"

        Just subTypeId ->
            if List.member subTypeId cardTypesForUseCase then
                UseCaseCard
            else if List.member subTypeId cardTypesForOrganization then
                OrganizationCard
            else if List.member subTypeId cardTypesForTool then
                ToolCard
            else
                let
                    _ =
                        Debug.log "Types.getCardType: unhandled case: " subTypeId
                in
                    ToolCard


getOrderedCards : DataIds -> List Card
getOrderedCards { cards, ids } =
    List.map (getCard cards) ids


getOrderedProperties : DataIds -> List Property
getOrderedProperties { properties, ids } =
    List.map (getProperty properties) ids


getProperty : Dict String Property -> String -> Property
getProperty properties id =
    case Dict.get id properties of
        Nothing ->
            Debug.crash ("getProperty: Should never happen id=" ++ id)

        Just property ->
            property


getValue : Dict String TypedValue -> String -> TypedValue
getValue values id =
    case Dict.get id values of
        Nothing ->
            Debug.crash ("getValue: Should never happen id=" ++ id)

        Just value ->
            value


initData : DataProxy {}
initData =
    { ballots = Dict.empty
    , cards = Dict.empty
    , collections = Dict.empty
    , properties = Dict.empty
    , users = Dict.empty
    , values = Dict.empty
    }


initDataId : DataId
initDataId =
    { ballots = Dict.empty
    , cards = Dict.empty
    , collections = Dict.empty
    , id = ""
    , properties = Dict.empty
    , users = Dict.empty
    , values = Dict.empty
    }


initDataIds : DataIds
initDataIds =
    { ballots = Dict.empty
    , cards = Dict.empty
    , collections = Dict.empty
    , ids = []
    , properties = Dict.empty
    , users = Dict.empty
    , values = Dict.empty
    }


mergeData : DataProxy a -> DataProxy b -> DataProxy b
mergeData new old =
    { old
        | ballots = Dict.union new.ballots old.ballots
        , cards = Dict.union new.cards old.cards
        , collections = Dict.union new.collections old.collections
        , properties = Dict.union new.properties old.properties
        , users = Dict.union new.users old.users
        , values = Dict.union new.values old.values
    }


mergeDataId : DataId -> DataId -> DataId
mergeDataId new old =
    let
        mergedData =
            mergeData new old
    in
        { mergedData
            | id =
                if String.isEmpty new.id then
                    old.id
                else
                    new.id
        }


mergeDataIds : DataIds -> DataIds -> DataIds
mergeDataIds new old =
    let
        mergedData =
            mergeData new old
    in
        { mergedData
            | ids = List.append old.ids new.ids
        }
