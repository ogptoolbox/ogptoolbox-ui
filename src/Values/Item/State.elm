module Values.Item.State exposing (..)

import Authenticator.Types exposing (Authentication)
import Dict exposing (Dict)
import Http
import I18n
import Navigation
import Ports
import Requests
import Urls
import Values.Item.Types exposing (..)
import WebData exposing (..)


init : Model
init =
    { authentication = Nothing
    , id = ""
    , language = I18n.English
    , webData = NotAsked
    }


update : InternalMsg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Retrieve ->
            let
                newModel =
                    { model | webData = Data (Loading (getData model.webData)) }

                cmd =
                    let
                        limit =
                            Just 10
                    in
                        Requests.getValue
                            model.authentication
                            model.id
                            |> Http.send (ForSelf << Retrieved)
            in
                ( newModel, cmd )

        Retrieved (Err err) ->
            let
                _ =
                    Debug.log "Value.State update Loaded Err" err

                newModel =
                    { model | webData = Failure err }
            in
                ( newModel, Cmd.none )

        Retrieved (Ok body) ->
            let
                data =
                    body.data

                typedValue =
                    Dict.get data.id data.values
            in
                ( { model | webData = Data (Loaded body) }
                , case typedValue of
                    Just value ->
                        -- TODO
                        Ports.setDocumentMetadata
                            { description = I18n.translate model.language I18n.ValuesDescription
                            , imageUrl = Urls.appLogoFullUrl
                            , title = I18n.translate model.language I18n.Values
                            }

                    Nothing ->
                        Cmd.none
                )


urlUpdate : Maybe Authentication -> I18n.Language -> Navigation.Location -> String -> Model -> ( Model, Cmd Msg )
urlUpdate authentication language location id model =
    update Retrieve
        { init
            | authentication = authentication
            , id = id
            , language = language
        }
