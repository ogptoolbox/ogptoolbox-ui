module Root.Types exposing (..)

import AddNew.Types
import AddNewCollection.Types
import Authenticator.Routes
import Authenticator.Types
import Card.Types
import Collection.Types
import Collections.Types
import I18n
import Navigation
import Routes
import Search.Types
import UserProfile.Types


type alias Model =
    { addNewModel : AddNew.Types.Model
    , addNewCollectionModel : AddNewCollection.Types.Model
    , authentication : Maybe Authenticator.Types.Authentication
    , authenticatorModel : Authenticator.Types.Model
    , authenticatorRoute : Maybe Authenticator.Routes.Route
    , cardModel : Card.Types.Model
    , collectionModel : Collection.Types.Model
    , collectionsModel : Collections.Types.Model
    , displayAddNewModal : Bool
    , location : Navigation.Location
    , navigatorLanguage : Maybe I18n.Language
    , route : Routes.Route
    , searchInputValue : String
    , searchModel : Search.Types.Model
    , signOutMsg : Maybe Msg
    , userProfileModel : UserProfile.Types.Model
    }


type Msg
    = AddNewMsg AddNew.Types.InternalMsg
    | AddNewCollectionMsg AddNewCollection.Types.InternalMsg
    | AuthenticatorMsg Authenticator.Types.InternalMsg
    | CardMsg Card.Types.InternalMsg
    | ChangeAuthenticatorRoute (Maybe Authenticator.Routes.Route)
    | CloseAuthenticatorModalAndNavigate String
    | CollectionMsg Collection.Types.InternalMsg
    | CollectionsMsg Collections.Types.InternalMsg
    | DismissAuthenticatorModal
    | DisplayAddNewModal Bool
    | LocationChanged Navigation.Location
    | Navigate String
    | NavigateBack
    | NoOp
    | PasswordChanged
    | Search
    | SearchInputChanged String
    | SearchMsg Search.Types.InternalMsg
    | SignOutImmediately
    | StartAuthenticator (Maybe Msg) Authenticator.Routes.Route
    | UserProfileMsg UserProfile.Types.InternalMsg


translateAddNewMsg : AddNew.Types.MsgTranslator Msg
translateAddNewMsg =
    AddNew.Types.translateMsg
        { onInternalMsg = AddNewMsg
        , onNavigate = Navigate
        }


translateAddNewCollectionMsg : AddNewCollection.Types.MsgTranslator Msg
translateAddNewCollectionMsg =
    AddNewCollection.Types.translateMsg
        { onInternalMsg = AddNewCollectionMsg
        , onNavigate = Navigate
        }


translateAuthenticatorMsg : Authenticator.Types.MsgTranslator Msg
translateAuthenticatorMsg =
    Authenticator.Types.translateMsg
        { onChangeRoute = ChangeAuthenticatorRoute
        , onInternalMsg = AuthenticatorMsg
        , onNavigate = CloseAuthenticatorModalAndNavigate
        , onPasswordChanged = PasswordChanged
        }


translateCardMsg : Card.Types.MsgTranslator Msg
translateCardMsg =
    Card.Types.translateMsg
        { onInternalMsg = CardMsg
        , onNavigate = Navigate
        }


translateCollectionMsg : Collection.Types.MsgTranslator Msg
translateCollectionMsg =
    Collection.Types.translateMsg
        { onInternalMsg = CollectionMsg
        , onNavigate = Navigate
        }


translateCollectionsMsg : Collections.Types.MsgTranslator Msg
translateCollectionsMsg =
    Collections.Types.translateMsg
        { onInternalMsg = CollectionsMsg
        , onNavigate = Navigate
        }


translateSearchMsg : Search.Types.MsgTranslator Msg
translateSearchMsg =
    Search.Types.translateMsg
        { onInternalMsg = SearchMsg
        , onNavigate = Navigate
        }


translateUserProfileMsg : UserProfile.Types.MsgTranslator Msg
translateUserProfileMsg =
    UserProfile.Types.translateMsg
        { onInternalMsg = UserProfileMsg
        , onNavigate = Navigate
        }
