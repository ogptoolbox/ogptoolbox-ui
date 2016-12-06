port module Ports exposing (..)

import Types exposing (DocumentMetatags, PopularTag, User, UserForPort)


-- DOCUMENT METATAGS


port setDocumentMetatags : DocumentMetatags -> Cmd msg



-- IMAGE UPLOAD


type alias ImagePortData =
    { contents : String
    , filename : String
    }


port fileSelected : String -> Cmd msg


port fileContentRead : (ImagePortData -> msg) -> Sub msg



-- AUTHENTICATION


port storeAuthentication : Maybe UserForPort -> Cmd msg


userToUserForPort : Maybe User -> Maybe UserForPort
userToUserForPort user =
    case user of
        Just user ->
            Just
                { activated =
                    if user.activated then
                        "true"
                    else
                        ""
                , apiKey = user.apiKey
                , email = user.email
                , name = user.name
                , urlName = user.urlName
                }

        Nothing ->
            Nothing



-- BUBBLES


type alias D3BubblesPopularTag =
    { count : Float
    , tag : String
    , tagId : String
    }


port mountd3bubbles :
    { popularTags : List D3BubblesPopularTag
    , selectedTags : List D3BubblesPopularTag
    }
    -> Cmd msg


port bubbleSelections : (D3BubblesPopularTag -> msg) -> Sub msg


port bubbleDeselections : (D3BubblesPopularTag -> msg) -> Sub msg
