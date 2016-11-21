module Tool.View exposing (..)

import Dict
import Html exposing (..)
import Html.Attributes exposing (..)


-- import Html.Events exposing (onClick)

import Html.Helpers exposing (aExternal)


-- import Tool.Types exposing (Msg(..))

import Types exposing (Card, Statement, StatementCustom(..), getManyStrings, getOneString)
import WebData exposing (LoadingStatus(..))


-- VIEW


root : Bool -> LoadingStatus Statement -> Maybe (Html msg)
root additionalInformationsCollapsed loadingStatus =
    case loadingStatus of
        Loading maybeStatement ->
            Maybe.map (viewStatement additionalInformationsCollapsed) maybeStatement

        Loaded statement ->
            Just (viewStatement additionalInformationsCollapsed statement)


viewStatement : Bool -> Statement -> Html msg
viewStatement additionalInformationsCollapsed tool =
    case tool.custom of
        CardCustom card ->
            div [ class "row" ]
                [ viewSidebar card
                , viewCard additionalInformationsCollapsed card
                ]

        _ ->
            Debug.crash "StatementCustom constructor not supported"


viewSidebar : Card -> Html msg
viewSidebar card =
    div [ class "col-md-3 sidebar" ]
        [ div [ class "row" ]
            [ div [ class "col-xs-12" ]
                [ div [ class "thumbnail orga grey" ]
                    [ div [ class "visual" ]
                        [ img [ alt "screen", src "img/ckan.png" ]
                            []
                        ]
                    , div [ class "caption" ]
                        [ table [ class "table" ]
                            [ tbody []
                                [ tr [ class "editable" ]
                                    [ td [ class "table-label" ]
                                        [ text "Type" ]
                                    , td []
                                        [ text "Web Software" ]
                                    ]
                                , tr [ class "editable" ]
                                    [ td [ class "table-label" ]
                                        [ text "License" ]
                                    , td []
                                        [ text "Open-Source" ]
                                    ]
                                , tr [ class "editable" ]
                                    [ td [ class "table-label" ]
                                        [ text "Website" ]
                                    , td []
                                        (case getOneString "URL" card of
                                            Just url ->
                                                [ aExternal [ href url ] [ text url ] ]

                                            Nothing ->
                                                []
                                        )
                                    ]
                                , tr []
                                    [ td [ attribute "colspan" "2" ]
                                        [ button [ class "btn btn-default btn-action btn-block", type' "button" ]
                                            [ text "Use it" ]
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        , div [ class "row" ]
            [ div [ class "col-xs-12" ]
                [ div [ class "panel panel-default panel-side" ]
                    [ div [ class "panel-heading" ]
                        [ div [ class "row" ]
                            [ div [ class "col-xs-7 text-left" ]
                                [ h6 [ class "panel-title" ]
                                    [ text "Tags" ]
                                ]
                            , div [ class "col-xs-5 text-right up7" ]
                                [ button [ class "btn btn-default btn-xs btn-action", type' "button" ]
                                    [ text "Edit" ]
                                ]
                            ]
                        ]
                    , div [ class "panel-body" ]
                        (getManyStrings "Tag" card
                            |> List.map (\tag -> span [ class "label label-default label-tag" ] [ text tag ])
                        )
                    ]
                ]
            ]
        , div [ class "row" ]
            [ div [ class "col-xs-12" ]
                [ div [ class "panel panel-default panel-side" ]
                    [ div [ class "panel-heading" ]
                        [ div [ class "row" ]
                            [ div [ class "col-xs-7 text-left" ]
                                [ h6 [ class "panel-title" ]
                                    [ text "Similar tools" ]
                                ]
                            , div [ class "col-xs-5 text-right label-small" ]
                                [ text "Score" ]
                            ]
                        ]
                    , div [ class "panel-body chart" ]
                        [ table [ class "table" ]
                            [ tbody []
                                [ tr []
                                    [ th [ class "tool-icon-small", scope "row" ]
                                        [ img [ src "img/ckan.png" ]
                                            []
                                        , text "."
                                        ]
                                    , td []
                                        [ text "Udata" ]
                                    , td [ class "text-right label-small" ]
                                        [ text "50.367" ]
                                    ]
                                , tr []
                                    [ th [ class "tool-icon-small", scope "row" ]
                                        [ img [ src "img/consul.png" ]
                                            []
                                        ]
                                    , td []
                                        [ text "DKAN" ]
                                    , td [ class "text-right label-small" ]
                                        [ text "11.348" ]
                                    ]
                                , tr []
                                    [ th [ class "tool-icon-small", scope "row" ]
                                        [ img [ src "img/hackpad.png" ]
                                            []
                                        ]
                                    , td []
                                        [ text "OpenDataSoft" ]
                                    , td [ class "text-right label-small" ]
                                        [ text "7.032" ]
                                    ]
                                , tr []
                                    [ th [ class "tool-icon-small", scope "row" ]
                                        [ img [ src "img/ckan.png" ]
                                            []
                                        ]
                                    , td []
                                        [ text "Socrata Open Data" ]
                                    , td [ class "text-right label-small" ]
                                        [ text "3.456" ]
                                    ]
                                ]
                            ]
                        , button [ class "btn btn-default btn-xs btn-action btn-block", type' "button" ]
                            [ text "See all and compare" ]
                        ]
                    ]
                ]
            ]
        ]


viewCard : Bool -> Card -> Html msg
viewCard additionalInformationsCollapsed card =
    div [ class "col-md-9 content content-right" ]
        [ div [ class "row" ]
            [ div [ class "col-xs-12" ]
                [ h1 []
                    [ text (getOneString "Name" card |> Maybe.withDefault "")
                    , small []
                        [ text "Software" ]
                    ]
                ]
            ]
        , div [ class "row" ]
            [ div [ class "col-xs-12" ]
                [ span [ class "label label-default label-tag label-maintag" ]
                    [ text "Open-Data" ]
                , span [ class "label label-default label-tag label-maintag" ]
                    [ text "Portal" ]
                , span [ class "label label-default label-tag label-maintag" ]
                    [ text "Open-Government" ]
                ]
            ]
        , div [ class "row" ]
            [ div [ class "col-xs-12" ]
                (([ div [ class "panel panel-default" ]
                        [ div [ class "panel-heading" ]
                            [ div [ class "row" ]
                                [ div [ class "col-xs-8 text-left" ]
                                    [ h3 [ class "panel-title" ]
                                        [ text "About" ]
                                    ]
                                , div [ class "col-xs-4 text-right up7" ]
                                    [ a [ class "show-more" ]
                                        [ text
                                            ("Best of "
                                                ++ (getManyStrings "Description-EN" card |> List.length |> toString)
                                            )
                                        ]
                                    , button
                                        [ class "btn btn-default btn-xs btn-action"
                                        , attribute "data-target" "#edit-content"
                                        , attribute "data-toggle" "modal"
                                        , type' "button"
                                        ]
                                        [ text "Edit" ]
                                    ]
                                ]
                            ]
                        , div [ class "panel-body" ]
                            (case getOneString "Description-EN" card of
                                Just description ->
                                    [ text description ]

                                Nothing ->
                                    []
                            )
                        ]
                  ]
                 )
                    ++ [ div [ class "panel panel-default panel-collapse up20" ]
                            [ div
                                [ attribute "aria-controls" "collapseTwo"
                                , attribute "aria-expanded" "false"
                                , attribute "role" "tab"
                                , class "panel-heading"
                                , id "headingTwo"
                                  -- , onClick CollapseAdditionalInformations
                                ]
                                [ div [ class "row" ]
                                    [ div [ class "col-xs-8 text-left" ]
                                        [ h3 [ class "panel-title" ]
                                            [ text "Additional informations" ]
                                        ]
                                    , div [ class "col-xs-4 text-right" ]
                                        [ a [ class "show-more pull-right" ]
                                            [ text "Show 6 more"
                                            , span
                                                [ class
                                                    ("glyphicon "
                                                        ++ (if additionalInformationsCollapsed then
                                                                "glyphicon-menu-right"
                                                            else
                                                                "glyphicon-menu-down"
                                                           )
                                                    )
                                                ]
                                                []
                                            ]
                                        ]
                                    ]
                                ]
                            , div
                                [ attribute "aria-labelledby" "headingTwo"
                                , classList
                                    [ ( "panel-collapse", True )
                                    , ( "collapse", True )
                                    , ( "in", not additionalInformationsCollapsed )
                                    ]
                                , id "collapseTwo"
                                , attribute "role" "tabpanel"
                                ]
                                [ div [ class "panel-body nomargin" ]
                                    [ table [ class "table table-striped" ]
                                        [ tbody []
                                            (card
                                                |> Dict.keys
                                                |> List.map
                                                    (\propertyName ->
                                                        tr []
                                                            [ th [ scope "row" ]
                                                                [ text propertyName ]
                                                            , td []
                                                                [ text
                                                                    (getOneString propertyName card
                                                                        |> Maybe.withDefault ""
                                                                    )
                                                                ]
                                                            ]
                                                    )
                                            )
                                        ]
                                    ]
                                ]
                            ]
                       , div [ class "panel panel-default" ]
                            [ div [ class "panel-heading" ]
                                [ div [ class "row" ]
                                    [ div [ class "col-xs-8 text-left" ]
                                        [ h3 [ class "panel-title" ]
                                            [ text "Used for" ]
                                        ]
                                    , div [ class "col-xs-4 text-right up7" ]
                                        [ a [ class "show-more" ]
                                            [ text "Best of 129" ]
                                        , button [ class "btn btn-default btn-xs btn-action", type' "button" ]
                                            [ text "Add" ]
                                        ]
                                    ]
                                ]
                            , div [ class "panel-body" ]
                                [ div [ class "row" ]
                                    [ div [ class "col-xs-6 col-md-4 " ]
                                        [ div [ class "thumbnail example grey" ]
                                            [ div [ class "visual" ]
                                                [ img [ alt "screen", src "img/screen1.png" ]
                                                    []
                                                ]
                                            , div [ class "caption" ]
                                                [ div [ class "example-author-thumb" ]
                                                    [ img [ alt "screen", src "img/whitehouse.png" ]
                                                        []
                                                    ]
                                                , h4 []
                                                    [ text "OpenSpending" ]
                                                , p []
                                                    [ text "OpenSpending ." ]
                                                , span [ class "label label-default label-tool" ]
                                                    [ text "Default" ]
                                                , span [ class "label label-default label-tool" ]
                                                    [ text "Default" ]
                                                , span [ class "label label-default label-tool" ]
                                                    [ text "Default" ]
                                                ]
                                            ]
                                        ]
                                    , div [ class "col-sm-12 text-center" ]
                                        [ a [ class "show-more" ]
                                            [ text "Show all 398"
                                            , span [ class "glyphicon glyphicon-menu-down" ]
                                                []
                                            ]
                                        ]
                                    ]
                                ]
                            ]
                       , div [ class "panel panel-default" ]
                            [ div [ class "panel-heading" ]
                                [ div [ class "row" ]
                                    [ div [ class "col-xs-8 text-left" ]
                                        [ h3 [ class "panel-title" ]
                                            [ text "Used by" ]
                                        ]
                                    , div [ class "col-xs-4 text-right up7" ]
                                        [ a [ class "show-more" ]
                                            [ text "Best of 128" ]
                                        , button [ class "btn btn-default btn-xs btn-action", type' "button" ]
                                            [ text "Add" ]
                                        ]
                                    ]
                                ]
                            , div [ class "panel-body" ]
                                [ div [ class "row" ]
                                    [ div [ class "col-xs-6 col-md-4 " ]
                                        [ div [ class "thumbnail orga grey" ]
                                            [ div [ class "visual" ]
                                                [ img [ alt "logo", src "img/hackpad.png" ]
                                                    []
                                                ]
                                            , div [ class "caption" ]
                                                [ h4 []
                                                    [ text "The White House" ]
                                                , p []
                                                    [ text "OpenSpending" ]
                                                ]
                                            ]
                                        ]
                                    , div [ class "col-sm-12 text-center" ]
                                        [ a [ class "show-more" ]
                                            [ text "Show all 398"
                                            , span [ class "glyphicon glyphicon-menu-down" ]
                                                []
                                            ]
                                        ]
                                    ]
                                ]
                            ]
                       ]
                )
            ]
        ]
