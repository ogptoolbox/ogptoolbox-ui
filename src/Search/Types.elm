module Search.Types exposing (..)

import Http
import Ports
import Types exposing (..)
import WebData exposing (..)


type alias Model =
    { collections : WebData DataIdsBody
    , ogpMode : Bool
    , organizations : WebData DataIdsBody
    , popularTagsData : WebData PopularTagsData
    , selectedTags : List Ports.D3BubblesPopularTag
    , tools : WebData DataIdsBody
    , useCases : WebData DataIdsBody
    }


type ExternalMsg
    = Navigate String


type InternalMsg
    = BubbleDeselect Ports.D3BubblesPopularTag
    | BubbleSelect Ports.D3BubblesPopularTag
    | GotCollections (Result Http.Error DataIdsBody)
    | GotMoreOrganizations (Result Http.Error DataIdsBody)
    | GotMoreTools (Result Http.Error DataIdsBody)
    | GotMoreUseCases (Result Http.Error DataIdsBody)
    | GotOrganizations (Result Http.Error DataIdsBody)
    | GotTagsPopularity (Result Http.Error PopularTagsData)
    | GotTools (Result Http.Error DataIdsBody)
    | GotUseCases (Result Http.Error DataIdsBody)
    | Load
    | LoadMoreOrganizations
    | LoadMoreTools
    | LoadMoreUseCases


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
