module Collection.State exposing (..)

import Constants
import I18n exposing (getImageUrlOrOgpLogo, getName)
import Ports
import Requests
import Task
import Collection.Types exposing (..)
import WebData exposing (..)


init : Model
init =
    { collection = NotAsked }


update : InternalMsg -> Model -> I18n.Language -> ( Model, Cmd Msg )
update msg model language =
    case msg of
        LoadCollection collectionId ->
            let
                newModel =
                    { model | collection = Data (Loading Nothing) }

                cmd =
                    Task.perform
                        LoadCollectionError
                        LoadCollectionSuccess
                        (Requests.getCollection collectionId)
                        |> Cmd.map ForSelf
            in
                ( newModel, cmd )

        LoadCollectionError err ->
            let
                _ =
                    Debug.log "Collection.State LoadCollectionError" err

                newModel =
                    { model | collection = Failure err }
            in
                ( newModel, Cmd.none )

        LoadCollectionSuccess body ->
            let
                newModel =
                    { model | collection = Data (Loaded body) }

                cmd =
                    Ports.setDocumentMetatags
                        { title =
                            "Collection"
                            -- TODO i18n
                        , imageUrl = Constants.logoUrl
                        }
            in
                ( newModel, cmd )
