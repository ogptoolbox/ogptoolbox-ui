module Card.View exposing (..)

import Card.Types exposing (..)
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Helpers exposing (aExternal, aForPath, aIfIsUrl)
import I18n exposing (..)
import Json.Decode as Decode
import Routes
import String
import Types exposing (..)
import Views exposing (viewCardListItem, viewLoading, viewWebData)
import WebData exposing (..)


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
                    div []
                        ([ viewCard language body ]
                            ++ (case model.editedProperty of
                                    Nothing ->
                                        []

                                    Just editedProperty ->
                                        let
                                            cards =
                                                case getData model.webData of
                                                    Nothing ->
                                                        Dict.empty

                                                    Just webData ->
                                                        webData.data.cards
                                        in
                                            [ viewEditPropertyModal language editedProperty cards ]
                               )
                        )
        )
        model.webData


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
                                    viewValueType language cards values keyValue.value
                            ]
                        , td []
                            [ viewValueType language cards values valueValue.value
                            ]
                        , td []
                            [ button
                                [ class "btn btn-default btn-xs btn-action"
                                , onClick (ForSelf (LoadProperties card.id keyId))
                                , type' "button"
                                ]
                                [ text "Edit" ]
                            ]
                        ]
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
                    (case getUsages language card values of
                        [] ->
                            [ button [ class "call-add" ] [ text "+ add a category" ] ]

                        usages ->
                            List.map
                                (\{ tag, tagId } ->
                                    let
                                        urlPath =
                                            Routes.urlBasePathForCard card ++ "?tagIds=" ++ tagId
                                    in
                                        aForPath
                                            navigate
                                            language
                                            urlPath
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
                                                , button
                                                    [ class "button call-add"
                                                    , onClick (ForSelf (LoadProperties card.id "description"))
                                                    ]
                                                    [ text "+ Add a description" ]
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
                                                        , onClick (ForSelf (LoadProperties card.id "description"))
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
                                                    |> Dict.map viewAdditionalInformation
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


viewEditPropertyModal : I18n.Language -> EditedProperty -> Dict String Card -> Html Msg
viewEditPropertyModal language { ballots, cardId, keyId, properties, propertyIds, selectedField, values } cards =
    let
        viewField =
            let
                selectField tagger =
                    \inputString -> ForSelf (SelectField (tagger inputString))

                onInputSelectField tagger =
                    onInput (selectField tagger)
            in
                case selectedField of
                    LocalizedInputTextField _ string ->
                        input
                            [ class "form-control"
                            , onInput
                                (\inputString ->
                                    ForSelf
                                        (SelectField
                                            (LocalizedInputTextField (I18n.iso639_1FromLanguage language) inputString)
                                        )
                                )
                            , type' "text"
                            , value string
                            ]
                            []

                    LocalizedTextareaField _ string ->
                        textarea
                            [ onInput
                                (\inputString ->
                                    ForSelf
                                        (SelectField
                                            (LocalizedTextareaField (I18n.iso639_1FromLanguage language) inputString)
                                        )
                                )
                            ]
                            [ text string ]

                    InputNumberField float ->
                        input
                            [ class "form-control"
                            , onInput
                                (selectField
                                    (\inputString ->
                                        (case String.toFloat inputString of
                                            Ok float ->
                                                InputNumberField float

                                            Err _ ->
                                                selectedField
                                        )
                                    )
                                )
                            , step "any"
                            , type' "number"
                            , value (toString float)
                            ]
                            []

                    BooleanField bool ->
                        input
                            [ class "form-control"
                            , onCheck (selectField BooleanField)
                            , type' "checkbox"
                            ]
                            []

                    InputEmailField string ->
                        input
                            [ class "form-control"
                            , onInputSelectField InputEmailField
                            , type' "email"
                            , value string
                            ]
                            []

                    InputUrlField string ->
                        input
                            [ class "form-control"
                            , onInputSelectField InputUrlField
                            , type' "url"
                            , value string
                            ]
                            []

                    ImageField string ->
                        input
                            [ class "form-control"
                            , onInputSelectField ImageField
                            , type' "url"
                            , value string
                            ]
                            []

                    CardIdField string ->
                        -- TODO replace with autocomplete
                        input
                            [ class "form-control"
                            , onInputSelectField CardIdField
                            , type' "text"
                            , value string
                            ]
                            []

        viewProperty index property =
            let
                value =
                    Dict.get property.valueId values

                ballot =
                    Dict.get property.ballotId ballots
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
                                [ viewValueType language cards values value.value ]
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
                                , type' "button"
                                ]
                                [ span [ attribute "aria-hidden" "true" ]
                                    [ text "×" ]
                                , span [ class "sr-only" ]
                                    [ text "Close" ]
                                ]
                            , h4 [ class "modal-title", id "myModalLabel" ]
                                ((case Dict.get keyId values of
                                    Nothing ->
                                        []

                                    Just key ->
                                        [ case getOneStringFromValueType language values key.value of
                                            Nothing ->
                                                Debug.crash "viewEditPropertyModal: property should have a string value"

                                            Just str ->
                                                text str
                                        ]
                                 )
                                    ++ [ span []
                                            [ text
                                                (I18n.translate language (I18n.CountVersionsAvailable (List.length propertyIds)))
                                            ]
                                       ]
                                )
                            ]
                        , div [ class "modal-body", style [ ( "min-height", "20em" ) ] ]
                            [ div [ class "row" ]
                                [ div [ class "col-xs-12" ]
                                    [ ul [ class "media-list" ]
                                        (propertyIds
                                            |> List.map (getProperty properties)
                                            |> List.indexedMap viewProperty
                                        )
                                    , nav [ class "navbar-fixed-bottom grey" ]
                                        [ Html.form
                                            [ class "navbar-form navbar-left big"
                                            , onSubmit (ForSelf (SubmitValue selectedField))
                                            ]
                                            [ select
                                                [ on "change"
                                                    (Html.Events.targetValue
                                                        `Decode.andThen`
                                                            (\str ->
                                                                case str of
                                                                    "One line text" ->
                                                                        Decode.succeed
                                                                            (LocalizedInputTextField
                                                                                (I18n.iso639_1FromLanguage language)
                                                                                ""
                                                                            )

                                                                    "Multi line text" ->
                                                                        Decode.succeed
                                                                            (LocalizedTextareaField
                                                                                (I18n.iso639_1FromLanguage language)
                                                                                ""
                                                                            )

                                                                    "Number" ->
                                                                        Decode.succeed (InputNumberField 0)

                                                                    "Yes / No" ->
                                                                        Decode.succeed (BooleanField False)

                                                                    "Email" ->
                                                                        Decode.succeed (InputEmailField "")

                                                                    "URL" ->
                                                                        Decode.succeed (InputUrlField "")

                                                                    "Image" ->
                                                                        Decode.succeed (ImageField "")

                                                                    "Internal link" ->
                                                                        Decode.succeed (CardIdField "")

                                                                    _ ->
                                                                        Decode.fail ("Invalid select value: " ++ str)
                                                            )
                                                        |> Decode.map (\x -> ForSelf (SelectField x))
                                                    )
                                                ]
                                                ([ "One line text"
                                                 , "Multi line text"
                                                 , "Number"
                                                 , "Yes / No"
                                                 , "Email"
                                                 , "URL"
                                                 , "Image"
                                                 , "Internal link"
                                                 ]
                                                    |> List.map (\s -> option [ value s ] [ text s ])
                                                )
                                            , div
                                                [ class "form-group" ]
                                                [ viewField ]
                                            , div [ class "navbar-right" ]
                                                [ button [ class "btn btn-default", type' "submit" ]
                                                    [ text "TODO Publish" ]
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
                                    [ button
                                        [ class "button call-add"
                                        , onClick (ForSelf (LoadProperties card.id "logo"))
                                        ]
                                        [ text "+ Add a logo" ]
                                    ]
                        ]
                    , div [ class "caption" ]
                        [ table [ class "table" ]
                            [ tbody []
                                [ --      tr [ class "editable" ]
                                  --     [ td [ class "table-label" ]
                                  --         [ text (I18n.translate language I18n.Type) ]
                                  --     , td []
                                  --         [ text "TODO type" ]
                                  --     ]
                                  -- ,
                                  tr [ class "editable" ]
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
                        case getTags language card values of
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
                                                , onClick (ForSelf (LoadProperties card.id "tags"))
                                                , type' "button"
                                                ]
                                                [ text "Edit" ]
                                            ]
                                        ]
                                    ]
                                , div [ class "panel-body" ]
                                    (List.map
                                        (\{ tag, tagId } ->
                                            let
                                                urlPath =
                                                    Routes.urlBasePathForCard card ++ "?tagIds=" ++ tagId
                                            in
                                                aForPath
                                                    navigate
                                                    language
                                                    urlPath
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
        ]


viewValueType : I18n.Language -> Dict String Card -> Dict String Value -> ValueType -> Html Msg
viewValueType language cards values value =
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

            BooleanValue bool ->
                text (toString bool)

            NumberValue float ->
                text (toString float)

            CardIdArrayValue childValues ->
                ul [ class "list-unstyled" ]
                    (List.map
                        (\childValue -> li [] [ viewValueType language cards values (CardIdValue childValue) ])
                        childValues
                    )

            ValueIdArrayValue childValues ->
                ul [ class "list-unstyled" ]
                    (List.map
                        (\childValue -> li [] [ viewValueType language cards values (ValueIdValue childValue) ])
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
                        viewValueType language cards values subValue.value
