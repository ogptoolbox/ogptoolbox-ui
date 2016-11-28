module Home exposing (..)

import Authenticator.Model
import Dict
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Html.Helpers exposing (aExternal, aForPath, getImageUrl)
import Http
import I18n
import String
import Task
import Types exposing (..)
import Requests exposing (newTaskGetExamples, newTaskGetOrganizations, newTaskGetTools)
import Views exposing (viewWebData)
import WebData exposing (LoadingStatus(..), getData, mapLoadingStatus, WebData(..))


-- MODEL


type alias Bubble =
    { name : String
    , radius : Float
    , selected : Bool
    }


type alias Model =
    { examples : WebData DataIdsBody
    , organizations : WebData DataIdsBody
    , tools : WebData DataIdsBody
    , bubbles : WebData (List Bubble)
    }


init : Model
init =
    { examples = NotAsked
    , organizations = NotAsked
    , tools = NotAsked
    , bubbles = NotAsked
    }



-- UPDATE


type ExternalMsg
    = Navigate String


type InternalMsg
    = DeselectBubble Bubble
    | ErrorBubbles Http.Error
    | ErrorExamples Http.Error
    | ErrorOrganizations Http.Error
    | ErrorTools Http.Error
    | Load String
    | LoadedBubbles (List Bubble)
    | LoadedExamples DataIdsBody
    | LoadedOrganizations DataIdsBody
    | LoadedTools DataIdsBody
    | SelectBubble Bubble


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


update : InternalMsg -> Maybe Authenticator.Model.Authentication -> Model -> (List Bubble -> Cmd Msg) -> ( Model, Cmd Msg )
update msg authenticationMaybe model mountd3bubbles =
    case msg of
        DeselectBubble { name } ->
            case getData model.bubbles of
                Nothing ->
                    ( model, Cmd.none )

                Just bubbles ->
                    let
                        newBubbles =
                            List.map
                                (\bubble ->
                                    if bubble.name == name then
                                        { bubble | selected = False }
                                    else
                                        bubble
                                )
                                bubbles
                    in
                        ( { model | bubbles = Data (Loaded newBubbles) }
                        , mountd3bubbles newBubbles
                        )

        ErrorBubbles err ->
            let
                _ =
                    Debug.log "Home ErrorBubbles" err

                model' =
                    { model | bubbles = Failure err }
            in
                ( model', Cmd.none )

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
                        , Task.perform
                            ErrorBubbles
                            LoadedBubbles
                            (Task.succeed
                                [ { name = "Data-visualization", radius = 87, selected = False }
                                , { name = "Petitions", radius = 80, selected = False }
                                , { name = "Consultation", radius = 60, selected = False }
                                , { name = "Law-making", radius = 57, selected = False }
                                , { name = "Budget", radius = 55, selected = False }
                                , { name = "Debate", radius = 54, selected = False }
                                , { name = "Reporting", radius = 50, selected = False }
                                , { name = "Deliberation", radius = 40, selected = False }
                                , { name = "Collaborative", radius = 38, selected = False }
                                , { name = "Mobilizing", radius = 35, selected = False }
                                , { name = "Crowdfunding", radius = 50, selected = False }
                                , { name = "Information", radius = 52, selected = False }
                                , { name = "Proposal Making", radius = 39, selected = False }
                                , { name = "Mapping", radius = 47, selected = False }
                                , { name = "Transparency", radius = 50, selected = False }
                                , { name = "Voting", radius = 37, selected = False }
                                , { name = "Polling", radius = 20, selected = False }
                                ]
                            )
                          -- TODO Replace with HTTP request
                        ]
            in
                model' ! cmds

        LoadedBubbles body ->
            ( { model | bubbles = Data (Loaded body) }
            , mountd3bubbles body
            )

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

        SelectBubble { name } ->
            case getData model.bubbles of
                Nothing ->
                    ( model, Cmd.none )

                Just bubbles ->
                    let
                        newBubbles =
                            List.map
                                (\bubble ->
                                    if bubble.name == name then
                                        { bubble | selected = True }
                                    else
                                        bubble
                                )
                                bubbles
                    in
                        ( { model | bubbles = Data (Loaded newBubbles) }
                        , mountd3bubbles newBubbles
                        )



-- VIEW


