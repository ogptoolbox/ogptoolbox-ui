module Card.State exposing (..)

import Authenticator.Model
import Card.Types exposing (..)
import Dict exposing (Dict)
import Http
import I18n exposing (getImageUrlOrOgpLogo, getName, getOneString)
import Ports
import Requests
import Routes
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
                    Requests.getCard authentication webData.data.id
                        |> Http.send (ForSelf << GotCard)
            in
                ( newModel, cmd )

        DisplayUseItModal displayUseItModal ->
            ( { model | displayUseItModal = displayUseItModal }
            , Cmd.none
            )

        GotCard response ->
            case response of
                Result.Err err ->
                    let
                        _ =
                            Debug.log "Card.State GotCard Error" err
                    in
                        ( { model | webData = Failure err }, Cmd.none )

                Result.Ok body ->
                    let
                        card =
                            getCard body.data.cards body.data.id

                        newModel =
                            { model | webData = Data (Loaded body) }

                        cmd =
                            Ports.setDocumentMetatags
                                { description =
                                    getOneString language descriptionKeys card body.data.values
                                        |> Maybe.withDefault (I18n.translate language I18n.MissingDescription)
                                , imageUrl =
                                    Routes.fullApiUrl <|
                                        getImageUrlOrOgpLogo language body.data.id body.data.cards body.data.values
                                , title = getName language card body.data.values
                                }
                    in
                        ( newModel, cmd )

        GotProperties response ->
            case response of
                Result.Err err ->
                    let
                        _ =
                            Debug.log "Card.State GotProperties Error" err
                    in
                        ( model, Cmd.none )

                Result.Ok { data } ->
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

        LoadCard cardId ->
            let
                newModel =
                    { model | webData = Data (Loading Nothing) }

                cmd =
                    Requests.getCard authentication cardId
                        |> Http.send (ForSelf << GotCard)
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
                    Requests.getObjectProperties authentication cardId keyId
                        |> Http.send (ForSelf << GotProperties)
            in
                ( newModel, cmd )

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
                    Http.toTask (Requests.postValue authentication selectedField)
                        |> Task.andThen
                            (\dataIdBody ->
                                Http.toTask
                                    (Requests.postProperty
                                        authentication
                                        cardId
                                        keyId
                                        dataIdBody.data.id
                                    )
                            )

                cmd =
                    Task.attempt (ForSelf << PropertyPosted) task
            in
                ( model, cmd )

        PropertyPosted (Result.Err err) ->
            let
                _ =
                    Debug.log "Card.State PropertyPosted Error" err
            in
                ( model, Cmd.none )

        PropertyPosted (Result.Ok { data }) ->
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

        RatingPosted (Result.Err err) ->
            let
                _ =
                    Debug.log "Card.State RatingPosted Error" err
            in
                ( model, Cmd.none )

        RatingPosted (Result.Ok { data }) ->
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

        VotePropertyDown propertyId ->
            let
                cmd =
                    Requests.postRating authentication propertyId -1
                        |> Http.send RatingPosted
                        |> Cmd.map ForSelf
            in
                ( model, cmd )

        VotePropertyUp propertyId ->
            let
                cmd =
                    Requests.postRating authentication propertyId 1
                        |> Http.send RatingPosted
                        |> Cmd.map ForSelf
            in
                ( model, cmd )
