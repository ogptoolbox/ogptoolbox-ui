module Cards.Item.Types exposing (..)

import Authenticator.Types exposing (Authentication)
import Http
import I18n
import Properties.KeysAutocomplete.Types
import Properties.New.Types
import Types exposing (..)
import Values.New.Types


type ExternalMsg
    = Navigate String
    | RequireSignIn InternalMsg


type InternalMsg
    = AddKey TypedValue
    | CloseDebateModal
    | CloseEditPropertiesModal
    | CreateKey String
    | DebatePropertyUpserted DataId
    | DisplayUseItModal Bool
    | GotCard (Result Http.Error DataIdBody)
    | GotDebateProperties (Result Http.Error DataIdsBody)
    | GotProperties (Result Http.Error DataIdsBody)
    | KeyUpserted (Result Http.Error DataIdBody)
    | KeysAutocompleteMsg Properties.KeysAutocomplete.Types.InternalMsg
    | LoadCard String
    | LoadDebateProperties (List String)
    | LoadProperties String
    | NewDebatePropertyMsg Properties.New.Types.InternalMsg
    | NewValueMsg Values.New.Types.InternalMsg
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
    , debatedIds : Maybe (List String)
    , debateKeyId : String
    , debatePropertyIds : List String
    , displayUseItModal : Bool
    , editedKeyId : Maybe String
    , httpError : Maybe Http.Error
    , keysAutocompleteModel : Properties.KeysAutocomplete.Types.Model
    , language : I18n.Language
    , newDebatePropertyModel : Properties.New.Types.Model
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


translateNewDebatePropertyMsg : Properties.New.Types.MsgTranslator Msg
translateNewDebatePropertyMsg =
    Properties.New.Types.translateMsg
        { onInternalMsg = ForSelf << NewDebatePropertyMsg
        , onPropertyUpserted = ForSelf << DebatePropertyUpserted
        }


translateNewValueMsg : Values.New.Types.MsgTranslator Msg
translateNewValueMsg =
    Values.New.Types.translateMsg
        { onInternalMsg = ForSelf << NewValueMsg
        , onValueUpserted = ForSelf << ValueUpserted
        }
