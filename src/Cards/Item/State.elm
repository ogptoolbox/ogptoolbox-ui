module Cards.Item.State exposing (..)

import Authenticator.Types exposing (Authentication)
import Cards.Item.Types exposing (..)
import Http
import I18n
import Ports
import Properties.KeysAutocomplete.State
import Properties.New.State
import Requests
import Task
import Types exposing (..)
import Urls
import Values.New.State


init : Model
init =
    let
        authentication =
            Nothing

        language =
            I18n.English
    in
        { authentication = authentication
        , cardId = ""
        , data = initData
        , debatedIds = Nothing
        , debatePropertyIds = []
        , displayUseItModal = False
        , editedKeyId = Nothing
        , httpError = Nothing
        , keysAutocompleteModel = Properties.KeysAutocomplete.State.init [] True
        , language = language
        , newDebatePropertyModel = Properties.New.State.init authentication language "" "" []
        , newValueModel = Values.New.State.init authentication language "" []
        , sameKeyPropertyIds = []
        }


validFieldTypes : String -> List String
validFieldTypes keyId =
    case keyId of
        "description" ->
            [ "TextField" ]

        -- "email" ->
        --     [ "InputEmailField" ]
        "license" ->
            [ "TextField" ]

        "location" ->
            [ "TextField" ]

        "logo" ->
            [ "ImageField" ]

        "name" ->
            [ "TextField" ]

        "screenshot" ->
            [ "ImageField" ]

        "tags" ->
            [ "TextField" ]

        "title" ->
            [ "TextField" ]

        "twitter-name" ->
            [ "TextField" ]

        "use-cases" ->
            [ "UseCaseIdField" ]

        "used-by" ->
            [ "OrganizationIdField" ]

        "used-for" ->
            [ "UseCaseIdField" ]

        "uses" ->
            [ "ToolIdField" ]

        "website" ->
            [ "InputUrlField" ]

        _ ->
            -- By default, all field types are valid.
            []


setAuthentication : Maybe Authentication -> Model -> Model
setAuthentication authentication model =
    { model | authentication = authentication }


subscriptions : Model -> Sub InternalMsg
subscriptions model =
    Sub.batch
        [ Sub.map KeysAutocompleteMsg (Properties.KeysAutocomplete.State.subscriptions model.keysAutocompleteModel)
        , Sub.map NewDebatePropertyMsg (Properties.New.State.subscriptions model.newDebatePropertyModel)
        , Sub.map NewValueMsg (Values.New.State.subscriptions model.newValueModel)
        ]


