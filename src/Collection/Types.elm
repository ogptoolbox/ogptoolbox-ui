module Collection.Types exposing (..)

import Authenticator.Types exposing (Authentication, canEditUserResource)
import Http
import I18n
import Types exposing (..)
import WebData exposing (..)


type alias Model =
    { authentication : Maybe Authentication
    , collection : WebData DataIdBody
    , language : I18n.Language
    }


type ExternalMsg
    = Navigate String


type InternalMsg
    = GotCollection (Result Http.Error DataIdBody)
    | LoadCollection String
    | ShareOnFacebook String
    | ShareOnGooglePlus String
    | ShareOnLinkedIn String
    | ShareOnTwitter String


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
