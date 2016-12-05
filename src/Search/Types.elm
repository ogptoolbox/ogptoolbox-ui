module Search.Types exposing (..)

import Http
import Set exposing (Set)
import Types exposing (..)
import WebData exposing (..)


type alias Model =
    { organizations : WebData DataIdsBody
    , popularTags : WebData (List PopularTag)
    , selectedTags : Set String
    , tools : WebData DataIdsBody
    , useCases : WebData DataIdsBody
    }


type ExternalMsg
    = Navigate String


type InternalMsg
    = BubbleDeselect String
    | BubbleSelect String
    | UseCasesLoadSuccess DataIdsBody
    | Load String
    | OrganizationsLoadError Http.Error
    | OrganizationsLoadSuccess DataIdsBody
    | PopularTagsLoadError Http.Error
    | PopularTagsLoadSuccess (List PopularTag)
    | ToolsLoadError Http.Error
    | ToolsLoadSuccess DataIdsBody
    | UseCasesLoadError Http.Error


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
