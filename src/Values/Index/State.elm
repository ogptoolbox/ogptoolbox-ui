module Values.Index.State exposing (..)

import Authenticator.Types exposing (Authentication)
import Dict exposing (Dict)
import Http
import I18n
import Navigation
import Ports
import Requests
import Urls
import Values.Index.Types exposing (..)
import WebData exposing (..)


init : Model
init =
    { authentication = Nothing
    , errors = Dict.empty
    , language = I18n.English
    , searchCriteria =
        { sort = "latest"
        , term = Nothing
        }
    , searchSort = "latest"
    , searchTerm = ""
    , webData = NotAsked
    }


convertControlsToSearchCriteria : Model -> Result FormErrors SearchCriteria
convertControlsToSearchCriteria model =
    let
        errorsList =
            (List.filterMap
                (\( name, errorMaybe ) ->
                    case errorMaybe of
                        Just error ->
                            Just ( name, error )

                        Nothing ->
                            Nothing
                )
                [ ( "searchSort"
                  , if String.isEmpty model.searchSort then
                        Just "Missing sort criteria"
                    else
                        Nothing
                  )
                , ( "searchTerm"
                  , Nothing
                  )
                ]
            )
    in
        if List.isEmpty errorsList then
            Ok
                { sort = model.searchSort
                , term =
                    if String.isEmpty model.searchTerm then
                        Nothing
                    else
                        Just model.searchTerm
                }
        else
            Err (Dict.fromList errorsList)


update : InternalMsg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Found (Err err) ->
            let
                _ =
                    Debug.log "Values.State update Loaded Err" err

                newModel =
                    { model | webData = Failure err }
            in
                ( newModel, Cmd.none )

        Found (Ok body) ->
            ( { model | webData = Data (Loaded body) }
            , Cmd.none
            )

        Search ->
            let
                newModel =
                    { model | webData = Data (Loading (getData model.webData)) }

                cmd =
                    let
                        limit =
                            Just 10
                    in
                        -- TODO: Handle sort order.
                        Requests.getValues
                            model.authentication
                            model.searchCriteria.term
                            limit
                            |> Http.send (ForSelf << Found)
            in
                ( newModel, cmd )

        SearchSortChanged searchSort ->
            ( { model | searchSort = searchSort }, Cmd.none )

        SearchTermChanged searchTerm ->
            ( { model | searchTerm = searchTerm }, Cmd.none )

        Submit ->
            case (convertControlsToSearchCriteria model) of
                Err errors ->
                    ( { model | errors = errors }, Cmd.none )

                Ok searchCriteria ->
                    update
                        Search
                        { model | errors = Dict.empty, searchCriteria = searchCriteria }


urlUpdate : Maybe Authentication -> I18n.Language -> Navigation.Location -> Model -> ( Model, Cmd Msg )
urlUpdate authentication language location model =
    let
        ( newModel, cmd ) =
            update
                Submit
                { init
                    | authentication = authentication
                    , language = language
                    , searchTerm = Urls.querySearchTerm location
                }
    in
        newModel
            ! [ cmd
              , Ports.setDocumentMetadata
                    { description = I18n.translate language I18n.ValuesDescription
                    , imageUrl = Urls.appLogoFullUrl
                    , title = I18n.translate language I18n.Values
                    }
              ]
