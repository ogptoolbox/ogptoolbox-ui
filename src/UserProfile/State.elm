module UserProfile.State exposing (..)

import Authenticator.Model
import Constants
import Http
import I18n exposing (getImageUrlOrOgpLogo, getName)
import Ports
import Requests
import UserProfile.Types exposing (..)
import WebData exposing (..)


init : Model
init =
    { collections = NotAsked }


update : InternalMsg -> Model -> Authenticator.Model.Authentication -> I18n.Language -> ( Model, Cmd Msg )
update msg model authentication language =
    case msg of
        GotCollections response ->
            case response of
                Result.Err err ->
                    let
                        _ =
                            Debug.log "UserProfile.State GotCollections Error" err

                        newModel =
                            { model | collections = Failure err }
                    in
                        ( newModel, Cmd.none )

                Result.Ok body ->
                    let
                        newModel =
                            { model | collections = Data (Loaded body) }

                        cmd =
                            Ports.setDocumentMetadata
                                { description = I18n.translate language I18n.UserProfileDescription
                                , imageUrl = Constants.logoUrl
                                , title = authentication.name
                                }
                    in
                        ( newModel, cmd )

        LoadCollections authorId ->
            let
                newModel =
                    { model | collections = Data (Loading Nothing) }

                cmd =
                    Requests.getCollectionsForAuthor authentication
                        |> Http.send (ForSelf << GotCollections)
            in
                ( newModel, cmd )
