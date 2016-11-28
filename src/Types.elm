module Types exposing (..)

import Dict exposing (Dict)


-- import Set


type alias Card =
    { createdAt : String
    , deleted : Bool
    , id : String
    , properties : Dict String String
    , rating : Int
    , ratingCount : Int
    , ratingSum : Int
    , subTypes : List String
    , tags : List (Dict String String)
    , type_ : String
    }


type CardType
    = Example
    | Organization
    | Tool


type alias DataId =
    { cards : Dict String Card
    , id : String
    , values : Dict String Value
    }


type alias DataIdBody =
    { data : DataId
    }


type alias DataIds =
    { cards : Dict String Card
    , ids : List String
    , users : Dict String User
    , values : Dict String Value
    }


type alias DataIdsBody =
    { count : Int
    , data : DataIds
    , limit : Int
    , offset : Int
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


type alias Value =
    { createdAt : String
    , id : String
    , schemaId : String
    , type_ : String
    , value : ValueType
    , widgetId : String
    }


type ValueType
    = StringValue String
    | IntValue Int
    | FloatValue Float
    | ListValue (List ValueType)


getManyStrings : List String -> Card -> Dict String Value -> List String
getManyStrings propertyKeys card values =
    let
        getStrings : ValueType -> List String
        getStrings value =
            case value of
                StringValue value ->
                    [ value ]

                ListValue [] ->
                    []

                ListValue subValues ->
                    List.concatMap getStrings subValues

                IntValue _ ->
                    []

                FloatValue _ ->
                    []
    in
        propertyKeys
            |> List.map
                (\propertyKey ->
                    Dict.get propertyKey card.properties
                        `Maybe.andThen` (\valueId -> Dict.get valueId values)
                        |> Maybe.map (\value -> getStrings value.value)
                        |> Maybe.withDefault []
                )
            |> List.filter (not << List.isEmpty)
            |> List.head
            |> Maybe.withDefault []


getOneString : List String -> Card -> Dict String Value -> Maybe String
getOneString propertyKeys card values =
    let
        getString : ValueType -> Maybe String
        getString value =
            case value of
                StringValue value ->
                    Just value

                ListValue [] ->
                    Nothing

                ListValue (subValue :: _) ->
                    getString subValue

                IntValue _ ->
                    Nothing

                FloatValue _ ->
                    Nothing
    in
        propertyKeys
            |> List.map
                (\propertyKey ->
                    Dict.get propertyKey card.properties
                        `Maybe.andThen` (\valueId -> Dict.get valueId values)
                        `Maybe.andThen` (\value -> getString value.value)
                )
            |> Maybe.oneOf



-- KEYS


descriptionKeys : List String
descriptionKeys =
    [ "description" ]


imageUrlPathKeys : List String
imageUrlPathKeys =
    [ "Logo", "Screenshot" ]


licenseKeys : List String
licenseKeys =
    [ "License", "license" ]


nameKeys : List String
nameKeys =
    [ "name" ]


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



-- filterByCardType : CardType -> List Statement -> List Statement
-- filterByCardType cardType statements =
--     List.filterMap
--         (\statement ->
--             case statement.custom of
--                 CardCustom card ->
--                     let
--                         expectedCardTypes =
--                             case cardType of
--                                 Example ->
--                                     cardTypesForExample
--                                 Organization ->
--                                     cardTypesForOrganization
--                                 Tool ->
--                                     cardTypesForTool
--                     in
--                         validateHasOneOfCardTypes expectedCardTypes card
--                             |> Result.map (\_ -> statement)
--                             |> Result.toMaybe
--         )
--         statements
-- VALIDATORS
-- validateCard : String -> List String -> Dict String Card -> Result String ()
-- validateCard cardId cardTypes cards =
--     (Dict.get cardId cards
--         |> Result.fromMaybe
--             ("Statement ID \""
--                 ++ cardId
--                 ++ "\" is not in body.data.cards; received "
--                 ++ (toString (Dict.keys cards))
--             )
--     )
--         `Result.andThen` (\card -> validateHasOneOfCardTypes cardTypes card)
-- validateHasOneOfCardTypes : List String -> Card -> Result String ()
-- validateHasOneOfCardTypes expectedCardTypes card =
--     let
--         existingCardTypes =
--             getManyStrings cardTypeKeys card
--         intersection =
--             Set.intersect (Set.fromList expectedCardTypes) (Set.fromList existingCardTypes)
--     in
--         if Set.isEmpty intersection then
--             Err
--                 ("Expected one card type among "
--                     ++ (toString expectedCardTypes)
--                     ++ " but found "
--                     ++ (toString existingCardTypes)
--                 )
--         else
--             Ok ()
