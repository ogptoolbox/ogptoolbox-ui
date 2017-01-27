module Values.New.Types exposing (..)

import Authenticator.Types exposing (Authentication)
import Cards.Autocomplete.Types
import Dict exposing (Dict)
import Http
import I18n
import Image.Types exposing (..)
import Ports
import Types exposing (..)


type ExternalMsg
    = Navigate String


type alias FormErrors =
    Dict String I18n.TranslationId


type InternalMsg
    = CardsAutocompleteMsg Cards.Autocomplete.Types.InternalMsg
    | Created (Result Http.Error DataIdBody)
    | FieldTypeChanged String
    | ImageRead Ports.ImagePortData
    | ImageSelected
    | ImageUploaded (Result Http.Error String)
    | LanguageChanged String
    | Submit
    | ValueChanged String
    | ValueChecked Bool


type alias Model =
    { authentication : Maybe Authentication
    , booleanValue : Bool
    , cardsAutocompleteModel : Cards.Autocomplete.Types.Model
    , errors : FormErrors
    , field : Maybe Field
    , fieldType : String
    , httpError : Maybe Http.Error
    , imageUploadStatus : ImageUploadStatus
    , language : I18n.Language
    , languageIso639_1 : String
    , value : String
    }


type Msg
    = ForParent ExternalMsg
    | ForSelf InternalMsg


type alias MsgTranslation parentMsg =
    { onInternalMsg : InternalMsg -> parentMsg
    , onNavigate : String -> parentMsg
    }


type alias MsgTranslator parentMsg =
    Msg -> parentMsg


translateCardsAutocompleteMsg : Cards.Autocomplete.Types.MsgTranslator Msg
translateCardsAutocompleteMsg =
    Cards.Autocomplete.Types.translateMsg
        { onInternalMsg = ForSelf << CardsAutocompleteMsg
        , onNavigate = ForParent << Navigate
        }


translateMsg : MsgTranslation parentMsg -> MsgTranslator parentMsg
translateMsg { onInternalMsg, onNavigate } msg =
    case msg of
        ForParent (Navigate path) ->
            onNavigate path

        ForSelf internalMsg ->
            onInternalMsg internalMsg
