module I18n exposing (..)

import Constants
import Dict exposing (Dict)
import String
import Types exposing (..)


-- STRINGS TO TRANSLATE
-- for translators who want to internationalize the application


type TranslationId
    = About
    | AboutAccess
    | AboutAccessContent
    | AboutCategories
    | AboutCategoriesContent1
    | AboutCategoriesContent2
    | AboutCategoriesContentLink
    | AboutContribution
    | AboutContributionContent
    | AboutCredits
    | AboutCreditsContent
    | AboutData
    | AboutDataContent0
    | AboutDataContent1
    | AboutDataContent2
    | AboutDev
    | AboutDevContent
    | AboutLanguages
    | AboutLanguagesContent
    | AboutLead
    | AboutLegal
    | AboutLegalContent
    | AboutModeration
    | AboutModerationContent
    | AboutTarget
    | AboutTargetContent
    | AboutTypes
    | AboutTypesContent
    | AboutTypesContentActor
    | AboutTypesContentCollection
    | AboutTypesContentTool
    | AboutTypesContentUseCase
    | AboutSource
    | AboutSourceContent
    | AboutWhat
    | AboutWhatContent
    | AboutWhy
    | AboutWhyContent1
    | AboutWhyContent2
    | ActivationFailed
    | ActivationInProgress
    | ActivationNotRequested
    | ActivationSucceeded
    | ActivationTitle
    | Actor GrammaticalNumber
    | AddNew
    | AddNewCollectionCatchPhrase
    | AddNewOrganization
    | AddNewOrganizationCatchPhrase
    | AddNewTool
    | AddNewToolCatchPhrase
    | AddNewUseCase
    | AddNewUseCaseCatchPhrase
    | AdditionalInformations
    | BestOf Int
    | CallToActionForCategory
    | CallToActionForDescription CardType
    | Close
    | Collection GrammaticalNumber
    | Copyright
    | EmailSentForAccountActivation
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
    | PublishOrganization
    | PublishTool
    | PublishUseCase
    | RegisterNow
    | ResetPassword
    | SeeAllAndCompare
    | Score
    | SearchInputPlaceholder
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
    | UseCase GrammaticalNumber
    | UsedBy
    | UsedFor
    | UnexpectedPayloadExplanation
    | UseIt
    | Website


