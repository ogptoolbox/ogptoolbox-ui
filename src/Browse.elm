module Browse exposing (..)

import Decoders exposing (validateHasOneOfCardTypes)
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Html.Helpers exposing (aForPath, imgForCard)
import PropertyKeys exposing (..)
import Requests exposing (cardTypesForExample, cardTypesForOrganization, cardTypesForTool)
import String
import Types exposing (..)
import Views exposing (viewLoading)
import WebData exposing (getData, getLoadingStatusData, LoadingStatus(..), WebData(..))


type ActivePill
    = Examples
    | Organizations
    | Tools


type alias PillCounts =
    Maybe
        { examples : Int
        , organizations : Int
        , tools : Int
        }


activePillCount : ActivePill -> Maybe { b | examples : a, organizations : a, tools : a } -> Maybe a
activePillCount activePill counts =
    Maybe.map
        (\{ examples, organizations, tools } ->
            case activePill of
                Examples ->
                    examples

                Organizations ->
                    organizations

                Tools ->
                    tools
        )
        counts


view : ActivePill -> PillCounts -> (String -> msg) -> String -> LoadingStatus DataIdsBody -> List (Html msg)
view activePill counts navigate searchQuery loadingStatus =
    [ div [ class "browse-tag" ]
        [ div [ class "row" ]
            [ div [ class "container-fluid" ]
                [ img [ src "img/bubbles2.png" ]
                    []
                , div [ class "row filters" ]
                    [ div [ class "col-md-12 text-center" ]
                        [ text "Showing results suited for                    "
                        , a
                            [ class "btn btn-default dropdown-toggle"
                            , attribute "data-slide-to" "2"
                            , href "#carousel-example-generic"
                            , attribute "role" "button"
                            ]
                            [ text "all organizations                    " ]
                        , text "and available in                     "
                        , a
                            [ class "btn btn-default dropdown-toggle"
                            , attribute "data-slide-to" "3"
                            , href "#carousel-example-generic"
                            , attribute "role" "button"
                            ]
                            [ text "English                    " ]
                        ]
                    ]
                ]
            ]
        ]
    , div [ class "scroll-content" ]
        [ div [ class "row browse" ]
            [ div [ class "container-fluid" ]
                ((if String.isEmpty searchQuery then
                    []
                  else
                    [ div [ class "row" ]
                        [ h1 [] [ text ("Search results for \"" ++ searchQuery ++ "\"") ] ]
                    ]
                 )
                    ++ [ div [ class "row fixed" ]
                            [ div [ class "col-xs-12" ]
                                [ ul [ class "nav nav-pills nav-justified", attribute "role" "tablist" ]
                                    [ li
                                        [ classList
                                            [ ( "active"
                                              , case activePill of
                                                    Examples ->
                                                        True

                                                    _ ->
                                                        False
                                              )
                                            ]
                                        , attribute "role" "presentation"
                                        ]
                                        [ aForPath navigate
                                            ("/examples?q=" ++ searchQuery)
                                            []
                                            [ text "Examples "
                                            , span [ class "badge" ]
                                                [ text
                                                    (case counts of
                                                        Nothing ->
                                                            "0"

                                                        Just counts ->
                                                            toString counts.examples
                                                    )
                                                ]
                                            ]
                                        ]
                                    , li
                                        [ classList
                                            [ ( "active"
                                              , case activePill of
                                                    Tools ->
                                                        True

                                                    _ ->
                                                        False
                                              )
                                            ]
                                        , attribute "role" "presentation"
                                        ]
                                        [ aForPath navigate
                                            ("/tools?q=" ++ searchQuery)
                                            []
                                            [ text "Tools "
                                            , span [ class "badge" ]
                                                [ text
                                                    (case counts of
                                                        Nothing ->
                                                            "0"

                                                        Just counts ->
                                                            toString counts.tools
                                                    )
                                                ]
                                            ]
                                        ]
                                    , li
                                        [ classList
                                            [ ( "active"
                                              , case activePill of
                                                    Organizations ->
                                                        True

                                                    _ ->
                                                        False
                                              )
                                            ]
                                        , attribute "role" "presentation"
                                        ]
                                        [ aForPath navigate
                                            ("/organizations?q=" ++ searchQuery)
                                            []
                                            [ text "Organizations "
                                            , span [ class "badge" ]
                                                [ text
                                                    (case counts of
                                                        Nothing ->
                                                            "0"

                                                        Just counts ->
                                                            toString counts.organizations
                                                    )
                                                ]
                                            ]
                                        ]
                                    ]
                                ]
                            ]
                       , div [ class "row list" ]
                            ((case loadingStatus of
                                Loading body ->
                                    [ viewLoading ]
                                        ++ (case body of
                                                Nothing ->
                                                    []

                                                Just body ->
                                                    viewStatements
                                                        activePill
                                                        navigate
                                                        (Dict.values body.data.statements)
                                           )

                                Loaded body ->
                                    viewStatements activePill navigate (Dict.values body.data.statements)
                             )
                                ++ (let
                                        count =
                                            activePillCount activePill counts
                                    in
                                        case count of
                                            Nothing ->
                                                []

                                            Just count ->
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
                                   )
                            )
                       ]
                )
            ]
        ]
    ]


viewStatements : ActivePill -> (String -> msg) -> List Statement -> List (Html msg)
viewStatements activePill navigate statements =
    List.filterMap
        (\statement ->
            case statement.custom of
                CardCustom card ->
                    let
                        expectedCardTypes =
                            case activePill of
                                Examples ->
                                    cardTypesForExample

                                Organizations ->
                                    cardTypesForOrganization

                                Tools ->
                                    cardTypesForTool
                    in
                        case validateHasOneOfCardTypes expectedCardTypes card of
                            Ok _ ->
                                Just (viewTool activePill statement card navigate)

                            Err _ ->
                                Nothing

                _ ->
                    Nothing
        )
        statements


viewTool : ActivePill -> Statement -> Card -> (String -> msg) -> Html msg
viewTool activePill statement card navigate =
    let
        statementUrl =
            (case activePill of
                Examples ->
                    "/examples/"

                Organizations ->
                    "/organizations/"

                Tools ->
                    "/tools/"
            )
                ++ statement.id
    in
        div [ class "col-xs-12" ]
            [ div [ class "thumbnail example", onClick (navigate statementUrl) ]
                [ div [ class "visual" ]
                    [ imgForCard [] "95x98" card ]
                , div [ class "caption" ]
                    ([ h4 []
                        [ aForPath navigate statementUrl [] [ text (getOneString nameKeys card |> Maybe.withDefault "") ]
                        , small []
                            [ text "Software" ]
                        ]
                     , div [ class "example-author" ]
                        [ img [ alt "screen", src "img/whitehouse.png" ]
                            []
                        , text "The White House"
                        ]
                     , p []
                        (case getOneString descriptionKeys card of
                            Just description ->
                                [ text description ]

                            Nothing ->
                                []
                        )
                     ]
                        ++ (case getManyStrings typeKeys card of
                                [] ->
                                    [ text "TODO call-to-action" ]

                                xs ->
                                    List.map
                                        (\str -> span [ class "label label-default label-tool" ] [ text str ])
                                        xs
                           )
                    )
                ]
            ]
