module Types exposing (..)

import Dict exposing (Dict)
import Set


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


type CardType
    = Example
    | Organization
    | Tool


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
    { ids : List String
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


type alias Plain =
    { languageCode : String
    , name : String
    }


type alias Statement =
    { createdAt : String
    , custom : StatementCustom
    , deleted : Bool
    , groundIds : List String
    , id : String
    , ratingCount : Int
    , ratingSum : Int
    }


type
    StatementCustom
    -- TODO Remove this indirection
    = CardCustom Card


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


getManyStrings : List String -> Card -> List String
getManyStrings propertyKeys card =
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
        propertyKeys
            |> List.map
                (\propertyKey ->
                    case Dict.get propertyKey card of
                        Nothing ->
                            []

                        Just cardField ->
                            getStrings cardField
                )
            |> List.filter (not << List.isEmpty)
            |> List.head
            |> Maybe.withDefault []


getOneString : List String -> Card -> Maybe String
getOneString propertyKeys card =
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
        List.map
            (\propertyKey ->
                Dict.get propertyKey card
                    `Maybe.andThen` getString
            )
            propertyKeys
            |> Maybe.oneOf



-- KEYS


cardTypeKeys : List String
cardTypeKeys =
    [ "Card Type" ]


descriptionKeys : List String
descriptionKeys =
    [ "Description-EN"
    , "Description-FR"
    ]


imageUrlPathKeys : List String
imageUrlPathKeys =
    [ "Logo", "Screenshot" ]


licenseKeys : List String
licenseKeys =
    [ "License", "license" ]


nameKeys : List String
nameKeys =
    [ "Name" ]


tagKeys : List String
tagKeys =
    [ "Tag" ]


typeKeys : List String
typeKeys =
    [ "Type" ]


urlKeys : List String
urlKeys =
    [ "URL", "Website" ]


usedByKeys : List String
usedByKeys =
    [ "Used by" ]



-- CARD TYPES


cardTypesForExample : List String
cardTypesForExample =
    [ "Final Use" ]


cardTypesForOrganization : List String
cardTypesForOrganization =
    [ "Organization" ]


cardTypesForTool : List String
cardTypesForTool =
    [ "Software", "Platform" ]


filterByCardType : CardType -> List Statement -> List Statement
filterByCardType cardType statements =
    List.filterMap
        (\statement ->
            case statement.custom of
                CardCustom card ->
                    let
                        expectedCardTypes =
                            case cardType of
                                Example ->
                                    cardTypesForExample

                                Organization ->
                                    cardTypesForOrganization

                                Tool ->
                                    cardTypesForTool
                    in
                        validateHasOneOfCardTypes expectedCardTypes card
                            |> Result.map (\_ -> statement)
                            |> Result.toMaybe
        )
        statements



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
            )
        `Result.andThen` (\card -> validateHasOneOfCardTypes cardTypes card)
