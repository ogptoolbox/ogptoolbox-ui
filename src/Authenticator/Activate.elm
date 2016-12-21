module Authenticator.Activate exposing (..)

import Authenticator.Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import I18n
import Ports
import Requests
import Task
import Types exposing (..)
import Urls
import WebData exposing (..)


type alias Model =
    WebData Authentication


type ExternalMsg
    = Activate Authentication


type InternalMsg
    = ActivateUser String String
    | ActivationSent (Result Http.Error UserBody)
    | SendActivation Authentication
    | UserActivated (Result Http.Error UserBody)


type Msg
    = ForParent ExternalMsg
    | ForSelf InternalMsg


type alias MsgTranslation parentMsg =
    { onInternalMsg : InternalMsg -> parentMsg
    , onActivate : Authentication -> parentMsg
    }


type alias MsgTranslator parentMsg =
    Msg -> parentMsg



-- navigate : Authentication -> Msg
-- navigate path =
--     ForParent (Navigate path)


init : Model
init =
    NotAsked


translateMsg : MsgTranslation parentMsg -> MsgTranslator parentMsg
translateMsg { onInternalMsg, onActivate } msg =
    case msg of
        ForParent (Activate authentication) ->
            onActivate authentication

        ForSelf internalMsg ->
            onInternalMsg internalMsg


update : InternalMsg -> Model -> I18n.Language -> ( Model, Cmd Msg )
update msg model language =
    case msg of
        ActivateUser userId authorization ->
            let
                newModel =
                    Data (Loading (getData model))

                cmd =
                    Requests.activateUser userId authorization
                        |> Http.send (ForSelf << UserActivated)
            in
                ( newModel, cmd )

        ActivationSent response ->
            case response of
                Result.Err err ->
                    let
                        _ =
                            Debug.log "Authenticator.ActivationSent Error" err
                    in
                        ( model, Cmd.none )

                Result.Ok body ->
                    ( model, Cmd.none )

        SendActivation authentication ->
            let
                cmd =
                    Requests.sendActivation authentication
                        |> Http.send (ForSelf << ActivationSent)
            in
                ( model, cmd )

        UserActivated response ->
            case response of
                Result.Err err ->
                    let
                        _ =
                            Debug.log "Authenticator.UserActivated Error" err
                    in
                        ( Failure err, Cmd.none )

                Result.Ok body ->
                    let
                        user =
                            body.data

                        cmds =
                            [ Ports.setDocumentMetadata
                                { description = I18n.translate language I18n.ActivationDescription
                                , imageUrl = Urls.appLogoFullUrl
                                , title = I18n.translate language I18n.ActivationTitle
                                }
                            , Ports.storeAuthentication (Ports.userToUserForPort (Just user))
                            , ForParent (Activate user)
                                |> (\msg -> Task.perform (\_ -> msg) (Task.succeed ()))
                            ]
                    in
                        Data (Loaded user) ! cmds


view : Model -> I18n.Language -> String -> Html msg
view model language userId =
    let
        i18nMessage =
            case model of
                NotAsked ->
                    I18n.ActivationNotRequested

                Failure _ ->
                    I18n.ActivationFailed

                Data loadingStatus ->
                    case loadingStatus of
                        Loading _ ->
                            I18n.ActivationInProgress

                        Loaded _ ->
                            I18n.ActivationSucceeded
    in
        div []
            [ header []
                [ div [ class "container" ]
                    [ div [ class "intro-text" ]
                        [ div [ class "intro-heading" ]
                            [ text (I18n.translate language I18n.ActivationTitle) ]
                        , div [ class "intro-lead-in" ]
                            [ text (I18n.translate language i18nMessage) ]
                        ]
                    ]
                ]
            ]
