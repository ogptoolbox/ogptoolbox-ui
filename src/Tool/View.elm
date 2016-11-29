module Tool.View exposing (..)

import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Helpers exposing (aForPath, aIfIsUrl)
import I18n exposing (getManyStrings, getOneString)
import Routes
import String
import Tool.Sidebar as Sidebar
import Types exposing (..)
import Views exposing (viewLoading)
import WebData exposing (LoadingStatus(..))


root : (String -> msg) -> I18n.Language -> LoadingStatus DataIdBody -> Html msg
root navigate language loadingStatus =
    case loadingStatus of
        Loading body ->
            case body of
                Nothing ->
                    viewLoading

                Just body ->
                    viewCard navigate language body

        Loaded body ->
            viewCard navigate language body


viewCard : (String -> msg) -> I18n.Language -> DataIdBody -> Html msg
viewCard navigate language body =
    let
        cards =
            body.data.cards

        values =
            body.data.values
    in
        case Dict.get body.data.id cards of
            Nothing ->
                text "Error: the card was not found."

            Just card ->
                div [ class "row" ]
                    [ Sidebar.root language card values
                    , viewCardContent navigate language card cards values
                    ]


viewCardContent : (String -> msg) -> I18n.Language -> Card -> Dict String Card -> Dict String Value -> Html msg
viewCardContent navigate language card cards values =
    div [ class "col-md-9 content content-right" ]
        [ div [ class "row" ]
            [ div [ class "col-xs-12" ]
                [ h1 []
                    [ text (getOneString language nameKeys card values |> Maybe.withDefault "TODO call-to-action")
                    , small []
                        [ text (String.join ", " card.subTypes) ]
                    ]
                ]
            ]
        , div [ class "row" ]
            [ div [ class "col-xs-12" ]
                (case getManyStrings language typeKeys card values of
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
                                        [ text (I18n.translate language I18n.About) ]
                                    ]
                                , div [ class "col-xs-4 text-right up7" ]
                                    [ a [ class "show-more" ]
                                        [ text
                                            ("Best of "
                                                ++ (getManyStrings language descriptionKeys card values
                                                        |> List.length
                                                        |> toString
                                                   )
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
                            [ text
                                (getOneString language descriptionKeys card values
                                    |> Maybe.withDefault "TODO call-to-action"
                                )
                            ]
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
                                            [ text (I18n.translate language I18n.AdditionalInformations) ]
                                        ]
                                    , div [ class "col-xs-4 text-right" ]
                                        [ a [ class "show-more pull-right" ]
                                            [ text ("Show " ++ (card.properties |> Dict.size |> toString) ++ " more")
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
                                            (card.properties
                                                |> Dict.map
                                                    (\propertyKey valueId ->
                                                        case Dict.get valueId values of
                                                            Nothing ->
                                                                text ("Error: value not found for ID: " ++ valueId)

                                                            Just value ->
                                                                tr []
                                                                    [ th [ scope "row" ]
                                                                        [ case Dict.get propertyKey values of
                                                                            Nothing ->
                                                                                text
                                                                                    ("Error: value not found for ID: "
                                                                                        ++ propertyKey
                                                                                    )

                                                                            Just value ->
                                                                                viewValueValue
                                                                                    language
                                                                                    navigate
                                                                                    cards
                                                                                    values
                                                                                    value.value
                                                                        ]
                                                                    , td []
                                                                        [ viewValueValue
                                                                            language
                                                                            navigate
                                                                            cards
                                                                            values
                                                                            value.value
                                                                        ]
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
                                            [ text (I18n.translate language I18n.UsedFor) ]
                                        ]
                                    , div [ class "col-xs-4 text-right up7" ]
                                        [ a [ class "show-more" ]
                                            [ text
                                                "Best of TODO"
                                              --                                             ("Best of "
                                              --     ++ (getManyStrings language usedForKeys card |> List.length |> toString)
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
                                  --         ((case getManyStrings language usedForKeys card of
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
                                            [ text (I18n.translate language I18n.UsedBy) ]
                                        ]
                                    , div [ class "col-xs-4 text-right up7" ]
                                        [ a [ class "show-more" ]
                                            [ text
                                                ("Best of "
                                                    ++ (getManyStrings language usedByKeys card values |> List.length |> toString)
                                                )
                                            ]
                                        , button [ class "btn btn-default btn-xs btn-action", type' "button" ]
                                            [ text "Add" ]
                                        ]
                                    ]
                                ]
                              -- , div [ class "panel-body" ]
                              --     [ div [ class "row" ]
                              --         ((case getManyStrings language usedByKeys card of
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
                )
            ]
        ]


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


viewValueValue : I18n.Language -> (String -> msg) -> Dict String Card -> Dict String Value -> ValueType -> Html msg
viewValueValue language navigate cards values value =
    case value of
        StringValue str ->
            aIfIsUrl [] str

        WrongValue str schemaId ->
            div []
                [ p [ style [ ( "color", "red" ) ] ] [ text "Wrong value!" ]
                , pre [] [ text str ]
                , p [] [ text ("schemaId: " ++ schemaId) ]
                ]

        LocalizedStringValue values ->
            dl []
                (values
                    |> Dict.toList
                    |> List.concatMap
                        (\( languageCode, childValue ) ->
                            [ dt [] [ text languageCode ]
                            , dd [] [ aIfIsUrl [] childValue ]
                            ]
                        )
                )

        NumberValue float ->
            text (toString float)

        ArrayValue childValues ->
            ul [ class "list-unstyled" ]
                (List.map
                    (\childValue -> li [] [ viewValueValue language navigate cards values childValue ])
                    childValues
                )

        BijectiveUriReferenceValue { targetId } ->
            case Dict.get targetId cards of
                Nothing ->
                    text ("Error: target card not found for ID: " ++ targetId)

                Just card ->
                    let
                        linkText =
                            case getOneString language nameKeys card values of
                                Nothing ->
                                    targetId

                                Just name ->
                                    name
                    in
                        case Routes.pathForCard card of
                            Nothing ->
                                text
                                    ("Error: impossible to determine the path of the referenced card; targetId: "
                                        ++ targetId
                                    )

                            Just urlPath ->
                                aForPath navigate
                                    urlPath
                                    []
                                    [ text linkText ]
