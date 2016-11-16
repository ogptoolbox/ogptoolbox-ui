module Views exposing (..)

import Authenticator.Model
import Dict
import Json.Decode
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Aria exposing (ariaDescribedby, ariaHidden, ariaLabel, ariaPressed, role)
import Html.Events exposing (on, onClick, onInput, onWithOptions, targetValue)
import Http exposing (Error(..))
import Routes exposing (makeUrl)
import String
import Types exposing (Ballot, convertArgumentTypeToString, ModelFragment, Statement, StatementCustom(..))
import WebData exposing (LoadingStatus, WebData(..))


argumentTypeLabelCouples : List ( String, String )
argumentTypeLabelCouples =
    [ ( "because", "Because" )
    , ( "but", "But" )
    , ( "comment", "Comment" )
    , ( "example", "Example" )
    ]


argumentTypes : List String
argumentTypes =
    List.map (\( item, label ) -> item) argumentTypeLabelCouples


kindLabelCouples : List ( String, String )
kindLabelCouples =
    [ ( "PlainStatement", "Plain" )
    , ( "Tag", "Tag" )
    ]


kinds : List String
kinds =
    List.map (\( item, label ) -> item) kindLabelCouples


languageCodeLabelCouples : List ( String, String )
languageCodeLabelCouples =
    [ ( "en", "English" )
    , ( "fr", "Français" )
    ]


languageCodes : List String
languageCodes =
    List.map (\( item, label ) -> item) languageCodeLabelCouples


aForPath : (String -> msg) -> String -> List (Attribute msg) -> List (Html msg) -> Html msg
aForPath navigate path attributes children =
    a
        ([ href (makeUrl path)
         , onWithOptions
            "click"
            { stopPropagation = True, preventDefault = True }
            (Json.Decode.succeed (navigate path))
         ]
            ++ attributes
        )
        children


decodeArgumentType : String -> Json.Decode.Decoder String
decodeArgumentType value =
    if List.member value argumentTypes then
        Json.Decode.succeed value
    else
        Json.Decode.fail ("Unknown argument type: " ++ value)


decodeKind : String -> Json.Decode.Decoder String
decodeKind value =
    if List.member value kinds then
        Json.Decode.succeed value
    else
        Json.Decode.fail ("Unknown type: " ++ value)


decodeLanguageCode : String -> Json.Decode.Decoder String
decodeLanguageCode value =
    if List.member value languageCodes then
        Json.Decode.succeed value
    else
        Json.Decode.fail ("Unknown language: " ++ value)



-- decodeRating : Int -> Json.Decode.Decoder Int
-- decodeRating value =
--     if List.member value ratings then
--         Json.Decode.succeed value
--     else
--         Json.Decode.fail ("Unknown rating: " ++ toString value)
-- decodeRatingTargetValue : Json.Decode.Decoder Int
-- decodeRatingTargetValue =
--     Json.Decode.customDecoder targetValue (Json.Decode.decodeString Json.Decode.int) `Json.Decode.andThen` decodeRating


hasBallotRating : Int -> Maybe Ballot -> Bool
hasBallotRating rating ballotMaybe =
    case ballotMaybe of
        Just ballot ->
            ballot.rating == rating

        Nothing ->
            False


viewArgumentType : String -> Maybe String -> (String -> msg) -> Html msg
viewArgumentType argumentType errorMaybe argumentTypeChanged =
    let
        ( errorClass, errorAttributes, errorBlock ) =
            case errorMaybe of
                Just error ->
                    ( " has-error"
                    , [ ariaDescribedby "argument-type-error" ]
                    , [ span
                            [ class "help-block"
                            , id "argument-type-error"
                            ]
                            [ text error ]
                      ]
                    )

                Nothing ->
                    ( "", [], [] )
    in
        div [ class ("form-group" ++ errorClass) ]
            ([ label [ class "control-label", for "argument-type" ] [ text "Argument Type" ]
             , select
                ([ class "form-control"
                 , id "argument-type"
                 , on "change"
                    (Json.Decode.map argumentTypeChanged
                        (targetValue `Json.Decode.andThen` decodeArgumentType)
                    )
                 ]
                    ++ errorAttributes
                )
                (List.map
                    (viewOption argumentType)
                    ([ ( "", "" ) ] ++ argumentTypeLabelCouples)
                )
             ]
                ++ errorBlock
            )


