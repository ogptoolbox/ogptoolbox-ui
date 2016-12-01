port module Ports exposing (..)

import Types exposing (DocumentMetatags, User)


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
