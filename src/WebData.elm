module WebData exposing (..)

import Http


type LoadingStatus a
    = Loading (Maybe a)
    | Loaded a


type WebData a
    = NotAsked
    | Failure Http.Error
    | Data (LoadingStatus a)


getData : WebData a -> Maybe a
getData webData =
    case webData of
        NotAsked ->
            Nothing

        Failure _ ->
            Nothing

        Data loadingStatus ->
            getLoadingStatusData loadingStatus


getLoadingStatusData : LoadingStatus a -> Maybe a
getLoadingStatusData loadingStatus =
    case loadingStatus of
        Loading data ->
            data

        Loaded data ->
            Just data
