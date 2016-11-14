module Home exposing (..)

import Authenticator.Model
import Dict
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http
import Task
import Types exposing (Card, DataIdsBody, Statement, StatementCustom(..))
import Requests exposing (newTaskGetExamples, newTaskGetOrganizations, newTaskGetTools)
import Views exposing (aForPath)


-- MODEL


type alias Model =
    { examples : List Statement
    , organizations : List Statement
    , tools : List Statement
    }


init : Model
init =
    { examples = []
    , organizations = []
    , tools = []
    }



-- UPDATE


type ExternalMsg
    = Navigate String


type InternalMsg
    = Error Http.Error
    | Load
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
        Error err ->
            let
                _ =
                    Debug.log "Home Error" err
            in
                ( model, Cmd.none )

        Load ->
            let
                cmds =
                    [ Task.perform
                        (\msg -> ForSelf (Error msg))
                        (\msg -> ForSelf (LoadedExamples msg))
                        (newTaskGetExamples authenticationMaybe)
                    , Task.perform
                        (\msg -> ForSelf (Error msg))
                        (\msg -> ForSelf (LoadedOrganizations msg))
                        (newTaskGetOrganizations authenticationMaybe)
                    , Task.perform
                        (\msg -> ForSelf (Error msg))
                        (\msg -> ForSelf (LoadedTools msg))
                        (newTaskGetTools authenticationMaybe)
                    ]
            in
                model ! cmds

        LoadedExamples body ->
            ( { model | examples = Dict.values body.data.statements }
            , Cmd.none
            )

        LoadedOrganizations body ->
            ( { model | organizations = Dict.values body.data.statements }
            , Cmd.none
            )

        LoadedTools body ->
            ( { model | tools = Dict.values body.data.statements }
            , Cmd.none
            )



-- VIEW


view : Maybe Authenticator.Model.Authentication -> Model -> Html Msg
view authenticationMaybe model =
    div []
        [ viewBanner authenticationMaybe model
        , viewMetrics authenticationMaybe model
        , viewExamples authenticationMaybe model
        , viewTools authenticationMaybe model
        , viewOrganizations authenticationMaybe model
        ]


viewBanner : Maybe Authenticator.Model.Authentication -> Model -> Html Msg
viewBanner authenticationMaybe model =
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
                                            , text "All organiations                    "
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


viewExamples : Maybe Authenticator.Model.Authentication -> Model -> Html Msg
viewExamples authenticationMaybe model =
    div [ class "row section" ]
        [ div [ class "container" ]
            [ h3 [ class "zone-label" ]
                [ text "Examples" ]
            , div [ class "row" ]
                ((model.examples
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
                                "/examples"
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


viewMetrics : Maybe Authenticator.Model.Authentication -> Model -> Html Msg
viewMetrics authenticationMaybe model =
    div [ class "row metrics" ]
        [ div [ class "container" ]
            [ div [ class "col-xs-4 text-center" ]
                [ span [ class "metric-label" ]
                    [ text "Examples" ]
                , h3 []
                    [ text "5891" ]
                ]
            , div [ class "col-xs-4 text-center" ]
                [ span [ class "metric-label" ]
                    [ text "Tools" ]
                , h3 []
                    [ List.length model.tools |> toString |> text ]
                ]
            , div [ class "col-xs-4 text-center" ]
                [ span [ class "metric-label" ]
                    [ text "Organizations" ]
                , h3 []
                    [ text "127" ]
                ]
            ]
        ]


viewOrganizations : Maybe Authenticator.Model.Authentication -> Model -> Html Msg
viewOrganizations authenticationMaybe model =
    div [ class "row section" ]
        [ div [ class "container" ]
            [ h3 [ class "zone-label" ]
                [ text "Organizations" ]
            , div [ class "row" ]
                ((model.organizations
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
                                "/organizations"
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


viewTools : Maybe Authenticator.Model.Authentication -> Model -> Html Msg
viewTools authenticationMaybe model =
    div [ class "row section grey" ]
        [ div [ class "container" ]
            [ h3 [ class "zone-label" ]
                [ text "Tools" ]
            , div [ class "row" ]
                ((model.tools
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
                                "/tools"
                                [ class "show-more" ]
                                -- TODO Store total count in model since model.tools contains only some pages.
                                [ text ("Show all " ++ (model.tools |> List.length |> toString))
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
