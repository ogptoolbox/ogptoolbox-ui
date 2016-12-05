module AddNew.Types exposing (..)

import Dict exposing (Dict)
import Http
import Ports
import Types exposing (..)


type UploadStatus
    = NotUploaded
    | Uploaded Ports.ImagePortData
    | UploadError Http.Error


type alias Model =
    { error : Maybe Http.Error
    , fields : Dict String String
    , imageUploadStatus : UploadStatus
    }


type ExternalMsg
    = Navigate String


type InternalMsg
    = Error Http.Error
    | SetField String String
    | SubmitFields
    | SubmittedFields DataIdBody
    | ImageSelected
    | ImageRead Ports.ImagePortData
    | ImageUploaded String
    | ImageUploadError Http.Error


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
