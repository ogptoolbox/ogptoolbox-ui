module Tool.View exposing (..)

import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Html.Helpers exposing (aExternal, aForPath, aIfIsUrl, imgForCard)
import Routes exposing (pathForStatement)
import String
import Tool.Sidebar as Sidebar
import Types exposing (..)
import Views exposing (viewLoading)
import WebData exposing (LoadingStatus(..))


root : (String -> msg) -> LoadingStatus DataIdBody -> Html msg
root navigate loadingStatus =
    case loadingStatus of
        Loading body ->
            case body of
                Nothing ->
                    viewLoading

                Just body ->
                    viewStatement navigate body

        Loaded body ->
            viewStatement navigate body


viewCard : (String -> msg) -> Dict String Statement -> Card -> Html msg
viewCard navigate statements card =
    div [ class "col-md-9 content content-right" ]
        [ div [ class "row" ]
            [ div [ class "col-xs-12" ]
                [ h1 []
                    [ text (getOneString nameKeys card |> Maybe.withDefault "TODO call-to-action")
                    , small []
                        [ text (getManyStrings cardTypeKeys card |> String.join ", ") ]
                    ]
                ]
            ]
        , div [ class "row" ]
            [ div [ class "col-xs-12" ]
                (case getManyStrings typeKeys card of
                    [] ->
                        [ text "TODO call-to-action" ]

                    xs ->
                        List.map
                            (\str -> span [ class "label label-default label-tag label-maintag" ] [ text str ])
                            xs
                )
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
                                                ++ (getManyStrings descriptionKeys card |> List.length |> toString)
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
                            [ text (getOneString descriptionKeys card |> Maybe.withDefault "TODO call-to-action") ]
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
                                ]
                                [ div [ class "row" ]
                                    [ div [ class "col-xs-8 text-left" ]
                                        [ h3 [ class "panel-title" ]
                                            [ text "Additional informations" ]
                                        ]
                                    , div [ class "col-xs-4 text-right" ]
                                        [ a [ class "show-more pull-right" ]
                                            [ text ("Show " ++ (card |> Dict.size |> toString) ++ " more")
                                            , span [ class "glyphicon glyphicon-menu-down" ] []
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
                                                    (\propertyKey cardField ->
                                                        tr []
                                                            [ th [ scope "row" ]
                                                                [ text propertyKey ]
                                                            , td []
                                                                [ viewCardField navigate statements cardField ]
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
                                            [ text
                                                "Best of TODO"
                                              --                                             ("Best of "
                                              --     ++ (getManyStrings usedForKeys card |> List.length |> toString)
                                              -- )
                                            ]
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
                                                [ img [ alt "screen", src "/img/screen1.png" ]
                                                    []
                                                ]
                                            , div [ class "caption" ]
                                                [ div [ class "example-author-thumb" ]
                                                    [ img [ alt "screen", src "/img/whitehouse.png" ]
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
                                    ]
                                  -- , div [ class "panel-body" ]
                                  --     [ div [ class "row" ]
                                  --         ((case getManyStrings usedForKeys card of
                                  --             [] ->
                                  --                 [ text "TODO call-to-action" ]
                                  --             targetIds ->
                                  --                 targetIds
                                  --                     |> List.map
                                  --                         (\targetId ->
                                  --                             viewUriReferenceAsThumbnail navigate statements targetId
                                  --                         )
                                  --                     |> List.append (viewShowMore (List.length targetIds))
                                  --          )
                                  --         )
                                  --     ]
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
                                            [ text
                                                ("Best of "
                                                    ++ (getManyStrings usedByKeys card |> List.length |> toString)
                                                )
                                            ]
                                        , button [ class "btn btn-default btn-xs btn-action", type' "button" ]
                                            [ text "Add" ]
                                        ]
                                    ]
                                ]
                            , div [ class "panel-body" ]
                                [ div [ class "row" ]
                                    ((case getManyStrings usedByKeys card of
                                        [] ->
                                            [ text "TODO call-to-action" ]

                                        targetIds ->
                                            targetIds
                                                |> List.map
                                                    (\targetId ->
                                                        viewUriReferenceAsThumbnail navigate statements targetId
                                                    )
                                                |> List.append (viewShowMore (List.length targetIds))
                                     )
                                    )
                                ]
                            ]
                       ]
                )
            ]
        ]


viewCardField : (String -> msg) -> Dict String Statement -> CardField -> Html msg
viewCardField navigate statements cardField =
    case cardField of
        StringField { format, value } ->
            case format of
                Nothing ->
                    aIfIsUrl [] value

                Just format ->
                    case format of
                        UriReference ->
                            viewUriReferenceAsLink navigate statements value

                        Uri ->
                            aIfIsUrl [] value

                        Email ->
                            a [ href ("mailto:" ++ value) ] [ text value ]

        NumberField float ->
            text (toString float)

        ArrayField cardFields ->
            ul [ class "list-unstyled" ]
                (List.map
                    (\cardField -> li [] [ viewCardField navigate statements cardField ])
                    cardFields
                )

        BijectiveUriReferenceField targetId ->
            viewUriReferenceAsLink navigate statements targetId


viewShowMore : number -> List (Html msg)
viewShowMore count =
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


viewUriReferenceAsLink : (String -> msg) -> Dict String Statement -> String -> Html msg
viewUriReferenceAsLink navigate statements statementId =
    case Dict.get statementId statements of
        Nothing ->
            text ("Error: the referenced statement (id: " ++ statementId ++ " ) was not found in statements.")

        Just statement ->
            case pathForStatement statement of
                Just urlPath ->
                    case statement.custom of
                        CardCustom card ->
                            aForPath navigate
                                urlPath
                                []
                                [ text
                                    (getOneString nameKeys card
                                        |> Maybe.withDefault "TODO call-to-action"
                                    )
                                ]

                Nothing ->
                    text ("Error: impossible to determine the path of the referenced statement (id: " ++ statementId)


viewUriReferenceAsThumbnail : (String -> msg) -> Dict String Statement -> String -> Html msg
viewUriReferenceAsThumbnail navigate statements statementId =
    case Dict.get statementId statements of
        Nothing ->
            text ("Error: the referenced statement (id: " ++ statementId ++ " ) was not found in statements.")

        Just statement ->
            case pathForStatement statement of
                Just urlPath ->
                    case statement.custom of
                        CardCustom card ->
                            div [ class "col-xs-6 col-md-4", onClick (navigate urlPath) ]
                                [ div [ class "thumbnail orga grey" ]
                                    [ div [ class "visual" ]
                                        [ imgForCard [] "261x140" card ]
                                    , div [ class "caption" ]
                                        [ h4 []
                                            [ aForPath navigate
                                                urlPath
                                                []
                                                [ text
                                                    (getOneString nameKeys card
                                                        |> Maybe.withDefault "TODO call-to-action"
                                                    )
                                                ]
                                            ]
                                        , p []
                                            [ text
                                                (getOneString descriptionKeys card
                                                    |> Maybe.withDefault "TODO call-to-action"
                                                )
                                            ]
                                        ]
                                    ]
                                ]

                Nothing ->
                    text ("Error: impossible to determine the path of the referenced statement (id: " ++ statementId)


viewStatement : (String -> msg) -> DataIdBody -> Html msg
viewStatement navigate body =
    case Dict.get body.data.id body.data.statements of
        Nothing ->
            text "Error: this should never happen due to the JSON decoder."

        Just statement ->
            case statement.custom of
                CardCustom card ->
                    div [ class "row" ]
                        [ Sidebar.root card
                        , viewCard navigate body.data.statements card
                        ]
