module Browse exposing (..)

import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Html.Helpers exposing (aForPath)
import I18n exposing (getImageUrl, getManyStrings, getOneString)
import String
import Types exposing (..)
import Views exposing (viewLoading)
import WebData exposing (getData, getLoadingStatusData, LoadingStatus(..), WebData(..))


type alias PillCounts =
    Maybe
        { examples : Int
        , organizations : Int
        , tools : Int
        }


cardTypeCount : CardType -> Maybe { b | examples : a, organizations : a, tools : a } -> Maybe a
cardTypeCount cardType counts =
    Maybe.map
        (\{ examples, organizations, tools } ->
            case cardType of
                Example ->
                    examples

                Organization ->
                    organizations

                Tool ->
                    tools
        )
        counts


view :
    CardType
    -> PillCounts
    -> (String -> msg)
    -> String
    -> I18n.Language
    -> LoadingStatus DataIdsBody
    -> List (Html msg)
view cardType counts navigate searchQuery language loadingStatus =
    [ div [ class "browse-tag" ]
        [ div [ class "row" ]
            [ div [ class "container-fluid" ]
                [ img [ src "/img/bubbles2.png" ]
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
                        [ h1 [] [ text (I18n.translate language (I18n.SearchResults searchQuery)) ] ]
                    ]
                 )
                    ++ [ div [ class "row fixed" ]
                            [ div [ class "col-xs-12" ]
                                [ ul [ class "nav nav-pills nav-justified", attribute "role" "tablist" ]
                                    [ li
                                        [ classList [ ( "active", cardType == Example ) ]
                                        , attribute "role" "presentation"
                                        ]
                                        [ aForPath navigate
                                            ("/examples?q=" ++ searchQuery)
                                            []
                                            [ text (I18n.translate language (I18n.Example I18n.Plural))
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
                                        [ classList [ ( "active", cardType == Tool ) ]
                                        , attribute "role" "presentation"
                                        ]
                                        [ aForPath navigate
                                            ("/tools?q=" ++ searchQuery)
                                            []
                                            [ text (I18n.translate language (I18n.Tool I18n.Plural))
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
                                        [ classList [ ( "active", cardType == Organization ) ]
                                        , attribute "role" "presentation"
                                        ]
                                        [ aForPath navigate
                                            ("/organizations?q=" ++ searchQuery)
                                            []
                                            [ text (I18n.translate language (I18n.Organization I18n.Plural))
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
                       , div [ class "row list p90" ]
                            ((case loadingStatus of
                                Loading body ->
                                    [ viewLoading ]
                                        ++ (case body of
                                                Nothing ->
                                                    []

                                                Just body ->
                                                    viewCards
                                                        cardType
                                                        navigate
                                                        language
                                                        (Dict.values body.data.cards)
                                                        body.data.values
                                           )

                                Loaded body ->
                                    viewCards
                                        cardType
                                        navigate
                                        language
                                        (Dict.values body.data.cards)
                                        body.data.values
                             )
                                ++ (let
                                        count =
                                            cardTypeCount cardType counts
                                    in
                                        case count of
                                            Nothing ->
                                                []

                                            Just count ->
                                                if count > 20 then
                                                    -- TODO Do not hardcode limit
                                                    [ div [ class "col-sm-12 text-center" ]
                                                        [ a [ class "show-more" ]
                                                            [ text (I18n.translate language (I18n.ShowAll count))
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


viewCards : CardType -> (String -> msg) -> I18n.Language -> List Card -> Dict String Value -> List (Html msg)
viewCards cardType navigate language cards values =

            List.map (viewCard cardType navigate language values) cards


viewCard : CardType -> (String -> msg) -> I18n.Language -> Dict String Value -> Card -> Html msg
viewCard cardType navigate language values card =
    let
        cardUrl =
            (case cardType of
                Example ->
                    "/examples/"

                Organization ->
                    "/organizations/"

                Tool ->
                    "/tools/"
            )
                ++ card.id

        name =
            getOneString language nameKeys card values |> Maybe.withDefault ""
    in
        div [ class "col-xs-12" ]
            [ div [ class "thumbnail example", onClick (navigate cardUrl) ]
                [ div [ class "visual" ]
                    [ case getImageUrl language "95x98" card values of
                        Just url ->
                            img [ alt "Logo", src url ] []

                        Nothing ->
                            h1 [ class "dynamic" ] [ text name ]
                    ]
                , div [ class "caption" ]
                    [ h4 []
                        [ aForPath
                            navigate
                            cardUrl
                            []
                            [ text name ]
                        , small []
                            [ text (I18n.translate language I18n.Software) ]
                        ]
                    , div [ class "example-author" ]
                        [ img [ alt "screen", src "/img/TODO.png" ]
                            []
                        , text "TODO The White House"
                        ]
                    , p []
                        (case getOneString language descriptionKeys card values of
                            Just description ->
                                [ text description ]

                            Nothing ->
                                []
                        )
                    ]
                , div [ class "tags" ]
                    (case getManyStrings language typeKeys card values of
                        [] ->
                            [ text "TODO call-to-action" ]

                        xs ->
                            List.map
                                (\str ->
                                    span
                                        [ class "label label-default label-tool" ]
                                        [ text str ]
                                )
                                xs
                    )
                ]
            ]
