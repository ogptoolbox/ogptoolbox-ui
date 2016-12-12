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

                webData =
                    case getData model.webData of
                        Nothing ->
                            Debug.crash "CloseEditPropertiesModal: cannot happen"

                        Just webData ->
                            webData

                cmd =
                    Task.perform
                        LoadCardError
                        LoadCardSuccess
                        (Requests.getCard authentication webData.data.id)
                        |> Cmd.map ForSelf
            in
                ( newModel, cmd )

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
                newEditedProperty =
                    Just
                        { ballots = Dict.empty
                        , cardId = cardId
                        , cards = Dict.empty
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
                                , cards = Dict.union data.cards editedProperty.cards
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

                                newCards =
                                    Dict.union data.cards editedProperty.cards

                                newPropertyIds =
                                    data.id :: editedProperty.propertyIds

                                newProperties =
                                    Dict.union data.properties editedProperty.properties

                                newValues =
                                    Dict.union data.values editedProperty.values
                            in
                                { editedProperty
                                    | ballots = newBallots
                                    , cards = newCards
                                    , properties = newProperties
                                    , propertyIds = newPropertyIds
                                    , selectedField = LocalizedInputTextField (I18n.iso639_1FromLanguage language) ""
                                    , values = newValues
                                }
                        )
                        editedProperty

                webData =
                    case getData model.webData of
                        Nothing ->
                            Debug.crash "SubmitValueSuccess: cannot happen: no webData"

                        Just webData ->
                            webData

                existingData =
                    webData.data

                newData =
                    case editedProperty of
                        Just editedProperty ->
                            let
                                newBallots =
                                    Dict.union data.ballots existingData.ballots

                                newCards =
                                    Dict.union data.cards existingData.cards

                                newProperties =
                                    Dict.union data.properties existingData.properties

                                newValues =
                                    Dict.union data.values existingData.values
                            in
                                { existingData
                                    | ballots = newBallots
                                    , cards = newCards
                                    , properties = newProperties
                                    , values = newValues
                                }

                        Nothing ->
                            Debug.crash "SubmitValueSuccess: cannot happen: no editedProperty"

                newModel =
                    { model
                        | editedProperty = newEditedProperty
                        , webData = Data (Loaded { webData | data = newData })
                    }
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

                                newCards =
                                    Dict.union data.cards editedProperty.cards

                                newProperties =
                                    Dict.union data.properties editedProperty.properties

                                newValues =
                                    Dict.union data.values editedProperty.values
                            in
                                { editedProperty
                                    | ballots = newBallots
                                    , cards = newCards
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
