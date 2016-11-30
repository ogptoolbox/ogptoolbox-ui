module Home exposing (..)

import Authenticator.Model
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Html.Helpers exposing (aExternal, aForPath)
import Http
import I18n exposing (getImageUrl, getManyStrings, getOneString)
import Set exposing (Set)
import String
import Task
import Types exposing (..)
import Requests exposing (newTaskGetExamples, newTaskGetOrganizations, newTaskGetTagsPopularity, newTaskGetTools)
import Views exposing (viewWebData)
import WebData exposing (LoadingStatus(..), getData, mapLoadingStatus, WebData(..))


-- MODEL


type alias Model =
    { examples : WebData DataIdsBody
    , organizations : WebData DataIdsBody
    , popularTags : WebData (List PopularTag)
    , selectedTags : Set String
    , tools : WebData DataIdsBody
    }


init : Model
init =
    { examples = NotAsked
    , organizations = NotAsked
    , popularTags = NotAsked
    , selectedTags = Set.empty
    , tools = NotAsked
    }



-- UPDATE


type ExternalMsg
    = Navigate String


type InternalMsg
    = DeselectBubble String
    | ErrorExamples Http.Error
    | ErrorOrganizations Http.Error
    | ErrorPopularTags Http.Error
    | ErrorTools Http.Error
    | Load String
    | LoadedExamples DataIdsBody
    | LoadedOrganizations DataIdsBody
    | LoadedPopularTags (List PopularTag)
    | LoadedTools DataIdsBody
    | SelectBubble String


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


update :
    InternalMsg
    -> Model
    -> Maybe Authenticator.Model.Authentication
    -> I18n.Language
    -> String
    -> (( List PopularTag, List String ) -> Cmd Msg)
    -> ( Model, Cmd Msg )
update msg model authenticationMaybe language searchQuery mountd3bubbles =
    case msg of
        DeselectBubble deselectedTag ->
            case getData model.popularTags of
                Nothing ->
                    ( model, Cmd.none )

                Just _ ->
                    let
                        newModel =
                            { model
                                | examples = Data (Loading (getData model.examples))
                                , organizations = Data (Loading (getData model.organizations))
                                , selectedTags = newSelectedTags
                                , tools = Data (Loading (getData model.tools))
                            }

                        newSelectedTags =
                            Set.remove deselectedTag model.selectedTags

                        cmds =
                            List.map (Cmd.map ForSelf)
                                [ Task.perform
                                    ErrorExamples
                                    LoadedExamples
                                    (newTaskGetExamples authenticationMaybe searchQuery "" newSelectedTags)
                                , Task.perform
                                    ErrorOrganizations
                                    LoadedOrganizations
                                    (newTaskGetOrganizations authenticationMaybe searchQuery "" newSelectedTags)
                                , Task.perform
                                    ErrorTools
                                    LoadedTools
                                    (newTaskGetTools authenticationMaybe searchQuery "" newSelectedTags)
                                , Task.perform
                                    ErrorPopularTags
                                    LoadedPopularTags
                                    (newTaskGetTagsPopularity language newSelectedTags)
                                ]
                    in
                        newModel ! cmds

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

        ErrorPopularTags err ->
            let
                _ =
                    Debug.log "Home ErrorPopularTags" err

                model' =
                    { model | popularTags = Failure err }
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
                            (newTaskGetExamples authenticationMaybe searchQuery "" model.selectedTags)
                        , Task.perform
                            ErrorOrganizations
                            LoadedOrganizations
                            (newTaskGetOrganizations authenticationMaybe searchQuery "" model.selectedTags)
                        , Task.perform
                            ErrorTools
                            LoadedTools
                            (newTaskGetTools authenticationMaybe searchQuery "" model.selectedTags)
                        , Task.perform
                            ErrorPopularTags
                            LoadedPopularTags
                            (newTaskGetTagsPopularity language Set.empty)
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

        LoadedPopularTags popularTags ->
            ( { model | popularTags = Data (Loaded popularTags) }
            , mountd3bubbles ( popularTags, model.selectedTags |> Set.toList )
            )

        LoadedTools body ->
            ( { model | tools = Data (Loaded body) }
            , Cmd.none
            )

        SelectBubble selectedTag ->
            case getData model.popularTags of
                Nothing ->
                    ( model, Cmd.none )

                Just _ ->
                    let
                        newModel =
                            { model
                                | examples = Data (Loading (getData model.examples))
                                , organizations = Data (Loading (getData model.organizations))
                                , selectedTags = newSelectedTags
                                , tools = Data (Loading (getData model.tools))
                            }

                        newSelectedTags =
                            Set.insert selectedTag model.selectedTags

                        cmds =
                            List.map (Cmd.map ForSelf)
                                [ Task.perform
                                    ErrorExamples
                                    LoadedExamples
                                    (newTaskGetExamples authenticationMaybe searchQuery "" newSelectedTags)
                                , Task.perform
                                    ErrorOrganizations
                                    LoadedOrganizations
                                    (newTaskGetOrganizations authenticationMaybe searchQuery "" newSelectedTags)
                                , Task.perform
                                    ErrorTools
                                    LoadedTools
                                    (newTaskGetTools authenticationMaybe searchQuery "" newSelectedTags)
                                , Task.perform
                                    ErrorPopularTags
                                    LoadedPopularTags
                                    (newTaskGetTagsPopularity language newSelectedTags)
                                ]
                    in
                        newModel ! cmds