viewKind : String -> Maybe String -> (String -> msg) -> Html msg
viewKind kind errorMaybe kindChanged =
    let
        ( errorClass, errorAttributes, errorBlock ) =
            case errorMaybe of
                Just error ->
                    ( " has-error"
                    , [ ariaDescribedby "type-error" ]
                    , [ span
                            [ class "help-block"
                            , id "type-error"
                            ]
                            [ text error ]
                      ]
                    )

                Nothing ->
                    ( "", [], [] )
    in
        div [ class ("form-group" ++ errorClass) ]
            ([ label [ class "control-label", for "type" ] [ text "Type" ]
             , select
                ([ class "form-control"
                 , id "type"
                 , on "change" (Json.Decode.map kindChanged (targetValue `Json.Decode.andThen` decodeKind))
                 ]
                    ++ errorAttributes
                )
                (List.map
                    (viewOption kind)
                    kindLabelCouples
                )
             ]
                ++ errorBlock
            )


viewLanguageCode : String -> Maybe String -> (String -> msg) -> Html msg
viewLanguageCode languageCode errorMaybe languageCodeChanged =
    let
        ( errorClass, errorAttributes, errorBlock ) =
            case errorMaybe of
                Just error ->
                    ( " has-error"
                    , [ ariaDescribedby "language-error" ]
                    , [ span
                            [ class "help-block"
                            , id "language-error"
                            ]
                            [ text error ]
                      ]
                    )

                Nothing ->
                    ( "", [], [] )
    in
        div [ class ("form-group" ++ errorClass) ]
            ([ label [ class "control-label", for "language" ] [ text "Language" ]
             , select
                ([ class "form-control"
                 , id "language"
                 , on "change"
                    (Json.Decode.map languageCodeChanged
                        (targetValue `Json.Decode.andThen` decodeLanguageCode)
                    )
                 ]
                    ++ errorAttributes
                )
                (List.map
                    (viewOption languageCode)
                    languageCodeLabelCouples
                )
             ]
                ++ errorBlock
            )


viewHttpError : Http.Error -> Html msg
viewHttpError err =
    div []
        [ case err of
            Timeout ->
                text "The server was too slow to respond (timeout)."

            NetworkError ->
                text "There was a network error."

            UnexpectedPayload string ->
                text "The server returned an unexpected payload."

            BadResponse code string ->
                if code == 404 then
                    viewNotFound
                else
                    text string
        ]


viewLoading : Html msg
viewLoading =
    text "Data is loading and should be displayed quite soon."


viewName : String -> Maybe String -> (String -> msg) -> Html msg
viewName name errorMaybe nameChanged =
    let
        ( errorClass, errorAttributes, errorBlock ) =
            case errorMaybe of
                Just error ->
                    ( " has-error"
                    , [ ariaDescribedby "name-error" ]
                    , [ span
                            [ class "help-block"
                            , id "name-error"
                            ]
                            [ text error ]
                      ]
                    )

                Nothing ->
                    ( "", [], [] )
    in
        div [ class ("form-group" ++ errorClass) ]
            ([ label [ class "control-label", for "name" ] [ text "Name" ]
             , input
                ([ class "form-control"
                 , id "name"
                 , placeholder "To be or not to be"
                 , type' "text"
                 , value name
                 , onInput nameChanged
                 ]
                    ++ errorAttributes
                )
                []
             ]
                ++ errorBlock
            )


viewNotFound : Html msg
viewNotFound =
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
            [ text "Page Not Found" ]
        , p
            [ style
                [ ( "color", "rgb(136, 136, 136)" )
                ]
            ]
            [ text "Sorry, but the page you were trying to view does not exist." ]
        ]


viewOption : a -> ( a, String ) -> Html msg
viewOption selectedItem ( item, label ) =
    let
        itemString =
            (toString item)

        itemString' =
            if String.left 1 itemString == "\"" && String.right 1 itemString == "\"" then
                String.slice 1 -1 itemString
            else
                itemString
    in
        option
            [ selected (item == selectedItem)
            , value itemString'
            ]
            [ text label ]


viewStatementLine :
    Maybe Authenticator.Model.Authentication
    -> (List (Attribute msg) -> List (Html msg) -> Html msg)
    -> String
    -> Bool
    -> (String -> msg)
    -> (Maybe Int -> String -> msg)
    -> (String -> msg)
    -> ModelFragment a
    -> Html msg
