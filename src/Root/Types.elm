module Root.Types exposing (..)

import Authenticator.Routes
import Authenticator.Types exposing (Authentication)
import Cards.Item.Types
import Cards.New.Types
import Collections.Edit.Types
import Collections.Item.Types
import Collections.Index.Types
import I18n
import Navigation
import Routes
import Search.Types
import UserProfile.Types


type alias Model =
    { authentication : Maybe Authentication
    , authenticatorCancelMsg : Maybe Msg
    , authenticatorCompletionMsg : Maybe Msg
    , authenticatorModel : Authenticator.Types.Model
    , authenticatorRoute : Maybe Authenticator.Routes.Route
    , cardModel : Cards.Item.Types.Model
    , collectionEditModel : Collections.Edit.Types.Model
    , collectionModel : Collections.Item.Types.Model
    , collectionsModel : Collections.Index.Types.Model
    , displayNewCardModal : Bool
    , location : Navigation.Location
    , navigatorLanguage : Maybe I18n.Language
    , newCardModel : Cards.New.Types.Model
    , route : Routes.Route
    , searchInputValue : String
    , searchModel : Search.Types.Model
    , signOutMsg : Maybe Msg
    , userProfileModel : UserProfile.Types.Model
    }


type Msg
    = AuthenticatorMsg Authenticator.Types.InternalMsg
    | AuthenticatorTerminated Authenticator.Routes.Route (Result () (Maybe Authentication))
    | CardMsg Cards.Item.Types.InternalMsg
    | ChangeAuthenticatorRoute Authenticator.Routes.Route
    | CloseAuthenticatorModalAndNavigate String
    | CollectionMsg Collections.Item.Types.InternalMsg
    | CollectionsMsg Collections.Index.Types.InternalMsg
    | DisplayNewCardModal Bool
    | EditCollectionMsg Collections.Edit.Types.InternalMsg
    | LocationChanged Navigation.Location
    | Navigate String
    | NavigateBack
    | NewCardMsg Cards.New.Types.InternalMsg
    | NoOp
    | Search
    | SearchInputChanged String
    | SearchMsg Search.Types.InternalMsg
    | SignOutImmediately
    | StartAuthenticator (Maybe Msg) (Maybe Msg) Authenticator.Routes.Route
    | UserProfileMsg UserProfile.Types.InternalMsg


translateNewCardMsg : Cards.New.Types.MsgTranslator Msg
translateNewCardMsg =
    Cards.New.Types.translateMsg
        { onInternalMsg = NewCardMsg
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


translateCardMsg : Cards.Item.Types.MsgTranslator Msg
translateCardMsg =
    Cards.Item.Types.translateMsg
        { onInternalMsg = CardMsg
        , onNavigate = Navigate
        }


translateEditCollectionMsg : Collections.Edit.Types.MsgTranslator Msg
translateEditCollectionMsg =
    Collections.Edit.Types.translateMsg
        { onInternalMsg = EditCollectionMsg
        , onNavigate = Navigate
        }


translateCollectionMsg : Collections.Item.Types.MsgTranslator Msg
translateCollectionMsg =
    Collections.Item.Types.translateMsg
        { onInternalMsg = CollectionMsg
        , onNavigate = Navigate
        }


translateCollectionsMsg : Collections.Index.Types.MsgTranslator Msg
translateCollectionsMsg =
    Collections.Index.Types.translateMsg
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
