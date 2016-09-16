module NewGroundArgument exposing (init, Msg, Model, update, view)

import Authenticator.Model
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Requests exposing (newTaskCreateStatement, newTaskRateStatement)
import String
import Task
import Types exposing (convertStatementFormToCustom, DataId, DataIdBody, decodeDataIdBody, initStatementForm,
    StatementCustom(..), StatementForm)
import Views exposing (viewKind, viewLanguageCode, viewName, viewOption, viewRating)


-- MODEL


type alias Model =
    { claimId : String
    , groundId : String
    , rating : Int
    , statementForm : StatementForm
    }


init : Model
init =
    { claimId = ""
    , groundId = ""
    , rating = 0
    , statementForm = initStatementForm
    }


-- UPDATE


type Msg
    = ArgumentCreated DataIdBody
    | ArgumentCreateError Http.Error
    | GroundCreated DataIdBody
    | GroundCreateError Http.Error
    | KindChanged String
    | LanguageCodeChanged String
    | NameInput String
    | ArgumentRated DataIdBody
    | ArgumentRateError Http.Error
    | GroundRated DataIdBody
    | GroundRateError Http.Error
    | RatingChanged Int
    | Submit


update : Msg -> Maybe Authenticator.Model.Authentication -> Model -> ( Model, Cmd Msg, Maybe DataId )
update msg authenticationMaybe model =
    case msg of
        ArgumentCreated body ->
            let
                data = body.data
                cmd =
                    case authenticationMaybe of
                        Just authentication ->
                            Task.perform
                                ArgumentRateError
                                ArgumentRated
                                (newTaskRateStatement authentication model.rating data.id)

                        Nothing ->
                            Cmd.none
            in
                (model, cmd, Just data)

        ArgumentCreateError err ->
            let
                _ = Debug.log "Argument Create Error" err
            in
                (model, Cmd.none, Nothing)

        ArgumentRated body ->
            (model, Cmd.none, Just body.data)

        ArgumentRateError err ->
            let
                _ = Debug.log "Argumenet Rate Error" err
            in
                (model, Cmd.none, Nothing)

        GroundCreated body ->
            let
                data = body.data
                cmd =
                    case authenticationMaybe of
                        Just authentication ->
                            Task.perform
                                GroundRateError
                                GroundRated
                                (newTaskRateStatement authentication 1 data.id)

                        Nothing ->
                            Cmd.none
            in
                ({ model | groundId = data.id }, cmd, Just data)

        GroundCreateError err ->
            let
                _ = Debug.log "Ground Statement Create Error" err
            in
                (model, Cmd.none, Nothing)

        GroundRated body ->
            let
                cmd =
                    case authenticationMaybe of
                        Just authentication ->
                            Task.perform
                                ArgumentCreateError
                                ArgumentCreated
                                (newTaskCreateStatement authentication (ArgumentCustom
                                    { claimId = model.claimId
                                    , groundId = model.groundId
                                    }))

                        Nothing ->
                            Cmd.none
            in
                (model, cmd, Just body.data)

        GroundRateError err ->
            let
                _ = Debug.log "Ground Statement Rate Error" err
            in
                (model, Cmd.none, Nothing)

        KindChanged kind ->
            let
                statementForm = model.statementForm
                statementForm' =
                    { statementForm
                    | kind = kind
                    }
            in
                ({ model | statementForm = statementForm' }, Cmd.none, Nothing)

        LanguageCodeChanged languageCode ->
            let
                statementForm = model.statementForm
                statementForm' =
                    { statementForm
                    | languageCode = languageCode
                    }
            in
                ({ model | statementForm = statementForm' }, Cmd.none, Nothing)

        NameInput name ->
            let
                statementForm = model.statementForm
                statementForm' =
                    { statementForm
                    | name = name
                    }
            in
                ({ model | statementForm = statementForm' }, Cmd.none, Nothing)

        RatingChanged rating ->
            ({ model | rating = rating }, Cmd.none, Nothing)

        Submit ->
            let
                statementForm = model.statementForm
                errorsList = ( List.filterMap (
                    \(name, errorMaybe) ->
                        case errorMaybe of
                            Just error ->
                                Just (name, error)
                            Nothing ->
                                Nothing
                    )
                    [
                        ( "kind"
                        , if String.isEmpty statementForm.kind
                            then Just "Missing type"
                            else Nothing
                        )
                    ,
                        ( "languageCpde"
                        , if  statementForm.kind == "PlainStatement" && String.isEmpty statementForm.languageCode
                            then Just "Missing language"
                            else Nothing
                        )
                    ,
                        ( "name"
                        , if List.member statementForm.kind ["PlainStatement", "Tag"]
                            && String.isEmpty statementForm.name
                            then Just "Missing name"
                            else Nothing
                        )
                    ] )

                cmd =
                    if List.isEmpty errorsList then
                        case authenticationMaybe of
                            Just authentication ->
                                Task.perform
                                    GroundCreateError
                                    GroundCreated
                                    (newTaskCreateStatement
                                        authentication
                                        (convertStatementFormToCustom statementForm))
                            Nothing ->
                                Cmd.none
                    else
                        Cmd.none
                statementForm' =
                    { statementForm
                    | errors = Dict.fromList errorsList
                    }
            in
                ({ model | statementForm = statementForm' }, cmd, Nothing)


-- VIEW


view : Model -> Html Msg
view model =
    let
        statementForm = model.statementForm
    in
        Html.form [ onSubmit Submit ]
            ([ viewRating model.rating (Dict.get "rating" statementForm.errors) RatingChanged
                , viewKind statementForm.kind (Dict.get "kind" statementForm.errors) KindChanged
                ]
            ++
            (case statementForm.kind of
                "PlainStatement" ->
                    [ viewLanguageCode statementForm.languageCode (Dict.get "languageCode" statementForm.errors)
                        LanguageCodeChanged
                    , viewName statementForm.name (Dict.get "name" statementForm.errors) NameInput
                    ]
                "Tag" ->
                    [ viewName statementForm.name (Dict.get "name" statementForm.errors) NameInput
                    ]

                _ ->
                    []
            )
            ++
            [ button
                [ class "btn btn-primary", type' "submit" ]
                [ text "Create" ]
            ])
