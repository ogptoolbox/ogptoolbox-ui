module Cards.Autocomplete.Types exposing (..)

import Autocomplete
import Http
import Types exposing (..)


type AutocompleteMenuState
    = AutocompleteMenuHidden
    | AutocompleteMenuSleeping
    | AutocompleteMenuLoading
    | AutocompleteMenuVisible


type ExternalMsg
    = Add Card
    | Create (List String) String


type alias Model =
    { autocomplete : String
    , autocompleteMenuState : AutocompleteMenuState
    , autocompleter : Autocomplete.State
    , autocompletions : List CardAutocompletion
    , cardTypes : List String
    , selected : Maybe CardAutocompletion
    }


type InternalMsg
    = AutocompleteMsg Autocomplete.Msg
    | Focus
    | HandleEscape
    | InputChanged String
    | KeyboardSelect String
    | LoadMenu
    | MenuLoaded (Result Http.Error CardsAutocompletionBody)
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
    { onAdd : Card -> parentMsg
    , onCreate : List String -> String -> parentMsg
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
        ForParent (Add card) ->
            onAdd card

        ForParent (Create cardTypes cardName) ->
            onCreate cardTypes cardName

        ForSelf internalMsg ->
            onInternalMsg internalMsg
