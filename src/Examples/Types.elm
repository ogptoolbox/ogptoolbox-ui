module Examples.Types exposing (..)

import Http
import Types exposing (..)
import WebData exposing (..)


type Model
    = Examples
        (WebData
            { examples : DataIdsBody
            , organizationsCount : Int
            , toolsCount : Int
            }
        )
    | Example (WebData DataIdBody)


type ExternalMsg
    = Navigate String


type InternalMsg
    = Error Http.Error
    | LoadAll String
    | LoadOne String
    | LoadedAll ( DataIdsBody, DataIdsBody, DataIdsBody )
    | LoadedOne DataIdBody


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
