module Home exposing (..)

import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Helpers exposing (aExternal, aForPath)
import I18n exposing (getImageUrl, getManyStrings, getName, getOneString)
import Navigation
import Routes
import Search.Types exposing (..)
import Types exposing (..)
import Urls
import Views exposing (viewCardThumbnail, viewLoading, viewTagsWithCallToAction, viewWebData)
import WebData exposing (..)


view : Model -> I18n.Language -> Navigation.Location -> Html Msg
view model language location =
    div []
        ([ viewBanner
         , viewMetrics language location model
         ]
            ++ [ div [ class "row section" ]
                    [ div [ class "container" ]
                        ([ h3 [ class "zone-label" ]
                            [ text (I18n.translate language (I18n.UseCase I18n.Plural)) ]
                         ]
                            ++ [ viewWebData language
                                    (viewThumbnails language location "example grey")
                                    model.useCases
                               ]
                        )
                    ]
               , div [ class "row section grey" ]
                    [ div [ class "container" ]
                        ([ h3 [ class "zone-label" ]
                            [ text (I18n.translate language (I18n.Tool I18n.Plural)) ]
                         ]
                            ++ [ viewWebData language
                                    (viewThumbnails language location "tool")
                                    model.tools
                               ]
                        )
                    ]
               , viewCollections model.collections language
               ]
        )


