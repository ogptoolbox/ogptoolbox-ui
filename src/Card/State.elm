module Card.State exposing (..)

import Authenticator.Model
import Card.Types exposing (..)
import I18n exposing (getImageUrlOrOgpLogo, getName)
import Ports
import Requests
import Task
import Types exposing (..)
import WebData exposing (..)


init : Model
init =
    NotAsked


update :
    InternalMsg
    -> Model
    -> Maybe Authenticator.Model.Authentication
    -> I18n.Language
    -> ( Model, Cmd Msg )
update msg model authentication language =
    case msg of
        Load cardId ->
            let
                newModel =
                    Data (Loading (getData model))

                cmd =
                    Task.perform
                        LoadError
                        LoadSuccess
                        (Requests.getCard authentication cardId)
                        |> Cmd.map ForSelf
            in
                ( newModel, cmd )

        LoadError err ->
            let
                _ =
                    Debug.log "Card.State Error" err
            in
                ( Failure err, Cmd.none )

        LoadSuccess body ->
            let
                card =
                    getCard body.data.cards body.data.id

                cmd =
                    Ports.setDocumentMetatags
                        { title = getName language card body.data.values
                        , imageUrl = getImageUrlOrOgpLogo language body.data.id body.data.cards body.data.values
                        }
            in
                ( Data (Loaded body), cmd )
