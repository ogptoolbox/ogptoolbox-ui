module Card.State exposing (..)

import Authenticator.Model
import Card.Types exposing (..)
import Dict exposing (Dict)
import I18n exposing (getImageUrlOrOgpLogo, getName)
import Ports
import Requests
import Task
import Types exposing (..)
import WebData exposing (..)


init : Model
init =
    { displayUseItModal = False
    , editedProperty = Nothing
    , webData = NotAsked
    }


update :
    InternalMsg
    -> Model
    -> Maybe Authenticator.Model.Authentication
    -> I18n.Language
    -> ( Model, Cmd Msg )
update msg ({ editedProperty } as model) authentication language =
    case msg of
        CloseEditPropertiesModal ->
            let
                newModel =
                    { model | editedProperty = Nothing }
            in
                ( newModel, Cmd.none )

        DisplayUseItModal displayUseItModal ->
            ( { model | displayUseItModal = displayUseItModal }
            , Cmd.none
            )

        LoadCard cardId ->
            let
                newModel =
                    { model | webData = Data (Loading Nothing) }

                cmd =
                    Task.perform
                        LoadCardError
                        LoadCardSuccess
                        (Requests.getCard authentication cardId)
                        |> Cmd.map ForSelf
            in
                ( newModel, cmd )

        LoadCardError err ->
            let
                _ =
                    Debug.log "Card.State LoadCardError" err

                newModel =
                    { model | webData = Failure err }
            in
                ( newModel, Cmd.none )

        LoadCardSuccess body ->
            let
                card =
                    getCard body.data.cards body.data.id

                newModel =
                    { model | webData = Data (Loaded body) }

                cmd =
                    Ports.setDocumentMetatags
                        { title = getName language card body.data.values
                        , imageUrl = getImageUrlOrOgpLogo language body.data.id body.data.cards body.data.values
                        }
            in
                ( newModel, cmd )

        LoadProperties cardId keyId ->
            let
                webData =
                    case getData model.webData of
                        Nothing ->
                            Debug.crash "LoadProperties: cannot happen"

                        Just webData ->
                            webData

                newEditedProperty =
                    Just
                        { ballots = Dict.empty
                        , cardId = cardId
                        , keyId = keyId
                        , properties = Dict.empty
                        , propertyIds = []
                        , selectedField = LocalizedInputTextField (I18n.iso639_1FromLanguage language) ""
                        , values = Dict.empty
                        }

                newModel =
                    { model | editedProperty = newEditedProperty }

                cmd =
                    Task.perform
                        LoadPropertiesError
                        LoadPropertiesSuccess
                        (Requests.getObjectProperties authentication cardId keyId)
                        |> Cmd.map ForSelf
            in
                ( newModel, cmd )

        LoadPropertiesError err ->
            let
                _ =
                    Debug.log "Card.State LoadPropertiesError" err
            in
                ( model, Cmd.none )

        LoadPropertiesSuccess { data } ->
            let
                newEditedProperty =
                    Maybe.map
                        (\editedProperty ->
                            { editedProperty
                                | ballots = data.ballots
                                , properties = data.properties
                                , propertyIds = data.ids
                                , values = Dict.union data.values editedProperty.values
                            }
                        )
                        editedProperty

                newModel =
                    { model | editedProperty = newEditedProperty }
            in
                ( newModel, Cmd.none )

        SelectField field ->
            let
                newEditedProperty =
                    Maybe.map
                        (\editedProperty -> { editedProperty | selectedField = field })
                        editedProperty

                newModel =
                    { model | editedProperty = newEditedProperty }
            in
                ( newModel, Cmd.none )

        SubmitValue selectedField ->
            let
                ( cardId, keyId ) =
                    case editedProperty of
                        Nothing ->
                            Debug.crash "SubmitValue: cannot happen"

                        Just { cardId, keyId } ->
                            ( cardId, keyId )

                task =
                    (Requests.postValue authentication selectedField)
                        `Task.andThen`
                            (\dataIdBody ->
                                Requests.postProperty
                                    authentication
                                    cardId
                                    keyId
                                    dataIdBody.data.id
                            )

                cmd =
                    Task.perform SubmitValueError SubmitValueSuccess task
                        |> Cmd.map ForSelf
            in
                ( model, cmd )

        SubmitValueError err ->
            let
                _ =
                    Debug.log "Card.State SubmitValueError" err
            in
                ( model, Cmd.none )

        SubmitValueSuccess { data } ->
            let
                newEditedProperty =
                    Maybe.map
                        (\editedProperty ->
                            let
                                newBallots =
                                    Dict.union data.ballots editedProperty.ballots

                                newPropertyIds =
                                    data.id :: editedProperty.propertyIds

                                newProperties =
                                    Dict.union data.properties editedProperty.properties

                                newValues =
                                    Dict.union data.values editedProperty.values
                            in
                                { editedProperty
                                    | ballots = newBallots
                                    , properties = newProperties
                                    , propertyIds = newPropertyIds
                                    , selectedField = LocalizedInputTextField (I18n.iso639_1FromLanguage language) ""
                                    , values = newValues
                                }
                        )
                        editedProperty

                newModel =
                    { model | editedProperty = newEditedProperty }
            in
                ( newModel, Cmd.none )

        VotePropertyDown propertyId ->
            let
                cmd =
                    Task.perform
                        VotePropertyError
                        VotePropertySuccess
                        (Requests.postRating authentication propertyId -1)
                        |> Cmd.map ForSelf
            in
                ( model, cmd )

        VotePropertyError err ->
            let
                _ =
                    Debug.log "Card.State VotePropertyError" err
            in
                ( model, Cmd.none )

        VotePropertySuccess { data } ->
            let
                newEditedProperty =
                    Maybe.map
                        (\editedProperty ->
                            let
                                newBallots =
                                    Dict.union data.ballots editedProperty.ballots

                                newProperties =
                                    Dict.union data.properties editedProperty.properties

                                newValues =
                                    Dict.union data.values editedProperty.values
                            in
                                { editedProperty
                                    | ballots = newBallots
                                    , properties = newProperties
                                    , values = newValues
                                }
                        )
                        editedProperty

                newModel =
                    { model | editedProperty = newEditedProperty }
            in
                ( newModel, Cmd.none )

        VotePropertyUp propertyId ->
            let
                cmd =
                    Task.perform
                        VotePropertyError
                        VotePropertySuccess
                        (Requests.postRating authentication propertyId 1)
                        |> Cmd.map ForSelf
            in
                ( model, cmd )
