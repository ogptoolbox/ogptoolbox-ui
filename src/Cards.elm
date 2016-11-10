module Cards exposing (init, InternalMsg, Model, MsgTranslation, MsgTranslator, translateMsg, update, view)

import Authenticator.Model
import Card
import Dict exposing (Dict)
import Hop.Types
import Html exposing (article, h1, Html, li, text, ul)
import Html.Attributes exposing (class)
import Html.App
import Http
import Navigation
import NewCard
import Requests
    exposing
        ( newTaskDeleteCardRating
        , newTaskFlagAbuse
        , newTaskGetCards
        , newTaskRateCard
        , updateFromDataId
        )
import Routes exposing (makeUrl, CardsNestedRoute(..))
import Task
import Types exposing (Ballot, DataId, DataIdBody, DataIdsBody, decodeDataIdsBody, Card, CardCustom(..))
import Views exposing (aForPath, viewNotFound, viewCardLine)


-- MODEL


type alias Model =
    { ballotById : Dict String Ballot
    , loaded :
        Bool
        -- , location : Hop.Types.Location
    , newCardModel : NewCard.Model
    , route : CardsNestedRoute
    , cardModel : Card.Model
    , cardById : Dict String Card
    , cardIds : List String
    }


init : Model
init =
    { ballotById = Dict.empty
    , loaded =
        False
        -- , location = Hop.Types.newLocation
    , newCardModel = NewCard.init
    , route = CardsNotFoundRoute
    , cardModel = Card.init
    , cardById = Dict.empty
    , cardIds = []
    }



-- ROUTING


