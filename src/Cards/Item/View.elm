module Cards.Item.View exposing (..)

import Cards.Item.Types exposing (..)
import Cards.ViewsParts exposing (..)
import Configuration
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Helpers exposing (aExternal, aForPath, aIfIsUrl)
import Http
import I18n
import Json.Decode as Decode
import Set
import String
import Types exposing (..)
import Urls
import Values.New.View
import Values.ViewsParts exposing (viewValueTypeLine)
import Views exposing (viewCardListItem, viewLoading)


view : Model -> Html Msg
view model =
    case Dict.get model.cardId model.data.cards of
        Just card ->
            viewCard model card

        Nothing ->
            div [ class "text-center" ]
                [ viewLoading model.language ]


viewCard : Model -> Card -> Html Msg
viewCard model card =
    let
        data =
            model.data

        cards =
            data.cards

        language =
            model.language

        values =
            data.values
    in
        let
            container =
                div [ class "container" ]
                    [ div
                        [ class "row" ]
                        ([ viewSidebar model card
                         , viewCardContent model card
                         ]
                            ++ (case model.editedKeyId of
                                    Just editedKeyId ->
                                        [ viewEditPropertyModal model card editedKeyId ]

                                    Nothing ->
                                        []
                               )
                            ++ (if model.displayUseItModal then
                                    case Dict.get card.id Configuration.useItData of
                                        Just { frenchGovDeployUrl } ->
                                            [ viewUseItModal model.language frenchGovDeployUrl ]

                                        Nothing ->
                                            []
                                else
                                    []
                               )
                        )
                    ]
        in
            case Urls.screenshotFullUrl language "" card values of
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