viewStatementLine authenticationMaybe htmlElement statementId link navigate ratingChanged flagAbuse model =
    htmlElement
        [ class "statement-line" ]
        [ viewStatementLinePanel authenticationMaybe statementId ratingChanged flagAbuse model
        , viewStatementLineBody authenticationMaybe statementId link navigate model
        ]


viewStatementLineBody :
    Maybe Authenticator.Model.Authentication
    -> String
    -> Bool
    -> (String -> msg)
    -> ModelFragment a
    -> Html msg
viewStatementLineBody authenticationMaybe statementId link navigate model =
    let
        statementMaybe =
            Dict.get statementId model.statementById
    in
        case statementMaybe of
            Nothing ->
                div
                    [ class "statement-line-body" ]
                    [ h4
                        [ class "statement-line-title" ]
                        [ text ("Missing statement " ++ statementId) ]
                    ]

            Just statement ->
                case statement.custom of
                    AbuseCustom abuse ->
                        let
                            content =
                                "Abuse"
                        in
                            div
                                [ class "statement-line-body" ]
                                [ h4
                                    [ class "statement-line-title" ]
                                    [ if link then
                                        aForPath navigate ("/statements/" ++ statement.id) [] [ text content ]
                                      else
                                        text content
                                    , text " for "
                                    ]
                                , viewStatementLineBody authenticationMaybe abuse.statementId True navigate model
                                ]

                    ArgumentCustom argument ->
                        let
                            content =
                                "Argument"
                        in
                            div
                                [ class "statement-line-body" ]
                                [ h4
                                    [ class "statement-line-title" ]
                                    [ if link then
                                        aForPath navigate ("/statements/" ++ statement.id) [] [ text content ]
                                      else
                                        text content
                                    , text " for "
                                    ]
                                , text (convertArgumentTypeToString argument.argumentType)
                                , dl
                                    []
                                    [ dt [] [ text "Claim:" ]
                                    , dd []
                                        [ viewStatementLineBody authenticationMaybe
                                            argument.claimId
                                            True
                                            navigate
                                            model
                                        ]
                                    , dt [] [ text "Ground:" ]
                                    , dd []
                                        [ viewStatementLineBody authenticationMaybe
                                            argument.groundId
                                            True
                                            navigate
                                            model
                                        ]
                                    ]
                                ]

                    CardCustom card ->
                        Debug.crash "TODO"

                    PlainCustom plain ->
                        div
                            [ class "statement-line-body" ]
                            [ h4
                                [ class "statement-line-title" ]
                                [ if link then
                                    aForPath navigate ("/statements/" ++ statement.id) [] [ text plain.name ]
                                  else
                                    text plain.name
                                ]
                            ]

                    TagCustom tag ->
                        let
                            content =
                                "Tag " ++ tag.name
                        in
                            div
                                [ class "statement-line-body" ]
                                [ h4
                                    [ class "statement-line-title" ]
                                    [ if link then
                                        aForPath navigate ("/statements/" ++ statement.id) [] [ text content ]
                                      else
                                        text content
                                    , text " for "
                                    ]
                                , viewStatementLineBody authenticationMaybe tag.statementId True navigate model
                                ]


viewStatementLinePanel :
    Maybe Authenticator.Model.Authentication
    -> String
    -> (Maybe Int -> String -> msg)
    -> (String -> msg)
    -> ModelFragment a
    -> Html msg
