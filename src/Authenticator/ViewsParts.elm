module Authenticator.ViewsParts exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Aria exposing (..)
import Html.Events exposing (..)
import I18n


errorInfos : String -> Maybe String -> ( String, List (Attribute msg), List (Html msg1) )
errorInfos fieldId error =
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
                        [ text error ]
                  ]
                )

            Nothing ->
                ( "", [], [] )


viewEmailField : (String -> msg) -> I18n.Language -> Maybe String -> String -> Html msg
viewEmailField valueChanged language error fieldValue =
    let
        fieldId =
            "email"

        fieldLabel =
            I18n.translate language I18n.Email

        fieldPlaceholder =
            "john.doe@example.com"

        fieldTitle =
            I18n.translate language I18n.EnterEmail

        ( errorClass, errorAttributes, errorBlock ) =
            errorInfos fieldId error
    in
        div [ class ("form-group" ++ errorClass) ]
            ([ label [ class "control-label", for fieldId ] [ text fieldLabel ]
             , input
                ([ class "form-control"
                 , id fieldId
                 , placeholder fieldPlaceholder
                 , required True
                 , title fieldTitle
                 , type_ "email"
                 , value fieldValue
                 , onInput valueChanged
                 ]
                    ++ errorAttributes
                )
                []
             ]
                ++ errorBlock
            )


viewPasswordField : (String -> msg) -> I18n.Language -> Maybe String -> String -> Html msg
viewPasswordField valueChanged language error fieldValue =
    let
        fieldId =
            "password"

        fieldLabel =
            I18n.translate language I18n.Password

        fieldPlaceholder =
            I18n.translate language I18n.PasswordPlaceholder

        fieldTitle =
            I18n.translate language I18n.EnterPassword

        ( errorClass, errorAttributes, errorBlock ) =
            errorInfos fieldId error
    in
        div [ class ("form-group" ++ errorClass) ]
            ([ label [ class "control-label", for fieldId ] [ text fieldLabel ]
             , input
                ([ class "form-control"
                 , id fieldId
                 , placeholder fieldPlaceholder
                 , required True
                 , title fieldTitle
                 , type_ "password"
                 , value fieldValue
                 , onInput valueChanged
                 ]
                    ++ errorAttributes
                )
                []
             ]
                ++ errorBlock
            )


viewUsernameField : (String -> msg) -> I18n.Language -> Maybe String -> String -> Html msg
viewUsernameField valueChanged language error fieldValue =
    let
        fieldId =
            "username"

        fieldLabel =
            I18n.translate language I18n.Username

        fieldPlaceholder =
            I18n.translate language I18n.UsernamePlaceholder

        fieldTitle =
            I18n.translate language I18n.EnterUsername

        ( errorClass, errorAttributes, errorBlock ) =
            errorInfos fieldId error
    in
        div [ class ("form-group" ++ errorClass) ]
            ([ label [ class "control-label", for fieldId ] [ text fieldLabel ]
             , input
                ([ class "form-control"
                 , id fieldId
                 , placeholder fieldPlaceholder
                 , required True
                 , title fieldTitle
                 , type_ "text"
                 , value fieldValue
                 , onInput valueChanged
                 ]
                    ++ errorAttributes
                )
                []
             ]
                ++ errorBlock
            )
