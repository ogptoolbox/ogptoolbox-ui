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
    = UseCaseCard
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
    , tagId : String
    }


type alias PopularTagsData =
    { popularity : List PopularTag
    , values : Dict String Value
    }


type alias User =
    { activated : Bool
    , apiKey : String
    , email : String
    , name : String
    , urlName : String
    }


type alias UserForPort =
    -- Workaround for ports removing booleans
    { activated : String
    , apiKey : String
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
    | BijectiveCardReferenceValue BijectiveCardReference
    | CardIdValue String
    | CardIdArrayValue (List String)
    | ValueIdValue String
    | ValueIdArrayValue (List String)
    | WrongValue String String


getCard : Dict String Card -> String -> Card
getCard cards id =
    -- TODO flip args like getValue
    case Dict.get id cards of
        Nothing ->
            Debug.crash "getCard: Should never happen"

        Just card ->
            card


getCardType : Card -> CardType
getCardType card =
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
                Debug.crash "getCardType: unhandled case"


getOrderedCards : DataIds -> List Card
getOrderedCards { cards, ids } =
    List.map (getCard cards) ids


getValue : String -> Dict String Value -> Value
getValue id values =
    case Dict.get id values of
        Nothing ->
            Debug.crash "getValue: Should never happen"

        Just value ->
            value


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


cardTypesForOrganization : List String
cardTypesForOrganization =
    [ "organization" ]


cardTypesForTool : List String
cardTypesForTool =
    [ "software", "platform" ]


cardTypesForUseCase : List String
cardTypesForUseCase =
    [ "use-case" ]
