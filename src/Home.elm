module Home exposing (..)

import Authenticator.Model
import Html exposing (a, br, div, h1, h2, h3, Html, img, input, label, li, p, span, text, ul)
import Html.Attributes exposing (attribute, class, href, id, name, src, type', value)


-- MODEL


type alias Model =
    {}


init : Model
init =
    {}


-- UPDATE


type ExternalMsg
    = Navigate String


type InternalMsg
    = Todo


type Msg
    = ForParent ExternalMsg
    | ForSelf InternalMsg


type alias MsgTranslation parentMsg =
    { onInternalMsg : InternalMsg -> parentMsg
    , onNavigate : String -> parentMsg
    }


type alias MsgTranslator parentMsg = Msg -> parentMsg


navigate : String -> Msg
navigate path =
    ForParent (Navigate path)


translateMsg : MsgTranslation parentMsg -> MsgTranslator parentMsg
translateMsg {onInternalMsg, onNavigate} msg =
    case msg of
        ForParent (Navigate path) ->
            onNavigate path

        ForSelf internalMsg ->
            onInternalMsg internalMsg


update : InternalMsg -> Maybe Authenticator.Model.Authentication -> Model -> ( Model, Cmd Msg )
update msg authenticationMaybe model =
    case msg of
        Todo ->
            ( model, Cmd.none )


-- VIEW


view : Maybe Authenticator.Model.Authentication -> Model -> Html Msg
view authenticationMaybe model =
    div []
        [ div [ class "banner" ]  -- Summary & bubbles
            [ div [ class "row " ]
                [ div [ class "carousel slide ", attribute "data-ride" "", id "carousel-example-generic" ]
                    [ div [ class "carousel-inner ", attribute "role" "listbox" ]
                        [ div [ class "item active" ]
                            [ div [ class "jumbotron" ]
                                [ div [ class "container" ]
                                    [ h1 []
                                        [ text "The international toolbox for"
                                        , br []
                                            []
                                        , text "open government projects"
                                        ]
                                    , p []
                                        [ text "Build your own project upon the common knowledge"
                                        , br []
                                            []
                                        , text "and practice of the International community."
                                        , br []
                                            []
                                        , text "Share your tools and list your initiative."
                                        ]
                                    , p []
                                        [ a [ class "btn btn-primary btn-lg", attribute "data-slide-to" "1", href "#carousel-example-generic", attribute "role" "button" ]
                                            [ text "Start browsing" ]
                                        ]
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
                                            [ a [ class "btn btn-default dropdown-toggle", attribute "data-slide-to" "2", href "#carousel-example-generic", attribute "role" "button" ]
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
                                                , li []
                                                    [ a [ href "#" ]
                                                        [ text "National government" ]
                                                    ]
                                                , li []
                                                    [ a [ href "#" ]
                                                        [ text "Political organization" ]
                                                    ]
                                                , li []
                                                    [ a [ href "#" ]
                                                        [ text "Political movement" ]
                                                    ]
                                                , li []
                                                    [ a [ href "#" ]
                                                        [ text "Non-profit organization" ]
                                                    ]
                                                , li []
                                                    [ a [ href "#" ]
                                                        [ text "For-profit organization" ]
                                                    ]
                                                ]
                                            ]
                                        , text "and available in                   "
                                        , div [ class "dropdown dropdown-filter dropup" ]
                                            [ a [ class "btn btn-default dropdown-toggle", attribute "data-slide-to" "3", href "#carousel-example-generic", attribute "role" "button" ]
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
                                                [ input [ attribute "checked" "", id "optionsRadios1", name "optionsRadios", type' "radio", value "option1" ]
                                                    []
                                                , text "All organiations                    "
                                                ]
                                            ]
                                        ]
                                    , div [ class "col-md-3 text-center" ]
                                        [ div [ class "radio" ]
                                            [ label []
                                                [ input [ attribute "checked" "", id "optionsRadios1", name "optionsRadios", type' "radio", value "option1" ]
                                                    []
                                                , text "Local government                    "
                                                ]
                                            ]
                                        ]
                                    , div [ class "col-md-3 text-center" ]
                                        [ div [ class "radio" ]
                                            [ label []
                                                [ input [ attribute "checked" "", id "optionsRadios1", name "optionsRadios", type' "radio", value "option1" ]
                                                    []
                                                , text "Regional government                    "
                                                ]
                                            ]
                                        ]
                                    , div [ class "col-md-3 text-center" ]
                                        [ div [ class "radio" ]
                                            [ label []
                                                [ input [ attribute "checked" "", id "optionsRadios1", name "optionsRadios", type' "radio", value "option1" ]
                                                    []
                                                , text "National government                    "
                                                ]
                                            ]
                                        ]
                                    , div [ class "col-md-3 text-center" ]
                                        [ div [ class "radio" ]
                                            [ label []
                                                [ input [ attribute "checked" "", id "optionsRadios1", name "optionsRadios", type' "radio", value "option1" ]
                                                    []
                                                , text "Political organization                    "
                                                ]
                                            ]
                                        ]
                                    , div [ class "col-md-3 text-center" ]
                                        [ div [ class "radio" ]
                                            [ label []
                                                [ input [ attribute "checked" "", id "optionsRadios1", name "optionsRadios", type' "radio", value "option1" ]
                                                    []
                                                , text "Political movement                    "
                                                ]
                                            ]
                                        ]
                                    , div [ class "col-md-3 text-center" ]
                                        [ div [ class "radio" ]
                                            [ label []
                                                [ input [ attribute "checked" "", id "optionsRadios1", name "optionsRadios", type' "radio", value "option1" ]
                                                    []
                                                , text "Non-profit organization                    "
                                                ]
                                            ]
                                        ]
                                    , div [ class "col-md-3 text-center" ]
                                        [ div [ class "radio" ]
                                            [ label []
                                                [ input [ attribute "checked" "", id "optionsRadios1", name "optionsRadios", type' "radio", value "option1" ]
                                                    []
                                                , text "For-profit organization                    "
                                                ]
                                            ]
                                        ]
                                    ]
                                , div [ class "row" ]
                                    [ div [ class "col-md-12 text-center" ]
                                        [ a [ class "btn btn-primary btn-lg", attribute "data-slide-to" "1", href "#carousel-example-generic", attribute "role" "button" ]
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
                                            [ input [ attribute "checked" "", id "optionsRadios1", name "optionsRadios", type' "checkbox", value "option1" ]
                                                []
                                            , text "English                    "
                                            ]
                                        ]
                                    ]
                                , div [ class "col-md-3 text-center" ]
                                    [ div [ class "checkbox" ]
                                        [ label []
                                            [ input [ attribute "checked" "", id "optionsRadios1", name "optionsRadios", type' "checkbox", value "option1" ]
                                                []
                                            , text "Français                    "
                                            ]
                                        ]
                                    ]
                                , div [ class "col-md-3 text-center" ]
                                    [ div [ class "checkbox" ]
                                        [ label []
                                            [ input [ attribute "checked" "", id "optionsRadios1", name "optionsRadios", type' "checkbox", value "option1" ]
                                                []
                                            , text "Espanol                    "
                                            ]
                                        ]
                                    ]
                                , div [ class "col-md-3 text-center" ]
                                    [ div [ class "checkbox" ]
                                        [ label []
                                            [ input [ attribute "checked" "", id "optionsRadios1", name "optionsRadios", type' "checkbox", value "option1" ]
                                                []
                                            , text "Deutsch                    "
                                            ]
                                        ]
                                    ]
                                , div [ class "col-md-3 text-center" ]
                                    [ div [ class "checkbox" ]
                                        [ label []
                                            [ input [ attribute "checked" "", id "optionsRadios1", name "optionsRadios", type' "checkbox", value "option1" ]
                                                []
                                            , text "Italian                    "
                                            ]
                                        ]
                                    ]
                                , div [ class "col-md-3 text-center" ]
                                    [ div [ class "checkbox" ]
                                        [ label []
                                            [ input [ attribute "checked" "", id "optionsRadios1", name "optionsRadios", type' "checkbox", value "option1" ]
                                                []
                                            , text "Arab                    "
                                            ]
                                        ]
                                    ]
                                , div [ class "col-md-3 text-center" ]
                                    [ div [ class "checkbox" ]
                                        [ label []
                                            [ input [ attribute "checked" "", id "optionsRadios1", name "optionsRadios", type' "checkbox", value "option1" ]
                                                []
                                            , text "Japanese                    "
                                            ]
                                        ]
                                    ]
                                , div [ class "col-md-3 text-center" ]
                                    [ div [ class "checkbox" ]
                                        [ label []
                                            [ input [ attribute "checked" "", id "optionsRadios1", name "optionsRadios", type' "radio", value "option1" ]
                                                []
                                            , text "Russian                    "
                                            ]
                                        ]
                                    ]
                                ]
                            , div [ class "row" ]
                                [ div [ class "col-md-12 text-center" ]
                                    [ a [ class "btn btn-primary btn-lg", attribute "data-slide-to" "1", href "#carousel-example-generic", attribute "role" "button" ]
                                        [ text "Continue" ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        , div [ class "row metrics" ]  -- Metrics
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
                        [ text "318" ]
                    ]
                , div [ class "col-xs-4 text-center" ]
                    [ span [ class "metric-label" ]
                        [ text "Organizations" ]
                    , h3 []
                        [ text "127" ]
                    ]
                ]
            ]
        ]