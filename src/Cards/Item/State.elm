module Cards.Item.State exposing (..)

import Authenticator.Types exposing (Authentication)
import Cards.Item.Types exposing (..)
import Http
import I18n
import Ports
import Requests
import Task
import Types exposing (..)
import Urls
import Values.New.State


init : Model
init =
    { authentication = Nothing
    , cardId = ""
    , data = initData
    , displayUseItModal = False
    , editedKeyId = Nothing
    , httpError = Nothing
    , language = I18n.English
    , newValueModel = Values.New.State.init
    , sameKeyPropertyIds = []
    }


setAuthentication : Maybe Authentication -> Model -> Model
setAuthentication authentication model =
    { model | authentication = authentication }


subscriptions : Model -> Sub InternalMsg
subscriptions model =
    Sub.map NewValueMsg (Values.New.State.subscriptions model.newValueModel)


update : InternalMsg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CloseEditPropertiesModal ->
            ( { model
                | editedKeyId = Nothing
                , httpError = Nothing
                , sameKeyPropertyIds = []
              }
            , Requests.getCard model.authentication model.cardId
                |> Http.send (ForSelf << GotCard)
            )

        DisplayUseItModal displayUseItModal ->
            ( { model | displayUseItModal = displayUseItModal }
            , Cmd.none
            )

        GotCard (Err httpError) ->
            ( { model | httpError = Just httpError }, Cmd.none )

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
                ( { model | data = data }, cmd )

        GotProperties (Err httpError) ->
            ( { model | httpError = Just httpError }, Cmd.none )

        GotProperties (Ok body) ->
            ( { model
                | data = mergeData body.data model.data
                , sameKeyPropertyIds = body.data.ids
              }
            , Cmd.none
            )

        LoadCard cardId ->
            ( { model
                | cardId = cardId
                , httpError = Nothing
              }
            , Requests.getCard model.authentication cardId
                |> Http.send (ForSelf << GotCard)
            )

        LoadProperties keyId ->
            case model.authentication of
                Just _ ->
                    ( { model
                        | editedKeyId = Just keyId
                        , httpError = Nothing
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
                            Debug.crash "Cards.Item.State update ValuePosted: model.editedKeyId == Nothing"
            in
                ( { model | data = mergeData data model.data }
                , Requests.postProperty model.authentication model.cardId editedKeyId data.id
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
