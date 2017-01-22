module Cards.New.View exposing (..)

import Cards.New.Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onClick, onInput, onSubmit, targetValue)
import I18n
import Image.View exposing (..)
import Json.Decode as Decode


viewOrganization : Model -> I18n.Language -> Html Msg
viewOrganization model language =
    let
        viewForm =
            div [ class "col-xs-12" ]
                [ div [ class "row section-form" ]
                    [ div [ class "col-xs-12" ]
                        [ div [ class "form-group" ]
                            [ label [ for "nameField" ]
                                [ text (I18n.translate language (I18n.Name)) ]
                            , input
                                [ class "form-control"
                                , id "nameField"
                                , onInput (\x -> ForSelf (SetField "Name" x))
                                , placeholder (I18n.translate language (I18n.NewCardOrganizationName))
                                , required True
                                , type_ "text"
                                ]
                                []
                            ]
                        , div [ class "form-group" ]
                            [ label [ for "aboutField" ]
                                [ text (I18n.translate language (I18n.Description)) ]
                            , textarea
                                [ class "form-control"
                                , id "aboutField"
                                , onInput (\x -> ForSelf (SetField "Description" x))
                                , placeholder (I18n.translate language (I18n.NewCardOrganizationDescriptionPlaceholder))
                                ]
                                []
                            ]
                        ]
                    ]
                , div [ class "row section-form" ]
                    [ -- TODO input text
                      -- , div [ class "col-xs-6" ]
                      --     [ div [ class "form-group" ]
                      --         [ label [ for "licenseField" ]
                      --             [ text "License" ]
                      --         , select [ class "form-control", id "licenseField" ]
                      --             [ option []
                      --                 [ text "1" ]
                      --             , option []
                      --                 [ text "2" ]
                      --             , option []
                      --                 [ text "3" ]
                      --             , option []
                      --                 [ text "4" ]
                      --             , option []
                      --                 [ text "5" ]
                      --             ]
                      --         ]
                      --     ]
                      div [ class "col-xs-12" ]
                        [ div [ class "form-group" ]
                            [ label [ for "websiteLinkField" ]
                                [ text (I18n.translate language (I18n.Website)) ]
                            , input
                                [ class "form-control"
                                , id "websiteLinkField"
                                , onInput (\x -> ForSelf (SetField "Website" x))
                                , placeholder (I18n.translate language (I18n.WebsiteDescription))
                                , type_ "url"
                                ]
                                []
                            ]
                        ]
                    ]
                ]
    in
        Html.form
            [ onSubmit (ForSelf SubmitFields) ]
            [ div [ class "row section" ]
                [ div [ class "container" ]
                    [ div [ class "row" ]
                        [ div [ class "col-md-12 content content-left" ]
                            [ div [ class "row" ]
                                [ div [ class "col-xs-12" ]
                                    [ h1 []
                                        [ text (I18n.translate language I18n.NewCardOrganization) ]
                                    ]
                                ]
                            ]
                        ]
                    , div [ class "row" ]
                        [ div [ class "col-md-9 content content-left" ]
                            [ div [ class "row" ]
                                [ viewForm ]
                            ]
                        ]
                    ]
                ]
            , div [ class "row section-form last" ]
                [ div [ class "container" ]
                    [ div [ class "col-md-9 content content-left" ]
                        [ button
                            [ class "btn btn-default pull-right"
                            , disabled (publishedDisabled model.imageUploadStatus)
                            , type_ "submit"
                            ]
                            [ text (I18n.translate language I18n.PublishOrganization) ]
                        ]
                    ]
                ]
            ]


