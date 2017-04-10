module Properties.New.View exposing (..)

import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Aria exposing (..)
import Html.Events exposing (..)
import Http.Error
import I18n
import Json.Decode
import Properties.New.Types exposing (..)
import Values.New.View
import Views exposing (errorInfos)


keyIdLabelCouples : List ( String, I18n.TranslationId )
keyIdLabelCouples =
    [ ( "pros", I18n.DebateProsLabel )
    , ( "cons", I18n.DebateConsLabel )
    ]


view : Model -> Html Msg
view model =
    section []
        [ h1 [] [ text <| I18n.translate model.language I18n.NewProperty ]
        , viewForm I18n.Create model
        ]


viewForm : I18n.TranslationId -> Model -> Html Msg
viewForm submitButtonI18n model =
    let
        language =
            model.language

        alert =
            case model.httpError of
                Nothing ->
                    []

                Just httpError ->
                    [ div
                        [ class "alert alert-danger"
                        , role "alert"
                        ]
                        [ strong []
                            [ text <|
                                I18n.translate language I18n.ValueCreationFailed
                                    ++ I18n.translate language I18n.Colon
                            ]
                        , text <| Http.Error.toString language httpError
                        ]
                    ]
    in
        Html.form
            [ onSubmit (ForSelf <| Submit) ]
            (alert
                ++ (viewFormControls model)
                ++ [ button
                        [ class "btn btn-primary"
                        , disabled (not (Dict.isEmpty model.errors) || model.newValueModel.field == Nothing)
                        , type_ "submit"
                        ]
                        [ text (I18n.translate language submitButtonI18n) ]
                   ]
            )


viewFormControls : Model -> List (Html Msg)
viewFormControls model =
    let
        language =
            model.language
    in
        [ let
            controlId =
                "keyId"

            ( errorClass, errorAttributes, errorBlock ) =
                errorInfos language controlId (Dict.get controlId model.errors)
          in
            div [ class ("form-group" ++ errorClass) ]
                ([ label
                    [ class "control-label", for controlId ]
                    [ text <| I18n.translate language I18n.Type ]
                 , select
                    ([ class "form-control"
                     , id controlId
                     , on "change"
                        (Json.Decode.map (ForSelf << KeyIdChanged)
                            targetValue
                        )
                     ]
                        ++ errorAttributes
                    )
                    (keyIdLabelCouples
                        |> List.map
                            (\( symbol, labelI18n ) ->
                                ( symbol
                                , I18n.translate language labelI18n
                                )
                            )
                        |> List.sortBy (\( symbol, label ) -> label)
                        |> (::) ( "", "" )
                        |> List.map
                            (\( keyId, label ) ->
                                option
                                    [ selected (keyId == model.keyId)
                                    , value keyId
                                    ]
                                    [ text label ]
                            )
                    )
                 ]
                    ++ errorBlock
                )
        ]
            ++ (Values.New.View.viewFormControls model.newValueModel
                    |> List.map (Html.map translateNewValueMsg)
               )
