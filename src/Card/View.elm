module Card.View exposing (..)

import Card.Types exposing (..)
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Helpers exposing (aExternal, aForPath, aIfIsUrl)
import I18n exposing (getImageLogoUrl, getImageScreenshotUrl, getImageUrl, getManyStrings, getName, getOneString, getSubTypes)
import Routes
import String
import Types exposing (..)
import Views exposing (viewCardListItem, viewLoading, viewWebData)
import WebData exposing (LoadingStatus(..))


view : Model -> I18n.Language -> Html Msg
view model language =
    viewWebData
        language
        (\loadingStatus ->
            case loadingStatus of
                Loading _ ->
                    div [ class "text-center" ]
                        [ viewLoading language ]

                Loaded body ->
                    viewCard language body
        )
        model


viewCard : I18n.Language -> DataIdBody -> Html Msg
viewCard language body =
    let
        cards =
            body.data.cards

        values =
            body.data.values

        card =
            getCard cards body.data.id
    in
        let
            container =
                div [ class "container" ]
                    [ div
                        [ class "row" ]
                        [ viewSidebar language card values
                        , viewCardContent language card cards values
                        ]
                    ]
        in
            case getImageScreenshotUrl language "" card values of
                Just url ->
                    div []
                        [ div [ class "banner screenshot" ]
                            [ div [ class "row " ]
                                [ div [ class "col-md-12 text-center" ]
                                    [ img [ src url ] [] ]
                                ]
                            ]
                        , div [ class "row pull-screenshot" ]
                            [ div [ class "container" ]
                                [-- div [ class "row" ]
                                 -- [ div [ class "col-xs-12" ]
                                 --     [ ol [ class "breadcrumb" ]
                                 --         [ li []
                                 --             [ a [ href "#" ]
                                 --                 [ text "Home" ]
                                 --             ]
                                 --         , li []
                                 --             [ a [ href "#" ]
                                 --                 [ text "Library" ]
                                 --             ]
                                 --         , li [ class "active" ]
                                 --             [ text "Data" ]
                                 --         ]
                                 --     ]
                                 -- ]
                                ]
                            ]
                        , div [ class "row section push-screenshot" ]
                            [ container ]
                        ]

                Nothing ->
                    div [ class "row section" ]
                        [ container ]


