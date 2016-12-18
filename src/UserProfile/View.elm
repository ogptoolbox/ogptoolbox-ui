module UserProfile.View exposing (..)

import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Helpers exposing (aForPath)
import I18n
import UserProfile.Types exposing (..)
import Types exposing (..)
import Urls
import WebData exposing (..)


view : Model -> I18n.Language -> User -> Html Msg
view model language user =
    let
        collections =
            case getData model.collections of
                Nothing ->
                    []

                Just collectionsBody ->
                    List.map
                        (\id ->
                            case Dict.get id collectionsBody.data.collections of
                                Nothing ->
                                    Debug.crash ("Collection not found id=" ++ id)

                                Just collection ->
                                    collection
                        )
                        collectionsBody.data.ids
    in
        div
            [ class "row section" ]
            [ div [ class "container" ]
                [ div [ class "row" ]
                    [ div [ class "col-md-12 content content-left" ]
                        [ div [ class "row" ]
                            [ div [ class "col-xs-12" ]
                                [ h1 [ class "user-name" ]
                                    [ text user.name ]
                                , h3 [ class "user-mail" ]
                                    [ text user.email ]
                                ]
                            ]
                        ]
                    ]
                , div [ class "row section" ]
                    [ div [ class "container" ]
                        [ h3 [ class "zone-label" ]
                            [ text "My Collections"
                              -- TODO i18n
                            ]
                        , div [ class "row" ]
                            ((List.map (viewCollectionThumbnail language user) collections)
                                ++ [ div [ class "col-sm-12 text-center" ]
                                        [ aForPath
                                            navigate
                                            language
                                            "/collections/new"
                                            [ class "show-more" ]
                                            [ span [ class "glyphicon glyphicon-plus" ]
                                                []
                                            , text "Ajouter une collection"
                                              -- TODO i18n
                                            ]
                                        ]
                                   ]
                            )
                        ]
                    ]
                ]
            ]


viewCollectionThumbnail : I18n.Language -> User -> Collection -> Html Msg
viewCollectionThumbnail language user collection =
    div [ class "col-xs-6 col-md-4 " ]
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