viewTool : Model -> I18n.Language -> Html Msg
viewTool model language =
    let
        viewForm =
            div [ class "col-xs-12" ]
                [ div [ class "row section-form" ]
                    [ div [ class "col-xs-12" ]
                        [ div [ class "form-group" ]
                            [ label [ for "nameField" ]
                                [ text (I18n.translate language (I18n.Name)) ]
                            , input
                                [ class "form-control"
                                , id "nameField"
                                , onInput (\x -> ForSelf (SetField "Name" x))
                                , placeholder (I18n.translate language (I18n.NewCardToolName))
                                , required True
                                , type_ "text"
                                ]
                                []
                            ]
                        , div [ class "form-group" ]
                            [ label [ for "aboutField" ]
                                [ text (I18n.translate language (I18n.Description)) ]
                            , textarea
                                [ class "form-control"
                                , id "aboutField"
                                , onInput (\x -> ForSelf (SetField "Description" x))
                                , placeholder (I18n.translate language (I18n.NewCardToolDescriptionPlaceholder))
                                ]
                                []
                            ]
                        ]
                    ]
                , div [ class "row section-form" ]
                    [ div [ class "col-xs-6" ]
                        [ div [ class "form-group" ]
                            [ label [ for "typeField" ]
                                [ text (I18n.translate language (I18n.Type)) ]
                            , select
                                [ class "form-control"
                                , id "typeField"
                                , on "change"
                                    (Html.Events.targetValue
                                        |> Decode.map (\x -> ForSelf (SetField "Types" x))
                                    )
                                ]
                                [ option [ value "software" ]
                                    [ text (I18n.translate language (I18n.Software)) ]
                                , option [ value "platform" ]
                                    [ text (I18n.translate language (I18n.Platform)) ]
                                ]
                            ]
                        ]
                    , div [ class "col-xs-6" ]
                        [ div [ class "form-group" ]
                            [ label [ for "licenseField" ]
                                [ text (I18n.translate language (I18n.License)) ]
                            , input
                                [ class "form-control"
                                , id "licenseField"
                                , onInput (\x -> ForSelf (SetField "License" x))
                                , type_ "text"
                                ]
                                []
                            ]
                        ]
                    , div [ class "col-xs-12" ]
                        [ div [ class "form-group" ]
                            [ label [ for "websiteLinkField" ]
                                [ text (I18n.translate language (I18n.Website)) ]
                            , input
                                [ class "form-control"
                                , id "websiteLinkField"
                                , onInput (\x -> ForSelf (SetField "Website" x))
                                , placeholder (I18n.translate language (I18n.WebsiteDescription))
                                , type_ "url"
                                ]
                                []
                            ]
                        , div [ class "form-group" ]
                            [ label [ for "downloadLinkField" ]
                                [ text (I18n.translate language (I18n.Download)) ]
                            , input
                                [ class "form-control"
                                , id "downloadLinkField"
                                , onInput (\x -> ForSelf (SetField "Download" x))
                                , placeholder (I18n.translate language (I18n.DownloadDescription))
                                , type_ "url"
                                ]
                                []
                            ]
                        ]
                    ]
                , div [ class "row section-form" ]
                    [ div [ class "col-xs-12" ]
                        [ div [ class "panel panel-default panel-collapse" ]
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
                                            [ text (I18n.translate language (I18n.AdditionalInformations)) ]
                                        ]
                                    , div [ class "col-xs-4 text-right" ]
                                        [ a [ class "show-more pull-right" ]
                                            [ text (I18n.translate language (I18n.ShowMore))
                                            , span [ class "glyphicon glyphicon-menu-down" ]
                                                []
                                            ]
                                        ]
                                    ]
                                ]
                            , div
                                [ attribute "aria-labelledby" "headingTwo"
                                , class "panel-collapse collapse"
                                , id "collapseTwo"
                                , attribute "role" "tabpanel"
                                ]
                                [ div [ class "panel-body nomargin" ]
                                    [ div [ class "form-group" ]
                                        [ label [ for "releaseDateField" ]
                                            [ text (I18n.translate language (I18n.ReleaseDate)) ]
                                        , input
                                            [ class "form-control"
                                            , id "releaseDateField"
                                            , onInput (\x -> ForSelf (SetField "Release Date" x))
                                            , placeholder (I18n.translate language (I18n.ReleaseDatePlaceholder))
                                            , type_ "date"
                                            ]
                                            []
                                        ]
                                    , div [ class "form-group" ]
                                        [ label [ for "publisherField" ]
                                            [ text "Publisher" ]
                                        , input
                                            [ class "form-control"
                                            , id "publisherField"
                                            , onInput (\x -> ForSelf (SetField "Publisher" x))
                                              -- , placeholder "What's the official name of the tool?" -- TODO
                                            , type_ "text"
                                            ]
                                            []
                                        ]
                                      -- , div [ class "form-group" ]
                                      --     [ label [ for "exampleInputFile" ]
                                      --         [ text "File input" ]
                                      --     , input [ id "exampleInputFile", type' "file" ]
                                      --         []
                                      --     , p [ class "help-block" ]
                                      --         [ text "Example block-level help text here." ]
                                      --     ]
                                      -- , div [ class "checkbox" ]
                                      --     [ label []
                                      --         [ input [ type' "checkbox" ]
                                      --             []
                                      --         , text "Check me out"
                                      --         ]
                                      --     ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
    in
        Html.form [ onSubmit (ForSelf SubmitFields) ]
            [ div [ class "row section" ]
                [ div [ class "container" ]
                    [ div [ class "row" ]
                        [ div [ class "col-md-12 content content-left" ]
                            [ div [ class "row" ]
                                [ div [ class "col-xs-12" ]
                                    [ h1 []
                                        [ text (I18n.translate language I18n.NewCardTool) ]
                                    ]
                                ]
                            ]
                        ]
                    , div [ class "row" ]
                        [ div [ class "col-md-9 content content-left" ]
                            [ div [ class "row" ]
                                [ viewForm ]
                            ]
                        , div [ class "col-md-3 sidebar" ]
                            [ div [ class "row" ]
                                [ div [ class "col-xs-12" ]
                                    [ div [ class "thumbnail orga grey" ]
                                        [ div [ class "upload-container" ]
                                            [ label [ for "logoField" ]
                                                [ text (I18n.translate language (I18n.Logo)) ]
                                            , div [ class "upload-zone" ]
                                                [ viewImageUploadStatus language model.imageUploadStatus ]
                                            , input
                                                [ id "logoField"
                                                , on "change" (Decode.succeed (ForSelf ImageSelected))
                                                , type_ "file"
                                                ]
                                                []
                                            ]
                                        ]
                                    ]
                                ]
                              -- , div [ class "row" ]
                              --     [ div [ class "col-xs-12" ]
                              --         [ i []
                              --             [ text "Maecenas " ]
                              --         ]
                              --     ]
                            ]
                        ]
                    ]
                ]
            , div [ class "row section-form last" ]
                [ div [ class "container" ]
                    [ div [ class "col-md-9 content content-left" ]
                        [ button
                            [ class "btn btn-default pull-right"
                            , disabled (publishedDisabled model.imageUploadStatus)
                            , type_ "submit"
                            ]
                            [ text (I18n.translate language I18n.PublishTool) ]
                        ]
                    ]
                ]
            ]


viewUseCase : Model -> I18n.Language -> Html Msg
viewUseCase model language =
    let
        viewForm =
            div [ class "col-xs-12" ]
                [ div [ class "row section-form" ]
                    [ div [ class "col-xs-12" ]
                        [ div [ class "form-group" ]
                            [ label [ for "nameField" ]
                                [ text (I18n.translate language (I18n.Name)) ]
                            , input
                                [ class "form-control"
                                , id "nameField"
                                , onInput (\x -> ForSelf (SetField "Name" x))
                                , placeholder (I18n.translate language I18n.NewCardUseCaseName)
                                , required True
                                , type_ "text"
                                ]
                                []
                            ]
                        , div [ class "form-group" ]
                            [ label [ for "aboutField" ]
                                [ text (I18n.translate language (I18n.Description)) ]
                            , textarea
                                [ class "form-control"
                                , id "aboutField"
                                , onInput (\x -> ForSelf (SetField "Description" x))
                                , placeholder (I18n.translate language I18n.NewCardUseCaseDescriptionPlaceholder)
                                ]
                                []
                            ]
                        ]
                    ]
                , div [ class "row section-form" ]
                    [ -- TODO input text
                      -- , div [ class "col-xs-6" ]
                      --     [ div [ class "form-group" ]
                      --         [ label [ for "licenseField" ]
                      --             [ text "License" ]
                      --         , select [ class "form-control", id "licenseField" ]
                      --             [ option []
                      --                 [ text "1" ]
                      --             , option []
                      --                 [ text "2" ]
                      --             , option []
                      --                 [ text "3" ]
                      --             , option []
                      --                 [ text "4" ]
                      --             , option []
                      --                 [ text "5" ]
                      --             ]
                      --         ]
                      --     ]
                      div [ class "col-xs-12" ]
                        [ div [ class "form-group" ]
                            [ label [ for "websiteLinkField" ]
                                [ text (I18n.translate language (I18n.Website)) ]
                            , input
                                [ class "form-control"
                                , id "websiteLinkField"
                                , onInput (\x -> ForSelf (SetField "Website" x))
                                , placeholder (I18n.translate language (I18n.WebsiteDescription))
                                , type_ "url"
                                ]
                                []
                            ]
                        ]
                    ]
                ]
    in
        Html.form
            [ onSubmit (ForSelf SubmitFields) ]
            [ div [ class "row section" ]
                [ div [ class "container" ]
                    [ div [ class "row" ]
                        [ div [ class "col-md-12 content content-left" ]
                            [ div [ class "row" ]
                                [ div [ class "col-xs-12" ]
                                    [ h1 []
                                        [ text (I18n.translate language I18n.NewCardUseCase) ]
                                    ]
                                ]
                            ]
                        ]
                    , div [ class "row" ]
                        [ div [ class "col-md-9 content content-left" ]
                            [ div [ class "row" ]
                                [ viewForm ]
                            ]
                        , div [ class "col-md-3 sidebar" ]
                            [ div [ class "row" ]
                                [ div [ class "col-xs-12" ]
                                    [ div [ class "thumbnail orga grey" ]
                                        [ div [ class "upload-container" ]
                                            [ label [ for "logoField" ]
                                                [ text (I18n.translate language (I18n.Logo)) ]
                                            , div [ class "upload-zone" ]
                                                [ viewImageUploadStatus language model.imageUploadStatus ]
                                            , input
                                                [ id "logoField"
                                                , on "change" (Decode.succeed (ForSelf ImageSelected))
                                                , type_ "file"
                                                ]
                                                []
                                            ]
                                        ]
                                    ]
                                ]
                              -- , div [ class "row" ]
                              --     [ div [ class "col-xs-12" ]
                              --         [ i []
                              --             [ text "Maecenas " ]
                              --         ]
                              --     ]
                            ]
                        ]
                    ]
                ]
            , div [ class "row section-form last" ]
                [ div [ class "container" ]
                    [ div [ class "col-md-9 content content-left" ]
                        [ button
                            [ class "btn btn-default pull-right"
                            , disabled (publishedDisabled model.imageUploadStatus)
                            , type_ "submit"
                            ]
                            [ text (I18n.translate language I18n.PublishUseCase) ]
                        ]
                    ]
                ]
            ]
