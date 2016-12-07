module UserProfile.Types exposing (..)

import Http
import Types exposing (..)
import WebData exposing (..)


type alias Model =
    { collections : WebData DataIdsBody }


type ExternalMsg
    = Navigate String


type InternalMsg
    = LoadCollections String
    | LoadCollectionsError Http.Error
    | LoadCollectionsSuccess DataIdsBody


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
