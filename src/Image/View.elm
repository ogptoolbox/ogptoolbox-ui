module Image.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Http.Error
import Image.Types exposing (..)
import I18n
import Urls


publishedDisabled : ImageUploadStatus -> Bool
publishedDisabled imageUploadStatus =
    case imageUploadStatus of
        ImageNotUploadedStatus ->
            False

        ImageSelectedStatus ->
            False

        ImageReadStatus _ ->
            True

        ImageUploadedStatus _ ->
            False

        ImageUploadErrorStatus _ ->
            False


viewImageUploadStatus : I18n.Language -> ImageUploadStatus -> Html msg
viewImageUploadStatus language imageUploadStatus =
    let
        missingImage messageI18n =
            div [ class "text-xs-center" ]
                [ span
                    [ attribute "aria-hidden" "true"
                    , class "glyphicon glyphicon-camera"
                    ]
                    []
                , p [] [ text <| I18n.translate language messageI18n ]
                ]
    in
        case imageUploadStatus of
            ImageNotUploadedStatus ->
                missingImage I18n.UploadImage

            ImageSelectedStatus ->
                missingImage I18n.ReadingSelectedImage

            ImageReadStatus { contents, filename } ->
                missingImage (I18n.UploadingImage filename)

            ImageUploadedStatus path ->
                img
                    [ alt <| I18n.translate language I18n.ImageAlt
                    , src (Urls.fullApiUrl path)
                    , style [ ( "max-width", "100%" ) ]
                    ]
                    []

            ImageUploadErrorStatus httpError ->
                missingImage <|
                    I18n.ImageUploadError <|
                        Http.Error.toString language httpError
