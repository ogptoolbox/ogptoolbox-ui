module Collections.View exposing (..)

import Configuration
import Collections.Types exposing (..)
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Helpers exposing (aForPath)
import I18n
import Types exposing (..)
import Views exposing (viewLoading, viewWebData)
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
                    in
                        div []
                            [ viewCollections language body.data.users collections ]
        )
        model.collections


viewCollections : I18n.Language -> Dict String User -> List Collection -> Html Msg
viewCollections language users collections =
    div [ class "row section" ]
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
                        [ img [ alt "screen", src (Configuration.apiUrlWithPath logo) ] []
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
