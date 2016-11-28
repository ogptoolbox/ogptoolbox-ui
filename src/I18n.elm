module I18n exposing (..)

import Types


-- STRINGS TO TRANSLATE
-- for translators who want to internationalize the application


type TranslationId
    = About
    | AddNew
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
    | PageNotFound
    | PageNotFoundExplanation
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

        AddNew ->
            { english = s "Add new"
            , french = s "Ajouter"
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
            { english = s "find digital tools to improve democracy"
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