-- VIEW


view : Model -> String -> I18n.Language -> Html Msg
view model searchQuery language =
    let
        viewWebDataFor title extraClass webData viewFunction =
            div [ class ("row section " ++ extraClass) ]
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
                                                    [ viewFunction
                                                        searchQuery
                                                        language
                                                        body.count
                                                        body.data.values
                                                        (Dict.values body.data.cards)
                                                    ]

                                        Loaded body ->
                                            [ viewFunction
                                                searchQuery
                                                language
                                                body.count
                                                body.data.values
                                                (Dict.values body.data.cards)
                                            ]
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
                        ""
                        model.examples
                        viewExamples
                   , viewWebDataFor
                        (I18n.translate language (I18n.Tool I18n.Plural))
                        "grey"
                        model.tools
                        viewTools
                   , viewCollections
                     --    , viewWebDataFor
                     --         (I18n.translate language (I18n.Organization I18n.Plural))
                     --         model.organizations
                     --         viewOrganizations
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


viewCollections : Html Msg
viewCollections =
    div [ class "row section" ]
        [ div [ class "container" ]
            [ h3 [ class "zone-label" ]
                [ text "Collections" ]
            , div [ class "row" ]
                [ div [ class "col-xs-6 col-md-4 " ]
                    [ a [ href "https://ui-html.ogptoolbox.org/collection.html" ]
                        [ div [ class "thumbnail collection" ]
                            [ div [ class "visual" ]
                                [ img [ alt "screen", src "https://ui-html.ogptoolbox.org/img/collection-cover.png" ]
                                    []
                                ]
                            , div [ class "caption" ]
                                [ h4 []
                                    [ text "Outils de consultation" ]
                                , div [ class "example-author" ]
                                    [ img [ alt "screen", src "https://ui-html.ogptoolbox.org/img/france.png" ]
                                        []
                                    , text "Etalab"
                                    ]
                                , p []
                                    [ text "L'Etat Français s'étant engagé dans une démarche ouverte pour proposer des nouvelles solutions de consultation aux acteurs publics, Etalab a sélectionné en concertation avec les acteurs de la civic tech une palette d'outils à même de répondre aux différents besoins des administrations en vue de mener des consultations publiques auprès des citoyens. Catalogués ici dans la Boîte à outils du Gouvernement ouvert, ces outils sont par ailleurs mis à la disposition des administrations françaises sur le portail consultation.gouv.fr qui leur permet de lancer une consultation publique clé en main en quelques minutes." ]
                                ]
                            ]
                        ]
                    ]
                , div [ class "col-xs-6 col-md-4 " ]
                    [ div [ class "thumbnail collection" ]
                        [ div [ class "visual" ]
                            [ img [ alt "screen", src "https://ui-html.ogptoolbox.org/img/collection-cover2.png" ]
                                []
                            ]
                        , div [ class "caption" ]
                            [ h4 []
                                [ text "Outils libres pour l'organisation de hackathon" ]
                            , div [ class "example-author" ]
                                [ img [ alt "screen", src "https://ui-html.ogptoolbox.org/img/paula.jpg" ]
                                    []
                                , text "Paula Forteza"
                                ]
                            , p []
                                [ text "Lorsque on organise un hackathon il est très outils d emettre en place un esemble d'outils pour communiquer avec ses collaborateurs. Cette collection est une séléction des meilleurs outils" ]
                            ]
                        ]
                    ]
                , div [ class "col-xs-6 col-md-4 " ]
                    [ div [ class "thumbnail collection" ]
                        [ div [ class "visual" ]
                            [ img [ alt "screen", src "https://ui-html.ogptoolbox.org/img/collection-cover3.png" ]
                                []
                            ]
                        , div [ class "caption" ]
                            [ h4 []
                                [ text "The best open data tools for governments" ]
                            , div [ class "example-author" ]
                                [ img [ alt "screen", src "https://ui-html.ogptoolbox.org/img/henri.jpg" ]
                                    []
                                , text "Henri Verdier"
                                ]
                            , p []
                                [ text "Open data is the idea that some data should be freely available to everyone to use and republish as they wish, without restrictions from copyright, patents or other mechanisms of control." ]
                            ]
                        ]
                    ]
                , div [ class "col-sm-12 text-center" ]
                    [ a [ class "show-more" ]
                        [ text "Show all 398"
                        , span [ class "glyphicon glyphicon-menu-down" ]
                            []
                        ]
                    ]
                ]
            ]
        ]


