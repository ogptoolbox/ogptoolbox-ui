module Collection.State exposing (..)

import Authenticator.Types exposing (Authentication)
import Collection.Types exposing (..)
import Dict exposing (Dict)
import Http
import I18n
import Ports
import Requests
import Urls
import WebData exposing (..)


init : Model
init =
    { authentication = Nothing
    , language = I18n.English
    , collection = NotAsked
    }


update : InternalMsg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotCollection response ->
            case response of
                Result.Err err ->
                    let
                        _ =
                            Debug.log "Collection.State GotCollection Error" err

                        newModel =
                            { model | collection = Failure err }
                    in
                        ( newModel, Cmd.none )

                Result.Ok body ->
                    let
                        newModel =
                            { model | collection = Data (Loaded body) }

                        collection =
                            case Dict.get body.data.id body.data.collections of
                                Nothing ->
                                    Debug.crash ("Collection not found id=" ++ body.data.id)

                                Just collection ->
                                    collection

                        cmd =
                            Ports.setDocumentMetadata
                                { description = collection.description
                                , imageUrl =
                                    collection.logo |> Maybe.withDefault Urls.appLogoFullUrl
                                , title = collection.name
                                }
                    in
                        ( newModel, cmd )

        LoadCollection collectionId ->
            let
                newModel =
                    { model | collection = Data (Loading Nothing) }

                cmd =
                    Requests.getCollection model.authentication collectionId
                        |> Http.send (ForSelf << GotCollection)
            in
                ( newModel, cmd )

        ShareOnFacebook url ->
            ( model, Ports.shareOnFacebook url )

        ShareOnGooglePlus url ->
            ( model, Ports.shareOnGooglePlus url )

        ShareOnLinkedIn url ->
            ( model, Ports.shareOnLinkedIn url )

        ShareOnTwitter url ->
            ( model, Ports.shareOnTwitter url )


urlUpdate : Maybe Authentication -> I18n.Language -> String -> Model -> ( Model, Cmd Msg )
urlUpdate authentication language collectionId model =
    update
        (LoadCollection collectionId)
        { model
            | authentication = authentication
            , language = language
        }
