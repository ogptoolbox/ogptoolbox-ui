module Views exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Http exposing (Error(..))
import I18n
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


viewHttpError : I18n.Language -> Http.Error -> Html msg
viewHttpError language err =
    let
        genericTitle =
            I18n.translate language I18n.GenericError
    in
        case err of
            Timeout ->
                viewError genericTitle (I18n.translate language I18n.TimeoutExplanation)

            NetworkError ->
                viewError genericTitle (I18n.translate language I18n.NetworkErrorExplanation)

            UnexpectedPayload string ->
                viewError genericTitle (I18n.translate language I18n.UnexpectedPayloadExplanation)

            BadResponse code string ->
                if code == 404 then
                    viewNotFound language
                else
                    viewError genericTitle string


viewLoading : Html msg
viewLoading =
    text "Data is loading and should be displayed quite soon."


viewNotFound : I18n.Language -> Html msg
viewNotFound language =
    viewError
        (I18n.translate language I18n.PageNotFound)
        (I18n.translate language I18n.PageNotFoundExplanation)


viewWebData : I18n.Language -> (LoadingStatus a -> List (Html msg)) -> WebData a -> List (Html msg)
viewWebData language viewSuccess webData =
    case webData of
        NotAsked ->
            [ text "" ]

        Failure err ->
            [ viewHttpError language err ]

        Data loadingStatus ->
            viewSuccess loadingStatus
