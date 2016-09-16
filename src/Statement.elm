module Statement exposing (init, InternalMsg, Model, Msg, MsgTranslation, MsgTranslator, translateMsg, update, view)

import Authenticator.Model
import Dict exposing (Dict)
import Html exposing (article, div, hr, Html, li, node, text, ul)
import Html.App
import Html.Attributes exposing (class)
import Http
import Navigation
import NewGroundArgument
import Requests exposing (newTaskDeleteStatementRating, newTaskFlagAbuse, newTaskRateStatement, updateFromDataId)
import Routes exposing (makeUrl)
import Task
import Types exposing (Ballot, DataIdBody, Statement, StatementCustom(..))
import Views exposing (aForPath, viewStatementLine, viewStatementLineBody, viewStatementLinePanel)


-- MODEL


type alias Model =
    { ballotById : Dict String Ballot
    , newGroundArgumentModel : NewGroundArgument.Model
    , statementById : Dict String Statement
    , statementId : String
    , statementIds : List String
    }


init : Model
init =
    { ballotById = Dict.empty
    , newGroundArgumentModel = NewGroundArgument.init
    , statementById = Dict.empty
    , statementId = ""
    , statementIds = []
    }


-- UPDATE


type ExternalMsg
    = Navigate String


type InternalMsg
    = FlagAbuse String
    | FlagAbuseError Http.Error
    | FlaggedAbuse DataIdBody
    | NewGroundArgumentMsg NewGroundArgument.Msg
    | Rated DataIdBody
    | RateError Http.Error
    | RatingChanged (Maybe Int) String


type Msg
    = ForParent ExternalMsg
    | ForSelf InternalMsg


type alias MsgTranslation parentMsg =
    { onInternalMsg : InternalMsg -> parentMsg
    , onNavigate : String -> parentMsg
    }


type alias MsgTranslator parentMsg = Msg -> parentMsg


navigate : String -> Msg
navigate path =
    ForParent (Navigate path)


translateMsg : MsgTranslation parentMsg -> MsgTranslator parentMsg
translateMsg {onInternalMsg, onNavigate} msg =
    case msg of
        ForParent (Navigate path) ->
            onNavigate path

        ForSelf internalMsg ->
            onInternalMsg internalMsg


