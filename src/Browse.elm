module Browse exposing (..)

import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Html.Helpers exposing (aForPath, imgForCard)
import String
import Types exposing (..)
import Views exposing (viewLoading)
import WebData exposing (getData, getLoadingStatusData, LoadingStatus(..), WebData(..))


type alias PillCounts =
    Maybe
        { examples : Int
        , organizations : Int
        , tools : Int
        }


cardTypeCount : CardType -> Maybe { b | examples : a, organizations : a, tools : a } -> Maybe a
cardTypeCount cardType counts =
    Maybe.map
        (\{ examples, organizations, tools } ->
            case cardType of
                Example ->
                    examples

                Organization ->
                    organizations

                Tool ->
                    tools
        )
        counts


view : CardType -> PillCounts -> (String -> msg) -> String -> LoadingStatus DataIdsBody -> List (Html msg)
view cardType counts navigate searchQuery loadingStatus =
    [ div [ class "browse-tag" ]
        [ div [ class "row" ]
            [ div [ class "container-fluid" ]
                [ img [ src "/img/bubbles2.png" ]
                    []
                , div [ class "row filters" ]
                    [ div [ class "col-md-12 text-center" ]
                        [ text "Showing results suited for                    "
                        , a
                            [ class "btn btn-default dropdown-toggle"
                            , attribute "data-slide-to" "2"
                            , href "#carousel-example-generic"
                            , attribute "role" "button"
                            ]
                            [ text "all organizations                    " ]
                        , text "and available in                     "
                        , a
                            [ class "btn btn-default dropdown-toggle"
                            , attribute "data-slide-to" "3"
                            , href "#carousel-example-generic"
                            , attribute "role" "button"
                            ]
                            [ text "English                    " ]
                        ]
                    ]
                ]
            ]
        ]
    , div [ class "scroll-content" ]
        [ div [ class "row browse" ]
            [ div [ class "container-fluid" ]
                ((if String.isEmpty searchQuery then
                    []
                  else
                    [ div [ class "row" ]
                        [ h1 [] [ text ("Search results for \"" ++ searchQuery ++ "\"") ] ]
                    ]
                 )
                    ++ [ div [ class "row fixed" ]
                            [ div [ class "col-xs-12" ]
                                [ ul [ class "nav nav-pills nav-justified", attribute "role" "tablist" ]
                                    [ li
                                        [ classList
                                            [ ( "active"
                                              , case cardType of
                                                    Example ->
                                                        True

                                                    _ ->
                                                        False
                                              )
                                            ]
                                        , attribute "role" "presentation"
                                        ]
                                        [ aForPath navigate
                                            ("/examples?q=" ++ searchQuery)
                                            []
                                            [ text "Examples "
                                            , span [ class "badge" ]
                                                [ text
                                                    (case counts of
                                                        Nothing ->
                                                            "0"

                                                        Just counts ->
                                                            toString counts.examples
                                                    )
                                                ]
                                            ]
                                        ]
                                    , li
                                        [ classList
                                            [ ( "active"
                                              , case cardType of
                                                    Tool ->
                                                        True

                                                    _ ->
                                                        False
                                              )
                                            ]
                                        , attribute "role" "presentation"
                                        ]
                                        [ aForPath navigate
                                            ("/tools?q=" ++ searchQuery)
                                            []
                                            [ text "Tools "
                                            , span [ class "badge" ]
                                                [ text
                                                    (case counts of
                                                        Nothing ->
                                                            "0"

                                                        Just counts ->
                                                            toString counts.tools
                                                    )
                                                ]
                                            ]
                                        ]
                                    , li
                                        [ classList
                                            [ ( "active"
                                              , case cardType of
                                                    Organization ->
                                                        True

                                                    _ ->
                                                        False
                                              )
                                            ]
                                        , attribute "role" "presentation"
                                        ]
                                        [ aForPath navigate
                                            ("/organizations?q=" ++ searchQuery)
                                            []
                                            [ text "Organizations "
                                            , span [ class "badge" ]
                                                [ text
                                                    (case counts of
                                                        Nothing ->
                                                            "0"

                                                        Just counts ->
                                                            toString counts.organizations
                                                    )
                                                ]
                                            ]
                                        ]
                                    ]
                                ]
                            ]
                       , div [ class "row list" ]
                            ((case loadingStatus of
                                Loading body ->
                                    [ viewLoading ]
                                        ++ (case body of
                                                Nothing ->
                                                    []

                                                Just body ->
                                                    viewStatements
                                                        cardType
                                                        navigate
                                                        (Dict.values body.data.statements)
                                           )

                                Loaded body ->
                                    viewStatements cardType navigate (Dict.values body.data.statements)
                             )
                                ++ (let
                                        count =
                                            cardTypeCount cardType counts
                                    in
                                        case count of
                                            Nothing ->
                                                []

                                            Just count ->
                                                if count > 20 then
                                                    -- TODO Do not hardcode limit
                                                    [ div [ class "col-sm-12 text-center" ]
                                                        [ a [ class "show-more" ]
                                                            [ text ("Show all " ++ (toString count))
                                                            , span [ class "glyphicon glyphicon-menu-down" ]
                                                                []
                                                            ]
                                                        ]
                                                    ]
                                                else
                                                    []
                                   )
                            )
                       ]
                )
            ]
        ]
    ]


viewStatements : CardType -> (String -> msg) -> List Statement -> List (Html msg)
viewStatements cardType navigate statements =
    statements
        |> filterByCardType cardType
        |> List.map (viewTool cardType navigate)


viewTool : CardType -> (String -> msg) -> Statement -> Html msg
viewTool cardType navigate statement =
    let
        statementUrl =
            (case cardType of
                Example ->
                    "/examples/"

                Organization ->
                    "/organizations/"

                Tool ->
                    "/tools/"
            )
                ++ statement.id

        card =
            case statement.custom of
                CardCustom card ->
                    card
    in
        div [ class "col-xs-12" ]
            [ div [ class "thumbnail example", onClick (navigate statementUrl) ]
                [ div [ class "visual" ]
                    [ imgForCard [] "95x98" card ]
                , div [ class "caption" ]
                    ([ h4 []
                        [ aForPath
                            navigate
                            statementUrl
                            []
                            [ text (getOneString nameKeys card |> Maybe.withDefault "") ]
                        , small []
                            [ text "Software" ]
                        ]
                     , div [ class "example-author" ]
                        [ img [ alt "screen", src "/img/whitehouse.png" ]
                            []
                        , text "The White House"
                        ]
                     , p []
                        (case getOneString descriptionKeys card of
                            Just description ->
                                [ text description ]

                            Nothing ->
                                []
                        )
                     ]
                        ++ (case getManyStrings typeKeys card of
                                [] ->
                                    [ text "TODO call-to-action" ]

                                xs ->
                                    List.map
                                        (\str -> span [ class "label label-default label-tool" ] [ text str ])
                                        xs
                           )
                    )
                ]
            ]
