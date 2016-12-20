module Collection.View exposing (..)

import Collection.Types exposing (..)
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import I18n
import Json.Decode as Decode
import Types exposing (..)
import Urls
import Views exposing (viewCardThumbnail, viewLoading, viewWebData)
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
                    let
                        collection =
                            case Dict.get body.data.id body.data.collections of
                                Nothing ->
                                    Debug.crash ("Collection not found id=" ++ body.data.id)

                                Just collection ->
                                    collection

                        user =
                            case Dict.get collection.authorId body.data.users of
                                Nothing ->
                                    Debug.crash ("User not found id=" ++ collection.authorId)

                                Just user ->
                                    user
                    in
                        div []
                            [ viewBanner language user collection
                            , viewCollectionContent language user collection body.data.cards body.data.values
                            ]
        )
        model.collection


viewBanner : I18n.Language -> User -> Collection -> Html Msg
viewBanner language user collection =
    div [ class "banner collection-header" ]
        [ div [ class "row full-bg" ]
            ((case collection.logo of
                Nothing ->
                    []

                Just logo ->
                    [ img [ class "cover", alt "screen", src (Urls.fullApiUrl logo) ] []
                    ]
             )
                ++ [ div [ class "container" ]
                        [ div [ class "row" ]
                            [ div [ class "col-xs-8" ]
                                []
                            , -- [ ol [ class "breadcrumb" ]
                              --     [ li []
                              --         [ a [ href "#" ]
                              --             [ text "Home" ]
                              --         ]
                              --     , li []
                              --         [ a [ href "#" ]
                              --             [ text "Collection" ]
                              --         ]
                              --     , li [ class "active" ]
                              --         [ text "Outils de consultation" ]
                              --     ]
                              -- ]
                              div [ class "col-xs-4" ]
                                [ div [ class "pull-right banner-button" ]
                                    [ button
                                        [ class "btn btn-default btn-xs btn-action-negative"
                                        , attribute "data-target" "#edit-content"
                                        , attribute "data-toggle" "modal"
                                        , onClick (navigate ("/collections/" ++ collection.id ++ "/edit"))
                                        , type_ "button"
                                        ]
                                        [ text "Edit collection"
                                          -- TODO i18n
                                        ]
                                    ]
                                ]
                            ]
                        , div [ class "row " ]
                            [ div [ class "col-md-12 text-center" ]
                                [ div [ class "collection-info" ]
                                    [ -- TODO
                                      -- div [ class "collection-thumb" ]
                                      -- [ img [ alt "screen", src "img/france.png" ]
                                      --     []
                                      -- ]
                                      h4 []
                                        [ text "Collection"
                                          -- TODO i18n
                                        ]
                                    , h2 []
                                        [ text collection.name ]
                                    , h3 []
                                        [ text "Recommandé par "
                                          -- TODO i18n
                                        , span []
                                            [ text user.name ]
                                        ]
                                    ]
                                ]
                            ]
                        ]
                   ]
            )
        ]


viewCollectionContent : I18n.Language -> User -> Collection -> Dict String Card -> Dict String Value -> Html Msg
viewCollectionContent language user collection cards values =
    div [ class "row" ]
        [ div [ class "container" ]
            [ div
                [ class "row" ]
                [ div [ class "col-xs-12" ]
                    [ div [ class "panel panel-default panel-side" ]
                        [ h6 [ class "panel-title" ]
                            [ text (I18n.translate language I18n.Share) ]
                        , div [ class "panel-body chart" ]
                            (let
                                url =
                                    Urls.fullUrl
                                        (Urls.absoluteUrlPathWithLanguage language ("/collections/" ++ collection.id))

                                imageUrl =
                                    collection.logo |> Maybe.withDefault Urls.appLogoFullUrl

                                facebookUrl =
                                    "http://www.facebook.com/sharer.php?s=100&p[title]="
                                        ++ Http.encodeUri collection.name
                                        ++ "&p[summary]="
                                        ++ Http.encodeUri
                                            (I18n.translate language (I18n.TweetMessage collection.name url))
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
                                        ++ Http.encodeUri collection.name
                                        ++ "&summary="
                                        ++ Http.encodeUri
                                            (I18n.translate language (I18n.TweetMessage collection.name url))
                                        ++ "&source="
                                        ++ Http.encodeUri "OGP Toolbox"

                                twitterUrl =
                                    "https://twitter.com/intent/tweet?text="
                                        ++ Http.encodeUri
                                            (I18n.translate language (I18n.TweetMessage collection.name url))
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
            , div [ class "row" ]
                [ div [ class "col-md-12 content" ]
                    [ div [ class "row" ]
                        [ div [ class "col-xs-12" ]
                            [ div [ class "panel panel-default main" ]
                                [ div [ class "row" ]
                                    [ div [ class "col-xs-8 text-left" ]
                                        [ h3 [ class "panel-title" ]
                                            [ text "About"
                                              -- TODO i18n
                                            ]
                                        ]
                                    , div [ class "col-xs-4 text-right" ]
                                        []
                                    ]
                                , div [ class "panel-body simple" ]
                                    [ p []
                                        [ text collection.description ]
                                    ]
                                ]
                            , div [ class "panel panel-default" ]
                                [ div [ class "row" ]
                                    [ div [ class "col-xs-8 text-left" ]
                                        [ h4 [ class "zone-label" ]
                                            [ text "Outils"
                                              -- TODO i18n
                                            ]
                                        ]
                                      -- , div [ class "col-xs-4 text-right up7" ]
                                      --     [ a [ class "btn btn-default btn-xs btn-action", href "compare.html", type' "button" ]
                                      --         [ text "Compare"-- TODO i18n
                                      --          ]
                                      --     ]
                                    ]
                                , div [ class "panel-body" ]
                                    [ div [ class "row" ]
                                        (let
                                            toolCards =
                                                List.filterMap
                                                    (\cardId ->
                                                        let
                                                            card =
                                                                getCard cards cardId
                                                        in
                                                            if cardSubTypeIdsIntersect card.subTypeIds cardTypesForTool then
                                                                Just card
                                                            else
                                                                Nothing
                                                    )
                                                    collection.cardIds
                                         in
                                            List.map
                                                (viewCardThumbnail language navigate "tool grey" values)
                                                toolCards
                                        )
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        , div [ class "row section grey last" ]
            [ div [ class "container" ]
                [ div [ class "col-xs-12" ]
                    [ h4 [ class "zone-label" ]
                        [ text "Utilisations"
                          -- TODO i18n
                        ]
                    , div [ class "row" ]
                        (let
                            useCaseCards =
                                List.filterMap
                                    (\cardId ->
                                        let
                                            card =
                                                getCard cards cardId
                                        in
                                            if
                                                List.any
                                                    (\subTypeId -> List.member subTypeId card.subTypeIds)
                                                    cardTypesForUseCase
                                            then
                                                Just card
                                            else
                                                Nothing
                                    )
                                    collection.cardIds
                         in
                            List.map
                                (viewCardThumbnail language navigate "example" values)
                                useCaseCards
                        )
                    ]
                ]
            ]
        ]