viewBanner : Html Msg
viewBanner =
    -- let
    --     viewSlide1 =
    --         div [ class "col-md-12 text-center" ]
    --             [ text "Showing results suited for"
    --             , div [ class "dropdown dropdown-filter dropup" ]
    --                 [ a
    --                     [ class "btn btn-default dropdown-toggle"
    --                     , attribute "data-slide-to" "2"
    --                     , href "#carousel-example-generic"
    --                     , attribute "role" "button"
    --                     ]
    --                     [ text "all organizations"
    --                     , span [ class "caret" ]
    --                         []
    --                     ]
    --                 , ul [ attribute "aria-labelledby" "dropdownMenu1", class "dropdown-menu" ]
    --                     [ li []
    --                         [ a [ href "#" ]
    --                             [ text "all organizations" ]
    --                         ]
    --                     , li []
    --                         [ a [ href "#" ]
    --                             [ text "Local government" ]
    --                         ]
    --                     , li []
    --                         [ a [ href "#" ]
    --                             [ text "Regional government" ]
    --                         ]
    --                     ]
    --                 ]
    --             , text "and available in"
    --             , div [ class "dropdown dropdown-filter dropup" ]
    --                 [ a
    --                     [ class "btn btn-default dropdown-toggle"
    --                     , attribute "data-slide-to" "3"
    --                     , href "#carousel-example-generic"
    --                     , attribute "role" "button"
    --                     ]
    --                     [ text "English"
    --                     , span [ class "caret" ]
    --                         []
    --                     ]
    --                 , ul [ attribute "aria-labelledby" "dropdownMenu1", class "dropdown-menu" ]
    --                     [ li []
    --                         [ a [ href "#" ]
    --                             [ text "Français" ]
    --                         ]
    --                     , li []
    --                         [ a [ href "#" ]
    --                             [ text "Espanol" ]
    --                         ]
    --                     , li []
    --                         [ a [ href "#" ]
    --                             [ text "Deutsch" ]
    --                         ]
    --                     , li []
    --                         [ a [ href "#" ]
    --                             [ text "Italiano" ]
    --                         ]
    --                     ]
    --                 ]
    --             ]
    -- in
    div [ class "banner" ]
        [ div [ class "row " ]
            [ div [ class "carousel slide", attribute "data-ride" "", id "carousel-example-generic" ]
                [ div [ class "carousel-inner ", attribute "role" "listbox" ]
                    [ div [ class "item active text-center" ]
                        [ div [ class "container-fluid" ]
                            [ div [ class "row" ]
                                [ div [ class "col-md-12 text-center" ]
                                    [ div [ class "bubbles" ] [] ]
                                ]
                            , div [ class "row show" ]
                                [ a [ href "#metrics", class "col-md-12 text-center banner-link" ]
                                    [ text "See results "
                                    , span [ class "glyphicon glyphicon-menu-down" ]
                                        []
                                    ]
                                ]
                            ]
                        ]
                    , div [ class "item text-center" ]
                        [ div [ class "container" ]
                            [ div [ class "row form-title" ]
                                [ div [ class "col-md-12 text-center " ]
                                    [ h2 []
                                        [ span [ attribute "aria-hidden" "true", class "glyphicon glyphicon-education" ]
                                            []
                                        , text "Which kind of organization are your intrested in ?"
                                        ]
                                    ]
                                ]
                            , div [ class "row form-content" ]
                                [ div [ class "col-md-3 text-center" ]
                                    [ div [ class "radio" ]
                                        [ label []
                                            [ input
                                                [ attribute "checked" ""
                                                , id "optionsRadios1"
                                                , name "optionsRadios"
                                                , type_ "radio"
                                                , value "option1"
                                                ]
                                                []
                                            , text "All organizations"
                                            ]
                                        ]
                                    ]
                                , div [ class "col-md-3 text-center" ]
                                    [ div [ class "radio" ]
                                        [ label []
                                            [ input
                                                [ attribute "checked" ""
                                                , id "optionsRadios1"
                                                , name "optionsRadios"
                                                , type_ "radio"
                                                , value "option1"
                                                ]
                                                []
                                            , text "Local government"
                                            ]
                                        ]
                                    ]
                                , div [ class "col-md-3 text-center" ]
                                    [ div [ class "radio" ]
                                        [ label []
                                            [ input
                                                [ attribute "checked" ""
                                                , id "optionsRadios1"
                                                , name "optionsRadios"
                                                , type_ "radio"
                                                , value "option1"
                                                ]
                                                []
                                            , text "Regional government"
                                            ]
                                        ]
                                    ]
                                , div [ class "col-md-3 text-center" ]
                                    [ div [ class "radio" ]
                                        [ label []
                                            [ input
                                                [ attribute "checked" ""
                                                , id "optionsRadios1"
                                                , name "optionsRadios"
                                                , type_ "radio"
                                                , value "option1"
                                                ]
                                                []
                                            , text "National government"
                                            ]
                                        ]
                                    ]
                                , div [ class "col-md-3 text-center" ]
                                    [ div [ class "radio" ]
                                        [ label []
                                            [ input
                                                [ attribute "checked" ""
                                                , id "optionsRadios1"
                                                , name "optionsRadios"
                                                , type_ "radio"
                                                , value "option1"
                                                ]
                                                []
                                            , text "Political organization"
                                            ]
                                        ]
                                    ]
                                , div [ class "col-md-3 text-center" ]
                                    [ div [ class "radio" ]
                                        [ label []
                                            [ input
                                                [ attribute "checked" ""
                                                , id "optionsRadios1"
                                                , name "optionsRadios"
                                                , type_ "radio"
                                                , value "option1"
                                                ]
                                                []
                                            , text "Political movement"
                                            ]
                                        ]
                                    ]
                                , div [ class "col-md-3 text-center" ]
                                    [ div [ class "radio" ]
                                        [ label []
                                            [ input
                                                [ attribute "checked" ""
                                                , id "optionsRadios1"
                                                , name "optionsRadios"
                                                , type_ "radio"
                                                , value "option1"
                                                ]
                                                []
                                            , text "Non-profit organization"
                                            ]
                                        ]
                                    ]
                                , div [ class "col-md-3 text-center" ]
                                    [ div [ class "radio" ]
                                        [ label []
                                            [ input
                                                [ attribute "checked" ""
                                                , id "optionsRadios1"
                                                , name "optionsRadios"
                                                , type_ "radio"
                                                , value "option1"
                                                ]
                                                []
                                            , text "For-profit organization"
                                            ]
                                        ]
                                    ]
                                ]
                            , div [ class "row" ]
                                [ div [ class "col-md-12 text-center" ]
                                    [ a
                                        [ class "btn btn-primary btn-lg"
                                        , attribute "data-slide-to" "1"
                                        , href "#carousel-example-generic"
                                        , attribute "role" "button"
                                        ]
                                        [ text "Continue" ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                , div [ class "item text-center" ]
                    [ div [ class "container" ]
                        [ div [ class "row form-title" ]
                            [ div [ class "col-md-12 text-center " ]
                                [ h2 []
                                    [ span [ attribute "aria-hidden" "true", class "glyphicon glyphicon-globe" ]
                                        []
                                    , text "Which language do you use ?"
                                    ]
                                ]
                            ]
                        , div [ class "row form-content" ]
                            [ div [ class "col-md-3 text-center" ]
                                [ div [ class "checkbox" ]
                                    [ label []
                                        [ input
                                            [ attribute "checked" ""
                                            , id "optionsRadios1"
                                            , name "optionsRadios"
                                            , type_ "checkbox"
                                            , value "option1"
                                            ]
                                            []
                                        , text "English                    "
                                        ]
                                    ]
                                ]
                            ]
                        , div [ class "row" ]
                            [ div [ class "col-md-12 text-center" ]
                                [ a
                                    [ class "btn btn-primary btn-lg"
                                    , attribute "data-slide-to" "1"
                                    , href "#carousel-example-generic"
                                    , attribute "role" "button"
                                    ]
                                    [ text "Continue" ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]


viewCollections : WebData DataIdsBody -> I18n.Language -> Html Msg
viewCollections collectionsWebData language =
    viewWebData
        language
        (\loadingStatus ->
            case loadingStatus of
                Loading _ ->
                    div [ class "text-center" ]
                        [ viewLoading language ]

                Loaded body ->
                    let
                        collections =
                            List.map
                                (\id ->
                                    case Dict.get id body.data.collections of
                                        Nothing ->
                                            Debug.crash ("Collection not found id=" ++ id)

                                        Just collection ->
                                            collection
                                )
                                body.data.ids

                        users =
                            body.data.users
                    in
                        div []
                            [ div [ class "row section" ]
                                [ div [ class "container" ]
                                    [ h3 [ class "zone-label" ]
                                        [ text "Collections"
                                          -- TODO i18n
                                        ]
                                    , div [ class "row" ]
                                        ((List.map
                                            (\collection ->
                                                let
                                                    user =
                                                        case Dict.get collection.authorId users of
                                                            Nothing ->
                                                                Debug.crash ("User not found id=" ++ collection.authorId)

                                                            Just user ->
                                                                user
                                                in
                                                    viewCollectionThumbnail language user collection
                                            )
                                            collections
                                         )
                                            ++ [ div [ class "col-sm-12 text-center" ]
                                                    [ aForPath
                                                        navigate
                                                        language
                                                        "/collections"
                                                        [ class "show-more" ]
                                                        [ span [ class "glyphicon glyphicon-menu-down" ] []
                                                        , text "Show more"
                                                          -- TODO i18n
                                                        ]
                                                    ]
                                               ]
                                        )
                                    ]
                                ]
                            ]
        )
        collectionsWebData


viewCollectionThumbnail : I18n.Language -> User -> Collection -> Html Msg
viewCollectionThumbnail language user collection =
    div [ class "col-xs-12 col-md-4 " ]
        [ aForPath
            navigate
            language
            ("/collections/" ++ collection.id)
            [ class "thumbnail collection" ]
            [ div [ class "visual" ]
                (case collection.logo of
                    Nothing ->
                        []

                    Just logo ->
                        [ img [ alt "screen", src (Urls.fullApiUrl logo) ] []
                        ]
                )
            , div [ class "caption" ]
                [ h4 []
                    [ text collection.name ]
                , div [ class "example-author" ]
                    [ -- img [ alt "screen", src "img/france.png" ] []
                      text user.name
                    ]
                , p []
                    [ text collection.description ]
                ]
            ]
        ]


viewMetric : WebData DataIdsBody -> Html Msg
viewMetric webData =
    case webData of
        NotAsked ->
            text ""

        Failure _ ->
            text "-"

        Data loadingStatus ->
            case loadingStatus of
                Loading _ ->
                    img [ alt "loading", src "/img/mini-loader.gif" ] []

                Loaded body ->
                    text (toString body.count)


viewMetrics : I18n.Language -> Navigation.Location -> Model -> Html Msg
viewMetrics language location model =
    div [ class "row metrics", id "metrics" ]
        [ div [ class "container" ]
            [ div [ class "col-xs-4 text-center" ]
                [ span [ class "metric-label" ]
                    [ text (I18n.translate language (I18n.UseCase I18n.Plural)) ]
                , aForPath
                    navigate
                    language
                    (Routes.urlBasePathForCardType UseCaseCard
                        ++ (Routes.queryStringForParams [ "q", "tagIds" ] location)
                    )
                    []
                    [ viewMetric model.useCases
                    ]
                ]
            , div [ class "col-xs-4 text-center" ]
                [ span [ class "metric-label" ]
                    [ text (I18n.translate language (I18n.Tool I18n.Plural)) ]
                , aForPath
                    navigate
                    language
                    (Routes.urlBasePathForCardType ToolCard
                        ++ (Routes.queryStringForParams [ "q", "tagIds" ] location)
                    )
                    []
                    [ viewMetric model.tools
                    ]
                ]
            , div [ class "col-xs-4 text-center" ]
                [ span [ class "metric-label" ]
                    [ text (I18n.translate language (I18n.Organization I18n.Plural)) ]
                , aForPath
                    navigate
                    language
                    (Routes.urlBasePathForCardType OrganizationCard
                        ++ (Routes.queryStringForParams [ "q", "tagIds" ] location)
                    )
                    []
                    [ viewMetric model.organizations
                    ]
                ]
            ]
        ]


viewThumbnailLoading : String -> Html Msg
viewThumbnailLoading thumbnailExtraClasses =
    div [ class "col-xs-12 col-sm-6 col-md-4 col-lg-3" ]
        [ div [ class ("thumbnail " ++ thumbnailExtraClasses) ]
            ([ div [ class "visual" ]
                [ h1 [ class "dynamic" ] [ text "..." ] ]
             , div [ class "caption" ]
                [ h4 [] [ text "..." ]
                , p [] [ text "..." ]
                ]
             ]
                ++ [ div [ class "tags" ]
                        (List.repeat 3
                            (span
                                [ class "label label-default label-tool" ]
                                [ text "..." ]
                            )
                        )
                   ]
            )
        ]


viewThumbnails : I18n.Language -> Navigation.Location -> String -> LoadingStatus DataIdsBody -> Html Msg
viewThumbnails language location thumbnailExtraClasses loadingStatus =
    div [ class "row" ]
        (case loadingStatus of
            Loading _ ->
                (List.repeat 8 (viewThumbnailLoading thumbnailExtraClasses))

            Loaded body ->
                let
                    firstCard =
                        body.data.cards |> Dict.values |> List.head
                in
                    (List.map
                        (viewCardThumbnail language navigate thumbnailExtraClasses body.data.values)
                        (getOrderedCards body.data)
                    )
                        ++ (case firstCard of
                                Nothing ->
                                    []

                                Just firstCard ->
                                    [ div [ class "col-sm-12 text-center" ]
                                        [ aForPath
                                            navigate
                                            language
                                            ((Routes.urlBasePathForCard firstCard)
                                                ++ (Routes.queryStringForParams [ "q", "tagIds" ] location)
                                            )
                                            [ class "show-more" ]
                                            [ text (I18n.translate language (I18n.ShowAll body.count))
                                            , span [ class "glyphicon glyphicon-menu-down" ] []
                                            ]
                                        ]
                                    ]
                           )
        )
