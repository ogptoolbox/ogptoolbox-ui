module Values.New.State exposing (..)

import Authenticator.Types exposing (Authentication)
import Cards.Autocomplete.State
import Constants exposing (cardTypesForOrganization, cardTypesForTool, cardTypesForUseCase)
import Dict exposing (Dict)
import Http
import Http.Error
import I18n
import Image.Types exposing (..)
import Navigation
import Ports
import Requests
import Task
import Types exposing (Field(..))
import Urls
import Values.New.Types exposing (..)


init : Maybe Authentication -> I18n.Language -> String -> List String -> Model
init authentication language languageIso639_1 validFieldTypes =
    let
        fieldType =
            case List.head validFieldTypes of
                Just firstFieldType ->
                    if List.member "TextField" validFieldTypes then
                        "TextField"
                    else
                        firstFieldType

                Nothing ->
                    "TextField"

        cardTypes =
            case fieldType of
                "OrganizationIdField" ->
                    cardTypesForOrganization

                "ToolIdField" ->
                    cardTypesForTool

                "UseCaseIdField" ->
                    cardTypesForUseCase

                _ ->
                    cardTypesForTool
    in
        { authentication = authentication
        , booleanValue = False
        , cardsAutocompleteModel = Cards.Autocomplete.State.init cardTypes False
        , errors = Dict.empty
        , field = Nothing
        , fieldType = fieldType
        , httpError = Nothing
        , imageUploadStatus = ImageNotUploadedStatus
        , language = language
        , languageIso639_1 = languageIso639_1
        , validFieldTypes = validFieldTypes
        , value = ""
        }


convertControls : Model -> Model
convertControls model =
    let
        language =
            model.language

        ( field, errorsList ) =
            case model.fieldType of
                "" ->
                    ( Nothing
                    , [ ( "fieldType", Just I18n.MissingValue ) ]
                    )

                "BooleanField" ->
                    ( Just (BooleanField model.booleanValue)
                    , []
                    )

                "ImageField" ->
                    case model.imageUploadStatus of
                        ImageNotUploadedStatus ->
                            ( Nothing
                            , [ ( "new-image", Just I18n.UploadImage ) ]
                            )

                        ImageSelectedStatus ->
                            ( Nothing
                            , [ ( "new-image", Just I18n.ReadingSelectedImage ) ]
                            )

                        ImageReadStatus { contents, filename } ->
                            ( Nothing
                            , [ ( "new-image", Just (I18n.UploadingImage filename) ) ]
                            )

                        ImageUploadedStatus path ->
                            ( Just (ImageField path)
                            , []
                            )

                        ImageUploadErrorStatus httpError ->
                            ( Nothing
                            , [ ( "new-image", Just (I18n.ImageUploadError (Http.Error.toString language httpError)) ) ]
                            )

                "InputEmailField" ->
                    case String.trim model.value of
                        "" ->
                            ( Nothing
                            , [ ( "value", Just I18n.MissingValue ) ]
                            )

                        email ->
                            ( Just (InputEmailField email)
                            , []
                            )

                "InputNumberField" ->
                    case String.trim model.value of
                        "" ->
                            ( Nothing
                            , [ ( "value", Just I18n.MissingValue ) ]
                            )

                        value ->
                            case String.toFloat value of
                                Err _ ->
                                    ( Nothing
                                    , [ ( "value", Just I18n.InvalidNumber ) ]
                                    )

                                Ok number ->
                                    ( Just (InputNumberField number)
                                    , []
                                    )

                "InputUrlField" ->
                    case String.trim model.value of
                        "" ->
                            ( Nothing
                            , [ ( "value", Just I18n.MissingValue ) ]
                            )

                        url ->
                            ( Just (InputUrlField url)
                            , []
                            )

                "OrganizationIdField" ->
                    let
                        cardAutocompletion =
                            model.cardsAutocompleteModel.selected
                    in
                        case cardAutocompletion of
                            Just cardAutocompletion ->
                                ( Just (CardIdField cardAutocompletion.card.id)
                                , []
                                )

                            Nothing ->
                                ( Nothing
                                , [ ( "cardId", Just I18n.MissingValue ) ]
                                )

                "TextField" ->
                    let
                        ( languageIso639_1, languageError ) =
                            if String.isEmpty model.languageIso639_1 then
                                ( Just "", Nothing )
                            else
                                case I18n.languageFromIso639_1 model.languageIso639_1 of
                                    Just _ ->
                                        ( Just model.languageIso639_1, Nothing )

                                    Nothing ->
                                        ( Nothing, Just I18n.UnknownLanguage )

                        ( value, valueError ) =
                            -- if String.isEmpty model.value then
                            --     ( Nothing, Just I18n.MissingValue )
                            -- else
                            ( Just model.value, Nothing )
                    in
                        case ( languageIso639_1, value ) of
                            ( Just "", Just value ) ->
                                if String.contains "\n" value || String.contains "\x0D" value then
                                    ( Just (TextareaField value), [] )
                                else
                                    ( Just (InputTextField value), [] )

                            ( Just languageIso639_1, Just value ) ->
                                if String.contains "\n" value || String.contains "\x0D" value then
                                    ( Just (LocalizedTextareaField languageIso639_1 value), [] )
                                else
                                    ( Just (LocalizedInputTextField languageIso639_1 value), [] )

                            _ ->
                                ( Nothing
                                , [ ( "language", languageError )
                                  , ( "value", valueError )
                                  ]
                                )

                "ToolIdField" ->
                    let
                        cardAutocompletion =
                            model.cardsAutocompleteModel.selected
                    in
                        case cardAutocompletion of
                            Just cardAutocompletion ->
                                ( Just (CardIdField cardAutocompletion.card.id)
                                , []
                                )

                            Nothing ->
                                ( Nothing
                                , [ ( "cardId", Just I18n.MissingValue ) ]
                                )

                "UseCaseIdField" ->
                    let
                        cardAutocompletion =
                            model.cardsAutocompleteModel.selected
                    in
                        case cardAutocompletion of
                            Just cardAutocompletion ->
                                ( Just (CardIdField cardAutocompletion.card.id)
                                , []
                                )

                            Nothing ->
                                ( Nothing
                                , [ ( "cardId", Just I18n.MissingValue ) ]
                                )

                _ ->
                    ( Nothing
                    , [ ( "fieldType", Just I18n.UnknownValue ) ]
                    )
    in
        { model
            | errors =
                case field of
                    Just _ ->
                        Dict.empty

                    Nothing ->
                        (Dict.fromList <|
                            List.filterMap
                                (\( key, errorMaybe ) ->
                                    case errorMaybe of
                                        Just error ->
                                            Just ( key, error )

                                        Nothing ->
                                            Nothing
                                )
                                errorsList
                        )
            , field = field
        }