viewCardContent : Model -> Card -> Html Msg
viewCardContent model card =
    let
        data =
            model.data

        cards =
            data.cards

        language =
            model.language

        values =
            data.values

        bestOf keys =
            let
                count =
                    List.length (I18n.getManyStrings language keys card values)
            in
                if count == 1 then
                    text ""
                else
                    text (I18n.translate language (I18n.BestOf count))

        viewAdditionalInformation keyId valueId =
            case Dict.get valueId values of
                Nothing ->
                    text ("Error: value not found for ID: " ++ valueId)

                Just valueValue ->
                    tr []
                        [ th [ scope "row" ]
                            [ case Dict.get keyId values of
                                Nothing ->
                                    text
                                        ("Error: value not found for ID: "
                                            ++ keyId
                                        )

                                Just keyValue ->
                                    viewValueTypeLine language (Just navigate) data False keyValue.value
                            ]
                        , td []
                            [ viewValueTypeLine language (Just navigate) data False valueValue.value
                            ]
                        , td []
                            [ button
                                [ class "btn btn-default btn-xs btn-action"
                                , onClick (ForSelf (LoadProperties keyId))
                                , type_ "button"
                                ]
                                [ text (I18n.translate language (I18n.Edit)) ]
                            ]
                        ]
    in
        div
            [ classList
                [ ( "col-md-9 content content-right", True )
                , ( "push-screenshot"
                  , case Urls.screenshotFullUrl language "" card values of
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
                        [ text (I18n.getName language card values)
                        , small []
                            [ text (I18n.getSubTypes language card values |> String.join ", ") ]
                        , button
                            [ attribute "data-target" "#edit-content"
                            , attribute "data-toggle" "modal"
                            , class "btn btn-default btn-xs btn-action4"
                            , onClick (ForSelf (LoadProperties "name"))
                            , style [ ( "margin-left", "15px" ) ]
                            , type_ "button"
                            ]
                            [ text (I18n.translate language (I18n.Edit)) ]
                        ]
                    ]
                ]
            , div [ class "row" ]
                [ div [ class "col-xs-12" ]
                    (case I18n.getUsages language card values of
                        -- [] ->
                        --     [ button [ class "call-add" ] [ text "+ add a category" ] ]
                        usages ->
                            List.map
                                (\{ tag, tagId } ->
                                    let
                                        path =
                                            Urls.basePathForCard card ++ "?tagIds=" ++ tagId
                                    in
                                        aForPath
                                            navigate
                                            language
                                            path
                                            [ class "label label-default label-tag label-maintag" ]
                                            [ text tag ]
                                )
                                usages
                    )
                ]
            , div [ class "row" ]
                [ div [ class "col-xs-12" ]
                    (([ div [ class "panel panel-default" ]
                            (let
                                panelTitle =
                                    div [ class "col-xs-8 text-left" ]
                                        [ h3 [ class "panel-title" ]
                                            [ text (I18n.translate language I18n.Description) ]
                                        ]

                                cardType =
                                    getCardType card
                             in
                                case I18n.getOneString language descriptionKeys card values of
                                    Nothing ->
                                        [ div [ class "panel-heading" ]
                                            [ div [ class "row" ]
                                                [ panelTitle ]
                                            ]
                                        , div [ class "panel-body" ]
                                            [ div [ class "call-container" ]
                                                [ p [] [ text (I18n.translate language (I18n.MissingDescription)) ]
                                                , button
                                                    [ class "button call-add"
                                                    , onClick (ForSelf (LoadProperties "description"))
                                                    ]
                                                    [ text (I18n.translate language (I18n.CallToActionForDescription cardType)) ]
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
                                                        [ attribute "data-target" "#edit-content"
                                                        , attribute "data-toggle" "modal"
                                                        , class "btn btn-default btn-xs btn-action"
                                                        , onClick (ForSelf (LoadProperties "description"))
                                                        , type_ "button"
                                                        ]
                                                        [ text (I18n.translate language (I18n.Edit)) ]
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
                                                    |> Dict.map viewAdditionalInformation
                                                    |> Dict.values
                                                )
                                            ]
                                        ]
                                    ]
                                ]
                           , (if cardSubTypeIdsIntersect card.subTypeIds cardTypesForOrganization then
                                div [ class "panel panel-default" ]
                                    [ div [ class "panel-heading" ]
                                        [ div [ class "row" ]
                                            [ div [ class "col-xs-8 text-left" ]
                                                [ h3 [ class "panel-title" ]
                                                    [ text (I18n.translate language I18n.UseCases) ]
                                                ]
                                            , div [ class "col-xs-4 text-right up7" ]
                                                -- [ a [ class "show-more" ]
                                                --     [ bestOf usagesKeys ]
                                                [ button
                                                    [ class "btn btn-default btn-xs btn-action"
                                                    , onClick (ForSelf (LoadProperties "use-cases"))
                                                    , type_ "button"
                                                    ]
                                                    [ text (I18n.translate language (I18n.Add)) ]
                                                ]
                                            ]
                                        ]
                                    , div [ class "panel-body" ]
                                        -- TODO Get different keys by card.type
                                        [ case Dict.get "use-case" card.references of
                                            Nothing ->
                                                div [ class "call-container" ]
                                                    [ p [] [ text "No use case listed for this organization yet." ]
                                                    , button
                                                        [ class "button call-add"
                                                        , onClick (ForSelf (LoadProperties "use-cases"))
                                                        ]
                                                        [ text "+ Add a use case" ]
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
                              else
                                text ""
                             )
                           , (if cardSubTypeIdsIntersect card.subTypeIds cardTypesForTool then
                                div [ class "panel panel-default" ]
                                    [ div [ class "panel-heading" ]
                                        [ div [ class "row" ]
                                            [ div [ class "col-xs-8 text-left" ]
                                                [ h3 [ class "panel-title" ]
                                                    [ text (I18n.translate language I18n.UsedFor) ]
                                                ]
                                            , div [ class "col-xs-4 text-right up7" ]
                                                -- [ a [ class "show-more" ]
                                                --     [ bestOf usedForKeys ]
                                                [ button
                                                    [ class "btn btn-default btn-xs btn-action"
                                                    , onClick (ForSelf (LoadProperties "used-for"))
                                                    , type_ "button"
                                                    ]
                                                    [ text (I18n.translate language (I18n.Add)) ]
                                                ]
                                            ]
                                        ]
                                    , div [ class "panel-body" ]
                                        -- TODO Get different keys by card.type
                                        [ case Dict.get "use-case" card.references of
                                            Nothing ->
                                                div [ class "call-container" ]
                                                    [ p [] [ text "No use case listed for this tool yet." ]
                                                    , button
                                                        [ class "button call-add"
                                                        , onClick (ForSelf (LoadProperties "used-for"))
                                                        ]
                                                        [ text "+ Add a use case" ]
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
                              else
                                text ""
                             )
                           , (if not (cardSubTypeIdsIntersect card.subTypeIds cardTypesForTool) then
                                div [ class "panel panel-default" ]
                                    [ div [ class "panel-heading" ]
                                        [ div [ class "row" ]
                                            [ div [ class "col-xs-8 text-left" ]
                                                [ h3 [ class "panel-title" ]
                                                    [ text (I18n.translate language I18n.Uses) ]
                                                ]
                                            , div [ class "col-xs-4 text-right up7" ]
                                                -- [ a [ class "show-more" ]
                                                --     [ bestOf usesKeys ]
                                                [ button
                                                    [ class "btn btn-default btn-xs btn-action"
                                                    , onClick (ForSelf (LoadProperties "uses"))
                                                    , type_ "button"
                                                    ]
                                                    [ text (I18n.translate language (I18n.Add)) ]
                                                ]
                                            ]
                                        ]
                                    , div [ class "panel-body" ]
                                        -- TODO Get different keys by card.type
                                        [ case
                                            Set.union
                                                (Set.fromList
                                                    (Dict.get "platform" card.references |> Maybe.withDefault [])
                                                )
                                                (Set.fromList
                                                    (Dict.get "software" card.references |> Maybe.withDefault [])
                                                )
                                                |> Set.toList
                                          of
                                            [] ->
                                                div [ class "call-container" ]
                                                    [ p [] [ text "No tool listed for this use case yet." ]
                                                    , button
                                                        [ class "button call-add"
                                                        , onClick (ForSelf (LoadProperties "uses"))
                                                        ]
                                                        [ text "+ Add a tool" ]
                                                    ]

                                            cardIds ->
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
                              else
                                text ""
                             )
                           , (if not (cardSubTypeIdsIntersect card.subTypeIds cardTypesForOrganization) then
                                div [ class "panel panel-default" ]
                                    [ div [ class "panel-heading" ]
                                        [ div [ class "row" ]
                                            [ div [ class "col-xs-8 text-left" ]
                                                [ h3 [ class "panel-title" ]
                                                    [ text (I18n.translate language I18n.UsedBy) ]
                                                ]
                                            , div [ class "col-xs-4 text-right up7" ]
                                                -- [ a [ class "show-more" ]
                                                --     [ bestOf usedByKeys ]
                                                [ button
                                                    [ class "btn btn-default btn-xs btn-action"
                                                    , onClick (ForSelf (LoadProperties "used-by"))
                                                    , type_ "button"
                                                    ]
                                                    [ text (I18n.translate language (I18n.Add)) ]
                                                ]
                                            ]
                                        ]
                                    , div [ class "panel-body" ]
                                        [ case Dict.get "organization" card.references of
                                            Nothing ->
                                                div [ class "call-container" ]
                                                    [ p [] [ text "No organization listed for this tool yet." ]
                                                    , button
                                                        [ class "button call-add"
                                                        , onClick (ForSelf (LoadProperties "used-by"))
                                                        ]
                                                        [ text "+ Add an organization" ]
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
                              else
                                text ""
                             )
                           ]
                    )
                ]
            ]


viewEditPropertyModal : Model -> Card -> String -> Html Msg
viewEditPropertyModal model card editedKeyId =
    let
        data =
            model.data

        cards =
            data.cards

        language =
            model.language

        values =
            data.values

        viewProperty index property =
            let
                value =
                    Dict.get property.valueId values

                ballot =
                    Dict.get property.ballotId data.ballots
            in
                li [ classList [ ( "media", True ), ( "best", index == 0 ) ] ]
                    [ div [ class "media-body" ]
                        (-- [
                         -- h4 [ class "media-heading" ]
                         -- [  text "TODO author"
                         -- TODO Format date with elm-date or something
                         -- , span []
                         --     [ text value.createdAt ]
                         --   ],
                         -- ]
                         (case value of
                            Nothing ->
                                []

                            Just value ->
                                [ viewValueTypeLine language (Just navigate) data True value.value ]
                         )
                        )
                    , div [ class "media-right" ]
                        [ a [ class "btn-vote" ]
                            [ span
                                [ attribute "aria-hidden" "true"
                                , class "glyphicon glyphicon-arrow-up"
                                , onClick (ForSelf (VotePropertyUp property.id))
                                , style
                                    (case ballot of
                                        Nothing ->
                                            []

                                        Just ballot ->
                                            if ballot.rating == 1 then
                                                [ ( "color", "blue" ) ]
                                            else
                                                []
                                    )
                                  -- TODO replace with "active" class
                                ]
                                []
                            ]
                        , div [ class "count" ]
                            [ text (toString property.ratingSum) ]
                        , a [ class "btn-vote" ]
                            [ span
                                [ attribute "aria-hidden" "true"
                                , class "glyphicon glyphicon-arrow-down"
                                , onClick (ForSelf (VotePropertyDown property.id))
                                , style
                                    (case ballot of
                                        Nothing ->
                                            []

                                        Just ballot ->
                                            if ballot.rating == -1 then
                                                [ ( "color", "blue" ) ]
                                            else
                                                []
                                    )
                                  -- TODO replace with "active" class
                                ]
                                []
                            ]
                        ]
                    ]
    in
        div []
            [ div
                [ attribute "aria-labelledby" "myModalLabel"
                , class "modal fade in"
                , id "edit-content"
                , attribute "role" "dialog"
                , attribute "tabindex" "-1"
                , style [ ( "display", "block" ) ]
                ]
                [ div [ class "modal-dialog", id "edit-overlay" ]
                    [ div [ class "modal-content" ]
                        [ div [ class "modal-header" ]
                            [ button
                                [ attribute "data-dismiss" "modal"
                                , class "close"
                                , onClick (ForSelf CloseEditPropertiesModal)
                                , type_ "button"
                                ]
                                [ span [ attribute "aria-hidden" "true" ]
                                    [ text "×" ]
                                , span [ class "sr-only" ]
                                    [ text "Close" ]
                                ]
                            , h4 [ class "modal-title", id "myModalLabel" ]
                                ((case Dict.get editedKeyId values of
                                    Nothing ->
                                        []

                                    Just key ->
                                        [ case I18n.getOneStringFromValueType language values key.value of
                                            Nothing ->
                                                Debug.crash "viewEditPropertyModal: property should have a string value"

                                            Just str ->
                                                text str
                                        ]
                                 )
                                    ++ [ span []
                                            [ text
                                                (I18n.translate language
                                                    (I18n.CountVersionsAvailable (List.length model.sameKeyPropertyIds))
                                                )
                                            ]
                                       ]
                                )
                            ]
                        , div [ class "modal-body", style [ ( "min-height", "35em" ) ] ]
                            [ div [ class "row" ]
                                [ div [ class "col-xs-8" ]
                                    [ ul [ class "media-list" ]
                                        (model.sameKeyPropertyIds
                                            |> List.map (getProperty data.properties)
                                            |> List.indexedMap viewProperty
                                        )
                                    ]
                                , div [ class "col-xs-4 grey fullheight-right" ]
                                    [ div []
                                        [ h5 [ attribute "aria-hidden" "true" ]
                                            [ text (I18n.translate language I18n.AddYourContribution) ]
                                        , Values.New.View.viewForm I18n.Add model.newValueModel
                                            |> Html.map translateNewValueMsg
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            , div [ class "modal-backdrop in" ] []
            ]


viewUseItModal : I18n.Language -> String -> Html Msg
viewUseItModal language frenchGovDeployUrl =
    div []
        [ div
            [ attribute "aria-labelledby" "myModalLabel"
            , class "modal fade in"
            , id "useit"
            , attribute "role" "dialog"
            , attribute "style" "display: block; padding-right: 6px;"
            , attribute "tabindex" "-1"
            ]
            [ div [ class "modal-dialog", id "login-overlay" ]
                [ div [ class "modal-content" ]
                    [ div [ class "modal-header" ]
                        [ button
                            [ class "close"
                            , attribute "data-dismiss" "modal"
                            , onClick (ForSelf (DisplayUseItModal False))
                            , type_ "button"
                            ]
                            [ span [ attribute "aria-hidden" "true" ]
                                [ text "×" ]
                            , span [ class "sr-only" ]
                                [ text "Close" ]
                            ]
                        , h4 [ class "modal-title", id "myModalLabel" ]
                            [ text (I18n.translate language (I18n.UseTool)) ]
                        ]
                    , div [ class "modal-body" ]
                        [ div [ class "row" ]
                            [ div [ class "col-xs-12" ]
                                [ -- a [ class "media action", href "#" ]
                                  --     [ div [ class "media-left icon" ]
                                  --         [ span [ attribute "aria-hidden" "true", class "glyphicon glyphicon-save" ]
                                  --             []
                                  --         ]
                                  --     , div [ class "media-body" ]
                                  --         [ h4 [ class "media-heading" ]
                                  --             [ text "Download" ]
                                  --         , text "Install this tool on your own machine."
                                  --         ]
                                  --     ]
                                  span
                                    [ class "media action" ]
                                    [ div [ class "media-left icon" ]
                                        [ span [ attribute "aria-hidden" "true", class "glyphicon glyphicon-cloud-upload" ]
                                            []
                                        ]
                                    , div [ class "media-body" ]
                                        [ h4 [ class "media-heading" ]
                                            [ text (I18n.translate language (I18n.ServiceDisclaimer)) ]
                                        , text (I18n.translate language (I18n.Deploy))
                                        , ul [ class "options" ]
                                            [ li [ class "option" ]
                                                [ a
                                                    [ href frenchGovDeployUrl
                                                    , rel "external"
                                                    , target "_blank"
                                                    ]
                                                    [ span []
                                                        [ text (I18n.translate language (I18n.DeployFrenchGov))
                                                        , i []
                                                            [ text (I18n.translate language (I18n.DeployFrenchGovEligibility)) ]
                                                        ]
                                                    ]
                                                ]
                                              -- , li [ class "option" ]
                                              --     [ text "Deployer avec Octo" ]
                                              -- , li [ class "option" ]
                                              --     [ text "Deployer avec Capgemini" ]
                                            ]
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        , div [ class "modal-backdrop in" ] []
        ]



-- viewShowMore : number -> List (Html msg)
-- viewShowMore count =
--     if count > 20 then
--         -- TODO Do not hardcode limit
--         [ div [ class "col-sm-12 text-center" ]
--             [ a [ class "show-more" ]
--                 [ text (I18n.ShowAll count)
--                 , span [ class "glyphicon glyphicon-menu-down" ]
--                     []
--                 ]
--             ]
--         ]
--     else
--         []


viewSidebar : Model -> Card -> Html Msg
viewSidebar model card =
    let
        data =
            model.data

        language =
            model.language

        values =
            data.values

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
    in
        div [ class "col-md-3 sidebar" ]
            [ div [ class "row" ]
                [ div [ class "col-xs-12" ]
                    [ div [ class "thumbnail orga grey" ]
                        [ div [ class "visual" ]
                            [ case Urls.logoFullUrl language "1000" card values of
                                Just url ->
                                    div []
                                        [ button
                                            [ class "button call-add pull-right"
                                            , onClick (ForSelf (LoadProperties "logo"))
                                            ]
                                            [ text (I18n.translate language I18n.Edit) ]
                                        , img [ alt "Logo", src url ] []
                                        ]

                                Nothing ->
                                    div [ class "call-container" ]
                                        [ button
                                            [ class "button call-add"
                                            , onClick (ForSelf (LoadProperties "logo"))
                                            ]
                                            [ text (I18n.translate language I18n.AddALogo) ]
                                        ]
                            ]
                        , div [ class "caption" ]
                            [ table [ class "table" ]
                                [ tbody []
                                    ([ --      tr [ class "editable" ]
                                       --     [ td [ class "table-label" ]
                                       --         [ text (I18n.translate language I18n.Type) ]
                                       --     , td []
                                       --         [ text "TODO type" ]
                                       --     ]
                                       -- ,
                                       tr
                                        [ class "editable"
                                        , onClick (ForSelf (LoadProperties "license"))
                                        ]
                                        [ td [ class "table-label" ]
                                            [ text (I18n.translate language I18n.License) ]
                                        , td []
                                            [ text
                                                (I18n.getOneString language licenseKeys card values
                                                    |> Maybe.withDefault ""
                                                )
                                            ]
                                        ]
                                     , div [ class "opensource-card" ]
                                        [ viewCardOpenSourceStatus language values card ]
                                     , let
                                        firstTd =
                                            td [ class "table-label" ]
                                                [ text (I18n.translate language I18n.Website) ]
                                       in
                                        case I18n.getOneString language urlKeys card values of
                                            Nothing ->
                                                tr []
                                                    [ firstTd
                                                    , td []
                                                        [ button
                                                            [ class "button call-add"
                                                            , onClick (ForSelf (LoadProperties "website"))
                                                            ]
                                                            [ text "+ Add a link" ]
                                                        ]
                                                    ]

                                            Just url ->
                                                tr
                                                    [ class "editable"
                                                    , onClick (ForSelf (LoadProperties "website"))
                                                    ]
                                                    [ firstTd
                                                    , td [] [ aExternal [ href url ] [ text url ] ]
                                                    ]
                                     ]
                                        ++ (case Dict.get card.id Configuration.useItData of
                                                Nothing ->
                                                    []

                                                Just { frenchGovDeployUrl } ->
                                                    [ tr []
                                                        [ td [ attribute "colspan" "2" ]
                                                            [ button
                                                                [ class "btn btn-default btn-action btn-block"
                                                                , onClick (ForSelf (DisplayUseItModal True))
                                                                , type_ "button"
                                                                ]
                                                                [ text (I18n.translate language I18n.UseIt) ]
                                                            ]
                                                        ]
                                                    ]
                                           )
                                    )
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
                            case I18n.getTags language card values of
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
                                                [ button
                                                    [ class "btn btn-default btn-xs btn-action"
                                                    , onClick (ForSelf (LoadProperties "tags"))
                                                    , type_ "button"
                                                    ]
                                                    [ text (I18n.translate language (I18n.Edit)) ]
                                                ]
                                            ]
                                        ]
                                    , div [ class "panel-body" ]
                                        (List.map
                                            (\{ tag, tagId } ->
                                                let
                                                    path =
                                                        Urls.basePathForCard card ++ "?tagIds=" ++ tagId
                                                in
                                                    aForPath
                                                        navigate
                                                        language
                                                        path
                                                        [ class "label label-default label-tag" ]
                                                        [ text tag ]
                                            )
                                            tags
                                        )
                                    ]
                        )
                    ]
                ]
              -- , viewSimilarTools -- TODO
            , div
                [ class "row" ]
                [ div [ class "col-xs-12" ]
                    [ div [ class "panel panel-default panel-side" ]
                        [ h6 [ class "panel-title" ]
                            [ text (I18n.translate language I18n.Share) ]
                        , div [ class "panel-body chart" ]
                            (let
                                cardName =
                                    I18n.getName language card values

                                imageUrl =
                                    I18n.getOneString language imagePathKeys card values
                                        |> Maybe.withDefault Urls.appLogoFullUrl

                                url =
                                    Urls.fullUrl
                                        (Urls.languagePath language (Urls.pathForCard card))

                                facebookUrl =
                                    "http://www.facebook.com/sharer.php?s=100&p[title]="
                                        ++ Http.encodeUri cardName
                                        ++ "&p[summary]="
                                        ++ Http.encodeUri (I18n.translate language (I18n.TweetMessage cardName url))
                                        ++ "&p[url]="
                                        ++ Http.encodeUri url
                                        ++ "&p[images][0]="
                                        ++ Http.encodeUri imageUrl

                                googlePlusUrl =
                                    "https://plus.google.com/share?url=" ++ Http.encodeUri url

                                linkedInUrl =
                                    "https://www.linkedin.com/shareArticle?mini=true&url="
                                        ++ Http.encodeUri url
                                        ++ "&title="
                                        ++ Http.encodeUri cardName
                                        ++ "&summary="
                                        ++ Http.encodeUri (I18n.translate language (I18n.TweetMessage cardName url))
                                        ++ "&source="
                                        ++ Http.encodeUri "OGP Toolbox"

                                twitterUrl =
                                    "https://twitter.com/intent/tweet?text="
                                        ++ Http.encodeUri (I18n.translate language (I18n.TweetMessage cardName url))
                             in
                                [ a
                                    [ class "btn btn-default btn-action btn-round"
                                    , href facebookUrl
                                    , onWithOptions
                                        "click"
                                        { stopPropagation = True, preventDefault = True }
                                        (Decode.succeed (ForSelf <| ShareOnFacebook facebookUrl))
                                    ]
                                    [ i [ attribute "aria-hidden" "true", class "fa fa-facebook" ] [] ]
                                , a
                                    [ class "btn btn-default btn-action btn-round"
                                    , href googlePlusUrl
                                    , onWithOptions
                                        "click"
                                        { stopPropagation = True, preventDefault = True }
                                        (Decode.succeed (ForSelf <| ShareOnGooglePlus googlePlusUrl))
                                    ]
                                    [ i [ attribute "aria-hidden" "true", class "fa fa-google-plus" ] [] ]
                                , a
                                    [ class "btn btn-default btn-action btn-round"
                                    , href linkedInUrl
                                    , onWithOptions
                                        "click"
                                        { stopPropagation = True, preventDefault = True }
                                        (Decode.succeed (ForSelf <| ShareOnLinkedIn linkedInUrl))
                                    ]
                                    [ i [ attribute "aria-hidden" "true", class "fa fa-linkedin" ] [] ]
                                , a
                                    [ class "btn btn-default btn-action btn-round"
                                    , href twitterUrl
                                    , onWithOptions
                                        "click"
                                        { stopPropagation = True, preventDefault = True }
                                        (Decode.succeed (ForSelf <| ShareOnTwitter twitterUrl))
                                    ]
                                    [ i [ attribute "aria-hidden" "true", class "fa fa-twitter" ] [] ]
                                ]
                            )
                        ]
                    ]
                ]
            ]
