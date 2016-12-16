module Views exposing (..)

import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Helpers exposing (aForPath)
import Http exposing (Error(..))
import I18n
import Routes
import String
import Types exposing (..)
import WebData exposing (LoadingStatus, WebData(..))


getHttpErrorAsString : I18n.Language -> Http.Error -> String
getHttpErrorAsString language err =
    case err of
        BadPayload message response ->
            I18n.translate language I18n.BadPayloadExplanation

        BadStatus response ->
            if response.status.code == 404 then
                I18n.translate language I18n.PageNotFoundExplanation
            else
                -- TODO Add I18n.BadStatusExplanation prefix
                toString response

        BadUrl message ->
            I18n.translate language I18n.BadUrlExplanation

        NetworkError ->
            I18n.translate language I18n.NetworkErrorExplanation

        Timeout ->
            I18n.translate language I18n.TimeoutExplanation


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
            I18n.getName language card values

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
                [ case I18n.getImageUrl language "300" card values of
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
                        [ text (I18n.getSubTypes language card values |> String.join ", ") ]
                    ]
                  -- , div [ class "example-author" ]
                  --     [ img [ alt "screen", src "/img/TODO.png" ]
                  --         []
                  --     , text "TODO The White House"
                  --     ]
                , p []
                    (case I18n.getOneString language descriptionKeys card values of
                        Just description ->
                            [ text description ]

                        Nothing ->
                            []
                    )
                ]
            , viewTagsWithCallToAction navigate language values card
            ]


viewCardThumbnail : I18n.Language -> (String -> msg) -> String -> Dict String Value -> Card -> Html msg
viewCardThumbnail language navigate extraClass values card =
    let
        name =
            I18n.getName language card values

        urlPath =
            Routes.urlPathForCard card

        cardType =
            getCardType card
    in
        div [ class "col-xs-12 col-sm-6 col-md-4 col-lg-3" ]
            [ aForPath
                navigate
                language
                urlPath
                [ class ("thumbnail " ++ extraClass) ]
                [ div [ class "visual" ]
                    [ case I18n.getImageUrl language "500" card values of
                        Just url ->
                            img [ alt "logo", src url ] []

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
                        [ text name ]
                    , case I18n.getOneString language descriptionKeys card values of
                        Just description ->
                            p [] [ text description ]

                        Nothing ->
                            p
                                [ class "call" ]
                                [ text (I18n.translate language (I18n.CallToActionForDescription cardType)) ]
                    ]
                , viewTagsWithCallToAction navigate language values card
                ]
            ]


viewLoading : I18n.Language -> Html msg
viewLoading language =
    div [ style [ ( "height", "100em" ) ] ]
        [ img [ class "loader", src "/img/loader.gif" ] [] ]


viewNotAuthentified : I18n.Language -> Html msg
viewNotAuthentified language =
    viewBigMessage
        (I18n.translate language I18n.AuthenticationRequired)
        (I18n.translate language I18n.AuthenticationRequiredExplanation)


viewNotFound : I18n.Language -> Html msg
viewNotFound language =
    viewBigMessage
        (I18n.translate language I18n.PageNotFound)
        (I18n.translate language I18n.PageNotFoundExplanation)


viewTagsWithCallToAction : (String -> msg) -> I18n.Language -> Dict String Value -> Card -> Html msg
viewTagsWithCallToAction navigate language values card =
    div [ class "tags" ]
        (case I18n.getTags language card values of
            [] ->
                [ span
                    -- TODO call to action
                    [ class "label label-default label-tool" ]
                    [ text (I18n.translate language I18n.CallToActionForCategory) ]
                ]

            tags ->
                tags
                    |> List.take 3
                    |> List.map
                        (\{ tag, tagId } ->
                            let
                                urlPath =
                                    Routes.urlBasePathForCard card ++ "?tagIds=" ++ tagId
                            in
                                aForPath
                                    navigate
                                    language
                                    urlPath
                                    [ class "label label-default label-tool" ]
                                    [ text tag ]
                        )
        )


viewWebData : I18n.Language -> (LoadingStatus a -> Html msg) -> WebData a -> Html msg
viewWebData language viewSuccess webData =
    case webData of
        NotAsked ->
            div [ class "text-center" ]
                [ viewLoading language ]

        Failure err ->
            let
                genericTitle =
                    I18n.translate language I18n.GenericError

                title =
                    case err of
                        BadPayload message response ->
                            genericTitle

                        BadStatus response ->
                            if response.status.code == 404 then
                                I18n.translate language I18n.PageNotFound
                            else
                                -- TODO Add I18n.BadStatusExplanation prefix
                                genericTitle

                        BadUrl message ->
                            genericTitle

                        NetworkError ->
                            genericTitle

                        Timeout ->
                            genericTitle
            in
                viewBigMessage title (getHttpErrorAsString language err)

        Data loadingStatus ->
            viewSuccess loadingStatus
