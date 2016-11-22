module Tool.View exposing (..)

import Dict
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Helpers exposing (aExternal, aIfIsUrl)
import Tool.Sidebar as Sidebar


-- import Tool.Types exposing (Msg(..))

import Types exposing (..)
import WebData exposing (LoadingStatus(..))


-- VIEW


root : Bool -> LoadingStatus Statement -> Maybe (Html msg)
root additionalInformationsCollapsed loadingStatus =
    case loadingStatus of
        Loading maybeStatement ->
            Maybe.map (viewStatement additionalInformationsCollapsed) maybeStatement

        Loaded statement ->
            Just (viewStatement additionalInformationsCollapsed statement)


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
                                , attribute "data-parent" "#accordion"
                                , attribute "data-target" "#collapseTwo"
                                , attribute "data-toggle" "collapse"
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
                                            [ text ("Show " ++ (card |> Dict.size |> toString) ++ " more")
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
                                    ]
                                , id "collapseTwo"
                                , attribute "role" "tabpanel"
                                ]
                                [ div [ class "panel-body nomargin" ]
                                    [ table [ class "table table-striped" ]
                                        [ tbody []
                                            (card
                                                |> Dict.map
                                                    (\propertyName cardField ->
                                                        tr []
                                                            [ th [ scope "row" ]
                                                                [ text propertyName ]
                                                            , td []
                                                                [ viewCardField cardField ]
                                                            ]
                                                    )
                                                |> Dict.values
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


viewCardField : CardField -> Html msg
viewCardField cardField =
        case cardField of
            StringField { format, value } ->
                case format of
                    Nothing ->
                            aIfIsUrl [] value

                    Just format ->
                        case format of
                            UriReference ->
                                text "TODO"

                            Uri ->
                                aIfIsUrl [] value

                            Email ->
                                a [ href ("mailto:" ++ value) ] [ text value ]

            NumberField float ->
                text (toString float)

            ArrayField cardFields ->
                ul [ class "list-unstyled" ]
                    (List.map
                        (\cardField -> li [] [ viewCardField cardField ])
                        cardFields
                    )

            BijectiveUriReferenceField string ->
                text string


viewStatement : Bool -> Statement -> Html msg
viewStatement additionalInformationsCollapsed tool =
    case tool.custom of
        CardCustom card ->
            div [ class "row" ]
                [ Sidebar.root card
                , viewCard additionalInformationsCollapsed card
                ]

        _ ->
            Debug.crash "StatementCustom constructor not supported"
