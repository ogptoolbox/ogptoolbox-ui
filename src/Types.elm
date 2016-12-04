module Types exposing (..)

import Configuration exposing (apiUrl)
import Dict exposing (Dict)
import String


type alias BijectiveCardReference =
    { targetId : String
    , reverseKeyId : String
    }


type alias Card =
    { createdAt : String
    , deleted : Bool
    , id : String
    , properties : Dict String String
    , rating : Int
    , ratingCount : Int
    , ratingSum : Int
    , references : Dict String (List String)
    , subTypeIds : List String
    , tags : List (Dict String String)
    , type_ : String
    }


type CardType
    = ExampleCard
    | OrganizationCard
    | ToolCard


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


type alias DocumentMetatags =
    { title : String
    , imageUrl : String
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
    | NumberValue Float
    | ArrayValue (List ValueType)
    | BijectiveCardReferenceValue BijectiveCardReference
    | ReferenceValue String
    | WrongValue String String


getCardType : Card -> CardType
getCardType card =
    case List.head card.subTypeIds of
        Nothing ->
            Debug.crash "urlPathForCard: unhandled case"

        Just subTypeId ->
            if List.member subTypeId cardTypesForExample then
                ExampleCard
            else if List.member subTypeId cardTypesForOrganization then
                OrganizationCard
            else if List.member subTypeId cardTypesForTool then
                ToolCard
            else
                Debug.crash "urlPathForCard: unhandled case"


getOrderedCards : DataIds -> List Card
getOrderedCards { cards, ids } =
    List.map
        (\id ->
            case Dict.get id cards of
                Nothing ->
                    Debug.crash "Should never happen"

                Just card ->
                    card
        )
        ids


imageUrl : String -> String
imageUrl urlPath =
    apiUrl
        ++ (if String.startsWith "/" urlPath then
                String.dropLeft 1 urlPath
            else
                urlPath
           )



-- KEYS


descriptionKeys : List String
descriptionKeys =
    [ "description" ]


imageLogoUrlPathKeys : List String
imageLogoUrlPathKeys =
    [ "logo" ]


imageScreenshotUrlPathKeys : List String
imageScreenshotUrlPathKeys =
    [ "screenshot" ]


imageUrlPathKeys : List String
imageUrlPathKeys =
    imageLogoUrlPathKeys ++ imageScreenshotUrlPathKeys


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
    [ "type:use-case" ]


cardTypesForOrganization : List String
cardTypesForOrganization =
    [ "type:organization" ]


cardTypesForTool : List String
cardTypesForTool =
    [ "type:software", "type:platform" ]
