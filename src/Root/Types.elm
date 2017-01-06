module Root.Types exposing (..)

import AddNew.Types
import Authenticator.Routes
import Authenticator.Types exposing (Authentication)
import Card.Types
import Collection.Types
import CollectionEdit.Types
import Collections.Types
import I18n
import Navigation
import Routes
import Search.Types
import UserProfile.Types


type alias Model =
    { addNewModel : AddNew.Types.Model
    , authentication : Maybe Authentication
    , authenticatorCancelMsg : Maybe Msg
    , authenticatorCompletionMsg : Maybe Msg
    , authenticatorModel : Authenticator.Types.Model
    , authenticatorRoute : Maybe Authenticator.Routes.Route
    , cardModel : Card.Types.Model
    , collectionEditModel : CollectionEdit.Types.Model
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
    | AuthenticatorMsg Authenticator.Types.InternalMsg
    | AuthenticatorTerminated Authenticator.Routes.Route (Result () (Maybe Authentication))
    | CardMsg Card.Types.InternalMsg
    | ChangeAuthenticatorRoute Authenticator.Routes.Route
    | CloseAuthenticatorModalAndNavigate String
    | CollectionEditMsg CollectionEdit.Types.InternalMsg
    | CollectionMsg Collection.Types.InternalMsg
    | CollectionsMsg Collections.Types.InternalMsg
    | DisplayAddNewModal Bool
    | LocationChanged Navigation.Location
    | Navigate String
    | NavigateBack
    | NoOp
    | Search
    | SearchInputChanged String
    | SearchMsg Search.Types.InternalMsg
    | SignOutImmediately
    | StartAuthenticator (Maybe Msg) (Maybe Msg) Authenticator.Routes.Route
    | UserProfileMsg UserProfile.Types.InternalMsg


translateAddNewMsg : AddNew.Types.MsgTranslator Msg
translateAddNewMsg =
    AddNew.Types.translateMsg
        { onInternalMsg = AddNewMsg
        , onNavigate = Navigate
        }


translateAuthenticatorMsg : Authenticator.Types.MsgTranslator Msg
translateAuthenticatorMsg =
    Authenticator.Types.translateMsg
        { onChangeRoute = ChangeAuthenticatorRoute
        , onInternalMsg = AuthenticatorMsg
        , onNavigate = CloseAuthenticatorModalAndNavigate
        , onTerminated = AuthenticatorTerminated
        }


translateCardMsg : Card.Types.MsgTranslator Msg
translateCardMsg =
    Card.Types.translateMsg
        { onInternalMsg = CardMsg
        , onNavigate = Navigate
        }


translateCollectionEditMsg : CollectionEdit.Types.MsgTranslator Msg
translateCollectionEditMsg =
    CollectionEdit.Types.translateMsg
        { onInternalMsg = CollectionEditMsg
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
