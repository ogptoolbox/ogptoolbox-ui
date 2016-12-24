module Root.State exposing (..)

import AddNew.State
import AddNewCollection.State
import AddNewCollection.Types
import Authenticator.Routes
import Authenticator.State
import Authenticator.Types
import Card.State
import Card.Types
import Collection.State
import Collection.Types
import Collections.State
import Collections.Types
import Decoders
import Dict exposing (Dict)
import Dom.Scroll
import Erl
import Json.Decode
import I18n
import Navigation
import Ports
import Root.Types exposing (..)
import Routes exposing (..)
import Search.State
import Search.Types
import UserProfile.State
import UserProfile.Types
import Task
import Types exposing (..)
import Urls


init : Flags -> Navigation.Location -> ( Model, Cmd Msg )
init flags location =
    { addNewModel = AddNew.State.init
    , addNewCollectionModel = AddNewCollection.State.init
    , authentication =
        Json.Decode.decodeValue Decoders.userForPortDecoder flags.authentication
            |> Result.toMaybe
    , authenticatorModel = Authenticator.State.init
    , authenticatorRoute = Nothing
    , cardModel = Card.State.init
    , collectionModel = Collection.State.init
    , collectionsModel = Collections.State.init
    , displayAddNewModal = False
    , location = location
    , navigatorLanguage =
        flags.language
            |> String.left 2
            |> String.toLower
            |> I18n.languageFromIso639_1
    , route = I18nRouteWithoutLanguage ""
    , searchInputValue = ""
    , searchModel = Search.State.init
    , signOutMsg = Nothing
    , userProfileModel = UserProfile.State.init
    }
        |> update (LocationChanged location)


navigateAfterSignOut : Model -> Cmd Msg
navigateAfterSignOut model =
    case model.signOutMsg of
        Just signOutMsg ->
            -- Execute sign out message to redirect to a new location.
            Task.perform (\_ -> signOutMsg) (Task.succeed ())

        Nothing ->
            -- Force page reload when sign out stays at the same location.
            Navigation.modifyUrl model.location.href


requireSignIn : Msg -> Model -> ( Model, Cmd Msg )
requireSignIn signOutMsg model =
    if model.authentication == Nothing then
        update (StartAuthenticator (Just NavigateBack) Authenticator.Routes.SignInRoute) model
    else
        ( { model | signOutMsg = Just signOutMsg }
        , Cmd.none
        )


