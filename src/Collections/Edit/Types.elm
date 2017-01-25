module Collections.Edit.Types exposing (..)

import Authenticator.Types exposing (Authentication)
import Cards.Autocomplete.Types
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
    | CardAdded (Result Http.Error DataIdBody)
    | CollectionPosted (Result Http.Error DataIdBody)
    | CreateCard (List String) String
    | GotCollection (Result Http.Error DataIdBody)
    | ImageSelected
    | ImageRead Ports.ImagePortData
    | ImageUploaded (Result Http.Error String)
    | LoadCollection String
    | PostCollection
    | RemoveCard String
    | SetDescription String
    | SetName String
    | ToolsAutocompleteMsg Cards.Autocomplete.Types.InternalMsg
    | UseCasesAutocompleteMsg Cards.Autocomplete.Types.InternalMsg


type alias Model =
    { authentication : Maybe Authentication
    , cardIds : List String
    , collectionJson : Maybe Json.Encode.Value
    , data : DataProxy {}
    , description : String
    , editedCollectionId : Maybe String
    , errors : FormErrors
    , imageUploadStatus : ImageUploadStatus
    , language : I18n.Language
    , name : String
    , toolsAutocompleteModel : Cards.Autocomplete.Types.Model
    , useCasesAutocompleteModel : Cards.Autocomplete.Types.Model
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


translateToolsAutocompleteMsg : Cards.Autocomplete.Types.MsgTranslator Msg
translateToolsAutocompleteMsg =
    Cards.Autocomplete.Types.translateMsg
        { onAdd = ForSelf << AddCard
        , onCreate = \cardTypes cardName -> ForSelf <| CreateCard cardTypes cardName
        , onInternalMsg = ForSelf << ToolsAutocompleteMsg
        }


translateUseCasesAutocompleteMsg : Cards.Autocomplete.Types.MsgTranslator Msg
translateUseCasesAutocompleteMsg =
    Cards.Autocomplete.Types.translateMsg
        { onAdd = ForSelf << AddCard
        , onCreate = \cardTypes cardName -> ForSelf <| CreateCard cardTypes cardName
        , onInternalMsg = ForSelf << UseCasesAutocompleteMsg
        }
