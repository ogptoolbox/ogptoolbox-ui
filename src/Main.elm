module Main exposing (..)

import About
import Authenticator.Model
import Authenticator.Update
import Authenticator.View
-- import Cards
import Examples
import Help
import Home
import Hop.Types
import Html exposing (a, button, div, form, header, Html, img, input, li, nav, p, span, text, ul)
import Html.App
import Html.Attributes exposing (attribute, class, href, id, placeholder, src, type')
-- import Html.Attributes.Aria exposing (..)
import Navigation
import Organizations
import Routes exposing (makeUrl, Route(..), urlParser)
import Statements
import Tools
import Views exposing (aForPath, viewNotFound)


main : Program Never
main =
    Navigation.program urlParser
        { init = init
        , update = update
        , urlUpdate = urlUpdate
        , view = view
        , subscriptions = subscriptions
        }


-- MODEL


type alias Model =
    { aboutModel : About.Model
    , authenticationMaybe : Maybe Authenticator.Model.Authentication
    , authenticatorModel : Authenticator.Model.Model
    -- , cardsModel : Cards.Model
    , examplesModel : Examples.Model
    , helpModel : Help.Model
    , homeModel : Home.Model
    , location : Hop.Types.Location
    , organizationsModel : Organizations.Model
    , page : String
    , route : Route
    , statementsModel : Statements.Model
    , toolsModel : Tools.Model
    }


init : ( Route, Hop.Types.Location ) -> ( Model, Cmd Msg )
init ( route, location ) =
    { aboutModel = About.init
    , authenticationMaybe = Nothing
    , authenticatorModel = Authenticator.Model.init
    -- , cardsModel = Cards.init
    , examplesModel = Examples.init
    , helpModel = Help.init
    , homeModel = Home.init
    , organizationsModel = Organizations.init
    , location = location
    , page = "reference"
    , route = route
    , statementsModel = Statements.init
    , toolsModel = Tools.init
    }
        |> urlUpdate ( route, location )


-- ROUTING


urlUpdate : (Route, Hop.Types.Location) -> Model -> (Model, Cmd Msg)
urlUpdate (route, location) model =
    let
        model' = { model
            | location = location
            , route = route
            }
    in
        case route of
            AboutRoute ->
                (model', Cmd.none)

            AuthenticatorRoute _ ->
                (model', Cmd.none)

            -- CardsRoute childRoute ->
            --     let
            --         -- Cmd.map translateCardsMsg Cards.load
            --         (cardsModel, childEffect) = Cards.urlUpdate (childRoute, location) model'.cardsModel
            --     in
            --         ({ model' | cardsModel = cardsModel }, Cmd.map translateCardsMsg childEffect)

            ExamplesRoute ->
                (model', Cmd.none)

            HelpRoute ->
                (model', Cmd.none)

            HomeRoute ->
                (model', Cmd.none)

            NotFoundRoute ->
                (model', Cmd.none)

            OrganizationsRoute ->
                (model', Cmd.none)

            StatementsRoute childRoute ->
                let
                    -- Cmd.map translateStatementsMsg Statements.load
                    (statementsModel, childEffect) = Statements.urlUpdate (childRoute, location) model'.statementsModel
                in
                    ({ model' | statementsModel = statementsModel }, Cmd.map translateStatementsMsg childEffect)

            ToolsRoute ->
                (model', Cmd.none)


-- UPDATE


type Msg
    = AboutMsg About.InternalMsg
    | AuthenticatorMsg Authenticator.Update.Msg
    -- | CardsMsg Cards.InternalMsg
    | ExamplesMsg Examples.InternalMsg
    | HelpMsg Help.InternalMsg
    | HomeMsg Home.InternalMsg
    | Navigate String
    | OrganizationsMsg Organizations.InternalMsg
    | StatementsMsg Statements.InternalMsg
    | ToolsMsg Tools.InternalMsg


aboutMsgTranslation : About.MsgTranslation Msg
aboutMsgTranslation =
    { onInternalMsg = AboutMsg
    , onNavigate = Navigate
    }


-- cardsMsgTranslation : Cards.MsgTranslation Msg
-- cardsMsgTranslation =
--     { onInternalMsg = CardsMsg
--     , onNavigate = Navigate
--     }


examplesMsgTranslation : Examples.MsgTranslation Msg
examplesMsgTranslation =
    { onInternalMsg = ExamplesMsg
    , onNavigate = Navigate
    }


helpMsgTranslation : Help.MsgTranslation Msg
helpMsgTranslation =
    { onInternalMsg = HelpMsg
    , onNavigate = Navigate
    }


homeMsgTranslation : Home.MsgTranslation Msg
homeMsgTranslation =
    { onInternalMsg = HomeMsg
    , onNavigate = Navigate
    }


organizationsMsgTranslation : Organizations.MsgTranslation Msg
organizationsMsgTranslation =
    { onInternalMsg = OrganizationsMsg
    , onNavigate = Navigate
    }


statementsMsgTranslation : Statements.MsgTranslation Msg
statementsMsgTranslation =
    { onInternalMsg = StatementsMsg
    , onNavigate = Navigate
    }


toolsMsgTranslation : Tools.MsgTranslation Msg
toolsMsgTranslation =
    { onInternalMsg = ToolsMsg
    , onNavigate = Navigate
    }


translateAboutMsg : About.MsgTranslator Msg
translateAboutMsg = About.translateMsg aboutMsgTranslation


-- translateCardsMsg : Cards.MsgTranslator Msg
-- translateCardsMsg = Cards.translateMsg cardsMsgTranslation


translateExamplesMsg : Examples.MsgTranslator Msg
translateExamplesMsg = Examples.translateMsg examplesMsgTranslation


translateHelpMsg : Help.MsgTranslator Msg
translateHelpMsg = Help.translateMsg helpMsgTranslation


translateHomeMsg : Home.MsgTranslator Msg
translateHomeMsg = Home.translateMsg homeMsgTranslation


translateOrganizationsMsg : Organizations.MsgTranslator Msg
translateOrganizationsMsg = Organizations.translateMsg organizationsMsgTranslation


translateStatementsMsg : Statements.MsgTranslator Msg
translateStatementsMsg = Statements.translateMsg statementsMsgTranslation


translateToolsMsg : Tools.MsgTranslator Msg
translateToolsMsg = Tools.translateMsg toolsMsgTranslation


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AboutMsg childMsg ->
            let
                ( aboutModel, childEffect ) =
                    About.update childMsg model.authenticationMaybe model.aboutModel
            in
                ( { model | aboutModel = aboutModel }, Cmd.map translateAboutMsg childEffect )

        Navigate path ->
            let
                command =
                    makeUrl path
                        |> Navigation.newUrl
            in
                ( model, command )

        AuthenticatorMsg childMsg ->
            let
                ( authenticatorModel, childEffect ) =
                    Authenticator.Update.update childMsg model.authenticatorModel
                changed = authenticatorModel.authenticationMaybe /= model.authenticationMaybe
                model' = { model
                    | authenticationMaybe = authenticatorModel.authenticationMaybe
                    , authenticatorModel = authenticatorModel
                    -- , cardsModel = if changed
                    --     then
                    --         Cards.init
                    --     else
                    --         model.cardsModel
                    , statementsModel = if changed
                        then
                            Statements.init
                        else
                            model.statementsModel
                    }
                (model'', effect'') = if changed
                    then
                        update (Navigate "/") model'
                    else
                        (model', Cmd.none)
            in
                model'' ! [Cmd.map AuthenticatorMsg childEffect, effect'']

        -- CardsMsg childMsg ->
        --     let
        --         ( cardsModel, childEffect ) =
        --             Cards.update childMsg model.authenticationMaybe model.cardsModel
        --     in
        --         ( { model | cardsModel = cardsModel }, Cmd.map translateCardsMsg childEffect )

        ExamplesMsg childMsg ->
            let
                ( examplesModel, childEffect ) =
                    Examples.update childMsg model.authenticationMaybe model.examplesModel
            in
                ( { model | examplesModel = examplesModel }, Cmd.map translateExamplesMsg childEffect )

        HelpMsg childMsg ->
            let
                ( helpModel, childEffect ) =
                    Help.update childMsg model.authenticationMaybe model.helpModel
            in
                ( { model | helpModel = helpModel }, Cmd.map translateHelpMsg childEffect )

        HomeMsg childMsg ->
            let
                ( homeModel, childEffect ) =
                    Home.update childMsg model.authenticationMaybe model.homeModel
            in
                ( { model | homeModel = homeModel }, Cmd.map translateHomeMsg childEffect )

        OrganizationsMsg childMsg ->
            let
                ( organizationsModel, childEffect ) =
                    Organizations.update childMsg model.authenticationMaybe model.organizationsModel
            in
                ( { model | organizationsModel = organizationsModel }, Cmd.map translateOrganizationsMsg childEffect )

        StatementsMsg childMsg ->
            let
                ( statementsModel, childEffect ) =
                    Statements.update childMsg model.authenticationMaybe model.statementsModel
            in
                ( { model | statementsModel = statementsModel }, Cmd.map translateStatementsMsg childEffect )

        ToolsMsg childMsg ->
            let
                ( toolsModel, childEffect ) =
                    Tools.update childMsg model.authenticationMaybe model.toolsModel
            in
                ( { model | toolsModel = toolsModel }, Cmd.map translateToolsMsg childEffect )


-- VIEW


view : Model -> Html Msg
view model =
    let
        profileNavItem = case model.authenticationMaybe of
            Just authentication ->
                li [] [ aForPath Navigate "/profile" [] [ text authentication.name ] ]
            Nothing ->
                text ""
        signInOrOutNavItem = case model.authenticationMaybe of
            Just authentication ->
                li [] [ aForPath Navigate "/sign_out" [] [ text "Sign Out" ] ]
            Nothing ->
                li [] [ aForPath Navigate "/sign_in" [] [ text "Sign In" ] ]
        signUpNavItem = case model.authenticationMaybe of
            Just authentication ->
                text ""
            Nothing ->
                li [] [ aForPath Navigate "/sign_up" [] [ text "Sign Up" ] ]
    in
        div []
            (
                [ header []
                    [ nav [ class "navbar navbar-default navbar-fixed-top", attribute "role" "navigation" ]
                        [ div [ class "container" ]
                            [ div [ class "navbar-header" ]
                                [ button [ attribute "aria-controls" "navbar", attribute "aria-expanded" "false", class "navbar-toggle collapsed", attribute "data-target" "#navbar", attribute "data-toggle" "collapse", type' "button" ]
                                    [ span [ class "sr-only" ]
                                        [ text "Toggle navigation" ]
                                    , span [ class "icon-bar" ]
                                        []
                                    , span [ class "icon-bar" ]
                                        []
                                    , span [ class "icon-bar" ]
                                        []
                                    ]
                                , a [ class "navbar-brand", href "#" ]
                                    [ text "OGPtoolbox" ]
                                , p [ class "navbar-text" ]
                                    [ text "tools and use cases for open government" ]
                                ]
                            , ul [ class "nav navbar-nav navbar-right" ]
                                [ profileNavItem
                                , signInOrOutNavItem
                                , signUpNavItem
                                , button [ class "btn btn-default btn-action", type' "button" ]
                                    [ text "Add new" ]
                                ]
                            ]
                        ]
                    , nav [ class "navbar navbar-inverse" ]
                        [ div [ class "container" ]
                            [ div [ class "navbar-header" ]
                                [ button [ attribute "aria-expanded" "false", class "navbar-toggle collapsed", attribute "data-target" "#bs-example-navbar-collapse-1", attribute "data-toggle" "collapse", type' "button" ]
                                    [ span [ class "sr-only" ]
                                        [ text "Toggle navigation" ]
                                    , span [ class "icon-bar" ]
                                        []
                                    , span [ class "icon-bar" ]
                                        []
                                    , span [ class "icon-bar" ]
                                        []
                                    ]
                                ]
                            , div [ class "collapse navbar-collapse", id "bs-example-navbar-collapse-1" ]
                                [ ul [ class "nav navbar-nav" ]
                                    [ li [] [ aForPath Navigate "/" [] [ text "Home" ] ]
                                    , li [] [ aForPath Navigate "/about" [] [ text "About" ] ]
                                    , li [] [ aForPath Navigate "/tools" [] [ text "Tools" ] ]
                                    , li [] [ aForPath Navigate "/examples" [] [ text "Examples" ] ]
                                    , li [] [ aForPath Navigate "/organizations" [] [ text "Organizations" ] ]
                                    , li [] [ aForPath Navigate "/help" [] [ text "Help" ] ]
                                    ]
                                , form [ class "navbar-form navbar-right" ]
                                    [ div [ class "form-group search-bar" ]
                                        [ span [ attribute "aria-hidden" "true", class "glyphicon glyphicon-search" ]
                                            []
                                        , input [ class "form-control", placeholder "Search for a tool, example or organization", type' "text" ]
                                            []
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
                ++ [ viewContent model ]
            )


viewContent : Model -> Html Msg
viewContent model =
    case model.route of
        AboutRoute ->
            Html.App.map translateAboutMsg (About.view model.authenticationMaybe model.aboutModel)

        AuthenticatorRoute subRoute ->
            Html.App.map AuthenticatorMsg (Authenticator.View.view subRoute model.authenticatorModel)

        -- CardsRoute nestedRoute ->
        --     Html.App.map translateCardsMsg (Cards.view model.authenticationMaybe model.cardsModel)

        ExamplesRoute ->
            Html.App.map translateExamplesMsg (Examples.view model.authenticationMaybe model.examplesModel)

        HelpRoute ->
            Html.App.map translateHelpMsg (Help.view model.authenticationMaybe model.helpModel)

        HomeRoute ->
            Html.App.map translateHomeMsg (Home.view model.authenticationMaybe model.homeModel)

        NotFoundRoute ->
            viewNotFound

        OrganizationsRoute ->
            Html.App.map translateOrganizationsMsg
                (Organizations.view model.authenticationMaybe model.organizationsModel)

        StatementsRoute nestedRoute ->
            Html.App.map translateStatementsMsg (Statements.view model.authenticationMaybe model.statementsModel)

        ToolsRoute ->
            Html.App.map translateToolsMsg
                (Tools.view model.authenticationMaybe model.toolsModel)


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
    -- Sub.batch
    --     -- [ Emitter.listenString "navigation" Navigate
    --     -- , Sub.map Reference (Reference.subscriptions model.reference)
    --     ]
