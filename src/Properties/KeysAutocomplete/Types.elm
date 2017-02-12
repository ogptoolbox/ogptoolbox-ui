module Properties.KeysAutocomplete.Types exposing (..)

import Autocomplete
import Http
import Types exposing (..)


type AutocompleteMenuState
    = AutocompleteMenuHidden
    | AutocompleteMenuSleeping
    | AutocompleteMenuLoading
    | AutocompleteMenuVisible


type ExternalMsg
    = Add TypedValue
    | Create String


type alias Model =
    { autocomplete : String
    , autocompleteMenuState : AutocompleteMenuState
    , autocompleter : Autocomplete.State
    , autocompletions : List TypedValueAutocompletion
    , cardTypes : List String
    , selected : Maybe TypedValueAutocompletion
    , showAddOrCreateButton : Bool
    }


type InternalMsg
    = AutocompleteMsg Autocomplete.Msg
    | Focus
    | HandleEscape
    | InputChanged String
    | KeyboardSelect String
    | LoadMenu
    | MenuLoaded (Result Http.Error TypedValuesAutocompletionBody)
    | MouseClose
    | MouseOpen
    | MouseSelect String
    | NoOp
    | Preview String
    | Reset
    | Wrap Bool


type Msg
    = ForParent ExternalMsg
    | ForSelf InternalMsg


type alias MsgTranslation parentMsg =
    { onAdd : TypedValue -> parentMsg
    , onCreate : String -> parentMsg
    , onInternalMsg : InternalMsg -> parentMsg
    }


type alias MsgTranslator parentMsg =
    Msg -> parentMsg


autocompleterSize : Int
autocompleterSize =
    5


translateMsg : MsgTranslation parentMsg -> MsgTranslator parentMsg
translateMsg { onAdd, onCreate, onInternalMsg } msg =
    case msg of
        ForParent (Add typedValue) ->
            onAdd typedValue

        ForParent (Create keyName) ->
            onCreate keyName

        ForSelf internalMsg ->
            onInternalMsg internalMsg
