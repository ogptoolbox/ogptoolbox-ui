module Properties.KeysAutocomplete.State exposing (..)

import Autocomplete
import Dom
import Http
import I18n
import Process
import Properties.KeysAutocomplete.Types exposing (..)
import Requests
import Task
import Time exposing (..)
import Types exposing (..)


autocompleteToAutocompletion : String -> Model -> Maybe TypedValueAutocompletion
autocompleteToAutocompletion autocomplete model =
    let
        simplified =
            String.toLower <| String.trim autocomplete
    in
        List.filter
            (\autocompletion -> String.toLower autocompletion.autocomplete == simplified)
            model.autocompletions
            |> List.head


idToAutocompletion : String -> Model -> Maybe TypedValueAutocompletion
idToAutocompletion id model =
    List.filter (\autocompletion -> autocompletion.value.id == id) model.autocompletions
        |> List.head


init : List String -> Bool -> Model
init cardTypes showAddOrCreateButton =
    { autocomplete = ""
    , autocompleteMenuState = AutocompleteMenuHidden
    , autocompleter = Autocomplete.empty
    , autocompletions = []
    , cardTypes = cardTypes
    , selected = Nothing
    , showAddOrCreateButton = showAddOrCreateButton
    }


requestToLoadAutocompleteMenu : Model -> ( Model, Cmd Msg )
requestToLoadAutocompleteMenu model =
    case model.autocompleteMenuState of
        AutocompleteMenuHidden ->
            sleepAndThenLoadAutocompleteMenu model

        AutocompleteMenuSleeping ->
            ( model, Cmd.none )

        AutocompleteMenuLoading ->
            ( { model | autocompleteMenuState = AutocompleteMenuSleeping }, Cmd.none )

        AutocompleteMenuVisible ->
            sleepAndThenLoadAutocompleteMenu model


resetAutocompleteMenu : Model -> Model
resetAutocompleteMenu model =
    { model
        | autocompleter = Autocomplete.empty
        , autocompleteMenuState = AutocompleteMenuHidden
    }


setModelFromSelected : Maybe TypedValueAutocompletion -> Model -> Model
setModelFromSelected selected model =
    let
        autocomplete =
            case selected of
                Just selected ->
                    selected.autocomplete

                Nothing ->
                    model.autocomplete
    in
        { model
            | autocomplete = autocomplete
            , selected = selected
        }


setModelFromTypedValueId : String -> Model -> Model
setModelFromTypedValueId id model =
    setModelFromSelected (idToAutocompletion id model) model


sleepAndThenLoadAutocompleteMenu : Model -> ( Model, Cmd Msg )
sleepAndThenLoadAutocompleteMenu model =
    ( { model | autocompleteMenuState = AutocompleteMenuSleeping }
    , Process.sleep (300 * millisecond)
        |> Task.perform (\() -> (ForSelf <| LoadMenu))
    )


subscriptions : Model -> Sub InternalMsg
subscriptions model =
    Sub.map AutocompleteMsg Autocomplete.subscription


