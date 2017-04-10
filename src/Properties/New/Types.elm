module Properties.New.Types exposing (..)

import Authenticator.Types exposing (Authentication)
import Dict exposing (Dict)
import Http
import I18n
import Types exposing (..)
import Values.New.Types


type ExternalMsg
    = PropertyUpserted DataId


type alias FormErrors =
    Dict String I18n.TranslationId


type InternalMsg
    = KeyIdChanged String
    | NewValueMsg Values.New.Types.InternalMsg
    | Submit
    | Upserted (Result Http.Error DataIdBody)
    | ValueUpserted DataId


type alias Model =
    { authentication : Maybe Authentication
    , data : DataId
    , errors : FormErrors
    , httpError : Maybe Http.Error
    , keyId : String
    , language : I18n.Language
    , newValueModel : Values.New.Types.Model
    , objectId : String
    , validFieldTypes : List String
    }


type Msg
    = ForParent ExternalMsg
    | ForSelf InternalMsg


type alias MsgTranslation parentMsg =
    { onInternalMsg : InternalMsg -> parentMsg
    , onPropertyUpserted : DataId -> parentMsg
    }


type alias MsgTranslator parentMsg =
    Msg -> parentMsg


translateMsg : MsgTranslation parentMsg -> MsgTranslator parentMsg
translateMsg { onInternalMsg, onPropertyUpserted } msg =
    case msg of
        ForParent (PropertyUpserted data) ->
            onPropertyUpserted data

        ForSelf internalMsg ->
            onInternalMsg internalMsg


translateNewValueMsg : Values.New.Types.MsgTranslator Msg
translateNewValueMsg =
    Values.New.Types.translateMsg
        { onInternalMsg = ForSelf << NewValueMsg
        , onValueUpserted = ForSelf << ValueUpserted
        }
