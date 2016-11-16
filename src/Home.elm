module Home exposing (..)

import Authenticator.Model
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http
import String
import Task
import Types exposing (Card, Statement, StatementCustom(..))
import Requests exposing (newTaskGetExamples, newTaskGetOrganizations, newTaskGetTools)
import Views exposing (aForPath, viewWebData)
import WebData exposing (LoadingStatus(..), maybeData, WebData(..))


-- MODEL


type alias Model =
    { examples : WebData (List Statement)
    , organizations : WebData (List Statement)
    , tools : WebData (List Statement)
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
    | LoadedExamples (List Statement)
    | LoadedOrganizations (List Statement)
    | LoadedTools (List Statement)


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
                        | examples = Data (Loading (maybeData model.examples))
                        , organizations = Data (Loading (maybeData model.organizations))
                        , tools = Data (Loading (maybeData model.tools))
                    }

                cmds =
                    List.map (Cmd.map ForSelf)
                        [ Task.perform
                            ErrorExamples
                            LoadedExamples
                            (newTaskGetExamples authenticationMaybe searchQuery)
                        , Task.perform
                            ErrorOrganizations
                            LoadedOrganizations
                            (newTaskGetOrganizations authenticationMaybe searchQuery)
                        , Task.perform
                            ErrorTools
                            LoadedTools
                            (newTaskGetTools authenticationMaybe searchQuery)
                        ]
            in
                model' ! cmds

        LoadedExamples statements ->
            ( { model | examples = Data (Loaded statements) }
            , Cmd.none
            )

        LoadedOrganizations statements ->
            ( { model | organizations = Data (Loaded statements) }
            , Cmd.none
            )

        LoadedTools statements ->
            ( { model | tools = Data (Loaded statements) }
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

                                Just data ->
                                    [ view searchQuery data ]

                        Loaded data ->
                            [ view searchQuery data ]
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
                                    [ img [ src "img/bubbles.png" ]
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
        url =
            "/examples/" ++ statement.id
    in
        viewThumbnail url card "example grey"


viewExamples : String -> List Statement -> Html Msg
viewExamples searchQuery examples =
    div [ class "row section" ]
        [ div [ class "container" ]
            [ h3 [ class "zone-label" ]
                [ text "Examples" ]
            , div [ class "row" ]
                ((examples
                    |> List.take 8
                    |> List.map
                        (\statement ->
                            case statement.custom of
                                CardCustom card ->
                                    viewExampleThumbnail statement card

                                _ ->
                                    Debug.crash "Unexpected statement.custom type"
                        )
                 )
                    ++ [ div [ class "col-sm-12 text-center" ]
                            [ aForPath navigate
                                ("/examples?q=" ++ searchQuery)
                                [ class "show-more" ]
                                [ text "Show all 398"
                                , span [ class "glyphicon glyphicon-menu-down" ]
                                    []
                                ]
                            ]
                       ]
                )
            ]
        ]


viewMetric : WebData (List Statement) -> Html msg
viewMetric webData =
    text <|
        case webData of
            NotAsked ->
                ""

            Failure _ ->
                "Error"

            Data loadingStatus ->
                case loadingStatus of
                    Loading maybeStatements ->
                        case maybeStatements of
                            Nothing ->
                                ""

                            Just statements ->
                                toString (List.length statements)

                    Loaded statements ->
                        toString (List.length statements)


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


viewOrganizations : String -> List Statement -> Html Msg
viewOrganizations searchQuery organizations =
    div [ class "row section" ]
        [ div [ class "container" ]
            [ h3 [ class "zone-label" ]
                [ text "Organizations" ]
            , div [ class "row" ]
                ((organizations
                    |> List.take 8
                    |> List.map
                        (\statement ->
                            case statement.custom of
                                CardCustom card ->
                                    viewOrganizationThumbnail statement card

                                _ ->
                                    Debug.crash "Unexpected statement.custom type"
                        )
                 )
                    ++ [ div [ class "col-sm-12 text-center" ]
                            [ aForPath navigate
                                ("/organizations?q=" ++ searchQuery)
                                [ class "show-more" ]
                                [ text "Show all 398"
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
        url =
            "/organizations/" ++ statement.id
    in
        viewThumbnail url card "orga grey"


viewThumbnail : String -> Card -> String -> Html Msg
viewThumbnail url card extraClass =
    div [ class "col-xs-6 col-md-3" ]
        [ div [ class ("thumbnail " ++ extraClass), onClick (navigate url) ]
            [ div [ class "visual" ]
                [ img [ alt "logo", src "img/TODO.png" ]
                    []
                ]
            , div [ class "caption" ]
                ([ h4 []
                    [ aForPath navigate url [] [ text card.name ] ]
                 , p []
                    [ text card.description ]
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


viewTools : String -> List Statement -> Html Msg
viewTools searchQuery tools =
    div [ class "row section grey" ]
        [ div [ class "container" ]
            [ h3 [ class "zone-label" ]
                [ text "Tools" ]
            , div [ class "row" ]
                ((tools
                    |> List.take 8
                    |> List.map
                        (\statement ->
                            case statement.custom of
                                CardCustom card ->
                                    viewToolThumbnail statement card

                                _ ->
                                    Debug.crash "Unexpected statement.custom type"
                        )
                 )
                    ++ [ div [ class "col-sm-12 text-center" ]
                            [ aForPath navigate
                                ("/tools?q=" ++ searchQuery)
                                [ class "show-more" ]
                                -- TODO Store total count in model since model.tools contains only some pages.
                                [ text ("Show all " ++ (tools |> List.length |> toString))
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
        url =
            "/tools/" ++ statement.id
    in
        viewThumbnail url card "tool"


viewModalTitle : Model -> Html Msg
viewModalTitle model =
    text "Sign up to contribute"
