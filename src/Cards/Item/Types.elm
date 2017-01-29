module Cards.Item.Types exposing (..)

import Authenticator.Types exposing (Authentication)
import Http
import I18n
import Types exposing (..)
import Values.New.Types


type ExternalMsg
    = Navigate String
    | RequireSignIn InternalMsg


type InternalMsg
    = CloseEditPropertiesModal
    | DisplayUseItModal Bool
    | GotCard (Result Http.Error DataIdBody)
    | GotProperties (Result Http.Error DataIdsBody)
    | LoadCard String
    | NewValueMsg Values.New.Types.InternalMsg
    | LoadProperties String
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
