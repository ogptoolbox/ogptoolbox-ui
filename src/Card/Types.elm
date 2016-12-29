module Card.Types exposing (..)

import Dict exposing (Dict)
import Http
import Types exposing (..)
import WebData exposing (..)


type alias EditedProperty =
    { ballots : Dict String Ballot
    , cardId : String
    , cards : Dict String Card
    , keyId : String
    , properties : Dict String Property
    , propertyIds : List String
    , selectedField : Field
    , values : Dict String TypedValue
    }


type alias Model =
    { displayUseItModal : Bool
    , editedProperty : Maybe EditedProperty
    , webData : WebData DataIdBody
    }


type ExternalMsg
    = Navigate String


type InternalMsg
    = CloseEditPropertiesModal
    | DisplayUseItModal Bool
    | GotCard (Result Http.Error DataIdBody)
    | GotProperties (Result Http.Error DataIdsBody)
    | LoadCard String
    | LoadProperties String String
    | PropertyPosted (Result Http.Error DataIdBody)
    | RatingPosted (Result Http.Error DataIdBody)
    | SelectField Field
    | ShareOnFacebook String
    | ShareOnGooglePlus String
    | ShareOnLinkedIn String
    | ShareOnTwitter String
    | SubmitValue Field
    | VotePropertyDown String
    | VotePropertyUp String


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
