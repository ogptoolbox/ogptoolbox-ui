module I18n exposing (..)

import Configuration
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
    | AuthenticationRequired
    | AuthenticationRequiredExplanation
    | BestOf Int
    | CallToActionForCategory
    | CallToActionForDescription CardType
    | Close
    | Collection GrammaticalNumber
    | Copyright
    | CountVersionsAvailable Int
    | EmailSentForAccountActivation
    | FooterAbout
    | FooterDiscover
    | GenericError
    | HeaderTitle
    | Help
    | Home
    | Language Language
    | LanguageWord
    | License
    | NetworkErrorExplanation
    | OGPsummitLink
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
    | Share
    | ShowAll Int
    | SignIn
    | SignOut
    | SignUp
    | SimilarTools
    | Software
    | Tags
    | TimeoutExplanation
    | Tool GrammaticalNumber
    | TweetMessage String String
    | Type
    | UseCase GrammaticalNumber
    | UseCases
    | UsedBy
    | UsedFor
    | Uses
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

        AboutAccess ->
            { english = s "How can I access OGP Toolbox Data?"
            , french = s "Comment puis-je accéder aux données de l'OGP Toolbox ?"
            , spanish = todo
            }

        AboutAccessContent ->
            { english = s "Harvested data are available on framagit and accessible under a cc-0 license:"
            , french = s "Les données moissonnées sont stockées sur un dépôt Framagit et disponible sous licence cc-0:"
            , spanish = todo
            }

        AboutCategories ->
            { english = s "How are tools and use cases categorized?"
            , french = s "Comment sont catégorisés les outils et les usages ?"
            , spanish = todo
            }

        AboutCategoriesContent1 ->
            { english = s "Rather than classify each tool (and their use cases) in monholitic and exclusive categories (i.e. “a tool cannot be in more than one category”), the platform is based on tags (labels), which enable to qualify each tool and each usage with as many key words as necessary. This is calledsocial tagging or “folksonomy”"
            , french = s "Plutôt que de classer les outils (et leurs usages) dans de grandes catégories monolithiques et exclusives (i.e. \"un outil ne peut pas être dans plus d'une catégorie à la fois\"), la plateforme repose sur un système de \"tags\" (labels), permettant de qualifier chaque outil et chaque usage avec autant de mots clés que vous jugerez nécessaire. C'est ce qu'on appelle \"tagging\" social ou \"folksonomie\""
            , spanish = todo
            }

        AboutCategoriesContent2 ->
            { english = s "These tags are represented by clickable bubbles. By navigating in different “bubbles” (tags), you will thus be able to find the same tool under multiple key words."
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
            { english = s "It's easy. Creat your account on the platform and click on “Add” at the top right of the screen. You will be guided!"
            , french = s "C'est très simple. Il suffit tout d'abord de créer un compte sur la plateforme. Ensuite, cliquer sur \"Ajouter\" en haut à droite et vous serez guidé."
            , spanish = todo
            }

        AboutCredits ->
            { english = s "Credits"
            , french = s "Crédits"
            , spanish = s "Créditos"
            }

        AboutCreditsContent ->
            { english = s "The bubble tags navigation system is based on "
            , french = s "Le système de navigations des tag par bulles est basé sur la solution "
            , spanish = todo
            }

        AboutData ->
            { english = s "What is the source of the data?"
            , french = s "D'où proviennent les données ?"
            , spanish = todo
            }

        AboutDataContent0 ->
            { english = s "The OGP Toolbox data comes from multiple sources:"
            , french = s "Les données de l'OGP Toolbox proviennent de sources multiples :"
            , spanish = todo
            }

        AboutDataContent1 ->
            { english = s "Existing catalogs are regularly harvested to feed and update the data base:"
            , french = s "Des catalogues existants sont moissonnés régulièrement pour alimenter et mettre à jour la base de données :"
            , spanish = todo
            }

        AboutDataContent2 ->
            { english = s "OGP Toolbox users can create new tools, use cases and organizations, or edit existing ones."
            , french = s "Les utilisateurs de l'OGP Toolbox peuvent créer de nouvelles fiches d'outil, de cas d'usage et d'organisation, ou éditer des fiches existantes."
            , spanish = todo
            }

        AboutDev ->
            { english = s "Who developed the OGP Toolbox?"
            , french = s "Qui a développé l'OGP Toolbox ?"
            , spanish = todo
            }

        AboutDevContent ->
            { english = s "The OGP Toolbox is a free software developed by Etalab, the Prime Minister taskforce in charge of open data and open government French policy, on behalf of the OGP community. Co-created by the open government and the civic tech international community throughout 2016, the OGP Toolbox is one of the main deliverables of the Global Summit of the Open Government Partnership (7, 8 and 9 December 2016)."
            , french = s "L'OGP Toolbox a été développée par Etalab, service du Premier Ministre en charge de l'ouverture des données publiques et du gouvernement ouvert de la France, pour le compte de la communauté du Partenariat du Gouvernement Ouvert. Co-créé avec les communautés internationales du gouvernement ouvert et de la civic tech tout au long de l'année 2016, l'OGP Toolbox est un des principaux livrables du Sommet mondial du Partenariat pour un Gouvernement Ouvert (7, 8 et 9 décembre 2016)."
            , spanish = todo
            }

        AboutLanguages ->
            { english = s "Which are the available languages for the OGP Toolbox?"
            , french = s "Dans quelles langues est disponible la plateforme ?"
            , spanish = todo
            }

        AboutLanguagesContent ->
            { english = s "The OGP Toolbox is available in English and French. The Platform is crowdsourced, which means that outside the online interface  (translated by Etalab), any content can be modified and translated by users. This concerns particularly tools, use case description and tags enabling to categorize them (see below). Content will be displayed in the language you configured. If an element is not available in your language, it will be displayed in English by default. It's your turn to translate it!"
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
            , spanish = s "Nota legal"
            }

        AboutLegalContent ->
            { english = s "OGPtoolobox.org is edited by the Etalab taskforce, a Prime Minister service, 39 quai André Citroën 75015 PARIS."
            , french = s "OGPtoolobox.org est édité par la mission Etalab, service du Premier Ministre, 39 quai André Citroën 75015 PARIS."
            , spanish = todo
            }

        AboutModeration ->
            { english = s "How are contributions moderated?"
            , french = s "Comment sont modérées les contributions ?"
            , spanish = todo
            }

        AboutModerationContent ->
            { english = s "The OGP Toolbox is based on community moderation. Data from the harvested catalogues and users’ contributions are automatically sort out through an open vote system. For each field, the most popular suggested description is highlighted in the tool, use case or organization card. The vote on available propositions is accessible by clicking on the “edit” button at the right of each field."
            , french = s "OGP Toolbox s'appuie sur une modération communautaire. Les données provenant des catalogues moissonnées et des contributions des utilisateurs sont triées de façon automatique à travers un système de vote ouvert. Pour chaque champ, la proposition de description ou de valeur la plus votée est mise en avant sur la fiche outil, cas d'usage ou organisation. Le vote sur les propositions disponibles est accessible en cliquant sur le bouton \"edit\" à la droite de chaque champ. "
            , spanish = todo
            }

        AboutTarget ->
            { english = s "Who is the OGP Toolbox for?"
            , french = s "À qui est destinée l'OGP Toolbox ?"
            , spanish = todo
            }

        AboutTargetContent ->
            { english = s "The OGP is intended to all public sector, private sector and  civil society actors that develop projects to promote democracy and promote transparency, participation and collaboration. Any engaged citizen willing to be introduced to new tools and to discover particular use cases will be able to access relevant information, and to get in touch with the users’ community."
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

        AboutTypesContentTool ->
            { english = s "Software or services, available online or through mobile applications."
            , french = s "Programme informatique ou service, disponible sur le web ou via des applications mobiles."
            , spanish = todo
            }

        AboutTypesContentActor ->
            { english = s "users or tool developers, who are part of the public sphere (government, subnational, administration), the private sphere (businesses…), the civil society (non-profit organizations…) or simple citizens."
            , french = s "Utilisateur ou développeur d'outil, faisant partie de la sphère publique (Etat, collectivité, administration...) ou privée (entreprise...), de la société civile (association, ONG...) ou simple citoyen."
            , spanish = todo
            }

        AboutTypesContentCollection ->
            { english = s "A series of solutions gathered by an actor to push them forward, for example \"Tools used by the French Government\", \"Online consultations tools\"…."
            , french = s "Le code comporte trois composants, chacun étant stocké sur un dépôt Framagit :"
            , spanish = todo
            }

        AboutTypesContentUseCase ->
            { english = s "A series of solutions gathered by an actor to push them forward, for example “’Tools used by the French Government”, “Online consultations tools”…."
            , french = s "un ensemble de solutions réunies par un acteur pour les mettre en avant, par exemple \"Outils utilisés par le gouvernement Français\", \"Outils de consultations en ligne\" ..."
            , spanish = todo
            }

        AboutSource ->
            { english = s "How can I access the code of the OGP Toolbox?"
            , french = s "Comment puis-je accéder au code de l'OGP Toolbox ?"
            , spanish = todo
            }

        AboutSourceContent ->
            { english = s "The code includes three components, each of which is available on framagit:"
            , french = s "Le code comporte trois composants, chacun étant stocké sur un dépôt Framagit :"
            , spanish = todo
            }

        AboutWhat ->
            { english = s "What is the OGP Toolbox?"
            , french = s "Qu'est ce que l'OGP Toolbox ?"
            , spanish = todo
            }

        AboutWhatContent ->
            { english = s "The OGP Toolbox is a collaborative platform that gathers digital tools (software and online services) used throughout the world to improve democracy and promote transparency, participation and collaboration. In this crowdsourced catalog you will find tools developed and used by actors from the public sector (governments, administrations, parliaments, subnational), actors from the private sector (companies and start-ups) and actors from the civil society (non-profit organizations, movements and engaged citizens). The OGP Toolbox was conceived as a social network: concrete use cases, technical criteria informed by the community and recommendations in the form of tool collections allow to benefit from the experience of users that have already implemented existing solutions."
            , french = s "L'OGP Toolbox est une plateforme collaborative qui recense les outils numériques (logiciels et services en ligne) utilisés dans le monde entier pour renforcer la démocratie et promouvoir la transparence, la participation et la collaboration dans l'action publique. Ce catalogue crowdsourcé rassemble des outils développés et utilisés par des acteurs publics (gouvernements, administrations, parlements et collectivités territoriales), comme des acteurs du secteur privé (entreprises et start-ups) ou des acteurs de la société civile (associations, mouvements et citoyens engagés). L'OGP Toolbox est conçue comme un réseau social : des cas d'usages concrets, des critères techniques expertisés par la communauté et des recommandations sous forme de collections d'outils permettent de profiter du savoir-faire des acteurs ayant déjà utilisé les solutions disponibles. "
            , spanish = todo
            }

        AboutWhy ->
            { english = s "Why do we need an OGP Toolbox?"
            , french = s "À quoi sert l'OGP Toolbox ? "
            , spanish = todo
            }

        AboutWhyContent1 ->
            { english = s "The OGP Toolbox aims at empowering  public sector, private sector  and civil society actors  by sharing resources and  experiences. The objective is to facilitate cooperation and the implementation of concrete engagements related to the open government through the appropriation of digital tools."
            , french = s "L'OGP Toolbox vise à renforcer le pouvoir d'agir des acteurs publics, privés et de la société civile à travers le partage de ressources et d'expériences. L'objectif est de faciliter la mise en oeuvre concrète d'engagements et de coopérations liées au gouvernement ouvert grâce à la maîtrise des outils numériques."
            , spanish = todo
            }

        AboutWhyContent2 ->
            { english = s "The platform enables to find the most adapted tool to each project or initiative through search and comparison functionalities by category, use case, organization or technical criterion. The idea is to simplify access and manipulation of digital tools for everyone."
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

        AuthenticationRequired ->
            { english = s "Authentication required"
            , french = todo
            , spanish = todo
            }

        AuthenticationRequiredExplanation ->
            { english = s "You must sign in to display this page."
            , french = todo
            , spanish = todo
            }

        AddNew ->
            { english = s "Add new"
            , french = s "Ajouter"
            , spanish = todo
            }

        AddNewCollectionCatchPhrase ->
            { english = s "A series of solutions gathered by an actor to push them forward"
            , french = s "Un ensemble de solutions réunies par un acteur pour les mettre en avant"
            , spanish = todo
            }

        AddNewUseCase ->
            { english = s "Add a new use case"
            , french = s "Ajouter un nouveau cas d'usage"
            , spanish = todo
            }

        AddNewUseCaseCatchPhrase ->
            { english = s "Example of a concrete use case of one or multiple tools having a participatory dimension."
            , french = s "Exemple concret d'utilisation d'un ou plusieurs outils avec une dimension de participation citoyenne."
            , spanish = todo
            }

        AddNewOrganization ->
            { english = s "Add a new organization"
            , french = s "Ajouter une nouvelle organisation"
            , spanish = todo
            }

        AddNewOrganizationCatchPhrase ->
            { english = todo
            , french = todo
            , spanish = todo
            }

        AddNewTool ->
            { english = s "Add a new tool"
            , french = s "Ajouter un nouvel outil"
            , spanish = todo
            }

        AddNewToolCatchPhrase ->
            { english = s "Software or services, available online or through mobile applications."
            , french = s "Programme informatique ou service, disponible sur le web ou via des applications mobiles."
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
                        s "Ajouter une description pour ce cas d'usage"

                    OrganizationCard ->
                        s "Ajouter ne description pour cette organisation"

                    ToolCard ->
                        s "Ajouter une description pour cet outil"
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
            , spanish =
                case number of
                    Singular ->
                        s "Colección"

                    Plural ->
                        s "Colecciones"
            }

        Copyright ->
            { english = s "© 2016 Etalab. Design by Nodesign.net"
            , french = s "© 2016 Etalab. Design par Nodesign.net"
            , spanish = todo
            }

        CountVersionsAvailable count ->
            { english =
                case count of
                    0 ->
                        s "No version available"

                    1 ->
                        s "1 version available"

                    _ ->
                        s ((toString count) ++ " versions available")
            , french =
                case count of
                    0 ->
                        s "Aucune version disponible"

                    1 ->
                        s "1 version disponible"

                    _ ->
                        s ((toString count) ++ " versions disponibles")
            , spanish = todo
            }

        EmailSentForAccountActivation ->
            { english = s "An email has been sent. Click the link it contains, to activate your account."
            , french = s "Un courriel vous a été envoyé. Cliquez sur le lien qu'il contient pour activer votre compte."
            , spanish = todo
            }

        FooterAbout ->
            { english = s "About"
            , french = s "A propos"
            , spanish = s "Acerca"
            }

        FooterDiscover ->
            { english = s "Discover"
            , french = s "Découvrir"
            , spanish = s "Descubrir"
            }

        GenericError ->
            { english = s "Something wrong happened!"
            , french = s "Quelque chose s'est mal passé !"
            , spanish = todo
            }

        HeaderTitle ->
            { english = s "digital solutions to improve democracy"
            , french = s "solutions numériques pour la démocratie"
            , spanish = todo
            }

        Help ->
            { english = s "Help"
            , french = s "Aide"
            , spanish = s "Ayuda"
            }

        Home ->
            { english = s "Home"
            , french = s "Accueil"
            , spanish = s "Inicio"
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
            , spanish = s "Idioma"
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

        OGPsummitLink ->
            { english = s "https://en.ogpsummit.org/osem/conference/ogp-summit"
            , french = s "https://fr.ogpsummit.org/osem/conference/ogp-summit"
            , spanish = todo
            }

        OpenGovParagraph ->
            { english = s """
The Open Government Partnership is a multilateral initiative that aims to secure concrete commitments
from governments to promote transparency, empower citizens, fight corruption, and harness new technologies
to strengthen governance.
"""
            , french = s "Le Partenariat pour un gouvernement ouvert est une initiative multilatérale créée en 2011 par huit pays fondateurs, qui s’attache à promouvoir la transparence et l’intégrité du gouvernement ainsi que l’utilisation des nouvelles technologies pour faciliter son ouverture."
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
            , spanish =
                case number of
                    Singular ->
                        s "Organización"

                    Plural ->
                        s "Organizaciones"
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
            , french = s "Désolé mais la page que vous avez demandé n'est pas disponible"
            , spanish = todo
            }

        PublishUseCase ->
            { english = s "Publish use case"
            , french = s "Poublier ce cas d'usage"
            , spanish = todo
            }

        PublishOrganization ->
            { english = s "Publish organization"
            , french = s "Publier cette organisation"
            , spanish = todo
            }

        PublishTool ->
            { english = s "Publish tool"
            , french = s "Publier cet outil"
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
            , spanish = s "Score"
            }

        SearchInputPlaceholder ->
            { english = s "Search for a tool, use case or organization"
            , french = s "Rechercher un outil, un cas d'usage ou une organisation"
            , spanish = todo
            }

        Share ->
            { english = s "Share"
            , french = s "Partager"
            , spanish = todo
            }

        ShowAll count ->
            { english = s ("Show all " ++ (toString count))
            , french = s ("Voir tous (" ++ (toString count) ++ ")")
            , spanish = s ("Ver todo (" ++ (toString count) ++ ")")
            }

        SignIn ->
            { english = s "Sign In"
            , french = s "Se connecter"
            , spanish = s "Acceder"
            }

        SignOut ->
            { english = s "Sign Out"
            , french = s "Se déconnecter"
            , spanish = s "Salir"
            }

        SignUp ->
            { english = s "Sign Up"
            , french = s "S'inscrire"
            , spanish = s "Registrarse"
            }

        SimilarTools ->
            { english = s "Similar tools"
            , french = s "Outils similaires"
            , spanish = todo
            }

        Software ->
            { english = s "Software"
            , french = s "Logiciel"
            , spanish = s "Software"
            }

        Tags ->
            { english = s "Tags"
            , french = s "Tags"
            , spanish = s "Tags"
            }

        TimeoutExplanation ->
            { english = s "The server was too slow to respond (timeout)."
            , french = s "Le servert a mis trop de temps à repondre (timeout)"
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
            , spanish =
                case number of
                    Singular ->
                        s "Herramienta"

                    Plural ->
                        s "Herramientas"
            }

        TweetMessage name url ->
            { english = s ("Discover " ++ name ++ " on OGPToolbox.org: " ++ url)
            , french = s ("Découvrez " ++ name ++ " dans OGPToolbox.org : " ++ url)
            , spanish = todo
            }

        Type ->
            { english = s "Type"
            , french = s "Type"
            , spanish = s "Tipo"
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
                        s "Caso de uso"

                    Plural ->
                        s "Casos de uso"
            }

        UseCases ->
            { english = s "Use cases"
            , french = s "Cas d'usage"
            , spanish = s "Casos de uso"
            }

        UsedBy ->
            { english = s "Used by"
            , french = s "Utilisé par"
            , spanish = todo
            }

        UsedFor ->
            { english = s "Used for"
            , french = s "Utilisé pour"
            , spanish = todo
            }

        Uses ->
            { english = s "Uses"
            , french = s "Utilise"
            , spanish = todo
            }

        UnexpectedPayloadExplanation ->
            { english = s "The server returned unexpected data."
            , french = s "Le server a retourné des données imprévues"
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
getManyStrings language keyIds card values =
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

                BooleanValue _ ->
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
        keyIds
            |> List.map
                (\keyId ->
                    Dict.get keyId card.properties
                        `Maybe.andThen` (\valueId -> Dict.get valueId values)
                        |> Maybe.map (\value -> getStrings value.value)
                        |> Maybe.withDefault []
                )
            |> List.filter (not << List.isEmpty)
            |> List.head
            |> Maybe.withDefault []


getOneString : Language -> List String -> Card -> Dict String Value -> Maybe String
getOneString language keyIds card values =
    keyIds
        |> List.map
            (\keyId ->
                Dict.get keyId card.properties
                    `Maybe.andThen` (\valueId -> Dict.get valueId values)
                    `Maybe.andThen` (\value -> getOneStringFromValueType language values value.value)
            )
        |> Maybe.oneOf


getOneStringFromValueType : Language -> Dict String Value -> ValueType -> Maybe String
getOneStringFromValueType language values valueType =
    case valueType of
        StringValue value ->
            Just value

        LocalizedStringValue valueByLanguage ->
            getValueByPreferredLanguage language valueByLanguage

        CardIdArrayValue _ ->
            Nothing

        ValueIdArrayValue [] ->
            Nothing

        ValueIdArrayValue (childValue :: _) ->
            getOneStringFromValueType language values (ValueIdValue childValue)

        NumberValue _ ->
            Nothing

        BooleanValue _ ->
            Nothing

        BijectiveCardReferenceValue _ ->
            Nothing

        CardIdValue cardId ->
            Nothing

        ValueIdValue valueId ->
            Dict.get valueId values
                `Maybe.andThen` (\subValue -> getOneStringFromValueType language values subValue.value)

        WrongValue _ _ ->
            Nothing


getName : Language -> Card -> Dict String Value -> String
getName language card values =
    -- TODO Name can be Nothing, if down-voted! So return a Maybe String and handle call-to-action
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
            (\urlPath -> Configuration.apiUrlWithPath urlPath ++ "?dim=" ++ dim)


getImageScreenshotUrl : Language -> String -> Card -> Dict String Value -> Maybe String
getImageScreenshotUrl language dim card values =
    getOneString language imageScreenshotUrlPathKeys card values
        |> Maybe.map
            (\urlPath -> Configuration.apiUrlWithPath urlPath ++ "?dim=" ++ dim)


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
                    Configuration.apiUrlWithPath urlPath


getLocalizedStringFromValueId : Language -> Dict String Value -> String -> String
getLocalizedStringFromValueId language values valueId =
    case Dict.get valueId values of
        Nothing ->
            "Error: value not found for ID: " ++ valueId

        Just { value } ->
            case value of
                LocalizedStringValue localizedValues ->
                    getValueByPreferredLanguage language localizedValues
                        |> Maybe.withDefault ("No localization for string valueId=" ++ valueId)

                _ ->
                    "This should not happen"


getSubTypes : Language -> Card -> Dict String Value -> List String
getSubTypes language card values =
    List.map
        (getLocalizedStringFromValueId language values)
        card.subTypeIds


getTags : Language -> Card -> Dict String Value -> List { tag : String, tagId : String }
getTags language card values =
    List.map
        (\tagId ->
            { tag = getLocalizedStringFromValueId language values tagId
            , tagId = tagId
            }
        )
        card.tagIds


getUsages : Language -> Card -> Dict String Value -> List { tag : String, tagId : String }
getUsages language card values =
    List.map
        (\tagId ->
            { tag = getLocalizedStringFromValueId language values tagId
            , tagId = tagId
            }
        )
        card.usageIds


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
