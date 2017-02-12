module Cards.Item.Types exposing (..)

import Authenticator.Types exposing (Authentication)
import Http
import I18n
import Properties.KeysAutocomplete.Types
import Types exposing (..)
import Values.New.Types


type ExternalMsg
    = Navigate String
    | RequireSignIn InternalMsg


type InternalMsg
    = AddKey TypedValue
    | CloseEditPropertiesModal
    | CreateKey String
    | DisplayUseItModal Bool
    | GotCard (Result Http.Error DataIdBody)
    | GotProperties (Result Http.Error DataIdsBody)
    | KeyUpserted (Result Http.Error DataIdBody)
    | LoadCard String
    | NewValueMsg Values.New.Types.InternalMsg
    | LoadProperties String
    | KeysAutocompleteMsg Properties.KeysAutocomplete.Types.InternalMsg
    | PropertyUpserted (Result Http.Error DataIdBody)
    | RatingPosted (Result Http.Error DataIdBody)
    | ShareOnFacebook String
    | ShareOnGooglePlus String
    | ShareOnLinkedIn String
    | ShareOnTwitter String
    | ValueUpserted DataId
    | VotePropertyDown String
    | VotePropertyUp String


type alias Model =
    { authentication : Maybe Authentication
    , cardId : String
    , data : DataProxy {}
    , displayUseItModal : Bool
    , editedKeyId : Maybe String
    , httpError : Maybe Http.Error
    , keysAutocompleteModel : Properties.KeysAutocomplete.Types.Model
    , language : I18n.Language
    , newValueModel : Values.New.Types.Model
    , sameKeyPropertyIds : List String
    }


type Msg
    = ForParent ExternalMsg
    | ForSelf InternalMsg


type alias MsgTranslation parentMsg =
    { onInternalMsg : InternalMsg -> parentMsg
    , onNavigate : String -> parentMsg
    , onRequireSignIn : InternalMsg -> parentMsg
    }


type alias MsgTranslator parentMsg =
    Msg -> parentMsg


navigate : String -> Msg
navigate path =
    ForParent (Navigate path)


translateKeysAutocompleteMsg : Properties.KeysAutocomplete.Types.MsgTranslator Msg
translateKeysAutocompleteMsg =
    Properties.KeysAutocomplete.Types.translateMsg
        { onAdd = ForSelf << AddKey
        , onCreate = ForSelf << CreateKey
        , onInternalMsg = ForSelf << KeysAutocompleteMsg
        }


translateMsg : MsgTranslation parentMsg -> MsgTranslator parentMsg
translateMsg { onInternalMsg, onRequireSignIn, onNavigate } msg =
    case msg of
        ForParent (Navigate path) ->
            onNavigate path

        ForParent (RequireSignIn completionMsg) ->
            onRequireSignIn completionMsg

        ForSelf internalMsg ->
            onInternalMsg internalMsg


translateNewValueMsg : Values.New.Types.MsgTranslator Msg
translateNewValueMsg =
    Values.New.Types.translateMsg
        { onInternalMsg = ForSelf << NewValueMsg
        , onValueUpserted = ForSelf << ValueUpserted
        }
