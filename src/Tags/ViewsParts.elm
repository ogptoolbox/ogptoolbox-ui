module Tags.ViewsParts exposing (..)

import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Helpers exposing (aForPath)
import I18n
import Types exposing (..)
import Urls


-- TODO: Replace TypedValue with DataProxy.


viewTagsWithCallToAction : (String -> msg) -> I18n.Language -> Dict String TypedValue -> Card -> Html msg
viewTagsWithCallToAction navigate language values card =
    div [ class "tags" ]
        (case I18n.getTags language card values of
            [] ->
                [ span
                    -- TODO call to action
                    [ class "label label-default label-tool" ]
                    [ text (I18n.translate language I18n.CallToActionForCategory) ]
                ]

            tags ->
                tags
                    |> List.take 3
                    |> List.map
                        (\{ tag, tagId } ->
                            let
                                path =
                                    Urls.basePathForCard card ++ "?tagIds=" ++ tagId
                            in
                                aForPath
                                    navigate
                                    language
                                    path
                                    [ class "label label-default label-tool" ]
                                    [ text tag ]
                        )
        )
