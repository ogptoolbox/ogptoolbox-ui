module Home exposing (..)

import Authenticator.Model
import Dict
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Html.Helpers exposing (aExternal, aForPath, imgForCard)
import Http
import String
import Task
import Types exposing (..)
import Requests exposing (newTaskGetExamples, newTaskGetOrganizations, newTaskGetTools)
import Views exposing (viewWebData)
import WebData exposing (LoadingStatus(..), getData, WebData(..))


-- MODEL


type alias Model =
    { examples : WebData DataIdsBody
    , organizations : WebData DataIdsBody
    , tools : WebData DataIdsBody
    }


init : Model
init =
    { examples = NotAsked
    , organizations = NotAsked
    , tools = NotAsked
    }



-- UPDATE


type ExternalMsg
    = Navigate String


type InternalMsg
    = ErrorExamples Http.Error
    | ErrorOrganizations Http.Error
    | ErrorTools Http.Error
    | Load String
    | LoadedExamples DataIdsBody
    | LoadedOrganizations DataIdsBody
    | LoadedTools DataIdsBody


type Msg
    = ForParent ExternalMsg
    | ForSelf InternalMsg


type alias MsgTranslation parentMsg =
    { onInternalMsg : InternalMsg -> parentMsg
    , onNavigate : String -> parentMsg
    }


type alias MsgTranslator parentMsg =
    Msg -> parentMsg


