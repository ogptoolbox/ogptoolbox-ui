module I18n exposing (..)

import Constants
import Dict exposing (Dict)
import String
import Types exposing (..)


-- STRINGS TO TRANSLATE
-- for translators who want to internationalize the application


type TranslationId
    = About
    | AddNew
    | AddNewCollectionCatchPhrase
    | AddNewExample
    | AddNewExampleCatchPhrase
    | AddNewTool
    | AddNewToolCatchPhrase
    | AdditionalInformations
    | BestOf Int
    | CallToActionForCategory
    | CallToActionForDescription Types.CardType
    | Close
    | Collection GrammaticalNumber
    | Copyright
    | Example GrammaticalNumber
    | GenericError
    | HeaderTitle
    | Help
    | Home
    | Language Language
    | LanguageWord
    | License
    | NetworkErrorExplanation
    | OpenGovParagraph
    | Organization GrammaticalNumber
    | PageLoading
    | PageLoadingExplanation
    | PageNotFound
    | PageNotFoundExplanation
    | PublishExample
    | PublishTool
    | SeeAllAndCompare
    | Score
    | SearchInputPlaceholder
    | SearchResults String
    | ShowAll Int
    | SignIn
    | SignOut
    | SignUp
    | SimilarTools
    | Software
    | Tags
    | TimeoutExplanation
    | Tool GrammaticalNumber
    | Type
    | UsedBy
    | UsedFor
    | UnexpectedPayloadExplanation
    | UseIt
    | Website


