module Browse exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import String
import Types exposing (Card, Statement, StatementCustom(..))
import Views exposing (aForPath, viewLoading)
import WebData exposing (LoadingStatus(..))


type PillType
    = Examples
    | Tools
    | Organizations


view : PillType -> (String -> msg) -> String -> LoadingStatus (List Statement) -> List (Html msg)
view activePill navigate searchQuery loadingStatus =
    [ div [ class "browse-tag" ]
        [ div [ class "row" ]
            [ div [ class "container-fluid" ]
                [ img [ src "img/bubbles2.png" ]
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
                                              , case activePill of
                                                    Examples ->
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
                                                [ text "42" ]
                                            ]
                                        ]
                                    , li
                                        [ classList
                                            [ ( "active"
                                              , case activePill of
                                                    Tools ->
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
                                                [ text "42" ]
                                            ]
                                        ]
                                    , li
                                        [ classList
                                            [ ( "active"
                                              , case activePill of
                                                    Organizations ->
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
                                                [ text "42" ]
                                            ]
                                        ]
                                    ]
                                ]
                            ]
                       , div [ class "row list" ]
                            ((case loadingStatus of
                                Loading maybeStatements ->
                                    [ viewLoading ]
                                        ++ (case maybeStatements of
                                                Nothing ->
                                                    []

                                                Just statements ->
                                                    viewStatements activePill navigate statements
                                           )

                                Loaded statements ->
                                    viewStatements activePill navigate statements
                             )
                                ++ [ div [ class "col-sm-12 text-center" ]
                                        [ a [ class "show-more" ]
                                            [ text "Show all 398"
                                            , span [ class "glyphicon glyphicon-menu-down" ]
                                                []
                                            ]
                                        ]
                                   ]
                            )
                       ]
                )
            ]
        ]
    ]


viewStatements : PillType -> (String -> msg) -> List Statement -> List (Html msg)
viewStatements activePill navigate statements =
    List.map
        (\statement ->
            case statement.custom of
                CardCustom card ->
                    viewTool activePill statement card navigate

                _ ->
                    text "statement.custom is not a Card"
        )
        statements


viewTool : PillType -> Statement -> Card -> (String -> msg) -> Html msg
viewTool activePill statement card navigate =
    let
        statementUrl =
            (case activePill of
                Examples ->
                    "/examples/"

                Organizations ->
                    "/organizations/"

                Tools ->
                    "/tools/"
            )
                ++ statement.id
    in
        div [ class "col-xs-12" ]
            [ div [ class "thumbnail example", onClick (navigate statementUrl) ]
                [ div [ class "visual" ]
                    [ img [ alt "screen", src "img/screen1.png" ]
                        []
                    ]
                , div [ class "caption" ]
                    ([ h4 []
                        [ aForPath navigate statementUrl [] [ text card.name ]
                        , small []
                            [ text "Software" ]
                        ]
                     , div [ class "example-author" ]
                        [ img [ alt "screen", src "img/whitehouse.png" ]
                            []
                        , text "The White House"
                        ]
                     , p []
                        [ text card.description ]
                     , span [ class "label label-default label-tool" ]
                        [ text "Default" ]
                     , span [ class "label label-default label-tool" ]
                        [ text "Default" ]
                     , span [ class "label label-default label-tool" ]
                        [ text "Default" ]
                     ]
                    )
                ]
            ]