view : Model -> String -> I18n.Language -> Html Msg
view model searchQuery language =
    let
        viewWebDataFor title webData view =
            div [ class "row section" ]
                [ div [ class "container" ]
                    ([ h3 [ class "zone-label" ]
                        [ text title ]
                     ]
                        ++ (viewWebData
                                language
                                (\loadingStatus ->
                                    case loadingStatus of
                                        Loading maybeStatement ->
                                            case maybeStatement of
                                                Nothing ->
                                                    []

                                                Just body ->
                                                    [ view searchQuery language body.count (Dict.values body.data.statements) ]

                                        Loaded body ->
                                            [ view searchQuery language body.count (Dict.values body.data.statements) ]
                                )
                                webData
                           )
                    )
                ]
    in
        div []
            ([ viewBanner
             , viewMetrics language model
             ]
                ++ (if String.isEmpty searchQuery then
                        []
                    else
                        [ div [ class "row section" ]
                            [ div [ class "container" ]
                                [ h1 [] [ text (I18n.translate language (I18n.SearchResults searchQuery)) ] ]
                            ]
                        ]
                   )
                ++ [ viewWebDataFor
                        (I18n.translate language (I18n.Example I18n.Plural))
                        model.examples
                        viewExamples
                   , viewWebDataFor
                        (I18n.translate language (I18n.Tool I18n.Plural))
                        model.tools
                        viewTools
                   , viewWebDataFor
                        (I18n.translate language (I18n.Organization I18n.Plural))
                        model.organizations
                        viewOrganizations
                   ]
            )


