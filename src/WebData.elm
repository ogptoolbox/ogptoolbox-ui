module WebData exposing (..)

import Http


type LoadingStatus a
    = Loading (Maybe a)
    | Loaded a


type WebData a
    = NotAsked
    | Failure Http.Error
    | Data (LoadingStatus a)


maybeData : WebData a -> Maybe a
maybeData webData =
    case webData of
        NotAsked ->
            Nothing

        Failure _ ->
            Nothing

        Data loadingStatus ->
            case loadingStatus of
                Loading maybeData ->
                    maybeData

                Loaded data ->
                    Just data
