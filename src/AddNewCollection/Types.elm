module AddNewCollection.Types exposing (..)

import Http
import Ports
import Types exposing (..)
import WebData exposing (..)


type UploadStatus
    = NotUploaded
    | Selected
    | Read Ports.ImagePortData
    | Uploaded String
    | UploadError Http.Error


type alias AddNewCollectionFields =
    { cardIds : String
    , description : String
    , name : String
    }


type alias Model =
    { editedCollectionId : Maybe String
    , fields : AddNewCollectionFields
    , imageUploadStatus : UploadStatus
    , webData : WebData DataIdBody
    }


type ExternalMsg
    = Navigate String


type InternalMsg
    = ImageSelected
    | ImageRead Ports.ImagePortData
    | ImageUploadError Http.Error
    | ImageUploadSuccess String
    | LoadCollection String
    | LoadCollectionError Http.Error
    | LoadCollectionSuccess DataIdBody
    | PostNewCollection
    | PostNewCollectionError Http.Error
    | PostNewCollectionSuccess DataIdBody
    | SetCardIds String
    | SetDescription String
    | SetName String


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
