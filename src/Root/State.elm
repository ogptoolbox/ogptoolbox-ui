module Root.State exposing (..)

import AddNew.State
import AddNewCollection.State
import AddNewCollection.Types
import Authenticator.Routes exposing (..)
import Authenticator.State
import Authenticator.Types
import Card.State
import Card.Types
import Collection.State
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
        Json.Decode.decodeValue Decoders.userDecoder flags.authentication
            |> Result.toMaybe
    , authenticatorCancelMsg = Nothing
    , authenticatorCompletionMsg = Nothing
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


navigate : String -> String -> Cmd msg
navigate currentPath path =
    if currentPath /= path then
        Navigation.newUrl path
    else
        Cmd.none


requireSignIn : Msg -> Model -> ( Model, Cmd Msg )
requireSignIn signOutMsg model =
    let
        newModel =
            { model | signOutMsg = Just signOutMsg }
    in
        if model.authentication == Nothing then
            update (StartAuthenticator (Just NavigateBack) Nothing SignInRoute) newModel
        else
            ( newModel, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    -- TODO Fix duplicate messages with port "fileContentRead", that was worked around by a "ImageSelectedStatus"
    -- constructor.
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
                in
                    ( { model | authenticatorModel = authenticatorModel }
                    , Cmd.map translateAuthenticatorMsg childCmd
                    )

            AuthenticatorTerminated route result ->
                case result of
                    Err () ->
                        ( { model
                            | authenticatorCancelMsg = Nothing
                            , authenticatorCompletionMsg = Nothing
                            , authenticatorRoute = Nothing
                          }
                        , case model.authenticatorCancelMsg of
                            Just cancelMsg ->
                                Task.perform (\_ -> cancelMsg) (Task.succeed ())

                            Nothing ->
                                Cmd.none
                        )

                    Ok authentication ->
                        { model
                            | authentication = authentication
                            , authenticatorCancelMsg = Nothing
                            , authenticatorCompletionMsg = Nothing
                            , authenticatorRoute = Nothing
                        }
                            ! [ Ports.storeAuthentication authentication
                              , case model.authenticatorCompletionMsg of
                                    Just completionMsg ->
                                        Task.perform (\_ -> completionMsg) (Task.succeed ())

                                    Nothing ->
                                        -- Don't use navigate to force a page reload.
                                        Navigation.modifyUrl
                                            (case route of
                                                ChangePasswordRoute _ ->
                                                    Urls.languagePath language "/profile"

                                                _ ->
                                                    model.location.href
                                            )
                              ]

            CardMsg childMsg ->
                let
                    ( cardModel, childCmd ) =
                        Card.State.update childMsg model.cardModel model.authentication language
                in
                    ( { model | cardModel = cardModel }
                    , Cmd.map translateCardMsg childCmd
                    )

            ChangeAuthenticatorRoute authenticatorRoute ->
                ( { model | authenticatorRoute = Just authenticatorRoute }
                , Cmd.none
                )

            CloseAuthenticatorModalAndNavigate path ->
                ( { model | authenticatorRoute = Nothing }
                , navigate model.location.href path
                )

            CollectionMsg childMsg ->
                let
                    ( collectionModel, childCmd ) =
                        Collection.State.update childMsg model.collectionModel
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

            DisplayAddNewModal displayAddNewModal ->
                ( { model | displayAddNewModal = displayAddNewModal }
                , Cmd.none
                )

            LocationChanged location ->
                urlUpdate location model

            Navigate path ->
                ( model, navigate model.location.href path )

            NavigateBack ->
                ( model, Navigation.back 1 )

            NoOp ->
                ( model, Cmd.none )

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

                    path =
                        "/tools?"
                            ++ (keptParams
                                    |> List.map (\( k, v ) -> k ++ "=" ++ v)
                                    |> String.join "&"
                               )

                    cmd =
                        navigate model.location.href path
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
                    newModel =
                        { model
                            | authenticatorCancelMsg = Nothing
                            , authenticatorCompletionMsg = model.signOutMsg
                        }
                in
                    update (AuthenticatorMsg Authenticator.Types.signOutMsg) newModel

            StartAuthenticator cancelMsg completionMsg authenticatorRoute ->
                if model.authenticatorRoute == Nothing then
                    ( { model
                        | authenticatorCancelMsg = cancelMsg
                        , authenticatorCompletionMsg = completionMsg
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
                                                    Collection.State.urlUpdate
                                                        model.authentication
                                                        language
                                                        collectionId
                                                        model.collectionModel
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

                                PressRoute ->
                                    ( { model | signOutMsg = Nothing }
                                    , Ports.setDocumentMetadata
                                        { description = I18n.translate language I18n.PressDescription
                                        , imageUrl = Urls.appLogoFullUrl
                                        , title = I18n.translate language I18n.Press
                                        }
                                    )

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
                                                (Navigate (Urls.languagePath language "/"))
                                                model

                                        -- TODO: Everybody can see the collections, but he can't see everything nor edit
                                        -- it.
                                        ( userProfileModel, childCmd ) =
                                            case model1.authentication of
                                                Just authentication ->
                                                    UserProfile.State.update
                                                        (UserProfile.Types.LoadCollections authentication.urlName)
                                                        model1.userProfileModel
                                                        authentication
                                                        language

                                                Nothing ->
                                                    ( model1.userProfileModel, Cmd.none )
                                    in
                                        { model1 | userProfileModel = userProfileModel }
                                            ! [ cmd1
                                              , Cmd.map translateUserProfileMsg childCmd
                                              ]
                    in
                        ( { localizedModel | route = route }, localizedCmd )

                Just ((I18nRouteWithoutLanguage path) as route) ->
                    let
                        language =
                            model.navigatorLanguage |> Maybe.withDefault I18n.English

                        command =
                            Urls.languagePath language
                                (path ++ (Urls.queryStringForParams [ "q", "tagIds" ] location))
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
                            Result.Err err ->
                                Debug.crash ("Dom.Scroll.toTop \"html-element\": " ++ toString err)

                            Result.Ok _ ->
                                NoOp
                    )
                    (Dom.Scroll.toTop "html-element")
              , cmd
              ]