getTranslationSet : TranslationId -> TranslationSet
getTranslationSet translationId =
    case translationId of
        About ->
            { english = s "Help"
            , french = s "Aide"
            , spanish = todo
            }

        AboutAccess ->
            { english = s "How can I access OGP Toolbox Data?"
            , french = s "Comment puis-je accéder aux données de l'OGP Toolbox ?"
            , spanish = todo
            }

        AboutAccessContent ->
            { english = s "Harvested data are stocked on a framagit drop and accessible under a cc-0 license:"
            , french = s "Les données moissonnées sont stockées sur un dépôt Framagit et disponible sous licence cc-0:"
            , spanish = todo
            }

        AboutCategories ->
            { english = s "How are tools and use cases categorized?"
            , french = s "Comment sont catégorisés les outils et les usages ?"
            , spanish = todo
            }

        AboutCategoriesContent1 ->
            { english = s "Rather than classify each tools (and their use cases) in great monolithic and exclusive categories (i.e. \"a tool cannot be in more than one category at a time\"), the platform is based on tags (labels), which enable to qualify each tool and each usage with as many key words you deem necessary. This is called social tagging or \"folksonomy\""
            , french = s "Plutôt que de classer les outils (et leurs usages) dans de grandes catégories monolithiques et exclusives (i.e. \"un outil ne peut pas être dans plus d'une catégorie à la fois\"), la plateforme repose sur un système de \"tags\" (labels), permettant de qualifier chaque outil et chaque usage avec autant de mots clés que vous jugerez nécessaire. C'est ce qu'on appelle \"tagging\" social ou \"folksonomie\""
            , spanish = todo
            }

        AboutCategoriesContent2 ->
            { english = s "These tags are represented by clickable bubbles. By navigating in different \"bubbles\" (tags), you will thus be able to find a tool associated to multiple key words."
            , french = s "Ces tags sont représentés sous forme de bulles cliquables. En naviguant dans des \"bulles\" (tags) différentes, vous pourrez ainsi retrouver le même outil dès lors qu'il est associé à plusieurs mots-clés."
            , spanish = todo
            }

        AboutCategoriesContentLink ->
            { english = s "https://en.wikipedia.org/wiki/Folksonomy"
            , french = s "https://fr.wikipedia.org/wiki/Folksonomie"
            , spanish = todo
            }

        AboutContribution ->
            { english = s "How can I add information about a tool, a use case or a collection?"
            , french = s "Comment puis-je renseigner un outil, un cas d'usage, une collection ?"
            , spanish = todo
            }

        AboutContributionContent ->
            { english = s "Very simply. You only have to create an account on the platform and click on \"Add\" at the top right of the screen and you will be guided."
            , french = s "C'est très simple. Il suffit tout d'abord de créer un compte sur la plateforme. Ensuite, cliquer sur \"Ajouter\" en haut à droite et vous serez guidé."
            , spanish = todo
            }

        AboutCredits ->
            { english = s "Credits"
            , french = s "Crédits"
            , spanish = todo
            }

        AboutCreditsContent ->
            { english = s "The bubble tag navigation système is based on"
            , french = s "Le système de navigations des tag par bulles est basé sur la solution"
            , spanish = todo
            }

        AboutData ->
            { english = s "What is the source of the data?"
            , french = s "D'où proviennent les données ?"
            , spanish = todo
            }

        AboutDataContent0 ->
            { english = s "The OGP Toolbox data originates from multiple sources:"
            , french = s "Les données de l'OGP Toolbox proviennent de sources multiples :"
            , spanish = todo
            }

        AboutDataContent1 ->
            { english = s "Existing catalogs are regularly harvested to feed and update the data base!"
            , french = s "Des catalogues existants sont moissonnés régulièrement pour alimenter et mettre à jour la base de données :"
            , spanish = todo
            }

        AboutDataContent2 ->
            { english = s "OGP Toolbox users can create new technical pages, use cases and organizations, or edit existing pages."
            , french = s "Les utilisateurs de l'OGP Toolbox peuvent créer de nouvelles fiches d'outil, de cas d'usage et d'organisation, ou éditer des fiches existantes."
            , spanish = todo
            }

        AboutDev ->
            { english = s "Who developed the OGP Toolbox?"
            , french = s "Qui a développé l'OGP Toolbox ?"
            , spanish = todo
            }

        AboutDevContent ->
            { english = s "The OGP Toolbox is a free software developed by Etalab, the Prime Minister taskforce in charge of open data and open government French policy, on behalf of the OGP community. Co-created by the open government and the civic tech international community throughout 2016, the OGP Toolbox is one of the foremost deliverable of the Global Summit of the Open Government Partnership (7, 8 and 9 December 2016)."
            , french = s "L'OGP Toolbox a été développée par Etalab, service du Premier Ministre en charge de l'ouverture des données publiques et du gouvernement ouvert de la France, pour le compte de la communauté du Partenariat du Gouvernement Ouvert. Co-créé avec les communautés internationales du gouvernement ouvert et de la civic tech tout au long de l'année 2016, l'OGP Toolbox est un des principaux livrables du Sommet mondial du Partenariat pour un Gouvernement Ouvert (7, 8 et 9 décembre 2016)."
            , spanish = todo
            }

        AboutLanguages ->
            { english = s "Which are the available languages?"
            , french = s "Dans quelles langues est disponible la plateforme ?"
            , spanish = todo
            }

        AboutLanguagesContent ->
            { english = s "The OGP Toolbox is available in English and French. The Platform is crowdsourced, which means that beyond the online interface (translated by Etalab), every content element can be modified and translated by users. This especially concerns tools, use description and tags enabling to categorize them (see below). Content elements will be displayed in the language you configured. If an element is not available in your language, it will be displayed in English by default. Your turn to translate it! "
            , french = s "OGP Toolbox est disponible en Anglais et en Français. La plateforme est crowdsourcée ce qui signifie qu'au-delà de l'interface du site Internet traduit par nos soins, chaque élément de contenu peut être modifié et traduit par les utilisateurs, notamment les descriptions des outils et des usages et les tags permettant de les catégoriser ( voir ci-dessous). Les éléments de contenu s'afficheront en priorité dans la langue que vous aurez paramétrée. Si un élément n'est pas disponible dans votre langue, il s'affiche en anglais par défaut, et vous invite à le traduire."
            , spanish = todo
            }

        AboutLead ->
            { english = s "All the answers to your questions about the OGP Toolbox"
            , french = s "Mieux comprendre l'OGP Toolbox"
            , spanish = todo
            }

        AboutLegal ->
            { english = s "Legal notices"
            , french = s "Mentions légales"
            , spanish = todo
            }

        AboutLegalContent ->
            { english = s "OGPtoolobox.org is edited by the Etalab taskforce, a Prime Minister service, 39 quai André Citroën 75015 PARIS."
            , french = s "OGPtoolobox.org est édité par la mission Etalab, service du Premier Ministre, 39 quai André Citroën 75015 PARIS."
            , spanish = todo
            }

        AboutModeration ->
            { english = s "How are contributions moderated?"
            , french = s "Comment puis-je renseigner un outil, un cas d'usage, une collection ?"
            , spanish = todo
            }

        AboutModerationContent ->
            { english = s "The OGP Toolbox is based on community moderation. Data from the harvested catalogues and users’ contributions are automatically sort out through an open vote system. For each field, the most popular suggested description is highlighted in the tool leaflet, use case or organization. The vote on available propositions is accessible by clicking on the \"edit\" button at the right of each field."
            , french = s "C'est très simple. Il suffit tout d'abord de créer un compte sur la plateforme. Ensuite, cliquer sur \"Ajouter\" en haut à droite et vous serez guidé."
            , spanish = todo
            }

        AboutTarget ->
            { english = s "For which user did we design this platform?"
            , french = s "À qui est destinée l'OGP Toolbox ?"
            , spanish = todo
            }

        AboutTargetContent ->
            { english = s "The OGP is intended to all public and private actors and to civil society that develop projects to reinforce democracy and promote transparency, participation and collaboration in public action. Every engaged citizen willing to be introduced to new tools and to discover use cases will be able to simply access relevant information, and to contact users’ community."
            , french = s "L'OGP Toolbox est destinée à tous les acteurs publics, privés et de la société civile portant des projets pour renforcer la démocratie et promouvoir la transparence, la participation et la collaboration dans l'action publique. Tout citoyen engagé voulant s'initier à de nouveaux outils et en découvrir les cas d'usages pourra accéder facilement aux informations pertinentes."
            , spanish = todo
            }

        AboutTypes ->
            { english = s "What can I find in the OGP Toolbox?"
            , french = s "Qu'est-ce-qu'on peut trouver dans l'OGP Toolbox ?"
            , spanish = todo
            }

        AboutTypesContent ->
            { english = s "On the platform you can find 4 types of content:"
            , french = s "La plateforme référence 4 types d'objets :"
            , spanish = todo
            }

        AboutTypesContentActor ->
            { english = s "Users or tools developers, who are part of the public sphere (government, subnational, administration), the private sphere (businesses…), the civil society (non-profit organizations…) or are simple citizens."
            , french = s "Utilisateur ou développeur d'outil, faisant partie de la sphère publique (Etat, collectivité, administration...) ou privée (entreprise...), de la société civile (association, ONG...) ou simple citoyen."
            , spanish = todo
            }

        AboutTypesContentCollection ->
            { english = s "A series of solutions gathered by an actor to push them forward, for example \"Tools used by the French Government\", \"Online consultations tools\"…."
            , french = s "Le code comporte trois composants, chacun étant stocké sur un dépôt Framagit :"
            , spanish = todo
            }

        AboutTypesContentTool ->
            { english = s "Computer programs or services, available online or through mobile applications."
            , french = s "Programme informatique ou service, disponible sur le web ou via des applications mobiles."
            , spanish = todo
            }

        AboutTypesContentUseCase ->
            { english = s "Example of a concrete use cases of one or multiple tools by an actor, encompassing a participatory dimension."
            , french = s "Exemple concret d'utilisation d'un ou plusieurs outils par un acteur, avec une dimension de participation citoyenne."
            , spanish = todo
            }

        AboutSource ->
            { english = s "How can I access the code of the OGP Toolbox?"
            , french = s "Comment puis-je accéder au code de l'OGP Toolbox ?"
            , spanish = todo
            }

        AboutSourceContent ->
            { english = s "The code includes three components, each of which is stocked on a framagit drop:"
            , french = s "La plateforme référence 4 types d'objets :"
            , spanish = todo
            }

        AboutWhat ->
            { english = s "What is the OGP Toolbox?"
            , french = s "Qu'est ce que l'OGP Toolbox ?"
            , spanish = todo
            }

        AboutWhatContent ->
            { english = s "The OGP Toolbox is a collaborative platform which identify digital tools (software and online services) used throughout the world to enhance democracy and promote transparency, participation and collaborative in public action. This crowdsourced catalog gathers tools developed and used by public actors (governments, administrations, parliaments, subnational) and civil society actors (non-profit organizations, informal movements and involved citizens). The OGP Toolbox is conceived as a social network: concrete use cases, technical criterions tested by the community and advices as series of tools in order to benefit from the savoir-faire of actors who already used the available solutions. The platform thus identifies 4 entities: "
            , french = s "L'OGP Toolbox est une plateforme collaborative qui recense les outils numériques (logiciels et services en ligne) utilisés dans le monde entier pour renforcer la démocratie et promouvoir la transparence, la participation et la collaboration dans l'action publique. Ce catalogue crowdsourcé rassemble des outils développés et utilisés par des acteurs publics (gouvernements, administrations, parlements et collectivités territoriales), comme des acteurs du secteur privé (entreprises et start-ups) ou des acteurs de la société civile (associations, mouvements et citoyens engagés). L'OGP Toolbox est conçue comme un réseau social : des cas d'usages concrets, des critères techniques expertisés par la communauté et des recommandations sous forme de collections d'outils permettent de profiter du savoir-faire des acteurs ayant déjà utilisé les solutions disponibles. "
            , spanish = todo
            }

        AboutWhy ->
            { english = s "What is the use for the OGP Toolbox?"
            , french = s "À quoi sert l'OGP Toolbox ? "
            , spanish = todo
            }

        AboutWhyContent1 ->
            { english = s "The OGP Toolbox aims at reinforcing public and private actor’s and civil society’s ability to act through resources and shared experiences. The objective is to facilitate cooperation and the implementation of concrete engagements related to the open government through the command of digital tools."
            , french = s "L'OGP Toolbox vise à renforcer le pouvoir d'agir des acteurs publics, privés et de la société civile à travers le partage de ressources et d'expériences. L'objectif est de faciliter la mise en oeuvre concrète d'engagements et de coopérations liées au gouvernement ouvert grâce à la maîtrise des outils numériques."
            , spanish = todo
            }

        AboutWhyContent2 ->
            { english = s "The platform enables to find the most adapted tool to each project or initiative through search and comparison by categories, use cases, organization or technical criterion, to simplify its access and its technical handle."
            , french = s "La plateforme permet de trouver l'outil le mieux adapté à chaque projet ou initiative à travers des recherches et des comparaisons par catégorie, cas d'usage, organisation ou critère technique, ainsi que d'en simplifier l'accès et la prise en main."
            , spanish = todo
            }

        ActivationFailed ->
            { english = s "The verification of your email address has failed. Retry please!"
            , french = s "La vérification de votre adresse courriel a échoué. Veuillez réessayer !"
            , spanish = todo
            }

        ActivationInProgress ->
            { english = s "Verifying your email address..."
            , french = s "Vérification de votre adresse courriel..."
            , spanish = todo
            }

        ActivationNotRequested ->
            { english = s "Your email address will be verified soon..."
            , french = s "Votre adresse courriel va bientôt être vérifiée..."
            , spanish = todo
            }

        ActivationSucceeded ->
            { english = s "The verification of your email address has succeeded. Your account is now activated!"
            , french = s "La vérification de votre adresse courriel a réussi. Votre compte est maintenant activé !"
            , spanish = todo
            }

        ActivationTitle ->
            { english = s "User Account Activation"
            , french = s "Activation du compte utilisateur"
            , spanish = todo
            }

        Actor number ->
            { english =
                case number of
                    Singular ->
                        s "Actor"

                    Plural ->
                        s "Actors"
            , french =
                case number of
                    Singular ->
                        s "Acteur"

                    Plural ->
                        s "Acteurs"
            , spanish =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
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

        AddNewUseCase ->
            { english = s "Add a new use case"
            , french = todo
            , spanish = todo
            }

        AddNewUseCaseCatchPhrase ->
            { english = todo
            , french = s "Un exemple concret et efficace d'utilisation d'un outil."
            , spanish = todo
            }

        AddNewOrganization ->
            { english = s "Add a new organization"
            , french = todo
            , spanish = todo
            }

        AddNewOrganizationCatchPhrase ->
            { english = todo
            , french = todo
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
                    UseCaseCard ->
                        s "Add a description for this use case"

                    OrganizationCard ->
                        s "Add a description for this organization"

                    ToolCard ->
                        s "Add a description for this tool"
            , french =
                case cardType of
                    UseCaseCard ->
                        todo

                    OrganizationCard ->
                        todo

                    ToolCard ->
                        todo
            , spanish =
                case cardType of
                    UseCaseCard ->
                        todo

                    OrganizationCard ->
                        todo

                    ToolCard ->
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

        EmailSentForAccountActivation ->
            { english = s "An email has been sent. Click the link it contains, to activate your account."
            , french = s "Un courriel vous a été envoyé. Cliquez sur le lien qu'il contient pour activer votre compte."
            , spanish = todo
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

        PublishUseCase ->
            { english = s "Publish use case"
            , french = todo
            , spanish = todo
            }

        PublishOrganization ->
            { english = s "Publish organization"
            , french = todo
            , spanish = todo
            }

        PublishTool ->
            { english = s "Publish tool"
            , french = todo
            , spanish = todo
            }

        RegisterNow ->
            { english = s "Register now!"
            , french = s "Inscrivez vous maintenant !"
            , spanish = todo
            }

        ResetPassword ->
            { english = s "Reset Password"
            , french = s "Changer de mot de passe"
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
            { english = s "Search for a tool, use case or organization"
            , french = s "Rechercher un outil, un cas d'usage ou une organisation"
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

        UseCase number ->
            { english =
                case number of
                    Singular ->
                        s "Use case"

                    Plural ->
                        s "Use cases"
            , french =
                case number of
                    Singular ->
                        s "Cas d'usage"

                    Plural ->
                        s "Cas d'usage"
            , spanish =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
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

                CardIdArrayValue ids ->
                    []

                CardIdValue cardId ->
                    []

                NumberValue _ ->
                    []

                BijectiveCardReferenceValue _ ->
                    []

                ValueIdArrayValue ids ->
                    List.concatMap (\id -> getStrings (ValueIdValue id)) ids

                ValueIdValue valueId ->
                    case Dict.get valueId values of
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

                CardIdArrayValue _ ->
                    Nothing

                ValueIdArrayValue [] ->
                    Nothing

                ValueIdArrayValue (childValue :: _) ->
                    getString (ValueIdValue childValue)

                NumberValue _ ->
                    Nothing

                BijectiveCardReferenceValue _ ->
                    Nothing

                CardIdValue cardId ->
                    Nothing

                ValueIdValue valueId ->
                    Dict.get valueId values `Maybe.andThen` (\subValue -> getString subValue.value)

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


getName : Language -> Card -> Dict String Value -> String
getName language card values =
    case getOneString language nameKeys card values of
        Nothing ->
            Debug.crash "getName: unhandled case"

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


getSubTypes : Language -> Card -> Dict String Value -> List String
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
                                case
                                    Maybe.oneOf
                                        [ Dict.get (iso639_1FromLanguage language) localizedValues
                                        , Dict.get "en" localizedValues
                                        ]
                                of
                                    Nothing ->
                                        Debug.crash "getSubTypes: no translation found, even with \"en\" fallback"

                                    Just str ->
                                        str

                            _ ->
                                "This should not happen"
                )
            )


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
                        -- (if languageCode == userLanguageCode then
                        --     s
                        --  else
                        --     "(" ++ (String.toUpper languageCode) ++ ") " ++ s
                        -- )
                        Just s
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
            , translateHelp English
              -- |> Maybe.map (\str -> "(EN) " ++ str)
            ]
            |> Maybe.withDefault
                ("TODO translate the ID "
                    ++ (toString translationId)
                    ++ " in "
                    ++ (toString language)
                )
