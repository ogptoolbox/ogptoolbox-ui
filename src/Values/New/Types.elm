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
    = ValueUpserted DataId


type alias FormErrors =
    Dict String I18n.TranslationId


type InternalMsg
    = AddCard Card
    | CardsAutocompleteMsg Cards.Autocomplete.Types.InternalMsg
    | CreateCard (List String) String
    | FieldTypeChanged String
    | ImageRead Ports.ImagePortData
    | ImageSelected
    | ImageUploaded (Result Http.Error String)
    | LanguageChanged String
    | Submit
    | Upserted (Result Http.Error DataIdBody)
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
    , validFieldTypes : List String
    , value : String
    }


type Msg
    = ForParent ExternalMsg
    | ForSelf InternalMsg


type alias MsgTranslation parentMsg =
    { onInternalMsg : InternalMsg -> parentMsg
    , onValueUpserted : DataId -> parentMsg
    }


type alias MsgTranslator parentMsg =
    Msg -> parentMsg


translateCardsAutocompleteMsg : Cards.Autocomplete.Types.MsgTranslator Msg
translateCardsAutocompleteMsg =
    Cards.Autocomplete.Types.translateMsg
        { onAdd = ForSelf << AddCard
        , onCreate = \cardTypes cardName -> ForSelf <| CreateCard cardTypes cardName
        , onInternalMsg = ForSelf << CardsAutocompleteMsg
        }


translateMsg : MsgTranslation parentMsg -> MsgTranslator parentMsg
translateMsg { onInternalMsg, onValueUpserted } msg =
    case msg of
        ForParent (ValueUpserted data) ->
            onValueUpserted data

        ForSelf internalMsg ->
            onInternalMsg internalMsg
