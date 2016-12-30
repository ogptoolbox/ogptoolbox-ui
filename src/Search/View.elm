module Search.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Helpers exposing (aForPath)
import I18n
import Navigation
import Search.Types exposing (..)
import Types exposing (..)
import Urls
import Views exposing (viewCardListItem, viewLoading, viewWebData)
import WebData exposing (getData, getLoadingStatusData, LoadingStatus(..), WebData(..))


searchResultsListPaginationSize : Int
searchResultsListPaginationSize =
    20


view : Model -> CardType -> I18n.Language -> Navigation.Location -> Html Msg
view { organizations, tools, useCases } activeCardType language location =
    let
        webData =
            case activeCardType of
                OrganizationCard ->
                    organizations

                ToolCard ->
                    tools

                UseCaseCard ->
                    useCases

        viewCardListItems =
            viewWebData language
                (\loadingStatus ->
                    case loadingStatus of
                        Loading _ ->
                            div [ class "col-xs-12 text-center" ]
                                [ viewLoading language ]

                        Loaded body ->
                            div [ class "col-xs-12" ]
                                ((List.map
                                    (viewCardListItem Search.Types.navigate language body.data.values)
                                    (getOrderedCards body.data)
                                 )
                                    ++ (if body.count > searchResultsListPaginationSize then
                                            [ div [ class "col-sm-12 text-center" ]
                                                [ a [ class "show-more" ]
                                                    [ text (I18n.translate language (I18n.ShowAll body.count))
                                                    , span [ class "glyphicon glyphicon-menu-down" ]
                                                        []
                                                    ]
                                                ]
                                            ]
                                        else
                                            []
                                       )
                                )
                )
                webData

        viewPills =
            div [ class "col-xs-12" ]
                [ ul [ class "nav nav-pills nav-justified", attribute "role" "tablist" ]
                    (List.map
                        (\( cardType, translationId, count ) ->
                            li
                                [ classList [ ( "active", activeCardType == cardType ) ]
                                , attribute "role" "presentation"
                                ]
                                [ aForPath
                                    navigate
                                    language
                                    ((Urls.basePathForCardType cardType)
                                        ++ (Urls.queryStringForParams [ "q", "tagIds" ] location)
                                    )
                                    []
                                    [ text (I18n.translate language (translationId I18n.Plural))
                                    , span [ class "badge" ]
                                        [ text
                                            (case count of
                                                Nothing ->
                                                    "..."

                                                Just count ->
                                                    toString count
                                            )
                                        ]
                                    ]
                                ]
                        )
                        [ -- This order is the displayed one, do not change it.
                          ( UseCaseCard, I18n.UseCase, getData useCases |> Maybe.map .count )
                        , ( ToolCard, I18n.Tool, getData tools |> Maybe.map .count )
                        , ( OrganizationCard, I18n.Organization, getData organizations |> Maybe.map .count )
                        ]
                    )
                ]
    in
        div []
            [ div [ class "browse-tag" ]
                [ div [ class "row" ]
                    [ div [ class "container-fluid" ]
                        [ div [ class "tag" ] [ div [ class "bubbles" ] [] ]
                          -- , div [ class "row filters" ]
                          --     [ div [ class "col-md-12 text-center" ]
                          --         [ text "Showing results suited for"
                          --         , a
                          --             [ class "btn btn-default dropdown-toggle"
                          --             , attribute "data-slide-to" "2"
                          --             , href "#carousel-example-generic"
                          --             , attribute "role" "button"
                          --             ]
                          --             [ text "all organizations" ]
                          --         , text "and available in"
                          --         , a
                          --             [ class "btn btn-default dropdown-toggle"
                          --             , attribute "data-slide-to" "3"
                          --             , href "#carousel-example-generic"
                          --             , attribute "role" "button"
                          --             ]
                          --             [ text "English" ]
                          --         ]
                          --     ]
                        ]
                    ]
                ]
            , div [ class "scroll-content" ]
                [ div [ class "row browse" ]
                    [ div [ class "container-fluid" ]
                        [ div [ class "row fixed" ]
                            [ viewPills ]
                        , div [ class "row list p90" ]
                            [ viewCardListItems ]
                        ]
                    ]
                ]
            ]
