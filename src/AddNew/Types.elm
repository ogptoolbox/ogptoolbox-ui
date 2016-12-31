module AddNew.Types exposing (..)

import Dict exposing (Dict)
import Http
import Image.Types exposing (..)
import Ports
import Types exposing (..)


type alias Model =
    { error : Maybe Http.Error
    , fields : Dict String String
    , imageUploadStatus : ImageUploadStatus
    }


type ExternalMsg
    = Navigate String


type InternalMsg
    = CardPosted (Result Http.Error DataIdBody)
    | ImageRead Ports.ImagePortData
    | ImageSelected
    | ImageUploaded (Result Http.Error String)
    | SetField String String
    | SubmitFields


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
