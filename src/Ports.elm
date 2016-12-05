port module Ports exposing (..)

import Types exposing (DocumentMetatags, PopularTag, User)


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


port storeAuthentication : Maybe User -> Cmd msg



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
