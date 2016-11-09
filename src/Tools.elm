module Tools exposing (..)

import Authenticator.Model
import Configuration exposing (apiUrl)
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Task
import Dict exposing (Dict)
import Json.Decode as Decode
    exposing
        ( (:=)
        , andThen
        , at
        , bool
        , customDecoder
        , Decoder
        , dict
        , fail
        , int
        , list
        , map
        , maybe
        , null
        , oneOf
        , string
        , succeed
        )
import Json.Decode.Extra as Json exposing ((|:))
import Footer


-- MODEL


type alias Model =
    { softwareStatements : List Statement
    }


init : Model
init =
    { softwareStatements = [] }


type alias Statement =
    { id :
        String
        -- , values : Dict String StatementValue
    }



-- type StatementValue
--     = StatementValueString String
--     | StatementValueListOfStrings (List String)


decodeStatementsBody : Decoder (List Statement)
decodeStatementsBody =
    at [ "data", "statements" ] (dict decodeStatement |> Decode.map Dict.values)


decodeStatement : Decoder Statement
decodeStatement =
    succeed Statement
        |: Decode.map (\id -> Debug.log "id" id) ("id" := string)



-- |: ("values" := dict (oneOf [ Decode.list string, string ]))
-- UPDATE


type ExternalMsg
    = Navigate String


type InternalMsg
    = FetchTools
    | FetchError Http.Error
    | FetchSuccess (List Statement)


type Msg
    = ForParent ExternalMsg
    | ForSelf InternalMsg


type alias MsgTranslation parentMsg =
    { onInternalMsg : InternalMsg -> parentMsg
    , onNavigate : String -> parentMsg
    }


type alias MsgTranslator parentMsg =
    Msg -> parentMsg


navigate : String -> Msg
navigate path =
    ForParent (Navigate path)


translateMsg : MsgTranslation parentMsg -> MsgTranslator parentMsg
translateMsg { onInternalMsg, onNavigate } msg =
    case msg of
        ForParent (Navigate path) ->
            onNavigate path

        ForSelf internalMsg ->
            onInternalMsg internalMsg


update : InternalMsg -> Maybe Authenticator.Model.Authentication -> Model -> ( Model, Cmd Msg )
update msg authenticationMaybe model =
    case msg of
        FetchTools ->
            let
                url =
                    apiUrl ++ "statements?type=Card"

                cmd =
                    Task.perform
                        (\err -> ForSelf (FetchError err))
                        (\body -> ForSelf (FetchSuccess body))
                        (Http.get decodeStatementsBody url)
            in
                ( model, cmd )

        FetchError err ->
            let
                _ =
                    Debug.log "FetchError err" err
            in
                ( model, Cmd.none )

        FetchSuccess statements ->
            ( { model | softwareStatements = statements }, Cmd.none )



-- VIEW


view : Maybe Authenticator.Model.Authentication -> Model -> Html Msg
view authenticationMaybe model =
    div []
        [ viewBreadcrumb
        , case List.head model.softwareStatements of
            Nothing ->
                text "Loading"

            Just statement ->
                viewTool statement
        , Footer.view
        ]


viewBreadcrumb : Html msg
viewBreadcrumb =
    div [ class "row" ]
        [ div [ class "container" ]
            [ div [ class "row" ]
                [ div [ class "col-xs-12" ]
                    [ ol [ class "breadcrumb" ]
                        [ li []
                            [ a [ href "#" ]
                                [ text "Home" ]
                            ]
                        , li []
                            [ a [ href "#" ]
                                [ text "Library" ]
                            ]
                        , li [ class "active" ]
                            [ text "Data" ]
                        ]
                    ]
                ]
            ]
        ]