navigate : String -> Msg
navigate path =
    ForParent (Navigate path)


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
        ErrorExamples err ->
            let
                _ =
                    Debug.log "Home ErrorExamples" err

                model' =
                    { model | examples = Failure err }
            in
                ( model', Cmd.none )

        ErrorOrganizations err ->
            let
                _ =
                    Debug.log "Home ErrorOrganizations" err

                model' =
                    { model | organizations = Failure err }
            in
                ( model', Cmd.none )

        ErrorTools err ->
            let
                _ =
                    Debug.log "Home ErrorTools" err

                model' =
                    { model | tools = Failure err }
            in
                ( model', Cmd.none )

        Load searchQuery ->
            let
                model' =
                    { model
                        | examples = Data (Loading (getData model.examples))
                        , organizations = Data (Loading (getData model.organizations))
                        , tools = Data (Loading (getData model.tools))
                    }

                cmds =
                    List.map (Cmd.map ForSelf)
                        [ Task.perform
                            ErrorExamples
                            LoadedExamples
                            (newTaskGetExamples authenticationMaybe searchQuery "")
                        , Task.perform
                            ErrorOrganizations
                            LoadedOrganizations
                            (newTaskGetOrganizations authenticationMaybe searchQuery "")
                        , Task.perform
                            ErrorTools
                            LoadedTools
                            (newTaskGetTools authenticationMaybe searchQuery "")
                        ]
            in
                model' ! cmds

        LoadedExamples body ->
            ( { model | examples = Data (Loaded body) }
            , Cmd.none
            )

        LoadedOrganizations body ->
            ( { model | organizations = Data (Loaded body) }
            , Cmd.none
            )

        LoadedTools body ->
            ( { model | tools = Data (Loaded body) }
            , Cmd.none
            )



-- VIEW


view : Model -> String -> Html Msg
view model searchQuery =
    let
        viewWebDataFor webData view =
            viewWebData
                (\loadingStatus ->
                    case loadingStatus of
                        Loading maybeStatement ->
                            case maybeStatement of
                                Nothing ->
                                    []

                                Just body ->
                                    [ view searchQuery body.count (Dict.values body.data.statements) ]

                        Loaded body ->
                            [ view searchQuery body.count (Dict.values body.data.statements) ]
                )
                webData
    in
        div []
            ([ viewBanner
             , viewMetrics model
             ]
                ++ (if String.isEmpty searchQuery then
                        []
                    else
                        [ div [ class "row section" ]
                            [ div [ class "container" ]
                                [ h1 [] [ text ("Search results for \"" ++ searchQuery ++ "\"") ] ]
                            ]
                        ]
                   )
                ++ (viewWebDataFor model.examples viewExamples)
                ++ (viewWebDataFor model.tools viewTools)
                ++ (viewWebDataFor model.organizations viewOrganizations)
            )


viewBanner : Html Msg
viewBanner =
    div [ class "banner" ]
        [ div [ class "row " ]
            [ div [ class "carousel slide ", attribute "data-ride" "", id "carousel-example-generic" ]
                [ div [ class "carousel-inner ", attribute "role" "listbox" ]
                    [ div [ class "item active" ]
                        [ div [ class "jumbotron" ]
                            [ div [ class "container" ]
                                [ h1 []
                                    [ text "Find digital tools"
                                    , br []
                                        []
                                    , text "to improve democracy"
                                    ]
                                , a
                                    [ class "btn btn-primary btn-lg"
                                    , attribute "data-slide-to" "1"
                                    , href "#carousel-example-generic"
                                    , attribute "role" "button"
                                    ]
                                    [ text "Start browsing" ]
                                ]
                            ]
                        , div [ class "carousel-caption" ]
                            []
                        ]
                    , div [ class "item text-center" ]
                        [ div [ class "container" ]
                            [ div [ class "row" ]
                                [ div [ class "col-md-12 text-center" ]
                                    [ img [ src "/img/bubbles.png" ]
                                        []
                                    ]
                                ]
                            , div [ class "row filters" ]
                                [ div [ class "col-md-12 text-center" ]
                                    [ text "Showing results suited for                  "
                                    , div [ class "dropdown dropdown-filter dropup" ]
                                        [ a
                                            [ class "btn btn-default dropdown-toggle"
                                            , attribute "data-slide-to" "2"
                                            , href "#carousel-example-generic"
                                            , attribute "role" "button"
                                            ]
                                            [ text "all organizations                      "
                                            , span [ class "caret" ]
                                                []
                                            ]
                                        , ul [ attribute "aria-labelledby" "dropdownMenu1", class "dropdown-menu" ]
                                            [ li []
                                                [ a [ href "#" ]
                                                    [ text "all organizations" ]
                                                ]
                                            , li []
                                                [ a [ href "#" ]
                                                    [ text "Local government" ]
                                                ]
                                            , li []
                                                [ a [ href "#" ]
                                                    [ text "Regional government" ]
                                                ]
                                            ]
                                        ]
                                    , text "and available in                   "
                                    , div [ class "dropdown dropdown-filter dropup" ]
                                        [ a
                                            [ class "btn btn-default dropdown-toggle"
                                            , attribute "data-slide-to" "3"
                                            , href "#carousel-example-generic"
                                            , attribute "role" "button"
                                            ]
                                            [ text "English                      "
                                            , span [ class "caret" ]
                                                []
                                            ]
                                        , ul [ attribute "aria-labelledby" "dropdownMenu1", class "dropdown-menu" ]
                                            [ li []
                                                [ a [ href "#" ]
                                                    [ text "Français" ]
                                                ]
                                            , li []
                                                [ a [ href "#" ]
                                                    [ text "Espanol" ]
                                                ]
                                            , li []
                                                [ a [ href "#" ]
                                                    [ text "Deutsch" ]
                                                ]
                                            , li []
                                                [ a [ href "#" ]
                                                    [ text "Italiano" ]
                                                ]
                                            ]
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    , div [ class "item text-center" ]
                        [ div [ class "container" ]
                            [ div [ class "row form-title" ]
                                [ div [ class "col-md-12 text-center " ]
                                    [ h2 []
                                        [ span [ attribute "aria-hidden" "true", class "glyphicon glyphicon-education" ]
                                            []
                                        , text "Which kind of organization are your intrested in ?"
                                        ]
                                    ]
                                ]
                            , div [ class "row form-content" ]
                                [ div [ class "col-md-3 text-center" ]
                                    [ div [ class "radio" ]
                                        [ label []
                                            [ input
                                                [ attribute "checked" ""
                                                , id "optionsRadios1"
                                                , name "optionsRadios"
                                                , type' "radio"
                                                , value "option1"
                                                ]
                                                []
                                            , text "All organizations                    "
                                            ]
                                        ]
                                    ]
                                , div [ class "col-md-3 text-center" ]
                                    [ div [ class "radio" ]
                                        [ label []
                                            [ input
                                                [ attribute "checked" ""
                                                , id "optionsRadios1"
                                                , name "optionsRadios"
                                                , type' "radio"
                                                , value "option1"
                                                ]
                                                []
                                            , text "Local government                    "
                                            ]
                                        ]
                                    ]
                                , div [ class "col-md-3 text-center" ]
                                    [ div [ class "radio" ]
                                        [ label []
                                            [ input
                                                [ attribute "checked" ""
                                                , id "optionsRadios1"
                                                , name "optionsRadios"
                                                , type' "radio"
                                                , value "option1"
                                                ]
                                                []
                                            , text "Regional government                    "
                                            ]
                                        ]
                                    ]
                                , div [ class "col-md-3 text-center" ]
                                    [ div [ class "radio" ]
                                        [ label []
                                            [ input
                                                [ attribute "checked" ""
                                                , id "optionsRadios1"
                                                , name "optionsRadios"
                                                , type' "radio"
                                                , value "option1"
                                                ]
                                                []
                                            , text "National government                    "
                                            ]
                                        ]
                                    ]
                                , div [ class "col-md-3 text-center" ]
                                    [ div [ class "radio" ]
                                        [ label []
                                            [ input
                                                [ attribute "checked" ""
                                                , id "optionsRadios1"
                                                , name "optionsRadios"
                                                , type' "radio"
                                                , value "option1"
                                                ]
                                                []
                                            , text "Political organization                    "
                                            ]
                                        ]
                                    ]
                                , div [ class "col-md-3 text-center" ]
                                    [ div [ class "radio" ]
                                        [ label []
                                            [ input
                                                [ attribute "checked" ""
                                                , id "optionsRadios1"
                                                , name "optionsRadios"
                                                , type' "radio"
                                                , value "option1"
                                                ]
                                                []
                                            , text "Political movement                    "
                                            ]
                                        ]
                                    ]
                                , div [ class "col-md-3 text-center" ]
                                    [ div [ class "radio" ]
                                        [ label []
                                            [ input
                                                [ attribute "checked" ""
                                                , id "optionsRadios1"
                                                , name "optionsRadios"
                                                , type' "radio"
                                                , value "option1"
                                                ]
                                                []
                                            , text "Non-profit organization                    "
                                            ]
                                        ]
                                    ]
                                , div [ class "col-md-3 text-center" ]
                                    [ div [ class "radio" ]
                                        [ label []
                                            [ input
                                                [ attribute "checked" ""
                                                , id "optionsRadios1"
                                                , name "optionsRadios"
                                                , type' "radio"
                                                , value "option1"
                                                ]
                                                []
                                            , text "For-profit organization                    "
                                            ]
                                        ]
                                    ]
                                ]
                            , div [ class "row" ]
                                [ div [ class "col-md-12 text-center" ]
                                    [ a
                                        [ class "btn btn-primary btn-lg"
                                        , attribute "data-slide-to" "1"
                                        , href "#carousel-example-generic"
                                        , attribute "role" "button"
                                        ]
                                        [ text "Continue" ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                , div [ class "item text-center" ]
                    [ div [ class "container" ]
                        [ div [ class "row form-title" ]
                            [ div [ class "col-md-12 text-center " ]
                                [ h2 []
                                    [ span [ attribute "aria-hidden" "true", class "glyphicon glyphicon-globe" ]
                                        []
                                    , text "Which language do you use ?"
                                    ]
                                ]
                            ]
                        , div [ class "row form-content" ]
                            [ div [ class "col-md-3 text-center" ]
                                [ div [ class "checkbox" ]
                                    [ label []
                                        [ input
                                            [ attribute "checked" ""
                                            , id "optionsRadios1"
                                            , name "optionsRadios"
                                            , type' "checkbox"
                                            , value "option1"
                                            ]
                                            []
                                        , text "English                    "
                                        ]
                                    ]
                                ]
                            ]
                        , div [ class "row" ]
                            [ div [ class "col-md-12 text-center" ]
                                [ a
                                    [ class "btn btn-primary btn-lg"
                                    , attribute "data-slide-to" "1"
                                    , href "#carousel-example-generic"
                                    , attribute "role" "button"
                                    ]
                                    [ text "Continue" ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]


viewExampleThumbnail : Statement -> Card -> Html Msg
viewExampleThumbnail statement card =
    let
        urlPath =
            "/examples/" ++ statement.id
    in
        viewThumbnail urlPath card "example grey"


viewExamples : String -> Int -> List Statement -> Html Msg
viewExamples searchQuery count examples =
    div [ class "row section" ]
        [ div [ class "container" ]
            [ h3 [ class "zone-label" ]
                [ text "Examples" ]
            , div [ class "row" ]
                ((examples
                    |> filterByCardType Example
                    |> List.take 8
                    |> List.map
                        (\statement ->
                            case statement.custom of
                                CardCustom card ->
                                    viewExampleThumbnail statement card
                        )
                 )
                    ++ [ div [ class "col-sm-12 text-center" ]
                            [ aForPath navigate
                                ("/examples?q=" ++ searchQuery)
                                [ class "show-more" ]
                                [ text ("Show all " ++ (toString count))
                                , span [ class "glyphicon glyphicon-menu-down" ]
                                    []
                                ]
                            ]
                       ]
                )
            ]
        ]


viewMetric : WebData DataIdsBody -> Html msg
viewMetric webData =
    text
        (case webData of
            NotAsked ->
                "-"

            Failure _ ->
                "Error"

            Data loadingStatus ->
                case loadingStatus of
                    Loading maybeStatements ->
                        case maybeStatements of
                            Nothing ->
                                ""

                            Just body ->
                                toString body.count

                    Loaded body ->
                        toString body.count
        )


viewMetrics : Model -> Html msg
viewMetrics model =
    div [ class "row metrics" ]
        [ div [ class "container" ]
            [ div [ class "col-xs-4 text-center" ]
                [ span [ class "metric-label" ]
                    [ text "Examples" ]
                , h3 []
                    [ viewMetric model.examples
                    ]
                ]
            , div [ class "col-xs-4 text-center" ]
                [ span [ class "metric-label" ]
                    [ text "Tools" ]
                , h3 []
                    [ viewMetric model.tools
                    ]
                ]
            , div [ class "col-xs-4 text-center" ]
                [ span [ class "metric-label" ]
                    [ text "Organizations" ]
                , h3 []
                    [ viewMetric model.organizations
                    ]
                ]
            ]
        ]


viewOrganizations : String -> Int -> List Statement -> Html Msg
viewOrganizations searchQuery count organizations =
    div [ class "row section" ]
        [ div [ class "container" ]
            [ h3 [ class "zone-label" ]
                [ text "Organizations" ]
            , div [ class "row" ]
                ((organizations
                    |> filterByCardType Organization
                    |> List.take 8
                    |> List.map
                        (\statement ->
                            case statement.custom of
                                CardCustom card ->
                                    viewOrganizationThumbnail statement card
                        )
                 )
                    ++ [ div [ class "col-sm-12 text-center" ]
                            [ aForPath navigate
                                ("/organizations?q=" ++ searchQuery)
                                [ class "show-more" ]
                                [ text ("Show all " ++ (toString count))
                                , span [ class "glyphicon glyphicon-menu-down" ]
                                    []
                                ]
                            ]
                       ]
                )
            ]
        ]


viewOrganizationThumbnail : Statement -> Card -> Html Msg
viewOrganizationThumbnail statement card =
    let
        urlPath =
            "/organizations/" ++ statement.id
    in
        viewThumbnail urlPath card "orga grey"


viewThumbnail : String -> Card -> String -> Html Msg
viewThumbnail urlPath card extraClass =
    div [ class "col-xs-6 col-md-3" ]
        [ div [ class ("thumbnail " ++ extraClass), onClick (navigate urlPath) ]
            [ div [ class "visual" ]
                [ imgForCard [] "218x140" card ]
            , div [ class "caption" ]
                ([ h4 []
                    [ aForPath navigate urlPath [] [ text (getOneString nameKeys card |> Maybe.withDefault "") ] ]
                 , p []
                    (case getOneString descriptionKeys card of
                        Just description ->
                            [ text description ]

                        Nothing ->
                            []
                    )
                 , span [ class "label label-default label-tool" ]
                    [ text "Default" ]
                 , span [ class "label label-default label-tool" ]
                    [ text "Default" ]
                 , span [ class "label label-default label-tool" ]
                    [ text "Default" ]
                 ]
                )
            ]
        ]


viewTools : String -> Int -> List Statement -> Html Msg
viewTools searchQuery count tools =
    div [ class "row section grey" ]
        [ div [ class "container" ]
            [ h3 [ class "zone-label" ]
                [ text "Tools" ]
            , div [ class "row" ]
                ((tools
                    |> filterByCardType Tool
                    |> List.take 8
                    |> List.map
                        (\statement ->
                            case statement.custom of
                                CardCustom card ->
                                    viewToolThumbnail statement card
                        )
                 )
                    ++ [ div [ class "col-sm-12 text-center" ]
                            [ aForPath navigate
                                ("/tools?q=" ++ searchQuery)
                                [ class "show-more" ]
                                [ text ("Show all " ++ (toString count))
                                , span [ class "glyphicon glyphicon-menu-down" ]
                                    []
                                ]
                            ]
                       ]
                )
            ]
        ]


viewToolThumbnail : Statement -> Card -> Html Msg
viewToolThumbnail statement card =
    let
        urlPath =
            "/tools/" ++ statement.id
    in
        viewThumbnail urlPath card "tool"


viewModalTitle : Model -> Html Msg
viewModalTitle model =
    text "Sign up to contribute"