subscriptions : Model -> Sub Msg
subscriptions model =
    -- TODO Fix duplicate messages with port "fileContentRead", that was worked around by a "Selected" constructor.
    Sub.batch
        [ Sub.map AddNewMsg (AddNew.State.subscriptions model.addNewModel)
        , Sub.map AddNewCollectionMsg (AddNewCollection.State.subscriptions model.addNewCollectionModel)
        , Sub.map SearchMsg (Search.State.subscriptions model.searchModel)
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        language =
            case model.route of
                I18nRouteWithLanguage language _ ->
                    language

                _ ->
                    I18n.English

        navigate urlPath =
            let
                currentUrlPath =
                    model.location.href
            in
                if currentUrlPath /= urlPath then
                    Navigation.newUrl urlPath
                else
                    Cmd.none
    in
        case msg of
            AddNewMsg childMsg ->
                let
                    ( addNewModel, childCmd ) =
                        AddNew.State.update childMsg model.addNewModel model.authentication language
                in
                    ( { model | addNewModel = addNewModel }
                    , Cmd.map translateAddNewMsg childCmd
                    )

            AddNewCollectionMsg childMsg ->
                let
                    ( addNewCollectionModel, childCmd ) =
                        AddNewCollection.State.update
                            childMsg
                            model.addNewCollectionModel
                            model.authentication
                            language
                in
                    ( { model | addNewCollectionModel = addNewCollectionModel }
                    , Cmd.map translateAddNewCollectionMsg childCmd
                    )

            AuthenticatorMsg childMsg ->
                let
                    ( authenticatorModel, childCmd ) =
                        Authenticator.State.update childMsg model.authenticatorModel language

                    changed =
                        authenticatorModel.authentication /= model.authentication

                    model_ =
                        { model
                            | authentication = authenticatorModel.authentication
                            , authenticatorModel = authenticatorModel
                            , authenticatorRoute =
                                if changed then
                                    Nothing
                                else
                                    model.authenticatorRoute
                        }
                in
                    ( model_, Cmd.map translateAuthenticatorMsg childCmd )

            CardMsg childMsg ->
                let
                    ( cardModel, childCmd ) =
                        Card.State.update childMsg model.cardModel model.authentication language
                in
                    ( { model | cardModel = cardModel }
                    , Cmd.map translateCardMsg childCmd
                    )

            ChangeAuthenticatorRoute authenticatorRoute ->
                ( { model | authenticatorRoute = authenticatorRoute }
                , if authenticatorRoute == Nothing then
                    if model.authentication == Nothing then
                        navigateAfterSignOut model
                    else
                        -- Force page reload when authentication modal closes.
                        Navigation.modifyUrl model.location.href
                  else
                    Cmd.none
                )

            CloseAuthenticatorModalAndNavigate urlPath ->
                ( { model | authenticatorRoute = Nothing }
                , navigate urlPath
                )

            CollectionMsg childMsg ->
                let
                    ( collectionModel, childCmd ) =
                        Collection.State.update childMsg model.collectionModel model.authentication language
                in
                    ( { model | collectionModel = collectionModel }
                    , Cmd.map translateCollectionMsg childCmd
                    )

            CollectionsMsg childMsg ->
                let
                    ( collectionsModel, childCmd ) =
                        Collections.State.update childMsg model.collectionsModel model.authentication language
                in
                    ( { model | collectionsModel = collectionsModel }
                    , Cmd.map translateCollectionsMsg childCmd
                    )

            DismissAuthenticatorModal ->
                let
                    newModel =
                        { model | authenticatorRoute = Nothing }
                in
                    case model.signOutMsg of
                        Just signOutMsg ->
                            update signOutMsg newModel

                        Nothing ->
                            ( newModel, Cmd.none )

            DisplayAddNewModal displayAddNewModal ->
                ( { model | displayAddNewModal = displayAddNewModal }
                , Cmd.none
                )

            LocationChanged location ->
                urlUpdate location model

            Navigate urlPath ->
                ( model, navigate urlPath )

            NavigateBack ->
                ( model, Navigation.back 1 )

            NoOp ->
                ( model, Cmd.none )

            PasswordChanged ->
                ( model, navigate <| Urls.absoluteUrlPathWithLanguage language "/profile" )

            Search ->
                let
                    keptParams =
                        ( "q", model.searchInputValue )
                            :: (case Urls.querySingleParameter "tagIds" model.location of
                                    Nothing ->
                                        []

                                    Just tagIds ->
                                        [ ( "tagIds", tagIds ) ]
                               )

                    urlPath =
                        "/tools?"
                            ++ (keptParams
                                    |> List.map (\( k, v ) -> k ++ "=" ++ v)
                                    |> String.join "&"
                               )

                    cmd =
                        navigate urlPath
                in
                    ( model, cmd )

            SearchInputChanged searchInputValue ->
                ( { model | searchInputValue = searchInputValue }, Cmd.none )

            SearchMsg childMsg ->
                let
                    ( newSearchModel, childCmd ) =
                        Search.State.update
                            childMsg
                            model.searchModel
                            model.authentication
                            language
                            model.location

                    newModel =
                        { model | searchModel = newSearchModel }
                in
                    ( newModel
                    , Cmd.map translateSearchMsg childCmd
                    )

            SignOutImmediately ->
                let
                    ( model1, cmd1 ) =
                        update (AuthenticatorMsg Authenticator.Types.signOutMsg) model
                in
                    model1 ! [ cmd1, navigateAfterSignOut model ]

            StartAuthenticator onCancel authenticatorRoute ->
                if model.authenticatorRoute == Nothing then
                    ( { model
                        | signOutMsg = onCancel
                        , authenticatorRoute = Just authenticatorRoute
                      }
                    , Cmd.none
                    )
                else
                    -- Don't start a new authenticator session when one is pending.
                    ( model, Cmd.none )

            UserProfileMsg childMsg ->
                let
                    authentication =
                        case model.authentication of
                            Nothing ->
                                Debug.crash "prevented by viewNotAuthorized"

                            Just authentication ->
                                authentication

                    ( newUserProfileModel, childCmd ) =
                        UserProfile.State.update childMsg model.userProfileModel authentication language

                    newModel =
                        { model | userProfileModel = newUserProfileModel }
                in
                    ( newModel
                    , Cmd.map translateUserProfileMsg childCmd
                    )


urlUpdate : Navigation.Location -> Model -> ( Model, Cmd Msg )
urlUpdate location model =
    let
        searchQuery =
            Urls.querySearchTerm location

        ( newModel, cmd ) =
            case parseLocation location of
                Just ((I18nRouteWithLanguage language localizedRoute) as route) ->
                    let
                        indexRoute titleSymbol descriptionSymbol =
                            let
                                getLocalizedString value =
                                    case value.value of
                                        LocalizedStringValue valueByLanguage ->
                                            case I18n.getValueByPreferredLanguage language valueByLanguage of
                                                Nothing ->
                                                    Debug.crash "indexRoute"

                                                Just tag ->
                                                    tag

                                        _ ->
                                            Debug.crash "indexRoute"

                                selectedTags =
                                    case Urls.querySingleParameter "tagIds" location of
                                        Nothing ->
                                            []

                                        Just tagIds ->
                                            tagIds
                                                |> String.split ","
                                                |> List.map
                                                    (\tagId ->
                                                        { count = 50
                                                        , tag = ""
                                                        , tagId = tagId
                                                        }
                                                    )

                                searchModel =
                                    model.searchModel

                                newSearchModel =
                                    { searchModel | selectedTags = selectedTags }

                                ( newSearchModel2, searchCmd ) =
                                    Search.State.update
                                        Search.Types.Load
                                        newSearchModel
                                        model.authentication
                                        language
                                        location

                                newModel =
                                    { model
                                        | searchModel = newSearchModel2
                                        , searchInputValue = searchQuery
                                    }
                            in
                                newModel
                                    ! [ Cmd.map translateSearchMsg searchCmd
                                      , Ports.setDocumentMetadata
                                            { description = I18n.translate language descriptionSymbol
                                            , imageUrl = Urls.appLogoFullUrl
                                            , title = I18n.translate language titleSymbol
                                            }
                                      ]

                        ( localizedModel, localizedCmd ) =
                            case localizedRoute of
                                AboutRoute ->
                                    ( { model | signOutMsg = Nothing }
                                    , Ports.setDocumentMetadata
                                        { description = I18n.translate language I18n.AboutDescription
                                        , imageUrl = Urls.appLogoFullUrl
                                        , title = I18n.translate language I18n.About
                                        }
                                    )

                                AuthenticatorRoute route ->
                                    let
                                        ( authenticatorModel, childCmd ) =
                                            Authenticator.State.urlUpdate
                                                language
                                                location
                                                route
                                                model.authenticatorModel
                                    in
                                        ( { model
                                            | authenticatorModel = authenticatorModel
                                            , signOutMsg = Nothing
                                          }
                                        , Cmd.map translateAuthenticatorMsg childCmd
                                        )

                                CollectionsRoute childRoute ->
                                    case childRoute of
                                        CollectionRoute collectionId ->
                                            let
                                                ( collectionModel, childCmd ) =
                                                    Collection.State.update
                                                        (Collection.Types.LoadCollection collectionId)
                                                        model.collectionModel
                                                        model.authentication
                                                        language
                                            in
                                                ( { model
                                                    | collectionModel = collectionModel
                                                    , signOutMsg = Nothing
                                                  }
                                                , Cmd.map translateCollectionMsg childCmd
                                                )

                                        CollectionsIndexRoute ->
                                            let
                                                ( collectionsModel, childCmd ) =
                                                    Collections.State.update
                                                        Collections.Types.LoadCollections
                                                        model.collectionsModel
                                                        model.authentication
                                                        language
                                            in
                                                ( { model
                                                    | collectionsModel = collectionsModel
                                                    , signOutMsg = Nothing
                                                  }
                                                , Cmd.map translateCollectionsMsg childCmd
                                                )

                                        EditCollectionRoute collectionId ->
                                            let
                                                ( model1, cmd1 ) =
                                                    requireSignIn
                                                        (Navigate (Urls.parentUrl location.href))
                                                        model

                                                -- TODO: Only the owner of the collection and an admin can edit it.
                                                ( addNewCollectionModel, childCmd ) =
                                                    AddNewCollection.State.update
                                                        (AddNewCollection.Types.LoadCollection collectionId)
                                                        model1.addNewCollectionModel
                                                        model1.authentication
                                                        language
                                            in
                                                { model1
                                                    | addNewCollectionModel = addNewCollectionModel
                                                }
                                                    ! [ cmd1
                                                      , Cmd.map translateAddNewCollectionMsg childCmd
                                                      ]

                                        NewCollectionRoute ->
                                            requireSignIn (Navigate (Urls.parentUrl location.href)) model

                                FaqRoute ->
                                    ( model
                                    , Ports.setDocumentMetadata
                                        { description = I18n.translate language I18n.FaqDescription
                                        , imageUrl = Urls.appLogoFullUrl
                                        , title = I18n.translate language I18n.Faq
                                        }
                                    )

                                HomeRoute ->
                                    indexRoute I18n.HomeTitle I18n.HomeDescription

                                NotFoundRoute _ ->
                                    ( model
                                    , Ports.setDocumentMetadata
                                        { description = I18n.translate language I18n.PageNotFoundDescription
                                        , imageUrl = Urls.appLogoFullUrl
                                        , title = I18n.translate language I18n.PageNotFound
                                        }
                                    )

                                OrganizationsRoute childRoute ->
                                    case childRoute of
                                        OrganizationRoute cardId ->
                                            let
                                                ( cardModel, childCmd ) =
                                                    Card.State.update
                                                        (Card.Types.LoadCard cardId)
                                                        model.cardModel
                                                        model.authentication
                                                        language

                                                newModel =
                                                    { model | cardModel = cardModel }
                                            in
                                                ( model, Cmd.map translateCardMsg childCmd )

                                        OrganizationsIndexRoute ->
                                            indexRoute (I18n.Organization I18n.Plural) I18n.OrganizationsDescription

                                        NewOrganizationRoute ->
                                            let
                                                ( model1, cmd1 ) =
                                                    requireSignIn
                                                        (Navigate (Urls.parentUrl location.href))
                                                        model

                                                addNewModel =
                                                    model1.addNewModel

                                                newAddNewModel =
                                                    { addNewModel
                                                        | fields = Dict.fromList [ ( "Types", "organization" ) ]
                                                    }
                                            in
                                                { model1 | addNewModel = newAddNewModel }
                                                    ! [ cmd1
                                                      , Ports.setDocumentMetadata
                                                            { description =
                                                                I18n.translate
                                                                    language
                                                                    I18n.AddNewOrganizationDescription
                                                            , imageUrl = Urls.appLogoFullUrl
                                                            , title = I18n.translate language I18n.AddNewOrganization
                                                            }
                                                      ]

                                ToolsRoute childRoute ->
                                    case childRoute of
                                        ToolRoute cardId ->
                                            let
                                                ( cardModel, childCmd ) =
                                                    Card.State.update
                                                        (Card.Types.LoadCard cardId)
                                                        model.cardModel
                                                        model.authentication
                                                        language

                                                newModel =
                                                    { model | cardModel = cardModel }
                                            in
                                                ( model, Cmd.map translateCardMsg childCmd )

                                        ToolsIndexRoute ->
                                            indexRoute (I18n.Tool I18n.Plural) I18n.ToolsDescription

                                        NewToolRoute ->
                                            let
                                                ( model1, cmd1 ) =
                                                    requireSignIn
                                                        (Navigate (Urls.parentUrl location.href))
                                                        model

                                                addNewModel =
                                                    model1.addNewModel

                                                newAddNewModel =
                                                    { addNewModel
                                                        | fields = Dict.fromList [ ( "Types", "software" ) ]
                                                    }
                                            in
                                                { model1 | addNewModel = newAddNewModel }
                                                    ! [ cmd1
                                                      , Ports.setDocumentMetadata
                                                            { description =
                                                                I18n.translate language I18n.AddNewToolDescription
                                                            , imageUrl = Urls.appLogoFullUrl
                                                            , title = I18n.translate language I18n.AddNewTool
                                                            }
                                                      ]

                                UseCasesRoute childRoute ->
                                    case childRoute of
                                        UseCaseRoute cardId ->
                                            let
                                                ( cardModel, childCmd ) =
                                                    Card.State.update
                                                        (Card.Types.LoadCard cardId)
                                                        model.cardModel
                                                        model.authentication
                                                        language

                                                newModel =
                                                    { model | cardModel = cardModel }
                                            in
                                                ( model, Cmd.map translateCardMsg childCmd )

                                        UseCasesIndexRoute ->
                                            indexRoute (I18n.UseCase I18n.Plural) I18n.UseCasesDescription

                                        NewUseCaseRoute ->
                                            let
                                                ( model1, cmd1 ) =
                                                    requireSignIn
                                                        (Navigate (Urls.parentUrl location.href))
                                                        model

                                                addNewModel =
                                                    model1.addNewModel

                                                newAddNewModel =
                                                    { addNewModel
                                                        | fields = Dict.fromList [ ( "Types", "use-case" ) ]
                                                    }
                                            in
                                                { model1 | addNewModel = newAddNewModel }
                                                    ! [ cmd1
                                                      , Ports.setDocumentMetadata
                                                            { description =
                                                                I18n.translate language I18n.AddNewUseCaseDescription
                                                            , title = I18n.translate language I18n.AddNewUseCase
                                                            , imageUrl = Urls.appLogoFullUrl
                                                            }
                                                      ]

                                UserProfileRoute ->
                                    let
                                        ( model1, cmd1 ) =
                                            requireSignIn
                                                -- Logout => Home
                                                (Navigate (Urls.absoluteUrlPathWithLanguage language "/"))
                                                model

                                        -- TODO: Everybody can see the collections, but he can't see everything nor edit
                                        -- it.
                                        authentication =
                                            case model1.authentication of
                                                Nothing ->
                                                    Debug.crash "prevented by viewNotAuthorized"

                                                Just authentication ->
                                                    authentication

                                        ( userProfileModel, childCmd ) =
                                            UserProfile.State.update
                                                (UserProfile.Types.LoadCollections authentication.urlName)
                                                model1.userProfileModel
                                                authentication
                                                language
                                    in
                                        { model1 | userProfileModel = userProfileModel }
                                            ! [ cmd1
                                              , Cmd.map translateUserProfileMsg childCmd
                                              ]
                    in
                        ( { localizedModel | route = route }, localizedCmd )

                Just ((I18nRouteWithoutLanguage urlPath) as route) ->
                    let
                        language =
                            model.navigatorLanguage |> Maybe.withDefault I18n.English

                        command =
                            Urls.absoluteUrlPathWithLanguage language
                                (urlPath ++ (Urls.queryStringForParams [ "q", "tagIds" ] location))
                                |> Navigation.modifyUrl
                    in
                        ( { model | route = route }, command )

                Nothing ->
                    let
                        language =
                            model.navigatorLanguage |> Maybe.withDefault I18n.English

                        url =
                            location.href
                                |> Erl.parse

                        newUrl =
                            { url | path = (I18n.iso639_1FromLanguage language) :: url.path }
                    in
                        ( model, Navigation.modifyUrl (Erl.toString newUrl) )
    in
        { newModel | location = location }
            ! [ Task.attempt
                    (\result ->
                        case result of
                            Result.Err _ ->
                                Debug.crash "Dom.Scroll.toTop \"html-element\""

                            Result.Ok _ ->
                                NoOp
                    )
                    (Dom.Scroll.toTop "html-element")
              , cmd
              ]
