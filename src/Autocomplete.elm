module Autocomplete
    exposing
        ( empty
        , HtmlDetails
        , KeySelected
        , MouseSelected
        , Msg
        , reset
        , resetToFirstItem
        , resetToLastItem
        , State
        , subscription
        , update
        , UpdateConfig
        , view
        , ViewConfig
        )

import Char exposing (KeyCode)
import Html exposing (Html, Attribute)
import Html.Attributes
import Html.Events
import Html.Keyed
import Keyboard


-- MODEL


type alias KeySelected =
    Bool


type alias MouseSelected =
    Bool


type alias State =
    { key : Maybe String
    , mouse : Maybe String
    }


empty : State
empty =
    { key = Nothing, mouse = Nothing }


reset : UpdateConfig msg data -> State -> State
reset { separateSelections } { key, mouse } =
    if separateSelections then
        { key = Nothing, mouse = mouse }
    else
        empty


resetToFirst : UpdateConfig msg data -> List data -> State -> State
resetToFirst config data state =
    let
        { getItemId, separateSelections } =
            config

        setFirstItem datum newState =
            { newState | key = Just <| getItemId datum }
    in
        case List.head data of
            Nothing ->
                empty

            Just datum ->
                if separateSelections then
                    reset config state
                        |> setFirstItem datum
                else
                    empty
                        |> setFirstItem datum


resetToFirstItem : UpdateConfig msg data -> List data -> Int -> State -> State
resetToFirstItem config data howManyToShow state =
    resetToFirst config (List.take howManyToShow data) state


resetToLastItem : UpdateConfig msg data -> List data -> Int -> State -> State
resetToLastItem config data howManyToShow state =
    let
        reversedData =
            List.reverse <| List.take howManyToShow data
    in
        resetToFirst config reversedData state



-- UPDATE


type Msg
    = Focus String
    | KeyDown KeyCode
    | MouseEnter String
    | MouseLeave String
    | MouseClick String


type alias UpdateConfig msg data =
    { getItemId : data -> String
    , onFocus : String -> Maybe msg
    , onKeyDown : KeyCode -> Maybe String -> Maybe msg
    , onMouseClick : String -> Maybe msg
    , onMouseEnter : String -> Maybe msg
    , onMouseLeave : String -> Maybe msg
    , onTooHigh : Maybe msg
    , onTooLow : Maybe msg
    , separateSelections : Bool
    }


getNextItemId : List String -> String -> String
getNextItemId ids selectedId =
    Maybe.withDefault selectedId <| List.foldl (getPrevious selectedId) Nothing ids


getPrevious : String -> String -> Maybe String -> Maybe String
getPrevious id selectedId resultId =
    if selectedId == id then
        Just id
    else if (Maybe.withDefault "" resultId) == id then
        Just selectedId
    else
        resultId


getPreviousItemId : List String -> String -> String
getPreviousItemId ids selectedId =
    Maybe.withDefault selectedId <| List.foldr (getPrevious selectedId) Nothing ids


navigateWithKey : Int -> List String -> Maybe String -> Maybe String
navigateWithKey code ids maybeId =
    case code of
        38 ->
            Maybe.map (getPreviousItemId ids) maybeId

        40 ->
            Maybe.map (getNextItemId ids) maybeId

        _ ->
            maybeId


resetMouseStateWithId : Bool -> String -> State -> State
resetMouseStateWithId separateSelections id state =
    if separateSelections then
        { key = state.key, mouse = Just id }
    else
        { key = Just id, mouse = Just id }


update : UpdateConfig msg data -> Msg -> Int -> State -> List data -> ( State, Maybe msg )
update config msg howManyToShow state data =
    case msg of
        Focus id ->
            ( state, config.onFocus id )

        KeyDown keyCode ->
            let
                boundedList =
                    List.map config.getItemId data
                        |> List.take howManyToShow

                newKey =
                    navigateWithKey keyCode boundedList state.key
            in
                if newKey == state.key && keyCode == 38 then
                    ( state
                    , config.onTooHigh
                    )
                else if newKey == state.key && keyCode == 40 then
                    ( state
                    , config.onTooLow
                    )
                else if config.separateSelections then
                    ( { state | key = newKey }
                    , config.onKeyDown keyCode newKey
                    )
                else
                    ( { key = newKey, mouse = newKey }
                    , config.onKeyDown keyCode newKey
                    )

        MouseClick id ->
            ( resetMouseStateWithId config.separateSelections id state
            , config.onMouseClick id
            )

        MouseEnter id ->
            ( resetMouseStateWithId config.separateSelections id state
            , config.onMouseEnter id
            )

        MouseLeave id ->
            ( resetMouseStateWithId config.separateSelections id state
            , config.onMouseLeave id
            )



-- VIEW


type alias HtmlDetails msg =
    { attributes : List (Attribute msg)
    , children : List (Html msg)
    }


type alias ViewConfig data =
    { getItemId : data -> String
    , menuId : String
    , viewItemContent : data -> List (Html Never)
    }


keyedDiv : List (Attribute Msg) -> List ( String, Html Msg ) -> Html Msg
keyedDiv attributes children =
    (Html.Keyed.node "li") attributes children


view : ViewConfig data -> Int -> State -> List data -> Html Msg
view config howManyToShow state data =
    Html.div [ Html.Attributes.class "dropdown open", Html.Attributes.id config.menuId ]
        [ viewList config howManyToShow state data ]


viewItem : ViewConfig data -> State -> data -> Html Msg
viewItem { getItemId, viewItemContent } { key, mouse } data =
    let
        id =
            getItemId data

        isSelected maybeId =
            case maybeId of
                Just someId ->
                    someId == id

                Nothing ->
                    False
    in
        Html.li
            ([ Html.Attributes.id id
             , Html.Events.onFocus (Focus id)
             , Html.Events.onMouseEnter (MouseEnter id)
             , Html.Events.onMouseLeave (MouseLeave id)
             , Html.Events.onClick (MouseClick id)
             ]
                ++ if (isSelected key) || (isSelected mouse) then
                    -- Dirty hack, because I don't succeed to change the color of the active menu item using other ways.
                    [ Html.Attributes.style [ ( "background-color", "#ddd" ) ] ]
                   else
                    []
            )
            (List.map (Html.map never) (viewItemContent data))


viewList : ViewConfig data -> Int -> State -> List data -> Html Msg
viewList config howManyToShow state data =
    let
        getKeyedItems datum =
            ( config.getItemId datum, viewItem config state datum )
    in
        keyedDiv [ Html.Attributes.class "dropdown-menu" ]
            (List.take howManyToShow data
                |> List.map getKeyedItems
            )



-- SUBSCRIPTIONS


{-| Add this to your `program`s subscriptions to animate the spinner.
-}
subscription : Sub Msg
subscription =
    Keyboard.downs KeyDown