viewStatementLinePanel authenticationMaybe statementId ratingChanged flagAbuse model =
    let
        statementMaybe =
            Dict.get statementId model.statementById
    in
        case statementMaybe of
            Nothing ->
                text ""

            Just statement ->
                let
                    authenticated =
                        case authenticationMaybe of
                            Just _ ->
                                True

                            Nothing ->
                                False

                    abuseAttributes =
                        if authenticated then
                            [ onClick (flagAbuse statement.id)
                            ]
                        else
                            [ disabled True
                            ]

                    ballotMaybe =
                        case statement.ballotIdMaybe of
                            Just ballotId ->
                                Dict.get ballotId model.ballotById

                            Nothing ->
                                Nothing

                    deleteRatingAttributes =
                        case ballotMaybe of
                            Just ballot ->
                                [ class "btn btn-default"
                                , onClick (ratingChanged Nothing statement.id)
                                ]

                            Nothing ->
                                [ class "btn btn-default"
                                , disabled (not authenticated)
                                ]

                    negativeRatingAttributes =
                        if hasBallotRating -1 ballotMaybe then
                            [ ariaPressed True
                            , class "active btn btn-default"
                            ]
                        else if authenticated then
                            [ class "btn btn-default"
                            , onClick (ratingChanged (Just -1) statement.id)
                            ]
                        else
                            [ class "btn btn-default"
                            , disabled True
                            ]

                    positiveRatingAttributes =
                        if hasBallotRating 1 ballotMaybe then
                            [ ariaPressed True
                            , class "active btn btn-default"
                            ]
                        else if authenticated then
                            [ class "btn btn-default"
                            , onClick (ratingChanged (Just 1) statement.id)
                            ]
                        else
                            [ class "btn btn-default"
                            , disabled True
                            ]

                    zeroRatingAttributes =
                        if hasBallotRating 0 ballotMaybe then
                            [ ariaPressed True
                            , class "active btn btn-default"
                            ]
                        else if authenticated then
                            [ class "btn btn-default"
                            , onClick (ratingChanged (Just 0) statement.id)
                            ]
                        else
                            [ class "btn btn-default"
                            , disabled True
                            ]
                in
                    div
                        [ ariaLabel "Statement panel"
                        , class "statement-line-panel"
                        , role "toolbar"
                        ]
                        [ div
                            [ ariaLabel "Rate statement"
                            , role "group"
                            , class "btn-group-vertical btn-group-xs"
                            ]
                            [ button
                                ([ ariaLabel "Set rating for statement to 1"
                                 , role "button"
                                 , title "Set rating for statement to 1"
                                 , type' "button"
                                 ]
                                    ++ positiveRatingAttributes
                                )
                                [ span
                                    [ ariaHidden True
                                    , class "glyphicon glyphicon-triangle-top"
                                    ]
                                    []
                                ]
                            , button
                                ([ ariaLabel "Set rating for statement to 0"
                                 , role "button"
                                 , title "Set rating for statement to 0"
                                 , type' "button"
                                 ]
                                    ++ zeroRatingAttributes
                                )
                                [ text "="
                                ]
                            , button
                                ([ ariaLabel "Set rating for statement to -1"
                                 , role "button"
                                 , title "Set rating for statement to -1"
                                 , type' "button"
                                 ]
                                    ++ negativeRatingAttributes
                                )
                                [ span
                                    [ ariaHidden True
                                    , class "glyphicon glyphicon-triangle-bottom"
                                    ]
                                    []
                                ]
                            ]
                        , div
                            [ ariaLabel "Manage statement"
                            , role "group"
                            , class "btn-group-vertical btn-group-xs"
                            ]
                            [ button
                                ([ ariaLabel "Erase rating for statement"
                                 , role "button"
                                 , title "Delete rating for statement"
                                 , type' "button"
                                 ]
                                    ++ deleteRatingAttributes
                                )
                                [ span
                                    [ ariaHidden True
                                    , class "glyphicon glyphicon-erase"
                                    ]
                                    []
                                ]
                            , button
                                [ ariaLabel "Sum and count of ratings"
                                , class "btn btn-default"
                                , disabled True
                                  -- , role "button"
                                , title "Sum and count of ratings"
                                , type' "button"
                                ]
                                [ text ((toString statement.ratingSum) ++ " / " ++ (toString statement.ratingCount))
                                ]
                            , button
                                ([ ariaLabel "Set statement rating to -1"
                                 , class "btn btn-default"
                                 , role "button"
                                 , title "Sum and count of ratings"
                                 , type' "button"
                                 ]
                                    ++ abuseAttributes
                                )
                                [ span
                                    [ ariaHidden True
                                    , class
                                        (if statement.isAbuse then
                                            "glyphicon glyphicon-trash"
                                         else
                                            "glyphicon glyphicon-warning-sign"
                                        )
                                    ]
                                    []
                                ]
                            ]
                        ]


viewWebData : (LoadingStatus a -> List (Html msg)) -> WebData a -> List (Html msg)
viewWebData viewSuccess webData =
    case webData of
        NotAsked ->
            [ text "" ]

        Failure err ->
            [ viewHttpError err ]

        Data loadingStatus ->
            viewSuccess loadingStatus