getTranslationSet : TranslationId -> TranslationSet
getTranslationSet translationId =
    case translationId of
        About ->
            { english = s "About"
            , french = s "À propos"
            , spanish = todo
            }

        AdditionalInformations ->
            { english = s "Additional informations"
            , french = s "Informations supplémentaires"
            , spanish = todo
            }

        AddNew ->
            { english = s "Add new"
            , french = s "Ajouter"
            , spanish = todo
            }

        AddNewCollectionCatchPhrase ->
            { english = todo
            , french = s "Une sélection des meilleurs outils et cas d'usage dans un contexte précis."
            , spanish = todo
            }

        AddNewExample ->
            { english = s "Add a new use case"
            , french = todo
            , spanish = todo
            }

        AddNewExampleCatchPhrase ->
            { english = todo
            , french = s "Un exemple concret et efficace d'utilisation d'un outil."
            , spanish = todo
            }

        AddNewTool ->
            { english = s "Add a new tool"
            , french = todo
            , spanish = todo
            }

        AddNewToolCatchPhrase ->
            { english = todo
            , french = s "Un logiciel ou services utilisé pour renforcer la démocratie."
            , spanish = todo
            }

        BestOf count ->
            { english = s ("Best of " ++ (toString count))
            , french = s ("Meilleur parmi " ++ (toString count))
            , spanish = todo
            }

        CallToActionForCategory ->
            { english = s "+ Add category"
            , french = s "+ Ajouter une catégorie"
            , spanish = todo
            }

        CallToActionForDescription cardType ->
            { english =
                case cardType of
                    Types.Example ->
                        s "Add a description for this use case"

                    Types.Organization ->
                        s "Add a description for this organization"

                    Types.Tool ->
                        s "Add a description for this tool"
            , french =
                case cardType of
                    Types.Example ->
                        todo

                    Types.Organization ->
                        todo

                    Types.Tool ->
                        todo
            , spanish =
                case cardType of
                    Types.Example ->
                        todo

                    Types.Organization ->
                        todo

                    Types.Tool ->
                        todo
            }

        Close ->
            { english = s "Close"
            , french = s "Fermer"
            , spanish = todo
            }

        Collection number ->
            { english =
                case number of
                    Singular ->
                        s "Collection"

                    Plural ->
                        s "Collections"
            , french =
                case number of
                    Singular ->
                        s "Collection"

                    Plural ->
                        s "Collections"
            , spanish = todo
            }

        Copyright ->
            { english = s "© 2016 Open Government Partnership"
            , french = s "© 2016 Partenariat pour un Gouvernement Ouvert"
            , spanish = todo
            }

        Example number ->
            { english =
                case number of
                    Singular ->
                        s "Use case"

                    Plural ->
                        s "Use cases"
            , french =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , spanish =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            }

        GenericError ->
            { english = s "Something wrong happened!"
            , french = s "Quelque chose s'est mal passé !"
            , spanish = todo
            }

        HeaderTitle ->
            { english = s "digital solutions to improve democracy"
            , french = todo
            , spanish = todo
            }

        Help ->
            { english = s "Help"
            , french = s "Aide"
            , spanish = todo
            }

        Home ->
            { english = s "Home"
            , french = s "Accueil"
            , spanish = todo
            }

        Language language ->
            case language of
                English ->
                    { english = s "English"
                    , french = s "Anglais"
                    , spanish = s "Inglés"
                    }

                French ->
                    { english = s "French"
                    , french = s "Français"
                    , spanish = s "Francés"
                    }

                Spanish ->
                    { english = s "Spanish"
                    , french = s "Espagnol"
                    , spanish = s "Español"
                    }

        LanguageWord ->
            { english = s "Language"
            , french = s "Langue"
            , spanish = todo
            }

        License ->
            { english = s "License"
            , french = s "Licence"
            , spanish = todo
            }

        NetworkErrorExplanation ->
            { english = s "There was a network error."
            , french = todo
            , spanish = todo
            }

        OpenGovParagraph ->
            { english = s """
The Open Government Partnership is a multilateral initiative that aims to secure concrete commitments
from governments to promote transparency, empower citizens, fight corruption, and harness new technologies
to strengthen governance. In the spirit of multi-stakeholder collaboration, OGP is overseen by a Steering Committee
including representatives of governments and civil society organizations.
"""
            , french = todo
            , spanish = todo
            }

        Organization number ->
            { english =
                case number of
                    Singular ->
                        s "Organization"

                    Plural ->
                        s "Organizations"
            , french =
                case number of
                    Singular ->
                        s "Organisation"

                    Plural ->
                        s "Organisations"
            , spanish = todo
            }

        PageLoading ->
            { english = s "Page is loading"
            , french = s "Chargement en cours"
            , spanish = todo
            }

        PageLoadingExplanation ->
            { english = s "Data is loading and should be displayed quite soon."
            , french = todo
            , spanish = todo
            }

        PageNotFound ->
            { english = s "Page Not Found"
            , french = s "Page non trouvée"
            , spanish = todo
            }

        PageNotFoundExplanation ->
            { english = s "Sorry, but the page you were trying to view does not exist."
            , french = todo
            , spanish = todo
            }

        PublishExample ->
            { english = s "Publish use case"
            , french = todo
            , spanish = todo
            }

        PublishTool ->
            { english = s "Publish tool"
            , french = todo
            , spanish = todo
            }

        SeeAllAndCompare ->
            { english = s "See all and compare"
            , french = s "Voir tous et comparer"
            , spanish = todo
            }

        Score ->
            { english = s "Score"
            , french = s "Score"
            , spanish = todo
            }

        SearchInputPlaceholder ->
            { english = s "Search for a tool, example or organization"
            , french = s "Rechercher un outil, un exemple ou une organisation"
            , spanish = todo
            }

        SearchResults searchQuery ->
            { english = s ("Search results for \"" ++ searchQuery ++ "\"")
            , french = s ("Résultats de recherche pour « " ++ searchQuery ++ " »")
            , spanish = todo
            }

        ShowAll count ->
            { english = s ("Show all " ++ (toString count))
            , french = s ("Voir tous (" ++ (toString count) ++ ")")
            , spanish = todo
            }

        SignIn ->
            { english = s "Sign In"
            , french = s "Se connecter"
            , spanish = todo
            }

        SignOut ->
            { english = s "Sign Out"
            , french = s "Se déconnecter"
            , spanish = todo
            }

        SignUp ->
            { english = s "Sign Up"
            , french = s "S'inscrire"
            , spanish = todo
            }

        SimilarTools ->
            { english = s "Similar tools"
            , french = s "Outils similaires"
            , spanish = todo
            }

        Software ->
            { english = s "Software"
            , french = s "Logiciel"
            , spanish = todo
            }

        Tags ->
            { english = s "Tags"
            , french = s "Tags"
            , spanish = todo
            }

        TimeoutExplanation ->
            { english = s "The server was too slow to respond (timeout)."
            , french = todo
            , spanish = todo
            }

        Tool number ->
            { english =
                case number of
                    Singular ->
                        s "Tool"

                    Plural ->
                        s "Tools"
            , french =
                case number of
                    Singular ->
                        s "Outil"

                    Plural ->
                        s "Outils"
            , spanish = todo
            }

        Type ->
            { english = s "Type"
            , french = s "Type"
            , spanish = todo
            }

        UsedBy ->
            { english = s "Used by"
            , french = todo
            , spanish = todo
            }

        UsedFor ->
            { english = s "Used for"
            , french = todo
            , spanish = todo
            }

        UnexpectedPayloadExplanation ->
            { english = s "The server returned unexpected data."
            , french = todo
            , spanish = todo
            }

        UseIt ->
            { english = s "Use it"
            , french = s "Utiliser"
            , spanish = todo
            }

        Website ->
            { english = s "Website"
            , french = s "Site web"
            , spanish = todo
            }



