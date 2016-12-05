module Constants exposing (..)

import Configuration exposing (appUrl)


logoUrl : String
logoUrl =
    appUrl ++ "img/ogptoolbox-logo.png"


searchResultsListPaginationSize : Int
searchResultsListPaginationSize =
    20