setContext : Maybe Authentication -> I18n.Language -> Model -> Model
setContext authentication language model =
    { model
        | authentication = authentication
        , language = language
    }


subscriptions : Model -> Sub InternalMsg
subscriptions model =
    Sub.batch
        [ Sub.map CardsAutocompleteMsg (Cards.Autocomplete.State.subscriptions model.cardsAutocompleteModel)
        , Ports.fileContentRead ImageRead
        ]


update : InternalMsg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddCard _ ->
            -- Add button is disabled in cards autocomplete => This message should not occur.
            ( model, Cmd.none )

        CardsAutocompleteMsg childMsg ->
            let
                ( cardsAutocompleteModel, childCmd ) =
                    Cards.Autocomplete.State.update
                        childMsg
                        model.authentication
                        model.language
                        "cardId"
                        model.cardsAutocompleteModel
            in
                ( convertControls { model | cardsAutocompleteModel = cardsAutocompleteModel }
                , Cmd.map translateCardsAutocompleteMsg childCmd
                )

        CreateCard _ _ ->
            -- Create button is disabled in cards autocomplete => This message should not occur.
            ( model, Cmd.none )

        FieldTypeChanged fieldType ->
            ( convertControls
                { model
                    | cardsAutocompleteModel =
                        case fieldType of
                            "OrganizationIdField" ->
                                Cards.Autocomplete.State.init cardTypesForOrganization False

                            "ToolIdField" ->
                                Cards.Autocomplete.State.init cardTypesForTool False

                            "UseCaseIdField" ->
                                Cards.Autocomplete.State.init cardTypesForUseCase False

                            _ ->
                                model.cardsAutocompleteModel
                    , fieldType = fieldType
                }
            , Cmd.none
            )

        ImageRead data ->
            let
                newModel =
                    convertControls { model | imageUploadStatus = ImageReadStatus data }

                -- Ensure that image is uploaded only once, although port "fileContentRead" is sent to every image
                -- editor.
                cmd =
                    case model.imageUploadStatus of
                        ImageNotUploadedStatus ->
                            Cmd.none

                        ImageSelectedStatus ->
                            Requests.postUploadImage newModel.authentication data.contents
                                |> Http.send ImageUploaded
                                |> Cmd.map ForSelf

                        ImageReadStatus _ ->
                            Cmd.none

                        ImageUploadedStatus _ ->
                            Cmd.none

                        ImageUploadErrorStatus _ ->
                            Cmd.none
            in
                ( newModel, cmd )

        ImageSelected ->
            ( convertControls { model | imageUploadStatus = ImageSelectedStatus }
            , Ports.fileSelected "new-image"
            )

        ImageUploaded (Err err) ->
            ( convertControls { model | imageUploadStatus = ImageUploadErrorStatus err }, Cmd.none )

        ImageUploaded (Ok path) ->
            ( convertControls { model | imageUploadStatus = ImageUploadedStatus path }
            , Cmd.none
            )

        LanguageChanged languageIso639_1 ->
            ( convertControls { model | languageIso639_1 = languageIso639_1 }
            , Cmd.none
            )

        Submit ->
            let
                newModel =
                    convertControls model
            in
                ( newModel
                , case newModel.field of
                    Just field ->
                        Requests.postValue
                            model.authentication
                            field
                            |> Http.send (ForSelf << Upserted)

                    Nothing ->
                        Cmd.none
                )

        Upserted (Err httpError) ->
            ( { model | httpError = Just httpError }, Cmd.none )

        Upserted (Ok body) ->
            let
                initedModel =
                    init model.authentication model.language model.languageIso639_1 model.validFieldTypes
            in
                ( { initedModel | fieldType = model.fieldType }
                , Task.perform (\_ -> ForParent <| ValueUpserted body.data) (Task.succeed ())
                )

        ValueChanged value ->
            ( convertControls { model | value = value }
            , Cmd.none
            )

        ValueChecked booleanValue ->
            ( convertControls { model | booleanValue = booleanValue }
            , Cmd.none
            )


urlUpdate : Maybe Authentication -> I18n.Language -> Navigation.Location -> Model -> ( Model, Cmd Msg )
urlUpdate authentication language location model =
    ( init authentication language (I18n.iso639_1FromLanguage language) model.validFieldTypes
    , Ports.setDocumentMetadata
        { description = I18n.translate language I18n.NewValueDescription
        , imageUrl = Urls.appLogoFullUrl
        , title = I18n.translate language I18n.NewValue
        }
    )