-- INTERNALS


type Language
    = English
    | French
    | Spanish


type alias TranslationSet =
    { english : Maybe String
    , french : Maybe String
    , spanish : Maybe String
    }



{-
   This type is opinionated: it satifies only the needs of this application.
   See also: https://en.wikipedia.org/wiki/Grammatical_number
-}


type GrammaticalNumber
    = Singular
    | Plural


s : a -> Maybe a
s =
    Just


todo : Maybe a
todo =
    Nothing



-- FUNCTIONS


getManyStrings : Language -> List String -> Card -> Dict String Value -> List String
getManyStrings language propertyKeys card values =
    let
        getStrings : ValueType -> List String
        getStrings value =
            case value of
                StringValue value ->
                    [ value ]

                LocalizedStringValue valueByLanguage ->
                    case getValueByPreferredLanguage language valueByLanguage of
                        Nothing ->
                            []

                        Just value ->
                            [ value ]

                ArrayValue [] ->
                    []

                ArrayValue childValues ->
                    List.concatMap getStrings childValues

                NumberValue _ ->
                    []

                BijectiveCardReferenceValue _ ->
                    []

                ReferenceValue propertyKey ->
                    case Dict.get propertyKey values of
                        Nothing ->
                            []

                        Just subValue ->
                            getStrings subValue.value

                WrongValue _ _ ->
                    []
    in
        propertyKeys
            |> List.map
                (\propertyKey ->
                    Dict.get propertyKey card.properties
                        `Maybe.andThen` (\valueId -> Dict.get valueId values)
                        |> Maybe.map (\value -> getStrings value.value)
                        |> Maybe.withDefault []
                )
            |> List.filter (not << List.isEmpty)
            |> List.head
            |> Maybe.withDefault []


getOneString : Language -> List String -> Card -> Dict String Value -> Maybe String
getOneString language propertyKeys card values =
    let
        getString : ValueType -> Maybe String
        getString value =
            case value of
                StringValue value ->
                    Just value

                LocalizedStringValue valueByLanguage ->
                    getValueByPreferredLanguage language valueByLanguage

                ArrayValue [] ->
                    Nothing

                ArrayValue (childValue :: _) ->
                    getString childValue

                NumberValue _ ->
                    Nothing

                BijectiveCardReferenceValue _ ->
                    Nothing

                ReferenceValue propertyKey ->
                    Dict.get propertyKey values `Maybe.andThen` (\subValue -> getString subValue.value)

                WrongValue _ _ ->
                    Nothing
    in
        propertyKeys
            |> List.map
                (\propertyKey ->
                    Dict.get propertyKey card.properties
                        `Maybe.andThen` (\valueId -> Dict.get valueId values)
                        `Maybe.andThen` (\value -> getString value.value)
                )
            |> Maybe.oneOf


