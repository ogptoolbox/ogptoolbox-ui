module Views exposing (..)

import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Helpers exposing (aForPath)
import Http exposing (Error(..))
import I18n exposing (getImageUrl, getName, getManyStrings, getOneString, getSubTypes)
import Routes
import String
import Types exposing (..)
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


viewCardListItem : (String -> msg) -> I18n.Language -> Dict String Value -> Card -> Html msg
viewCardListItem navigate language values card =
    let
        name =
            getName language card values

        urlPath =
            Routes.urlPathForCard card

        cardType =
            getCardType card
    in
        div
            [ class
                ("thumbnail "
                    ++ case cardType of
                        UseCaseCard ->
                            "example"

                        ToolCard ->
                            "tool"

                        OrganizationCard ->
                            "orga"
                )
            , onClick (navigate urlPath)
            ]
            [ div [ class "visual" ]
                [ case getImageUrl language "300" card values of
                    Just url ->
                        img [ alt "Logo", src url ] []

                    Nothing ->
                        h1 [ class "dynamic" ]
                            [ text
                                (case cardType of
                                    OrganizationCard ->
                                        String.left 1 name

                                    ToolCard ->
                                        String.left 2 name

                                    UseCaseCard ->
                                        name
                                )
                            ]
                ]
            , div [ class "caption" ]
                [ h4 []
                    [ aForPath
                        navigate
                        language
                        urlPath
                        []
                        [ text name ]
                    , small []
                        [ text (getSubTypes language card values |> String.join ", ") ]
                    ]
                  -- , div [ class "example-author" ]
                  --     [ img [ alt "screen", src "/img/TODO.png" ]
                  --         []
                  --     , text "TODO The White House"
                  --     ]
                , p []
                    (case getOneString language descriptionKeys card values of
                        Just description ->
                            [ text description ]

                        Nothing ->
                            []
                    )
                ]
            , viewTagsWithCallToAction navigate language values card
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
    div [ style [ ( "height", "100em" ) ] ]
        [ img [ class "loader", src "/img/loader.gif" ] [] ]


viewNotFound : I18n.Language -> Html msg
viewNotFound language =
    viewBigMessage
        (I18n.translate language I18n.PageNotFound)
        (I18n.translate language I18n.PageNotFoundExplanation)


viewTagsWithCallToAction : (String -> msg) -> I18n.Language -> Dict String Value -> Card -> Html msg
viewTagsWithCallToAction navigate language values card =
    div [ class "tags" ]
        (case getManyStrings language tagKeys card values of
            [] ->
                [ span
                    -- TODO call to action
                    [ class "label label-default label-tool" ]
                    [ text (I18n.translate language I18n.CallToActionForCategory) ]
                ]

            xs ->
                xs
                    |> List.take 3
                    |> List.map
                        (\str ->
                            span
                                -- TODO Create link to search results with tagId= in URL
                                -- aForPath
                                --     navigate
                                --     language
                                --     ((Routes.urlBasePathForCard card) ++ "tagId=" ++ TODO)
                                [ class "label label-default label-tool" ]
                                [ text str ]
                        )
        )


viewWebData : I18n.Language -> (LoadingStatus a -> Html msg) -> WebData a -> Html msg
viewWebData language viewSuccess webData =
    case webData of
        NotAsked ->
            div [ class "text-center" ]
                [ viewLoading language ]

        Failure err ->
            viewHttpError language err

        Data loadingStatus ->
            viewSuccess loadingStatus
