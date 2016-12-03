module Tool.Sidebar exposing (..)

import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Helpers exposing (aExternal)
import I18n exposing (getImageLogoUrl, getManyStrings, getOneString)
import Types exposing (..)


root : I18n.Language -> Card -> Dict String Value -> Html msg
root language card values =
    let
        viewSimilarTools =
            div [ class "row" ]
                [ div [ class "col-xs-12" ]
                    [ div [ class "panel panel-default panel-side" ]
                        [ div [ class "panel-heading" ]
                            [ div [ class "row" ]
                                [ div [ class "col-xs-7 text-left" ]
                                    [ h6 [ class "panel-title" ]
                                        [ text (I18n.translate language I18n.SimilarTools) ]
                                    ]
                                , div [ class "col-xs-5 text-right label-small" ]
                                    [ text (I18n.translate language I18n.Score) ]
                                ]
                            ]
                        , div [ class "panel-body chart" ]
                            [ table [ class "table" ]
                                [ tbody []
                                    [ tr []
                                        [ th [ class "tool-icon-small", scope "row" ]
                                            [ img [ src "/img/TODO.png" ]
                                                []
                                            ]
                                        , td []
                                            [ text "TODO Udata" ]
                                        , td [ class "text-right label-small" ]
                                            [ text "TODO 50.367" ]
                                        ]
                                    ]
                                ]
                            , button [ class "btn btn-default btn-xs btn-action btn-block", type' "button" ]
                                [ text (I18n.translate language I18n.SeeAllAndCompare) ]
                            ]
                        ]
                    ]
                ]
    in
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
                                            (\tag -> a [ class "label label-default label-tag" ] [ text tag ])
                                            tags
                                        )
                                    ]
                        )
                    ]
                ]
              -- , viewSimilarTools -- TODO
            ]
