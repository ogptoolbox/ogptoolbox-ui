module Examples.View exposing (..)

import Authenticator.Model
import Browse
import Example
import Examples.Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import I18n
import Types exposing (..)
import Views exposing (viewWebData)
import WebData exposing (..)


root : Maybe Authenticator.Model.Authentication -> Model -> String -> I18n.Language -> List (Html Msg)
root authenticationMaybe model searchQuery language =
    case model of
        Examples.Types.Example webData ->
            [ div [ class "row section" ]
                [ div [ class "container" ]
                    (viewWebData
                        language
                        (\loadingStatus -> [ Example.view navigate language loadingStatus ])
                        webData
                    )
                ]
            ]

        Examples.Types.Examples webData ->
            viewWebData
                language
                (\loadingStatus ->
                    let
                        counts =
                            getLoadingStatusData loadingStatus
                                |> Maybe.map
                                    (\loadingStatus ->
                                        { examples = loadingStatus.examples.count
                                        , organizations = loadingStatus.organizationsCount
                                        , tools = loadingStatus.toolsCount
                                        }
                                    )
                    in
                        Browse.view
                            Types.Example
                            counts
                            navigate
                            searchQuery
                            language
                            (mapLoadingStatus .examples loadingStatus)
                )
                webData
