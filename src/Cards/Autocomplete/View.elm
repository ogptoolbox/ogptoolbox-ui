module Cards.Autocomplete.View exposing (..)

import Autocomplete
import Cards.Autocomplete.Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Aria exposing (..)
import Html.Events exposing (..)
import I18n
import Json.Decode
import Types exposing (CardAutocompletion)
import Views exposing (errorInfos)


viewAutocomplete :
    I18n.Language
    -> String
    -> I18n.TranslationId
    -> I18n.TranslationId
    -> Maybe I18n.TranslationId
    -> Model
    -> Html Msg
viewAutocomplete language parentId controlLabelI18n controlPlaceholderI18n error model =
    let
        controlId =
            if String.isEmpty parentId then
                "autocomplete"
            else
                parentId ++ ".autocomplete"

        controlFindAnother =
            I18n.translate language I18n.FindAnotherCard

        controlFindOne =
            I18n.translate language I18n.FindCard

        controlLabel =
            I18n.translate language controlLabelI18n

        controlPlaceholder =
            I18n.translate language controlPlaceholderI18n

        controlSelectOneOrTypeMoreCharacters =
            I18n.translate language I18n.SelectCardOrTypeMoreCharacters

        controlTitle =
            I18n.translate language I18n.EnterCard

        ( errorClass, errorAttributes, errorBlock ) =
            errorInfos language controlId error

        decodeKeyCode =
            keyCode
                |> Json.Decode.andThen
                    (\code ->
                        if code == 38 || code == 40 then
                            Json.Decode.succeed (ForSelf NoOp)
                        else if code == 27 then
                            Json.Decode.succeed (ForSelf HandleEscape)
                        else
                            Json.Decode.fail "not handling that key"
                    )

        menuId =
            controlId ++ "-menu"

        query =
            case model.selected of
                Just selected ->
                    selected.autocomplete

                Nothing ->
                    model.autocomplete

        showAutocompleteMenu =
            case model.autocompleteMenuState of
                AutocompleteMenuVisible ->
                    True

                _ ->
                    False

        menu =
            if showAutocompleteMenu then
                [ Html.map (ForSelf << AutocompleteMsg)
                    (Autocomplete.view
                        { getItemId = .card >> .id
                        , menuId = menuId
                        , viewItemContent = viewAutocompleteItemContent
                        }
                        autocompleterSize
                        model.autocompleter
                        model.autocompletions
                    )
                ]
            else
                []
    in
        div [ class ("form-group" ++ errorClass) ]
            (List.concat
                [ [ label [ class "control-label", for controlId ] [ text controlLabel ]
                  , div [ class "input-group" ]
                        [ input
                            (List.concat
                                [ [ attribute "aria-autocomplete" "list"
                                  , ariaExpanded <| String.toLower <| toString showAutocompleteMenu
                                  , attribute "aria-haspopup" <| String.toLower <| toString showAutocompleteMenu
                                  , attribute "aria-owns" menuId
                                  , autocomplete False
                                  , class "form-control"
                                  , id controlId
                                  , onFocus (ForSelf Focus)
                                  , onInput (ForSelf << InputChanged)
                                  , onWithOptions
                                        "keydown"
                                        { preventDefault = True, stopPropagation = False }
                                        decodeKeyCode
                                  , placeholder controlPlaceholder
                                  , title controlTitle
                                  , role "combobox"
                                  , type_ "text"
                                  , value query
                                  ]
                                , (case model.selected of
                                    Just selected ->
                                        [ ariaActiveDescendant selected.autocomplete ]

                                    Nothing ->
                                        []
                                  )
                                , errorAttributes
                                ]
                            )
                            []
                        , span [ class "input-group-btn" ]
                            [ (case model.autocompleteMenuState of
                                AutocompleteMenuHidden ->
                                    button
                                        [ class "btn btn-todo-style"
                                        , onWithOptions "click"
                                            { preventDefault = True, stopPropagation = False }
                                            (Json.Decode.succeed (ForSelf MouseOpen))
                                        ]
                                        (case model.selected of
                                            Just selected ->
                                                [ span
                                                    [ ariaHidden True
                                                    , class "fa fa-caret-down fa-fw"
                                                    ]
                                                    []
                                                , span
                                                    [ class "sr-only" ]
                                                    [ text controlFindAnother ]
                                                ]

                                            Nothing ->
                                                [ span
                                                    [ ariaHidden True
                                                    , class "fa fa-caret-down fa-fw"
                                                    ]
                                                    []
                                                , span
                                                    [ class "sr-only" ]
                                                    [ text controlFindOne ]
                                                ]
                                        )

                                AutocompleteMenuVisible ->
                                    button
                                        [ class "active btn btn-todo-style"
                                        , onWithOptions "click"
                                            { preventDefault = True, stopPropagation = False }
                                            (Json.Decode.succeed (ForSelf MouseClose))
                                        ]
                                        [ span
                                            [ ariaHidden True
                                            , class "fa fa-caret-down fa-fw"
                                            ]
                                            []
                                        , span
                                            [ class "sr-only" ]
                                            [ text "Select a person or type more characters" ]
                                        ]

                                _ ->
                                    button
                                        [ class "btn btn-todo-style"
                                        , disabled True
                                        , onWithOptions "click"
                                            { preventDefault = True, stopPropagation = False }
                                            (Json.Decode.succeed (ForSelf NoOp))
                                        ]
                                        [ span [ ariaHidden True, class "fa fa-fw fa-refresh fa-spin" ] []
                                        , span [ class "sr-only" ] [ text <| I18n.translate language I18n.LoadingMenu ]
                                        ]
                              )
                            ]
                        , if model.showAddOrCreateButton then
                            case model.selected of
                                Just selected ->
                                    span [ class "input-group-btn" ]
                                        [ button
                                            [ class "btn btn-success"
                                            , onWithOptions "click"
                                                { preventDefault = True, stopPropagation = False }
                                                (Json.Decode.succeed
                                                    (ForParent (Add selected.card))
                                                )
                                            ]
                                            [ text <| I18n.translate language I18n.Add ]
                                        ]

                                Nothing ->
                                    if String.isEmpty (String.trim model.autocomplete) then
                                        text ""
                                    else
                                        span [ class "input-group-btn" ]
                                            [ button
                                                [ class "btn btn-warning"
                                                , onWithOptions "click"
                                                    { preventDefault = True, stopPropagation = False }
                                                    (Json.Decode.succeed
                                                        (ForParent (Create model.cardTypes model.autocomplete))
                                                    )
                                                ]
                                                [ text <| I18n.translate language I18n.Create ]
                                            ]
                          else
                            text ""
                        ]
                  , span [ class "sr-only" ] [ text <| I18n.translate language I18n.LoadingMenu ]
                  ]
                , menu
                , errorBlock
                ]
            )


viewAutocompleteFieldset :
    I18n.Language
    -> String
    -> I18n.TranslationId
    -> Maybe I18n.TranslationId
    -> Model
    -> Html Msg
viewAutocompleteFieldset language fieldId fieldLabelI18n error model =
    let
        prefix =
            if String.isEmpty fieldId then
                fieldId
            else
                fieldId ++ "."
    in
        fieldset [ class "form-group" ]
            [ legend [] [ text <| I18n.translate language fieldLabelI18n ]
            , viewAutocomplete language fieldId I18n.Card I18n.CardPlaceholder error model
            ]


viewAutocompleteItemContent : CardAutocompletion -> List (Html Never)
viewAutocompleteItemContent cardAutocompletion =
    [ Html.text cardAutocompletion.autocomplete ]
