port module Ports exposing (..)

import Analytics
import Configuration
import Types exposing (DocumentMetadata, PopularTag, User)
import Urls


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



-- DOCUMENT METADATA


type alias DocumentMetatags =
    { description : String
    , imageUrl : String
    , title : String
    , twitterName : String
    }


setDocumentMetadata : DocumentMetadata -> Cmd msg
setDocumentMetadata metadata =
    setDocumentMetatags
        { description = metadata.description
        , imageUrl = Urls.fullApiUrl metadata.imageUrl ++ "?dim=500"
        , title = metadata.title
        , twitterName = Configuration.twitterName
        }


port setDocumentMetatags : DocumentMetatags -> Cmd msg



-- IMAGE UPLOAD


type alias ImagePortData =
    { contents : String
    , filename : String
    }


port fileSelected : String -> Cmd msg


port fileContentRead : (ImagePortData -> msg) -> Sub msg



-- PIWIK


port initPiwikAnalytics : Analytics.PiwikConfiguration -> Cmd msg



-- SHARERS


port shareOnFacebook : String -> Cmd msg


port shareOnGooglePlus : String -> Cmd msg


port shareOnLinkedIn : String -> Cmd msg


port shareOnTwitter : String -> Cmd msg