getName : Language -> String -> Dict String Card -> Dict String Value -> String
getName language cardId cards values =
    case Dict.get cardId cards of
        Nothing ->
            "No name"

        Just card ->
            case getOneString language nameKeys card values of
                Nothing ->
                    "No name"

                Just name ->
                    name


getImageUrl : Language -> String -> Card -> Dict String Value -> Maybe String
getImageUrl language dim card values =
    case getImageLogoUrl language dim card values of
        Nothing ->
            getImageScreenshotUrl language dim card values

        Just url ->
            Just url


getImageLogoUrl : Language -> String -> Card -> Dict String Value -> Maybe String
getImageLogoUrl language dim card values =
    getOneString language imageLogoUrlPathKeys card values
        |> Maybe.map
            (\urlPath -> imageUrl urlPath ++ "?dim=" ++ dim)


getImageScreenshotUrl : Language -> String -> Card -> Dict String Value -> Maybe String
getImageScreenshotUrl language dim card values =
    getOneString language imageScreenshotUrlPathKeys card values
        |> Maybe.map
            (\urlPath -> imageUrl urlPath ++ "?dim=" ++ dim)


getImageUrlOrOgpLogo : Language -> String -> Dict String Card -> Dict String Value -> String
getImageUrlOrOgpLogo language cardId cards values =
    case Dict.get cardId cards of
        Nothing ->
            Constants.logoUrl

        Just card ->
            case getOneString language imageUrlPathKeys card values of
                Nothing ->
                    Constants.logoUrl

                Just urlPath ->
                    imageUrl urlPath


getSubTypes : Language -> Card -> Dict String Value -> String
getSubTypes language card values =
    card.subTypeIds
        |> List.map
            (\subTypeId ->
                (case Dict.get subTypeId values of
                    Nothing ->
                        "Error: value not found for ID: " ++ subTypeId

                    Just { value } ->
                        case value of
                            LocalizedStringValue localizedValues ->
                                case Dict.get (iso639_1FromLanguage language) localizedValues of
                                    Nothing ->
                                        "Error: localized value not found for ID: " ++ subTypeId

                                    Just localizedValue ->
                                        localizedValue

                            _ ->
                                "This should not happen"
                )
            )
        |> String.join ", "


getValueByPreferredLanguage : Language -> Dict String String -> Maybe String
getValueByPreferredLanguage language valueByLanguage =
    let
        userLanguageCode =
            iso639_1FromLanguage language
    in
        ([ Dict.get userLanguageCode valueByLanguage
            |> Maybe.map (\s -> ( userLanguageCode, s ))
         , Dict.get "en" valueByLanguage
            |> Maybe.map (\s -> ( "en", s ))
         ]
            ++ (Dict.toList valueByLanguage |> List.map Just)
        )
            |> List.filterMap identity
            |> List.filterMap
                (\( languageCode, s ) ->
                    if String.isEmpty (String.trim s) then
                        Nothing
                    else
                        Just
                            (if languageCode == userLanguageCode then
                                s
                             else
                                "(" ++ (String.toUpper languageCode) ++ ") " ++ s
                            )
                )
            |> List.head


languageFromIso639_1 : String -> Maybe Language
languageFromIso639_1 str =
    case str of
        "en" ->
            Just English

        "es" ->
            Just Spanish

        "fr" ->
            Just French

        _ ->
            Nothing


iso639_1FromLanguage : Language -> String
iso639_1FromLanguage language =
    case language of
        English ->
            "en"

        Spanish ->
            "es"

        French ->
            "fr"


translate : Language -> TranslationId -> String
translate language translationId =
    let
        translationSet =
            getTranslationSet translationId

        translateHelp language =
            case language of
                English ->
                    translationSet.english

                French ->
                    translationSet.french

                Spanish ->
                    translationSet.spanish
    in
        Maybe.oneOf
            [ translateHelp language
            , translateHelp English |> Maybe.map (\str -> "(EN) " ++ str)
            ]
            |> Maybe.withDefault
                ("TODO translate the ID "
                    ++ (toString translationId)
                    ++ " in "
                    ++ (toString language)
                )
