module Card.Types exposing (..)

import Dict exposing (Dict)
import Http
import Types exposing (..)
import WebData exposing (..)


type alias EditedProperty =
    { ballots : Dict String Ballot
    , cardId : String
    , keyId : String
    , properties : Dict String Property
    , propertyIds : List String
    , selectedField : Field
    , values : Dict String Value
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
    | LoadCard String
    | LoadCardError Http.Error
    | LoadCardSuccess DataIdBody
    | LoadProperties String String
    | LoadPropertiesError Http.Error
    | LoadPropertiesSuccess DataIdsBody
    | SelectField Field
    | SubmitValue Field
    | SubmitValueError Http.Error
    | SubmitValueSuccess DataIdBody
    | VotePropertyDown String
    | VotePropertyError Http.Error
    | VotePropertySuccess DataIdBody
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
