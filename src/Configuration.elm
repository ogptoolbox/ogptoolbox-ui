module Configuration exposing (..)

import Dict exposing (Dict)
import String


apiUrl : String
apiUrl =
    -- "https://api.ogptoolbox.org/"
    "http://localhost:3000/"


appUrl : String
appUrl =
    "http://localhost:3011/"


useItData =
    Dict.fromList
        [ ( "7873", { frenchGovDeployUrl = "https://consultation.etalab.gouv.fr/" } )
        , ( "4848", { frenchGovDeployUrl = "https://consultation.etalab.gouv.fr/" } )
        , ( "6228", { frenchGovDeployUrl = "https://consultation.etalab.gouv.fr/" } )
        , ( "2333", { frenchGovDeployUrl = "https://consultation.etalab.gouv.fr/" } )
        ]



-- HELPERS


apiUrlWithPath : String -> String
apiUrlWithPath urlPath =
    apiUrl
        ++ (if String.startsWith "/" urlPath then
                String.dropLeft 1 urlPath
            else
                urlPath
           )