update : InternalMsg -> Maybe Authenticator.Model.Authentication -> Model -> ( Model, Cmd Msg )
update msg authenticationMaybe model =
    case msg of
        FlagAbuse statementId ->
            let
                cmd =
                    case authenticationMaybe of
                        Just authentication ->
                            Task.perform
                                (\err -> ForSelf (FlagAbuseError err))
                                (\body -> ForSelf (FlaggedAbuse body))
                                (newTaskFlagAbuse authentication statementId)
                        Nothing ->
                            Cmd.none
            in
                (model, cmd)

        FlagAbuseError err ->
            let
                _ = Debug.log "Flag Abuse Error" err
            in
                ( model, Cmd.none )

        FlaggedAbuse body ->
            ( updateFromDataId body.data model, makeUrl ("/statements/" ++ body.data.id) |> Navigation.newUrl )

        NewGroundArgumentMsg childMsg ->
            let
                newGroundArgumentModel = model.newGroundArgumentModel
                newGroundArgumentModel' =
                    { newGroundArgumentModel
                    | claimId = model.statementId
                    }
                (newGroundArgumentModel'', childEffect, dataMaybe) =
                    NewGroundArgument.update childMsg authenticationMaybe newGroundArgumentModel'
                model' = case dataMaybe of
                    Just data ->
                        { model
                        | ballotById = Dict.merge
                            (\id ballot ballotById -> if ballot.deleted
                                then ballotById
                                else Dict.insert id ballot ballotById)
                            (\id leftBallot rightBallot ballotById -> if leftBallot.deleted
                                then ballotById
                                else Dict.insert id leftBallot ballotById)
                            Dict.insert
                            data.ballots
                            model.ballotById
                            Dict.empty
                        , newGroundArgumentModel = newGroundArgumentModel''
                        , statementById = Dict.merge
                            (\id statement statementById -> if statement.deleted
                                then statementById
                                else Dict.insert id statement statementById)
                            (\id leftStatement rightStatement statementById -> if leftStatement.deleted
                                then statementById
                                else Dict.insert id leftStatement statementById)
                            Dict.insert
                            data.statements
                            model.statementById
                            Dict.empty
                        , statementIds = if Dict.member data.id data.statements
                            then if List.member data.id model.statementIds
                                then model.statementIds
                                else data.id :: model.statementIds
                            else
                                -- data.id is not the ID of a statement (but a ballot ID, etc).
                                model.statementIds
                        }
                    Nothing ->
                        { model
                        | newGroundArgumentModel = newGroundArgumentModel''
                        }
            in
                (model', Cmd.map (\msg -> ForSelf (NewGroundArgumentMsg msg)) childEffect)

        Rated body ->
            let
                data = body.data
            in
                ( { model
                    | ballotById = Dict.merge
                        (\id ballot ballotById -> if ballot.deleted
                            then ballotById
                            else Dict.insert id ballot ballotById)
                        (\id leftBallot rightBallot ballotById -> if leftBallot.deleted
                            then ballotById
                            else Dict.insert id leftBallot ballotById)
                        Dict.insert
                        data.ballots
                        model.ballotById
                        Dict.empty
                    , statementById = Dict.merge
                        (\id statement statementById -> if statement.deleted
                            then statementById
                            else Dict.insert id statement statementById)
                        (\id leftStatement rightStatement statementById -> if leftStatement.deleted
                            then statementById
                            else Dict.insert id leftStatement statementById)
                        Dict.insert
                        data.statements
                        model.statementById
                        Dict.empty
                    , statementIds = if Dict.member data.id data.statements
                        then if List.member data.id model.statementIds
                            then model.statementIds
                            else data.id :: model.statementIds
                        else
                            -- data.id is not the ID of a statement (but a ballot ID, etc).
                            model.statementIds
                    }
                , Cmd.none
                )

        RateError err ->
            let
                _ = Debug.log "Existing Statement Rate Error" err
            in
                (model, Cmd.none)

        RatingChanged ratingMaybe statementId ->
            let
                cmd =
                    case authenticationMaybe of
                        Just authentication ->
                            case ratingMaybe of
                                Just rating ->
                                    Task.perform
                                        (\err -> ForSelf (RateError err))
                                        (\body -> ForSelf (Rated body))
                                        (newTaskRateStatement authentication rating statementId)
                                Nothing ->
                                    Task.perform
                                        (\err -> ForSelf (RateError err))
                                        (\body -> ForSelf (Rated body))
                                        (newTaskDeleteStatementRating authentication statementId)
                        Nothing ->
                            Cmd.none
            in
                (model, cmd)


-- VIEW


view : Maybe Authenticator.Model.Authentication -> Model -> Html Msg
view authenticationMaybe model =
    article
        [ class "statement" ]
        [ viewStatementLine
            authenticationMaybe
            div
            model.statementId
            False
            navigate
            (\ratingMaybe statementId -> ForSelf (RatingChanged ratingMaybe statementId))
            (\statementId -> ForSelf (FlagAbuse statementId))
            model
        , hr [] []
        , let
                statementMaybe =
                    Dict.get model.statementId model.statementById
            in
                case statementMaybe of
                    Just statement ->
                        ul
                            [ class "statements-list list-unstyled" ]
                            (List.map
                                (\argumentId ->
                                    let
                                        groundArgumentMaybe = Dict.get argumentId model.statementById
                                    in
                                        case groundArgumentMaybe of
                                            Just groundArgument ->
                                                case groundArgument.custom of
                                                    ArgumentCustom argument ->
                                                        li
                                                            [ class "statement-line" ]
                                                            [ viewStatementLinePanel
                                                                authenticationMaybe
                                                                argumentId
                                                                (\ratingMaybe statementId ->
                                                                    ForSelf (RatingChanged ratingMaybe statementId))
                                                                (\statementId -> ForSelf (FlagAbuse statementId))
                                                                model
                                                            , viewStatementLineBody
                                                                authenticationMaybe
                                                                argument.groundId
                                                                True
                                                                navigate
                                                                model
                                                            ]
                                                    _ ->
                                                        text "Error: Argument is not of type Argument"

                                            Nothing ->
                                                text "Error: Missing argument"
                                    )
                                statement.groundIds)

                    Nothing ->
                        text ""

        , case authenticationMaybe of
            Just authentication ->
                Html.App.map
                    (\msg -> ForSelf (NewGroundArgumentMsg msg))
                    (NewGroundArgument.view model.newGroundArgumentModel)
            Nothing ->
                text ""
        ]
