module NewStatement exposing (init, Msg, Model, update, view)

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
    StatementForm)
import Views exposing (viewKind, viewLanguageCode, viewName, viewOption)


-- MODEL


type alias Model = StatementForm


init : Model
init = initStatementForm


-- UPDATE


type Msg
    = Created DataIdBody
    | CreateError Http.Error
    | KindChanged String
    | LanguageCodeChanged String
    | NameInput String
    | Rated DataIdBody
    | RateError Http.Error
    | Submit


update : Msg -> Maybe Authenticator.Model.Authentication -> Model -> ( Model, Cmd Msg, Maybe DataId )
update msg authenticationMaybe model =
    case msg of
        Created body ->
            let
                data = body.data
                cmd =
                    case authenticationMaybe of
                        Just authentication ->
                            Task.perform
                                RateError
                                Rated
                                (newTaskRateStatement authentication 1 data.id)

                        Nothing ->
                            Cmd.none
            in
                (model, cmd, Just data)

        CreateError err ->
            let
                _ = Debug.log "New Statement Create Error" err
            in
                (model, Cmd.none, Nothing)

        KindChanged kind ->
            ({ model | kind = kind }, Cmd.none, Nothing)

        LanguageCodeChanged languageCode ->
            ({ model | languageCode = languageCode }, Cmd.none, Nothing)

        NameInput name ->
            ({ model | name = name }, Cmd.none, Nothing)

        Rated body ->
            (model, Cmd.none, Just body.data)

        RateError err ->
            let
                _ = Debug.log "New Statement Rate Error" err
            in
                (model, Cmd.none, Nothing)

        Submit ->
            let
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
                        , if String.isEmpty model.kind
                            then Just "Missing type"
                            else Nothing
                        )
                    ,
                        ( "languageCpde"
                        , if  model.kind == "PlainStatement" && String.isEmpty model.languageCode
                            then Just "Missing language"
                            else Nothing
                        )
                    ,
                        ( "name"
                        , if List.member model.kind ["PlainStatement", "Tag"] && String.isEmpty model.name
                            then Just "Missing name"
                            else Nothing
                        )
                    ] )

                cmd =
                    if List.isEmpty errorsList then
                        case authenticationMaybe of
                            Just authentication ->
                                Task.perform
                                    CreateError
                                    Created
                                    (newTaskCreateStatement
                                        authentication
                                        (convertStatementFormToCustom model))
                            Nothing ->
                                Cmd.none
                    else
                        Cmd.none
            in
                ({ model | errors = Dict.fromList errorsList }, cmd, Nothing)


-- VIEW


view : Model -> Html Msg
view model =
    Html.form [ onSubmit Submit ]
        ([ viewKind model.kind (Dict.get "kind" model.errors) KindChanged ]
        ++
        (case model.kind of
            "Card" ->
                []

            "PlainStatement" ->
                [ viewLanguageCode model.languageCode (Dict.get "languageCode" model.errors) LanguageCodeChanged
                , viewName model.name (Dict.get "name" model.errors) NameInput
                ]

            "Tag" ->
                [ viewName model.name (Dict.get "name" model.errors) NameInput
                ]

            _ ->
                []
        )
        ++
        [ button
            [ class "btn btn-primary", type' "submit" ]
            [ text "Create" ]
        ])