viewTool : Statement -> Html msg
viewTool statement =
    div [ class "row section" ]
        [ div [ class "container" ]
            [ div [ class "row" ]
                [ div [ class "col-md-3 sidebar" ]
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
                                                    [ a [ href "#" ]
                                                        [ text "www.ckan.org" ]
                                                    ]
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
                                    [ span [ class "label label-default label-tag" ]
                                        [ text "CMS" ]
                                    , span [ class "label label-default label-tag" ]
                                        [ text "Open-Data" ]
                                    , span [ class "label label-default label-tag" ]
                                        [ text "Open-Spurce" ]
                                    , span [ class "label label-default label-tag" ]
                                        [ text "Python" ]
                                    , span [ class "label label-default label-tag" ]
                                        [ text "Framework" ]
                                    , span [ class "label label-default label-tag" ]
                                        [ text "web" ]
                                    , span [ class "label label-default label-tag" ]
                                        [ text "platform" ]
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
                , div [ class "col-md-9 content content-right" ]
                    [ div [ class "row" ]
                        [ div [ class "col-xs-12" ]
                            [ h1 []
                                [ text statement.id
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
                            [ div [ class "panel panel-default" ]
                                [ div [ class "panel-heading" ]
                                    [ div [ class "row" ]
                                        [ div [ class "col-xs-8 text-left" ]
                                            [ h3 [ class "panel-title" ]
                                                [ text "About" ]
                                            ]
                                        , div [ class "col-xs-4 text-right up7" ]
                                            [ a [ class "show-more" ]
                                                [ text "Best of 8 " ]
                                            , button [ class "btn btn-default btn-xs btn-action", attribute "data-target" "#edit-content", attribute "data-toggle" "modal", type' "button" ]
                                                [ text "Edit" ]
                                            ]
                                        ]
                                    ]
                                , div [ class "panel-body" ]
                                    [ p []
                                        [ text "The Comprehensive Knowledge Archive Network (CKAN) is a web-based open source management system for the" ]
                                    ]
                                ]
                            , div [ class "panel panel-default panel-collapse up20" ]
                                [ div [ attribute "aria-controls" "collapseTwo", attribute "aria-expanded" "false", class "panel-heading", attribute "data-parent" "#accordion", attribute "data-toggle" "collapse", href "#collapseTwo", id "headingTwo", attribute "role" "tab" ]
                                    [ div [ class "row" ]
                                        [ div [ class "col-xs-8 text-left" ]
                                            [ h3 [ class "panel-title" ]
                                                [ text "Additional informations" ]
                                            ]
                                        , div [ class "col-xs-4 text-right" ]
                                            [ a [ class "show-more pull-right" ]
                                                [ text "Show 6 more"
                                                , span [ class "glyphicon glyphicon-menu-down" ]
                                                    []
                                                ]
                                            ]
                                        ]
                                    ]
                                , div [ attribute "aria-labelledby" "headingTwo", class "panel-collapse collapse", id "collapseTwo", attribute "role" "tabpanel" ]
                                    [ div [ class "panel-body nomargin" ]
                                        [ table [ class "table table-striped" ]
                                            [ tbody []
                                                [ tr []
                                                    [ th [ scope "row" ]
                                                        [ text "Developer" ]
                                                    , td []
                                                        [ text "Open Knowledge Foundation" ]
                                                    ]
                                                , tr []
                                                    [ th [ scope "row" ]
                                                        [ text "Original release date" ]
                                                    , td []
                                                        [ text "January 2007" ]
                                                    ]
                                                , tr []
                                                    [ th [ scope "row" ]
                                                        [ text "Latest release" ]
                                                    , td []
                                                        [ text "23 september 2015" ]
                                                    ]
                                                , tr []
                                                    [ th [ scope "row" ]
                                                        [ text "Programming Language" ]
                                                    , td []
                                                        [ text "Python" ]
                                                    ]
                                                , tr []
                                                    [ th [ scope "row" ]
                                                        [ text "Available Languages" ]
                                                    , td []
                                                        [ text "English, French, Spanish, Russian, German, Italian" ]
                                                    ]
                                                , tr []
                                                    [ th [ scope "row" ]
                                                        [ text "Demo" ]
                                                    , td []
                                                        [ a []
                                                            [ text "http://demo.ckan.org/" ]
                                                        ]
                                                    ]
                                                , tr []
                                                    [ th [ scope "row" ]
                                                        [ text "Contact" ]
                                                    , td []
                                                        [ a []
                                                            [ text "services@ckan.org" ]
                                                        ]
                                                    ]
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
                                                        [ text "OpenSpending is a centralized platform on the topic of public financial information, including an global database of budgets and spending data, a community of contributors and users exposing cases, and a set of open resources and tools providing technical, fiscal, and political understanding necessary to work with financial data." ]
                                                    , span [ class "label label-default label-tool" ]
                                                        [ text "Default" ]
                                                    , span [ class "label label-default label-tool" ]
                                                        [ text "Default" ]
                                                    , span [ class "label label-default label-tool" ]
                                                        [ text "Default" ]
                                                    ]
                                                ]
                                            ]
                                        , div [ class "col-xs-6 col-md-4 " ]
                                            [ div [ class "thumbnail example grey" ]
                                                [ div [ class "visual" ]
                                                    [ img [ alt "screen", src "img/screen2.png" ]
                                                        []
                                                    ]
                                                , div [ class "caption" ]
                                                    [ div [ class "example-author-thumb" ]
                                                        [ img [ alt "screen", src "img/hackpad.png" ]
                                                            []
                                                        ]
                                                    , h4 []
                                                        [ text "OpenSpending" ]
                                                    , p []
                                                        [ text "OpenSpending is a centralized platform on the topic of public financial information, including an global database of budgets and spending data, a community of contributors and users exposing cases, and a set of open resources and tools providing technical, fiscal, and political understanding necessary to work with financial data." ]
                                                    , span [ class "label label-default label-tool" ]
                                                        [ text "Default" ]
                                                    , span [ class "label label-default label-tool" ]
                                                        [ text "Default" ]
                                                    , span [ class "label label-default label-tool" ]
                                                        [ text "Default" ]
                                                    ]
                                                ]
                                            ]
                                        , div [ class "col-xs-6 col-md-4 " ]
                                            [ div [ class "thumbnail example grey" ]
                                                [ div [ class "visual" ]
                                                    [ img [ alt "screen", src "img/screen3.png" ]
                                                        []
                                                    ]
                                                , div [ class "caption" ]
                                                    [ div [ class "example-author-thumb" ]
                                                        [ img [ alt "screen", src "img/consul.png" ]
                                                            []
                                                        ]
                                                    , h4 []
                                                        [ text "OpenSpending" ]
                                                    , p []
                                                        [ text "OpenSpending is a centralized platform on the topic of public financial information, including an global database of budgets and spending data, a community of contributors and users exposing cases, and a set of open resources and tools providing technical, fiscal, and political understanding necessary to work with financial data." ]
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
                                                        [ text "OpenSpending is a centralized platform on the topic of public financial information, including an global database of budgets and spending data, a community of contributors and users exposing cases, and a set of open resources and tools providing technical, fiscal, and political understanding necessary to work with financial data." ]
                                                    ]
                                                ]
                                            ]
                                        , div [ class "col-xs-6 col-md-4 " ]
                                            [ div [ class "thumbnail orga grey" ]
                                                [ div [ class "visual" ]
                                                    [ img [ alt "logo", src "img/hackpad.png" ]
                                                        []
                                                    ]
                                                , div [ class "caption" ]
                                                    [ h4 []
                                                        [ text "The White House" ]
                                                    , p []
                                                        [ text "OpenSpending is a centralized platform on the topic of public financial information, including an global database of budgets and spending data, a community of contributors and users exposing cases, and a set of open resources and tools providing technical, fiscal, and political understanding necessary to work with financial data." ]
                                                    ]
                                                ]
                                            ]
                                        , div [ class "col-xs-6 col-md-4 " ]
                                            [ div [ class "thumbnail orga grey" ]
                                                [ div [ class "visual" ]
                                                    [ img [ alt "logo", src "img/hackpad.png" ]
                                                        []
                                                    ]
                                                , div [ class "caption" ]
                                                    [ h4 []
                                                        [ text "The White House" ]
                                                    , p []
                                                        [ text "OpenSpending is a centralized platform on the topic of public financial information, including an global database of budgets and spending data, a community of contributors and users exposing cases, and a set of open resources and tools providing technical, fiscal, and political understanding necessary to work with financial data." ]
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
                        ]
                    ]
                ]
            ]
        ]
