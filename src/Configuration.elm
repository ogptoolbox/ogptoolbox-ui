module Configuration exposing (..)

import String


apiUrl : String
apiUrl =
    -- "https://api.ogptoolbox.org/"
    "http://localhost:3000/"


appUrl : String
appUrl =
    "http://localhost:3011/"



-- HELPERS


apiUrlWithPath : String -> String
apiUrlWithPath urlPath =
    apiUrl
        ++ (if String.startsWith "/" urlPath then
                String.dropLeft 1 urlPath
            else
                urlPath
           )