viewCardContent : I18n.Language -> Card -> Dict String Card -> Dict String Value -> Html Msg
viewCardContent language card cards values =
    let
        bestOf keys =
            let
                count =
                    List.length (getManyStrings language keys card values)
            in
                if count == 1 then
                    text ""
                else
                    text (I18n.translate language (I18n.BestOf count))
    in
        div
            [ classList
                [ ( "col-md-9 content content-right", True )
                , ( "push-screenshot"
                  , case getImageScreenshotUrl language "" card values of
                        Nothing ->
                            False

                        Just _ ->
                            True
                  )
                ]
            ]
            [ div [ class "row" ]
                [ div [ class "col-xs-12" ]
                    [ h1 []
                        [ text (getName language card values)
                        , small []
                            [ text (getSubTypes language card values |> String.join ", ") ]
                        ]
                    ]
                ]
            , div [ class "row" ]
                [ div [ class "col-xs-12" ]
                    (case getSubTypes language card values of
                        [] ->
                            [ button [ class "call-add" ] [ text "+ add a category" ] ]

                        xs ->
                            List.map
                                (\str -> span [ class "label label-default label-tag label-maintag" ] [ text str ])
                                xs
                    )
                ]
            , div [ class "row" ]
                [ div [ class "col-xs-12" ]
                    (([ div [ class "panel panel-default" ]
                            (let
                                panelTitle =
                                    div [ class "col-xs-8 text-left" ]
                                        [ h3 [ class "panel-title" ]
                                            [ text (I18n.translate language I18n.About) ]
                                        ]
                             in
                                case getOneString language descriptionKeys card values of
                                    Nothing ->
                                        [ div [ class "panel-heading" ]
                                            [ div [ class "row" ]
                                                [ panelTitle ]
                                            ]
                                        , div [ class "panel-body" ]
                                            [ div [ class "call-container" ]
                                                [ p [] [ text "No description for this tool yet." ]
                                                , button [ class "button call-add" ] [ text "+ Add a description" ]
                                                ]
                                            ]
                                        ]

                                    Just description ->
                                        [ div [ class "panel-heading" ]
                                            [ div [ class "row" ]
                                                [ panelTitle
                                                , div [ class "col-xs-4 text-right up7" ]
                                                    [ a [ class "show-more" ]
                                                        [ bestOf descriptionKeys ]
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
                                            [ p []
                                                [ text description ]
                                            ]
                                        ]
                            )
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
                                                                                        cards
                                                                                        values
                                                                                        value.value
                                                                            ]
                                                                        , td []
                                                                            [ viewValueValue
                                                                                language
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
                                        ]
                                    ]
                                , div [ class "panel-body" ]
                                    [ case Dict.get "software" card.references of
                                        Nothing ->
                                            div [ class "call-container" ]
                                                [ p [] [ text "No use case listed for this tool yet." ]
                                                , button [ class "button call-add" ] [ text "+ Add a use case" ]
                                                ]

                                        Just cardIds ->
                                            div [ class "row list" ]
                                                [ div [ class "col-xs-12" ]
                                                    (List.filterMap
                                                        (\cardId ->
                                                            Dict.get cardId cards
                                                                |> Maybe.map
                                                                    (viewCardListItem
                                                                        navigate
                                                                        language
                                                                        values
                                                                    )
                                                        )
                                                        cardIds
                                                    )
                                                ]
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
                                                [ bestOf usedByKeys ]
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
                                  --                             viewCardReferenceAsThumbnail navigate statements targetId
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



-- viewShowMore : number -> List (Html msg)
-- viewShowMore count =
--     if count > 20 then
--         -- TODO Do not hardcode limit
--         [ div [ class "col-sm-12 text-center" ]
--             [ a [ class "show-more" ]
--                 [ text ("Show all " ++ (toString count))
--                 , span [ class "glyphicon glyphicon-menu-down" ]
--                     []
--                 ]
--             ]
--         ]
--     else
--         []


viewSidebar : I18n.Language -> Card -> Dict String Value -> Html Msg
viewSidebar language card values =
    -- let
    --     viewSimilarTools =
    --         div [ class "row" ]
    --             [ div [ class "col-xs-12" ]
    --                 [ div [ class "panel panel-default panel-side" ]
    --                     [ div [ class "panel-heading" ]
    --                         [ div [ class "row" ]
    --                             [ div [ class "col-xs-7 text-left" ]
    --                                 [ h6 [ class "panel-title" ]
    --                                     [ text (I18n.translate language I18n.SimilarTools) ]
    --                                 ]
    --                             , div [ class "col-xs-5 text-right label-small" ]
    --                                 [ text (I18n.translate language I18n.Score) ]
    --                             ]
    --                         ]
    --                     , div [ class "panel-body chart" ]
    --                         [ table [ class "table" ]
    --                             [ tbody []
    --                                 [ tr []
    --                                     [ th [ class "tool-icon-small", scope "row" ]
    --                                         [ img [ src "/img/TODO.png" ]
    --                                             []
    --                                         ]
    --                                     , td []
    --                                         [ text "TODO Udata" ]
    --                                     , td [ class "text-right label-small" ]
    --                                         [ text "TODO 50.367" ]
    --                                     ]
    --                                 ]
    --                             ]
    --                         , button [ class "btn btn-default btn-xs btn-action btn-block", type' "button" ]
    --                             [ text (I18n.translate language I18n.SeeAllAndCompare) ]
    --                         ]
    --                     ]
    --                 ]
    --             ]
    -- in
    div [ class "col-md-3 sidebar" ]
        [ div [ class "row" ]
            [ div [ class "col-xs-12" ]
                [ div [ class "thumbnail orga grey" ]
                    [ div [ class "visual" ]
                        [ case getImageLogoUrl language "1000" card values of
                            Just url ->
                                img [ alt "Logo", src url ] []

                            Nothing ->
                                div [ class "call-container" ]
                                    [ button [ class "button call-add" ]
                                        [ text "+ Add a logo" ]
                                    ]
                        ]
                    , div [ class "caption" ]
                        [ table [ class "table" ]
                            [ tbody []
                                [ tr [ class "editable" ]
                                    [ td [ class "table-label" ]
                                        [ text (I18n.translate language I18n.Type) ]
                                    , td []
                                        [ text "TODO type" ]
                                    ]
                                , tr [ class "editable" ]
                                    [ td [ class "table-label" ]
                                        [ text (I18n.translate language I18n.License) ]
                                    , td []
                                        [ text (getOneString language licenseKeys card values |> Maybe.withDefault "") ]
                                    ]
                                , let
                                    firstTd =
                                        td [ class "table-label" ]
                                            [ text (I18n.translate language I18n.Website) ]
                                  in
                                    case getOneString language urlKeys card values of
                                        Nothing ->
                                            tr []
                                                [ firstTd
                                                , td []
                                                    [ button [ class "button call-add" ]
                                                        [ text "+ Add a link" ]
                                                    ]
                                                ]

                                        Just url ->
                                            tr [ class "editable" ]
                                                [ firstTd
                                                , td [] [ aExternal [ href url ] [ text url ] ]
                                                ]
                                , tr []
                                    [ td [ attribute "colspan" "2" ]
                                        [ button [ class "btn btn-default btn-action btn-block", type' "button" ]
                                            [ text (I18n.translate language I18n.UseIt) ]
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
                    (let
                        panelTitle =
                            div [ class "col-xs-7 text-left" ]
                                [ h6 [ class "panel-title" ]
                                    [ text (I18n.translate language I18n.Tags) ]
                                ]
                     in
                        case getManyStrings language tagKeys card values of
                            [] ->
                                [ div [ class "panel-heading" ]
                                    [ div [ class "row" ] [ panelTitle ] ]
                                , div [ class "panel-body" ]
                                    [ div [ class "call-container" ]
                                        [ button [ class "button call-add" ]
                                            [ text "+ Add a tag" ]
                                        ]
                                    ]
                                ]

                            tags ->
                                [ div [ class "panel-heading" ]
                                    [ div [ class "row" ]
                                        [ panelTitle
                                        , div [ class "col-xs-5 text-right up7" ]
                                            [ button [ class "btn btn-default btn-xs btn-action", type' "button" ]
                                                [ text "Edit" ]
                                            ]
                                        ]
                                    ]
                                , div [ class "panel-body" ]
                                    (List.map
                                        (\tag -> span [ class "label label-default label-tag" ] [ text tag ])
                                        tags
                                    )
                                ]
                    )
                ]
            ]
          -- , viewSimilarTools -- TODO
        ]


viewValueValue : I18n.Language -> Dict String Card -> Dict String Value -> ValueType -> Html Msg
viewValueValue language cards values value =
    let
        cardLink cardId =
            case Dict.get cardId cards of
                Nothing ->
                    text ("Error: target card not found for ID: " ++ cardId)

                Just card ->
                    let
                        linkText =
                            case getOneString language nameKeys card values of
                                Nothing ->
                                    cardId

                                Just name ->
                                    name

                        urlPath =
                            Routes.urlPathForCard card
                    in
                        aForPath navigate language urlPath [] [ text linkText ]
    in
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

            CardIdArrayValue childValues ->
                ul [ class "list-unstyled" ]
                    (List.map
                        (\childValue -> li [] [ viewValueValue language cards values (CardIdValue childValue) ])
                        childValues
                    )

            ValueIdArrayValue childValues ->
                ul [ class "list-unstyled" ]
                    (List.map
                        (\childValue -> li [] [ viewValueValue language cards values (ValueIdValue childValue) ])
                        childValues
                    )

            BijectiveCardReferenceValue { targetId } ->
                cardLink targetId

            CardIdValue cardId ->
                cardLink cardId

            ValueIdValue valueId ->
                case Dict.get valueId values of
                    Nothing ->
                        text ("Error: referenced value not found for valueId: " ++ valueId)

                    Just subValue ->
                        viewValueValue language cards values subValue.value