update : InternalMsg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddKey typedValue ->
            update (LoadProperties typedValue.id) model

        CloseDebateModal ->
            ( { model
                | debatedIds = Nothing
                , httpError = Nothing
                , debatePropertyIds = []
              }
            , Requests.getCard model.authentication model.cardId
                |> Http.send (ForSelf << GotCard)
            )

        CloseEditPropertiesModal ->
            ( { model
                | editedKeyId = Nothing
                , httpError = Nothing
                , sameKeyPropertyIds = []
              }
            , Requests.getCard model.authentication model.cardId
                |> Http.send (ForSelf << GotCard)
            )

        CreateKey keyName ->
            case model.authentication of
                Just _ ->
                    ( model
                    , Requests.postValue
                        model.authentication
                        (LocalizedInputTextField (I18n.iso639_1FromLanguage model.language) keyName)
                        |> Http.send (ForSelf << KeyUpserted)
                    )

                Nothing ->
                    ( model
                    , Task.perform
                        (\_ -> ForParent <| RequireSignIn <| CreateKey keyName)
                        (Task.succeed ())
                    )

        DebatePropertyUpserted data ->
            ( { model
                | data = mergeData data model.data
                , debatePropertyIds =
                    if List.member data.id model.debatePropertyIds then
                        model.debatePropertyIds
                    else
                        data.id :: model.debatePropertyIds
              }
            , Cmd.none
            )

        DisplayUseItModal displayUseItModal ->
            ( { model | displayUseItModal = displayUseItModal }
            , Cmd.none
            )

        GotCard (Err httpError) ->
            ( { model
                | httpError = Just httpError
                , keysAutocompleteModel = Properties.KeysAutocomplete.State.init [] True
              }
            , Cmd.none
            )

        GotCard (Ok body) ->
            let
                data =
                    mergeData body.data model.data

                card =
                    getCard data.cards body.data.id

                language =
                    model.language

                cmd =
                    Ports.setDocumentMetadata
                        { description =
                            I18n.getOneString language descriptionKeys card data.values
                                |> Maybe.withDefault (I18n.translate language I18n.MissingDescription)
                        , imageUrl =
                            Urls.imageOrAppLogoFullUrl
                                language
                                card.id
                                data.cards
                                data.values
                        , title = I18n.getName language card data.values
                        }
            in
                ( { model
                    | data = data
                    , keysAutocompleteModel = Properties.KeysAutocomplete.State.init card.subTypeIds True
                  }
                , cmd
                )

        GotDebateProperties (Err httpError) ->
            ( { model | httpError = Just httpError }, Cmd.none )

        GotDebateProperties (Ok body) ->
            ( { model
                | data = mergeData body.data model.data
                , debatePropertyIds = body.data.ids
              }
            , Cmd.none
            )

        GotProperties (Err httpError) ->
            ( { model | httpError = Just httpError }, Cmd.none )

        GotProperties (Ok body) ->
            ( { model
                | data = mergeData body.data model.data
                , sameKeyPropertyIds = body.data.ids
              }
            , Cmd.none
            )

        KeysAutocompleteMsg childMsg ->
            let
                ( keysAutocompleteModel, childCmd ) =
                    Properties.KeysAutocomplete.State.update
                        childMsg
                        model.authentication
                        model.language
                        "keyId"
                        model.keysAutocompleteModel
            in
                ( { model | keysAutocompleteModel = keysAutocompleteModel }
                , Cmd.map translateKeysAutocompleteMsg childCmd
                )

        KeyUpserted (Err httpError) ->
            ( { model | httpError = Just httpError }, Cmd.none )

        KeyUpserted (Ok { data }) ->
            { model | data = mergeData data model.data }
                |> update (LoadProperties data.id)

        LoadCard cardId ->
            ( { model
                | cardId = cardId
                , httpError = Nothing
              }
            , Requests.getCard model.authentication cardId
                |> Http.send (ForSelf << GotCard)
            )

        LoadDebateProperties debatedIds ->
            case model.authentication of
                Just _ ->
                    let
                        debatedId =
                            List.head debatedIds |> Maybe.withDefault model.cardId
                    in
                        ( { model
                            | debatedIds = Just debatedIds
                            , debatePropertyIds = []
                            , httpError = Nothing
                            , newDebatePropertyModel =
                                Properties.New.State.init
                                    model.authentication
                                    model.language
                                    (I18n.iso639_1FromLanguage model.language)
                                    debatedId
                                    [ "TextField" ]
                          }
                        , Requests.getDebateProperties model.authentication debatedId
                            |> Http.send (ForSelf << GotDebateProperties)
                        )

                Nothing ->
                    ( model
                    , Task.perform
                        (\_ -> ForParent <| RequireSignIn <| LoadDebateProperties debatedIds)
                        (Task.succeed ())
                    )

        LoadProperties keyId ->
            case model.authentication of
                Just _ ->
                    ( { model
                        | editedKeyId = Just keyId
                        , httpError = Nothing
                        , newValueModel =
                            Values.New.State.init
                                model.authentication
                                model.language
                                (I18n.iso639_1FromLanguage model.language)
                                (validFieldTypes keyId)
                        , sameKeyPropertyIds = []
                      }
                    , Requests.getObjectProperties model.authentication model.cardId keyId
                        |> Http.send (ForSelf << GotProperties)
                    )

                Nothing ->
                    ( model
                    , Task.perform
                        (\_ -> ForParent <| RequireSignIn <| LoadProperties keyId)
                        (Task.succeed ())
                    )

        NewDebatePropertyMsg childMsg ->
            let
                ( newDebatePropertyModel, childCmd ) =
                    model.newDebatePropertyModel
                        |> Properties.New.State.setContext model.authentication model.language
                        |> Properties.New.State.update childMsg
            in
                ( { model | newDebatePropertyModel = newDebatePropertyModel }
                , Cmd.map translateNewDebatePropertyMsg childCmd
                )

        NewValueMsg childMsg ->
            let
                ( newValueModel, childCmd ) =
                    model.newValueModel
                        |> Values.New.State.setContext model.authentication model.language
                        |> Values.New.State.update childMsg
            in
                ( { model | newValueModel = newValueModel }
                , Cmd.map translateNewValueMsg childCmd
                )

        PropertyUpserted (Err httpError) ->
            ( { model | httpError = Just httpError }, Cmd.none )

        PropertyUpserted (Ok body) ->
            ( { model
                | data = mergeData body.data model.data
                , sameKeyPropertyIds =
                    if List.member body.data.id model.sameKeyPropertyIds then
                        model.sameKeyPropertyIds
                    else
                        body.data.id :: model.sameKeyPropertyIds
              }
            , Cmd.none
            )

        RatingPosted (Err httpError) ->
            ( { model | httpError = Just httpError }, Cmd.none )

        RatingPosted (Ok body) ->
            ( { model
                | data = mergeData body.data model.data
              }
            , Cmd.none
            )

        ShareOnFacebook url ->
            ( model, Ports.shareOnFacebook url )

        ShareOnGooglePlus url ->
            ( model, Ports.shareOnGooglePlus url )

        ShareOnLinkedIn url ->
            ( model, Ports.shareOnLinkedIn url )

        ShareOnTwitter url ->
            ( model, Ports.shareOnTwitter url )

        ValueUpserted data ->
            let
                editedKeyId =
                    case model.editedKeyId of
                        Just editedKeyId ->
                            editedKeyId

                        Nothing ->
                            Debug.crash "Cards.Item.State update ValueUpserted: model.editedKeyId == Nothing"
            in
                ( { model | data = mergeData data model.data }
                , Requests.postProperty model.authentication model.cardId editedKeyId data.id 1
                    |> Http.send (ForSelf << PropertyUpserted)
                )

        VotePropertyDown propertyId ->
            ( model
            , Requests.rateProperty model.authentication propertyId -1
                |> Http.send (ForSelf << RatingPosted)
            )

        VotePropertyUp propertyId ->
            ( model
            , Requests.rateProperty model.authentication propertyId 1
                |> Http.send (ForSelf << RatingPosted)
            )


urlUpdate : Maybe Authentication -> I18n.Language -> String -> Model -> ( Model, Cmd Msg )
urlUpdate authentication language cardId model =
    update (LoadCard cardId)
        { init
            | authentication = authentication
            , language = language
        }
