module Configuration exposing (..)

import Dict exposing (Dict)


apiUrl : String
apiUrl =
    -- "http://localhost:3000/"
    "https://api.ogptoolbox.org/"


appUrl : String
appUrl =
    "http://localhost:3011/"


twitterName : String
twitterName =
    "@OGPToolbox"


useItData : Dict String { frenchGovDeployUrl : String }
useItData =
    Dict.fromList
        [ ( "7873", { frenchGovDeployUrl = "https://consultation.etalab.gouv.fr/tools/nova-ideo" } )
        , ( "4848", { frenchGovDeployUrl = "https://consultation.etalab.gouv.fr/tools/cap-collectif" } )
        , ( "6228", { frenchGovDeployUrl = "https://consultation.etalab.gouv.fr/tools/assembl" } )
        , ( "2333", { frenchGovDeployUrl = "https://consultation.etalab.gouv.fr/tools/democracyos" } )
        ]
