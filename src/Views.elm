module Views exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Http exposing (Error(..))
import WebData exposing (LoadingStatus, WebData(..))


viewError : String -> String -> Html msg
viewError title message =
    div
        [ style
            [ ( "justify-content", "center" )
            , ( "flex-direction", "column" )
            , ( "display", "flex" )
            , ( "align-items", "center" )
            , ( "height", "100%" )
            , ( "margin", "1em" )
            , ( "font-family", "sans-serif" )
            ]
         ]

        [ h1 []
            [ text title ]
        , p
            [ style
                [ ( "color", "rgb(136, 136, 136)" )
                , ( "margin-top", "3em" )
                ]
            ]
            [ text message ]
        ]


viewHttpError : Http.Error -> Html msg
viewHttpError err =
    let
        genericTitle =
            "Something wrong happened!"
    in
        case err of
            Timeout ->
                viewError genericTitle "The server was too slow to respond (timeout)."

            NetworkError ->
                viewError genericTitle "There was a network error."

            UnexpectedPayload string ->
                viewError genericTitle "The server returned unexpected data."

            BadResponse code string ->
                if code == 404 then
                    viewNotFound
                else
                    viewError genericTitle string


viewLoading : Html msg
viewLoading =
    text "Data is loading and should be displayed quite soon."


viewNotFound : Html msg
viewNotFound =
    viewError
        "Page Not Found"
        "Sorry, but the page you were trying to view does not exist."


viewWebData : (LoadingStatus a -> List (Html msg)) -> WebData a -> List (Html msg)
viewWebData viewSuccess webData =
    case webData of
        NotAsked ->
            [ text "" ]

        Failure err ->
            [ viewHttpError err ]

        Data loadingStatus ->
            viewSuccess loadingStatus