urlUpdate : ( CardsNestedRoute, Hop.Types.Location ) -> Model -> ( Model, Cmd Msg )
urlUpdate ( route, location ) model =
    let
        model' =
            { model
              -- | location = location
                | route = route
            }
    in
        case route of
            CardRoute cardId ->
                let
                    cardModel =
                        model'.cardModel

                    model'' =
                        { model'
                            | cardModel =
                                { cardModel
                                    | cardId = cardId
                                }
                        }
                in
                    ( model'', load )

            CardsIndexRoute ->
                ( model', load )

            CardsNotFoundRoute ->
                ( model', Cmd.none )



-- UPDATE


type ExternalMsg
    = Navigate String


type InternalMsg
    = Error Http.Error
    | FlagAbuse String
    | FlagAbuseError Http.Error
    | FlaggedAbuse DataIdBody
    | Load
    | Loaded DataIdsBody
    | NewCardMsg NewCard.Msg
    | Rated DataIdBody
    | RateError Http.Error
    | RatingChanged (Maybe Int) String
    | CardMsg Card.InternalMsg


type Msg
    = ForParent ExternalMsg
    | ForSelf InternalMsg


type alias MsgTranslation parentMsg =
    { onInternalMsg : InternalMsg -> parentMsg
    , onNavigate : String -> parentMsg
    }


type alias MsgTranslator parentMsg =
    Msg -> parentMsg


cardMsgTranslation : Card.MsgTranslation Msg
cardMsgTranslation =
    { onInternalMsg = \internalMsg -> ForSelf (CardMsg internalMsg)
    , onNavigate = \path -> ForParent (Navigate path)
    }


load : Cmd Msg
load =
    Task.perform (\_ -> Debug.crash "") (\_ -> ForSelf Load) (Task.succeed "")


navigate : String -> Msg
navigate path =
    ForParent (Navigate path)


translateCardMsg : Card.MsgTranslator Msg
translateCardMsg =
    Card.translateMsg cardMsgTranslation


translateMsg : MsgTranslation parentMsg -> MsgTranslator parentMsg
translateMsg { onInternalMsg, onNavigate } msg =
    case msg of
        ForParent (Navigate path) ->
            onNavigate path

        ForSelf internalMsg ->
            onInternalMsg internalMsg


update : InternalMsg -> Maybe Authenticator.Model.Authentication -> Model -> ( Model, Cmd Msg )
update msg authenticationMaybe model =
    case msg of
        Error err ->
            let
                _ =
                    Debug.log "Cards Error" err
            in
                ( model, Cmd.none )

        FlagAbuse cardId ->
            let
                cmd =
                    case authenticationMaybe of
                        Just authentication ->
                            Task.perform
                                (\err -> ForSelf (FlagAbuseError err))
                                (\body -> ForSelf (FlaggedAbuse body))
                                (newTaskFlagAbuse authentication cardId)

                        Nothing ->
                            Cmd.none
            in
                ( model, cmd )

        FlagAbuseError err ->
            let
                _ =
                    Debug.log "Flag Abuse Error" err
            in
                ( model, Cmd.none )

        FlaggedAbuse body ->
            ( updateFromDataId body.data model, makeUrl ("/cards/" ++ body.data.id) |> Navigation.newUrl )

        Load ->
            let
                cmd =
                    if model.loaded then
                        Cmd.none
                    else
                        Task.perform
                            (\msg -> ForSelf (Error msg))
                            (\msg -> ForSelf (Loaded msg))
                            (newTaskGetCards authenticationMaybe)
            in
                ( model, cmd )

        Loaded body ->
            ( { model
                | ballotById = body.data.ballots
                , loaded = True
                , cardById = body.data.cards
                , cardIds = body.data.ids
              }
            , Cmd.none
            )

        NewCardMsg childMsg ->
            let
                ( newCardModel, childEffect, dataMaybe ) =
                    NewCard.update childMsg authenticationMaybe model.newCardModel

                model' =
                    case dataMaybe of
                        Just data ->
                            updateFromDataId data model

                        Nothing ->
                            model
            in
                ( { model' | newCardModel = newCardModel }
                , Cmd.map (\msg -> ForSelf (NewCardMsg msg)) childEffect
                )

        Rated body ->
            ( updateFromDataId body.data model, Cmd.none )

        RateError err ->
            let
                _ =
                    Debug.log "Existing Card Rate Error" err
            in
                ( model, Cmd.none )

        RatingChanged ratingMaybe cardId ->
            let
                cmd =
                    case authenticationMaybe of
                        Just authentication ->
                            case ratingMaybe of
                                Just rating ->
                                    Task.perform
                                        (\err -> ForSelf (RateError err))
                                        (\body -> ForSelf (Rated body))
                                        (newTaskRateCard authentication rating cardId)

                                Nothing ->
                                    Task.perform
                                        (\err -> ForSelf (RateError err))
                                        (\body -> ForSelf (Rated body))
                                        (newTaskDeleteCardRating authentication cardId)

                        Nothing ->
                            Cmd.none
            in
                ( model, cmd )

        CardMsg childMsg ->
            let
                cardModel =
                    model.cardModel

                cardModel' =
                    { cardModel
                        | ballotById = model.ballotById
                        , cardById = model.cardById
                        , cardIds = model.cardIds
                    }

                ( cardModel'', childEffect ) =
                    Card.update childMsg authenticationMaybe cardModel'

                model' =
                    { model
                        | ballotById = cardModel''.ballotById
                        , cardById = cardModel''.cardById
                        , cardIds = cardModel''.cardIds
                        , cardModel = cardModel''
                    }
            in
                ( model', Cmd.map translateCardMsg childEffect )



-- VIEW


view : Maybe Authenticator.Model.Authentication -> Model -> Html Msg
view authenticationMaybe model =
    case model.route of
        CardRoute cardId ->
            let
                cardModel =
                    model.cardModel

                cardModel' =
                    { cardModel
                        | ballotById = model.ballotById
                        , cardById = model.cardById
                        , cardIds = model.cardIds
                    }
            in
                Html.App.map translateCardMsg (Card.view authenticationMaybe cardModel')

        CardsIndexRoute ->
            article
                [ class "cards" ]
                [ h1 [] [ text "Cards" ]
                , ul
                    [ class "list-unstyled cards-list" ]
                    (List.map
                        (\cardId ->
                            viewCardLine
                                authenticationMaybe
                                li
                                cardId
                                True
                                navigate
                                (\ratingMaybe cardId -> ForSelf (RatingChanged ratingMaybe cardId))
                                (\cardId -> ForSelf (FlagAbuse cardId))
                                model
                        )
                        model.cardIds
                    )
                , case authenticationMaybe of
                    Just authentication ->
                        Html.App.map (\msg -> ForSelf (NewCardMsg msg)) (NewCard.view model.newCardModel)

                    Nothing ->
                        text ""
                ]

        CardsNotFoundRoute ->
            viewNotFound
