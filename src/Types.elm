module Types exposing (..)

import Dict exposing (Dict)


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


type alias PopularTag =
    { count : Float
    , tag : String
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
    | LocalizedStringValue (Dict String String)
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

                LocalizedStringValue values ->
                    case Dict.get "en" values of
                        Nothing ->
                            []

                        Just value ->
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

                LocalizedStringValue values ->
                    Dict.get "en" values

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
    [ "logo", "screenshot" ]


licenseKeys : List String
licenseKeys =
    [ "license" ]


nameKeys : List String
nameKeys =
    [ "name" ]


tagKeys : List String
tagKeys =
    [ "tags" ]


typeKeys : List String
typeKeys =
    [ "types" ]


urlKeys : List String
urlKeys =
    [ "website" ]


usedByKeys : List String
usedByKeys =
    [ "used-by" ]



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