update : InternalMsg -> I18n.Language -> String -> Model -> ( Model, Cmd Msg )
update msg language fieldId model =
    case msg of
        AutocompleteMsg childMsg ->
            let
                ( newAutocompleter, newMsgMaybe ) =
                    Autocomplete.update
                        updateAutocompleteConfig
                        childMsg
                        autocompleterSize
                        model.autocompleter
                        model.autocompletions

                newModel =
                    { model | autocompleter = newAutocompleter }
            in
                case newMsgMaybe of
                    Nothing ->
                        ( newModel, Cmd.none )

                    Just newMsg ->
                        update newMsg language fieldId newModel

        Focus ->
            model ! []

        HandleEscape ->
            ( { model | selected = autocompleteToAutocompletion model.autocomplete model }
                |> resetAutocompleteMenu
            , Cmd.none
            )

        KeyboardSelect id ->
            let
                newModel =
                    setModelFromTypedValueId id model
                        |> resetAutocompleteMenu
            in
                newModel ! []

        InputChanged fieldValue ->
            let
                ( newModel, cmd ) =
                    requestToLoadAutocompleteMenu model
            in
                ( { newModel
                    | autocomplete = fieldValue
                    , selected = autocompleteToAutocompletion fieldValue newModel
                  }
                , cmd
                )

        LoadMenu ->
            ( { model | autocompleteMenuState = AutocompleteMenuLoading }
            , Requests.autocompletePropertiesKeys
                Nothing
                language
                model.cardTypes
                model.autocomplete
                autocompleterSize
                |> Http.send (ForSelf << MenuLoaded)
            )

        MenuLoaded (Err httpError) ->
            case model.autocompleteMenuState of
                AutocompleteMenuSleeping ->
                    ( { model | autocompleteMenuState = AutocompleteMenuLoading }
                    , Requests.autocompletePropertiesKeys
                        Nothing
                        language
                        model.cardTypes
                        model.autocomplete
                        autocompleterSize
                        |> Http.send (ForSelf << MenuLoaded)
                    )

                _ ->
                    ( { model | autocompleteMenuState = AutocompleteMenuHidden }, Cmd.none )

        MenuLoaded (Ok typedValuesAutocompletionBody) ->
            ( { model
                | autocompleteMenuState = AutocompleteMenuVisible
                , autocompletions = typedValuesAutocompletionBody.data
              }
            , Cmd.none
            )

        MouseClose ->
            let
                prefix =
                    if String.isEmpty fieldId then
                        fieldId
                    else
                        fieldId ++ "."
            in
                ( { model
                    | autocomplete =
                        case model.selected of
                            Just selected ->
                                selected.autocomplete

                            Nothing ->
                                model.autocomplete
                  }
                    |> resetAutocompleteMenu
                , Task.attempt (\_ -> ForSelf NoOp) (Dom.focus (prefix ++ "autocomplete"))
                )

        MouseOpen ->
            requestToLoadAutocompleteMenu model

        MouseSelect id ->
            let
                prefix =
                    if String.isEmpty fieldId then
                        fieldId
                    else
                        fieldId ++ "."

                newModel =
                    setModelFromTypedValueId id model
                        |> resetAutocompleteMenu
            in
                ( newModel, Task.attempt (\_ -> ForSelf NoOp) (Dom.focus (prefix ++ "autocomplete")) )

        NoOp ->
            model ! []

        Preview id ->
            ( { model | selected = idToAutocompletion id model }
            , Cmd.none
            )

        Reset ->
            ( { model
                | autocompleter = Autocomplete.reset updateAutocompleteConfig model.autocompleter
                , selected = autocompleteToAutocompletion model.autocomplete model
              }
            , Cmd.none
            )

        Wrap toTop ->
            case model.selected of
                Just selected ->
                    update Reset language fieldId model

                Nothing ->
                    let
                        ( autocompleter, selected ) =
                            if toTop then
                                ( Autocomplete.resetToLastItem
                                    updateAutocompleteConfig
                                    model.autocompletions
                                    autocompleterSize
                                    model.autocompleter
                                , List.head <| List.reverse <| model.autocompletions
                                )
                            else
                                ( Autocomplete.resetToFirstItem
                                    updateAutocompleteConfig
                                    model.autocompletions
                                    autocompleterSize
                                    model.autocompleter
                                , List.head <| model.autocompletions
                                )
                    in
                        ( { model
                            | autocompleter = autocompleter
                            , selected = selected
                          }
                        , Cmd.none
                        )


updateAutocompleteConfig : Autocomplete.UpdateConfig InternalMsg TypedValueAutocompletion
updateAutocompleteConfig =
    { getItemId = .value >> .id
    , onFocus = \id -> Just <| Preview id
    , onKeyDown =
        \code maybeId ->
            if code == 38 || code == 40 then
                Maybe.map Preview maybeId
            else if code == 13 then
                Maybe.map KeyboardSelect maybeId
            else
                Just <| Reset
    , onMouseEnter = \id -> Just <| Preview id
    , onMouseClick = \id -> Just <| MouseSelect id
    , onMouseLeave = \_ -> Just <| Preview ""
    , onTooHigh = Just <| Wrap True
    , onTooLow = Just <| Wrap False
    , separateSelections = False
    }