viewExampleThumbnail : Card -> Dict String Value -> I18n.Language -> Html Msg
viewExampleThumbnail card values language =
    let
        urlPath =
            "/examples/" ++ card.id
    in
        viewThumbnail urlPath card values "example grey" Types.Example language


viewExamples : String -> I18n.Language -> Int -> Dict String Value -> List Card -> Html Msg
viewExamples searchQuery language count values examples =
    div [ class "row" ]
        ((examples
            |> List.take 8
            |> List.map (\card -> viewExampleThumbnail card values language)
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


viewOrganizations : String -> I18n.Language -> Int -> Dict String Value -> List Card -> Html Msg
viewOrganizations searchQuery language count values organizations =
    div [ class "row" ]
        ((organizations
            |> List.take 8
            |> List.map
                (\card -> viewOrganizationThumbnail card values language)
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


viewOrganizationThumbnail : Card -> Dict String Value -> I18n.Language -> Html Msg
viewOrganizationThumbnail card values language =
    let
        urlPath =
            "/organizations/" ++ card.id
    in
        viewThumbnail urlPath card values "orga grey" Types.Organization language


viewThumbnail : String -> Card -> Dict String Value -> String -> CardType -> I18n.Language -> Html Msg
viewThumbnail urlPath card values extraClass cardType language =
    let
        name =
            getOneString language nameKeys card values |> Maybe.withDefault ""
    in
        div [ class "col-xs-6 col-md-3" ]
            [ div [ class ("thumbnail " ++ extraClass), onClick (navigate urlPath) ]
                [ div [ class "visual" ]
                    [ case getImageUrl language "218x140" card values of
                        Just url ->
                            img [ alt "Logo", src url ] []

                        Nothing ->
                            h1 [ class "dynamic" ]
                                [ text
                                    (case cardType of
                                        Example ->
                                            name

                                        Organization ->
                                            name

                                        Tool ->
                                            String.left 2 name
                                    )
                                ]
                    ]
                , div [ class "caption" ]
                    [ h4 []
                        [ aForPath navigate urlPath [] [ text name ] ]
                    , case getOneString language descriptionKeys card values of
                        Just description ->
                            p [] [ text description ]

                        Nothing ->
                            p
                                [ class "call" ]
                                [ text (I18n.translate language (I18n.CallToActionForDescription cardType)) ]
                    ]
                , div [ class "tags" ]
                    (case getManyStrings language tagKeys card values of
                        [] ->
                            [ span
                                [ class "label label-default label-tool" ]
                                [ text (I18n.translate language I18n.CallToActionForCategory) ]
                            ]

                        xs ->
                            xs
                                |> List.take 3
                                |> List.map
                                    (\str ->
                                        span
                                            [ class "label label-default label-tool" ]
                                            [ text str ]
                                    )
                    )
                ]
            ]


viewTools : String -> I18n.Language -> Int -> Dict String Value -> List Card -> Html Msg
viewTools searchQuery language count values tools =
    div [ class "row" ]
        ((tools
            |> List.take 8
            |> List.map (\card -> viewToolThumbnail card values language)
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


viewToolThumbnail : Card -> Dict String Value -> I18n.Language -> Html Msg
viewToolThumbnail card values language =
    let
        urlPath =
            "/tools/" ++ card.id
    in
        viewThumbnail urlPath card values "tool" Types.Tool language
