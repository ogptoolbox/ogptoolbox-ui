module CollectionEdit.Types exposing (..)

import Authenticator.Types exposing (Authentication)
import CardsAutocomplete.Types
import Dict exposing (Dict)
import Http
import I18n
import Image.Types exposing (..)
import Json.Encode
import Ports
import Types exposing (..)
import WebData exposing (..)


type ExternalMsg
    = Navigate String


type alias FormErrors =
    Dict String I18n.TranslationId


type InternalMsg
    = AddCard Card
    | CollectionPosted (Result Http.Error DataIdBody)
    | CreateCard String
    | GotAddedCard (Result Http.Error DataIdBody)
    | GotCollection (Result Http.Error DataIdBody)
    | ImageSelected
    | ImageRead Ports.ImagePortData
    | ImageUploaded (Result Http.Error String)
    | LoadCollection String
    | PostCollection
    | RemoveCard String
    | SetDescription String
    | SetName String
    | ToolsAutocompleteMsg CardsAutocomplete.Types.InternalMsg
    | UseCasesAutocompleteMsg CardsAutocomplete.Types.InternalMsg


type alias Model =
    { authentication : Maybe Authentication
    , cardIds : List String
    , collectionJson : Maybe Json.Encode.Value
    , data : DataId
    , description : String
    , editedCollectionId : Maybe String
    , errors : FormErrors
    , imageUploadStatus : ImageUploadStatus
    , language : I18n.Language
    , name : String
    , toolsAutocompleteModel : CardsAutocomplete.Types.Model
    , useCasesAutocompleteModel : CardsAutocomplete.Types.Model
    , webData : WebData DataIdBody
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


navigate : String -> Msg
navigate path =
    ForParent (Navigate path)


translateMsg : MsgTranslation parentMsg -> MsgTranslator parentMsg
translateMsg { onInternalMsg, onNavigate } msg =
    case msg of
        ForParent (Navigate path) ->
            onNavigate path

        ForSelf internalMsg ->
            onInternalMsg internalMsg


translateToolsAutocompleteMsg : CardsAutocomplete.Types.MsgTranslator Msg
translateToolsAutocompleteMsg =
    CardsAutocomplete.Types.translateMsg
        { onAdd = ForSelf << AddCard
        , onCreate = ForSelf << CreateCard
        , onInternalMsg = ForSelf << ToolsAutocompleteMsg
        }


translateUseCasesAutocompleteMsg : CardsAutocomplete.Types.MsgTranslator Msg
translateUseCasesAutocompleteMsg =
    CardsAutocomplete.Types.translateMsg
        { onAdd = ForSelf << AddCard
        , onCreate = ForSelf << CreateCard
        , onInternalMsg = ForSelf << UseCasesAutocompleteMsg
        }
