module Search.Types exposing (..)

import Http
import Ports
import Types exposing (..)
import WebData exposing (..)


type alias Model =
    { organizations : WebData DataIdsBody
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
    | Load
    | OrganizationsLoadError Http.Error
    | OrganizationsLoadSuccess DataIdsBody
    | PopularTagsLoadError Http.Error
    | PopularTagsLoadSuccess PopularTagsData
    | ToolsLoadError Http.Error
    | ToolsLoadSuccess DataIdsBody
    | UseCasesLoadError Http.Error
    | UseCasesLoadSuccess DataIdsBody


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
