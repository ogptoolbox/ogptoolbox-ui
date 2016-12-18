module Collection.Types exposing (..)

import Http
import Types exposing (..)
import WebData exposing (..)


type alias Model =
    { collection : WebData DataIdBody }


type ExternalMsg
    = Navigate String


type InternalMsg
    = GotCollection (Result Http.Error DataIdBody)
    | LoadCollection String
    | Tweet String


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
