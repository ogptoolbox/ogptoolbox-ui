module Views exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Http exposing (Error(..))
import I18n
import WebData exposing (LoadingStatus, WebData(..))


viewBigMessage : String -> String -> Html msg
viewBigMessage title message =
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
                viewBigMessage genericTitle (I18n.translate language I18n.TimeoutExplanation)

            NetworkError ->
                viewBigMessage genericTitle (I18n.translate language I18n.NetworkErrorExplanation)

            UnexpectedPayload string ->
                viewBigMessage genericTitle (I18n.translate language I18n.UnexpectedPayloadExplanation)

            BadResponse code string ->
                if code == 404 then
                    viewNotFound language
                else
                    viewBigMessage genericTitle string


viewLoading : I18n.Language -> Html msg
viewLoading language =
    viewBigMessage
        (I18n.translate language I18n.PageLoading)
        (I18n.translate language I18n.PageLoadingExplanation)


viewNotFound : I18n.Language -> Html msg
viewNotFound language =
    viewBigMessage
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
