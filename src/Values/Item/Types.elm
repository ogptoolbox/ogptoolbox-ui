module Values.Item.Types exposing (..)

import Authenticator.Types exposing (Authentication)
import Http
import I18n
import Types exposing (..)
import WebData exposing (..)


type ExternalMsg
    = Navigate String


type InternalMsg
    = Retrieve
    | Retrieved (Result Http.Error DataIdBody)


type alias Model =
    { authentication : Maybe Authentication
    , id : String
    , language : I18n.Language
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


translateMsg : MsgTranslation parentMsg -> MsgTranslator parentMsg
translateMsg { onInternalMsg, onNavigate } msg =
    case msg of
        ForParent (Navigate path) ->
            onNavigate path

        ForSelf internalMsg ->
            onInternalMsg internalMsg


valueTypeToTypeLabel : I18n.Language -> ValueType -> String
valueTypeToTypeLabel language valueType =
    I18n.translate language <|
        case valueType of
            BijectiveCardReferenceValue _ ->
                I18n.BijectiveCardReference

            BooleanValue _ ->
                I18n.Boolean

            CardIdArrayValue _ ->
                I18n.CardIdArray

            CardIdValue _ ->
                I18n.CardId

            EmailValue _ ->
                I18n.Email

            ImagePathValue _ ->
                I18n.Image

            LocalizedStringValue _ ->
                I18n.LocalizedString

            NumberValue _ ->
                I18n.Number

            StringValue _ ->
                I18n.String

            UrlValue _ ->
                I18n.Url

            ValueIdArrayValue _ ->
                I18n.ValueIdArray

            ValueIdValue _ ->
                I18n.ValueId

            WrongValue _ schemaId ->
                I18n.UnknownSchemaId schemaId
