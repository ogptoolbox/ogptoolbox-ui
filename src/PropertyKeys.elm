module PropertyKeys exposing (..)

import Dict
import Types exposing (..)


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
