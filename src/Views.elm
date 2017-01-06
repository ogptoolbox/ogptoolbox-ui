module Views exposing (..)

import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Aria exposing (..)
import Html.Events exposing (..)
import Html.Helpers exposing (aForPath)
import Http exposing (Error(..))
import Http.Error
import I18n
import String
import Tags.ViewsParts exposing (..)
import Types exposing (..)
import Urls
import WebData exposing (LoadingStatus, WebData(..))


errorInfos : I18n.Language -> String -> Maybe I18n.TranslationId -> ( String, List (Attribute msg), List (Html msg1) )
errorInfos language fieldId error =
    let
        errorId =
            fieldId ++ "-error"
    in
        case error of
            Just error ->
                ( " has-error"
                , [ ariaDescribedby errorId ]
                , [ span
                        [ class "help-block"
                        , id errorId
                        ]
                        [ text <| I18n.translate language error ]
                  ]
                )

            Nothing ->
                ( "", [], [] )


viewBigMessage : String -> String -> Html msg
viewBigMessage title message =
    div
        [ style
            [ ( "justify-content", "center" )
            , ( "flex-direction", "column" )
            , ( "display", "flex" )
            , ( "align-items", "center" )
            , ( "height", "100%" )
            , ( "margin", "1em" )
            , ( "font-family", "sans-serif" )
            ]
        ]
        [ h1 []
            [ text title ]
        , p
            [ style
                [ ( "color", "rgb(136, 136, 136)" )
                , ( "margin-top", "3em" )
                ]
            ]
            [ text message ]
        ]


viewCardListItem : (String -> msg) -> I18n.Language -> Dict String TypedValue -> Card -> Html msg
viewCardListItem navigate language values card =
    let
        name =
            I18n.getName language card values

        path =
            Urls.pathForCard card

        cardType =
            getCardType card
    in
        div
            [ class
                ("thumbnail "
                    ++ case cardType of
                        UseCaseCard ->
                            "example"

                        ToolCard ->
                            "tool"

                        OrganizationCard ->
                            "orga"
                )
            , onClick (navigate path)
            ]
            [ div [ class "visual" ]
                [ case Urls.imageFullUrl language "300" card values of
                    Just url ->
                        img [ alt "Logo", src url ] []

                    Nothing ->
                        h1 [ class "dynamic" ]
                            [ text
                                (case cardType of
                                    OrganizationCard ->
                                        String.left 1 name

                                    ToolCard ->
                                        String.left 2 name

                                    UseCaseCard ->
                                        name
                                )
                            ]
                ]
            , div [ class "caption" ]
                [ h4 []
                    [ aForPath
                        navigate
                        language
                        path
                        []
                        [ text name ]
                    , small []
                        [ text (I18n.getSubTypes language card values |> String.join ", ") ]
                    ]
                  -- , div [ class "example-author" ]
                  --     [ img [ alt "screen", src "/img/TODO.png" ]
                  --         []
                  --     , text "TODO The White House"
                  --     ]
                , p []
                    (case I18n.getOneString language descriptionKeys card values of
                        Just description ->
                            [ text description ]

                        Nothing ->
                            []
                    )
                ]
            , viewTagsWithCallToAction navigate language values card
            ]


viewDescriptionControl :
    (String -> msg)
    -> I18n.Language
    -> I18n.TranslationId
    -> Dict String I18n.TranslationId
    -> String
    -> Html msg
viewDescriptionControl valueChanged language placeholderI18n errors controlValue =
    let
        controlId =
            "description"

        controlLabel =
            I18n.translate language I18n.About

        controlPlaceholder =
            I18n.translate language placeholderI18n

        controlTitle =
            I18n.translate language I18n.EnterDescription

        ( errorClass, errorAttributes, errorBlock ) =
            errorInfos language controlId (Dict.get controlId errors)
    in
        div [ class ("form-group" ++ errorClass) ]
            ([ label [ class "control-label", for controlId ] [ text controlLabel ]
             , textarea
                ([ class "form-control"
                 , id controlId
                 , onInput valueChanged
                 , placeholder controlPlaceholder
                 , title controlTitle
                 ]
                    ++ errorAttributes
                )
                [ text controlValue ]
             ]
                ++ errorBlock
            )


viewLoading : I18n.Language -> Html msg
viewLoading language =
    div [ style [ ( "height", "100em" ) ] ]
        [ img [ class "loader", src "/img/loader.gif" ] [] ]


viewNameControl :
    (String -> msg)
    -> I18n.Language
    -> I18n.TranslationId
    -> Dict String I18n.TranslationId
    -> String
    -> Html msg
viewNameControl valueChanged language placeholderI18n errors controlValue =
    let
        controlId =
            "name"

        controlLabel =
            I18n.translate language I18n.Name

        controlPlaceholder =
            I18n.translate language placeholderI18n

        controlTitle =
            I18n.translate language I18n.EnterName

        ( errorClass, errorAttributes, errorBlock ) =
            errorInfos language controlId (Dict.get controlId errors)
    in
        div [ class ("form-group" ++ errorClass) ]
            ([ label [ class "control-label", for controlId ] [ text controlLabel ]
             , input
                ([ class "form-control"
                 , id controlId
                 , onInput valueChanged
                 , placeholder controlPlaceholder
                 , title controlTitle
                 , type_ "text"
                 , value controlValue
                 ]
                    ++ errorAttributes
                )
                []
             ]
                ++ errorBlock
            )


viewNotAuthentified : I18n.Language -> Html msg
viewNotAuthentified language =
    viewBigMessage
        (I18n.translate language I18n.AuthenticationRequired)
        (I18n.translate language I18n.AuthenticationRequiredExplanation)


viewNotFound : I18n.Language -> Html msg
viewNotFound language =
    viewBigMessage
        (I18n.translate language I18n.PageNotFound)
        (I18n.translate language I18n.PageNotFoundExplanation)


viewWebData : I18n.Language -> (LoadingStatus a -> Html msg) -> WebData a -> Html msg
viewWebData language viewSuccess webData =
    case webData of
        NotAsked ->
            div [ class "text-center" ]
                [ viewLoading language ]

        Failure err ->
            let
                genericTitle =
                    I18n.translate language I18n.GenericError

                title =
                    case err of
                        BadPayload message response ->
                            genericTitle

                        BadStatus response ->
                            if response.status.code == 404 then
                                I18n.translate language I18n.PageNotFound
                            else
                                -- TODO Add I18n.BadStatusExplanation prefix
                                genericTitle

                        BadUrl message ->
                            genericTitle

                        NetworkError ->
                            genericTitle

                        Timeout ->
                            genericTitle
            in
                viewBigMessage title (Http.Error.toString language err)

        Data loadingStatus ->
            viewSuccess loadingStatus
