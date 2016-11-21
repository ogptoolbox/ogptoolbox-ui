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
            case loadingStatus of
                Loading getData ->
                    getData

                Loaded data ->
                    Just data