viewBanner : Html Msg
viewBanner =
    div [ class "banner" ]
        [ div [ class "row " ]
            [ div [ class "carousel slide", attribute "data-ride" "", id "carousel-example-generic" ]
                [ div [ class "carousel-inner ", attribute "role" "listbox" ]
                    [ div [ class "item active text-center" ]
                        [ div [ class "container-fluid" ]
                            [ div [ class "row" ]
                                [ div [ class "col-md-12 text-center" ]
                                    [ div [ id "tag" ]
                                        [ div [ class "plot" ] []
                                        ]
                                    ]
                                ]
                            , div [ class "row filters" ]
                                [ div [ class "col-md-12 text-center" ]
                                    [ text "Showing results suited for"
                                    , div [ class "dropdown dropdown-filter dropup" ]
                                        [ a
                                            [ class "btn btn-default dropdown-toggle"
                                            , attribute "data-slide-to" "2"
                                            , href "#carousel-example-generic"
                                            , attribute "role" "button"
                                            ]
                                            [ text "all organizations"
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
                                    , text "and available in"
                                    , div [ class "dropdown dropdown-filter dropup" ]
                                        [ a
                                            [ class "btn btn-default dropdown-toggle"
                                            , attribute "data-slide-to" "3"
                                            , href "#carousel-example-generic"
                                            , attribute "role" "button"
                                            ]
                                            [ text "English"
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
                                            , text "All organizations"
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
                                            , text "Local government"
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
                                            , text "Regional government"
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
                                            , text "National government"
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
                                            , text "Political organization"
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
                                            , text "Political movement"
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
                                            , text "Non-profit organization"
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
                                            , text "For-profit organization"
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


viewExampleThumbnail : Statement -> Card -> I18n.Language -> Html Msg
viewExampleThumbnail statement card language =
    let
        urlPath =
            "/examples/" ++ statement.id
    in
        viewThumbnail urlPath card "example grey" Types.Example language


viewExamples : String -> I18n.Language -> Int -> List Statement -> Html Msg
viewExamples searchQuery language count examples =
    div [ class "row" ]
        ((examples
            |> filterByCardType Example
            |> List.take 8
            |> List.map
                (\statement ->
                    case statement.custom of
                        CardCustom card ->
                            viewExampleThumbnail statement card language
                )
         )
            ++ [ div [ class "col-sm-12 text-center" ]
                    [ aForPath navigate
                        ("/examples?q=" ++ searchQuery)
                        [ class "show-more" ]
                        [ text (I18n.translate language (I18n.ShowAll count))
                        , span [ class "glyphicon glyphicon-menu-down" ] []
                        ]
                    ]
               ]
        )


viewMetric : WebData DataIdsBody -> Html msg
viewMetric webData =
    text
        (case webData of
            NotAsked ->
                "-"

            Failure _ ->
                "-"

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


viewMetrics : I18n.Language -> Model -> Html msg
viewMetrics language model =
    div [ class "row metrics" ]
        [ div [ class "container" ]
            [ div [ class "col-xs-4 text-center" ]
                [ span [ class "metric-label" ]
                    [ text (I18n.translate language (I18n.Example I18n.Plural)) ]
                , h3 []
                    [ viewMetric model.examples
                    ]
                ]
            , div [ class "col-xs-4 text-center" ]
                [ span [ class "metric-label" ]
                    [ text (I18n.translate language (I18n.Tool I18n.Plural)) ]
                , h3 []
                    [ viewMetric model.tools
                    ]
                ]
            , div [ class "col-xs-4 text-center" ]
                [ span [ class "metric-label" ]
                    [ text (I18n.translate language (I18n.Organization I18n.Plural)) ]
                , h3 []
                    [ viewMetric model.organizations
                    ]
                ]
            ]
        ]


viewOrganizations : String -> I18n.Language -> Int -> List Statement -> Html Msg
viewOrganizations searchQuery language count organizations =
    div [ class "row" ]
        ((organizations
            |> filterByCardType Organization
            |> List.take 8
            |> List.map
                (\statement ->
                    case statement.custom of
                        CardCustom card ->
                            viewOrganizationThumbnail statement card language
                )
         )
            ++ [ div [ class "col-sm-12 text-center" ]
                    [ aForPath navigate
                        ("/organizations?q=" ++ searchQuery)
                        [ class "show-more" ]
                        [ text (I18n.translate language (I18n.ShowAll count))
                        , span [ class "glyphicon glyphicon-menu-down" ] []
                        ]
                    ]
               ]
        )


viewOrganizationThumbnail : Statement -> Card -> I18n.Language -> Html Msg
viewOrganizationThumbnail statement card language =
    let
        urlPath =
            "/organizations/" ++ statement.id
    in
        viewThumbnail urlPath card "orga grey" Types.Organization language


viewThumbnail : String -> Card -> String -> CardType -> I18n.Language -> Html Msg
viewThumbnail urlPath card extraClass cardType language =
    let
        name =
            getOneString nameKeys card |> Maybe.withDefault ""
    in
        div [ class "col-xs-6 col-md-3" ]
            [ div [ class ("thumbnail " ++ extraClass), onClick (navigate urlPath) ]
                [ div [ class "visual" ]
                    [ case getImageUrl "218x140" card of
                        Just url ->
                            img [ alt "Logo", src url ] []

                        Nothing ->
                            h1 [ class "dynamic" ] [ text name ]
                    ]
                , div [ class "caption" ]
                    [ h4 []
                        [ aForPath navigate urlPath [] [ text name ] ]
                    , case getOneString descriptionKeys card of
                        Just description ->
                            p [] [ text description ]

                        Nothing ->
                            p
                                [ class "call" ]
                                [ text (I18n.translate language (I18n.CallToActionForDescription cardType)) ]
                    ]
                , div [ class "tags" ]
                    (case getManyStrings tagKeys card of
                        [] ->
                            [ span
                                [ class "label label-default label-tool" ]
                                [ text (I18n.translate language I18n.CallToActionForCategory) ]
                            ]

                        xs ->
                            List.map
                                (\str ->
                                    span
                                        [ class "label label-default label-tool" ]
                                        [ text str ]
                                )
                                xs
                    )
                ]
            ]


viewTools : String -> I18n.Language -> Int -> List Statement -> Html Msg
viewTools searchQuery language count tools =
    div [ class "row" ]
        ((tools
            |> filterByCardType Tool
            |> List.take 8
            |> List.map
                (\statement ->
                    case statement.custom of
                        CardCustom card ->
                            viewToolThumbnail statement card language
                )
         )
            ++ [ div [ class "col-sm-12 text-center" ]
                    [ aForPath navigate
                        ("/tools?q=" ++ searchQuery)
                        [ class "show-more" ]
                        [ text (I18n.translate language (I18n.ShowAll count))
                        , span [ class "glyphicon glyphicon-menu-down" ] []
                        ]
                    ]
               ]
        )


viewToolThumbnail : Statement -> Card -> I18n.Language -> Html Msg
viewToolThumbnail statement card language =
    let
        urlPath =
            "/tools/" ++ statement.id
    in
        viewThumbnail urlPath card "tool" Types.Tool language
