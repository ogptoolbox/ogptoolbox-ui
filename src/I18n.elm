module I18n exposing (..)

import Dict exposing (Dict)
import String
import Types exposing (..)


-- STRINGS TO TRANSLATE
-- for translators who want to internationalize the application


type TranslationId
    = About
    | AboutCredits
    | AboutCreditsContent
    | AboutDescription
    | AboutLead
    | AboutLegal
    | AboutLegalContent
    | AccountCreationFailed
    | ActivationDescription
    | ActivationFailed
    | ActivationInProgress
    | ActivationNotRequested
    | ActivationSucceeded
    | ActivationTitle
    | Add
    | AddCard
    | AddCollection
    | AdditionalInformations
    | AddTool
    | AddToolOrUseCase
    | AddUseCase
    | AddYourContribution
    | AuthenticationFailed
    | AuthenticationRequired
    | AuthenticationRequiredExplanation
    | BadAuthorization
    | BadEmailOrPassword
    | BadPayload
    | BadPayloadExplanation
    | BadStatus
    | BadUrl
    | BadUrlExplanation
    | BestOf Int
    | CallToActionForCategory
    | CallToActionForDescription CardType
    | Card
    | CardPlaceholder
    | ChangePassword
    | ChangePasswordExplanation
    | Close
    | Collection GrammaticalNumber
    | CollectionAdd
    | CollectionAddDescription
    | CollectionAddTitle
    | CollectionDescriptionPlaceholder
    | CollectionNamePlaceholder
    | CollectionsDescription
    | CollectionsRecommendedBy
    | CollectionSubmissionFailed
    | CollectionsTitle
    | Colon
    | Compare
    | Copyright
    | CountVersionsAvailable Int
    | Create
    | CreateAccountNow
    | CreateOrganizationPage
    | CreateYourAccount
    | Deploy
    | DeployFrenchGov
    | DeployFrenchGovEligibility
    | Description
    | Download
    | DownloadDescription
    | Edit
    | EditCollection
    | EditCollectionCatchPhrase
    | EditCollectionDescription
    | EditCollectionTitle
    | Email
    | EmailPlaceholder
    | EmailSentForAccountActivation String
    | EnterCard
    | EnterDescription
    | EnterEmail
    | EnterName
    | EnterPassword
    | EnterUsername
    | EtalabLogo
    | Faq
    | FaqBug
    | FaqBugContent
    | FaqCategories
    | FaqCategoriesContent1
    | FaqCategoriesContent2
    | FaqCategoriesContentLink
    | FaqCategoriesContentLinkText
    | FaqContribution
    | FaqContributionContent
    | FaqCode
    | FaqData
    | FaqCodeData
    | FaqDataHarvest
    | FaqDataHarvestContent0
    | FaqDataHarvestContent1
    | FaqDataHarvestContent2
    | FaqDescription
    | FaqDev
    | FaqDevContent
    | FaqLanguages
    | FaqLanguagesContent
    | FaqLead
    | FaqModeration
    | FaqModerationContent
    | FaqTarget
    | FaqTargetContent
    | FaqTypes
    | FaqTypesContent
    | FaqTypesContentCollection
    | FaqTypesContentOrganization
    | FaqTypesContentTool
    | FaqTypesContentUseCase
    | FaqWhat
    | FaqWhatContent1
    | FaqWhatContent2
    | FaqWhy
    | FaqWhyContent1
    | FaqWhyContent2
    | FieldTypeEmail
    | FieldTypeInteger
    | FieldTypeSingleLine
    | FieldTypeMultiLine
    | FieldTypeBoolean
    | FieldTypeImage
    | FieldTypeInternalLink
    | FieldTypeURL
    | FindAnotherCard
    | FindCard
    | FooterAbout
    | FooterDiscover
    | GenericError
    | HaveAnAccount
    | HeaderTitle
    | Help
    | Home
    | HomeDescription
    | HomeResults
    | HomeStart
    | HomeTitle
    | Image
    | ImageAlt
    | ImageUploadError String
    | ImproveExistingContent
    | Language Language
    | LanguageWord
    | License
    | LoadingMenu
    | Logo
    | MissingDescription
    | MissingValue
    | Name
    | NetworkErrorExplanation
    | New
    | NewCard
    | NewCardItemBox
    | NewCardCollectionCatchPhrase
    | NewCardOrganization
    | NewCardOrganizationDescription
    | NewCardOrganizationDescriptionPlaceholder
    | NewCardOrganizationCatchPhrase
    | NewCardOrganizationName
    | NewCardTool
    | NewCardToolCatchPhrase
    | NewCardToolDescription
    | NewCardToolDescriptionPlaceholder
    | NewCardToolName
    | NewCardUseCase
    | NewCardUseCaseCatchPhrase
    | NewCardUseCaseDescription
    | NewCardUseCaseDescriptionPlaceholder
    | NewCardUseCaseName
    | OGPsummitLink
    | OpenGovernmentPartnership
    | OpenGovernmentPartnershipLogo
    | OpenGovParagraph
    | Organization GrammaticalNumber
    | OrganizationsDescription
    | PageLoading
    | PageLoadingExplanation
    | PageNotFound
    | PageNotFoundDescription
    | PageNotFoundExplanation
    | Password
    | PasswordChangeFailed
    | PasswordLost
    | PasswordPlaceholder
    | Platform
    | Press
    | PressDescription
    | PressLead
    | ProfileMyCollections
    | Publish
    | PublishCollection
    | PublishOrganization
    | PublishTool
    | PublishUseCase
    | ReadingSelectedImage
    | ReadMore
    | ReleaseDate
    | ReleaseDatePlaceholder
    | Register
    | RegisterNow
    | Remove
    | ResetPassword
    | ResetPasswordExplanation
    | ResetPasswordLink
    | Save
    | Score
    | SearchInputPlaceholder
    | SeeAllAndCompare
    | SelectCardOrTypeMoreCharacters
    | Send
    | SendEmailAgain
    | ServiceDisclaimer
    | Share
    | ShowAll Int
    | ShowMore
    | SignIn
    | SignInToContribute
    | SignOut
    | SignOutAndContributeLater
    | SignUp
    | SimilarTools
    | Software
    | Tags
    | TimeoutExplanation
    | Tool GrammaticalNumber
    | ToolPlaceholder
    | ToolsDescription
    | TweetMessage String String
    | Type
    | UnknownUser
    | UntitledCard
    | UploadImage
    | UploadingImage String
    | UseCase GrammaticalNumber
    | UseCasePlaceholder
    | UseCases
    | UseCasesDescription
    | UsedBy
    | UsedFor
    | Username
    | UsernameOrEmailAlreadyExist
    | UsernamePlaceholder
    | UserProfileDescription
    | Uses
    | UseIt
    | UseTool
    | VoteBestContributions
    | Website
    | WebsiteDescription


getTranslationSet : TranslationId -> TranslationSet
getTranslationSet translationId =
    case translationId of
        About ->
            { english = s "About"
            , french = s "À propos"
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

        AboutDescription ->
            getTranslationSet AboutLead

        AboutLead ->
            { english = s "About the OGP Toolbox"
            , french = s "À propos de la boite à outils OGP"
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

        AccountCreationFailed ->
            { english = s "Account création failed"
            , french = s "Échec de la création du compte"
            , spanish = todo
            }

        ActivationDescription ->
            { english = s "Verification of the user's email address."
            , french = s "Vérification de l'adresse courriel de l'utilisateur."
            , spanish = todo
            }

        ActivationFailed ->
            { english = s "The verification of your email address has failed. Please try again."
            , french = s "La vérification de votre adresse courriel a échoué. Veuillez réessayer."
            , spanish = todo
            }

        ActivationInProgress ->
            { english = s "Verifying your email address..."
            , french = s "Vérification de votre adresse courriel..."
            , spanish = todo
            }

        ActivationNotRequested ->
            { english = s "Your email address will be verified shortly..."
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

        Add ->
            { english = s "Add"
            , french = s "Ajouter"
            , spanish = todo
            }

        AddCard ->
            { english = s "Add Card"
            , french = s "Ajouter une fiche"
            , spanish = todo
            }

        AddCollection ->
            { english = s "Add your collection"
            , french = s "Ajouter votre collection"
            , spanish = todo
            }

        AdditionalInformations ->
            { english = s "Additional informations"
            , french = s "Informations supplémentaires"
            , spanish = todo
            }

        AddTool ->
            { english = s "Add a tool"
            , french = s "Ajouter un outil"
            , spanish = todo
            }

        AddToolOrUseCase ->
            { english = s "Add a new tool or use case"
            , french = s "Ajoutez un nouvel outil ou cas d'usage"
            , spanish = todo
            }

        AddUseCase ->
            { english = s "Add a use case"
            , french = s "Ajouter un cas d'usage"
            , spanish = todo
            }

        AddYourContribution ->
            { english = s "Add your contribution"
            , french = s "Ajouter votre contribution"
            , spanish = todo
            }

        AuthenticationFailed ->
            { english = s "Authentication failed"
            , french = s "L'authentification a échoué"
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

        BadAuthorization ->
            { english = s "Authorization code is wrong or obsolete."
            , french = s "Le code d'autorisation est erroné ou périmé."
            , spanish = todo
            }

        BadEmailOrPassword ->
            { english = s "Either email address is unknown or password is wrong."
            , french = s "Soit l'adresse courriel est inconnue, soit le mot de passe est erroné."
            , spanish = todo
            }

        BadPayload ->
            { english = s "Bad payload"
            , french = s "Contenu incorrect"
            , spanish = todo
            }

        BadPayloadExplanation ->
            { english = s "The server returned unexpected data."
            , french = s "Le server a retourné des données imprévues"
            , spanish = todo
            }

        BadStatus ->
            { english = s "Bad status"
            , french = s "Statut incorrect"
            , spanish = todo
            }

        BadUrl ->
            { english = s "Bad URL"
            , french = s "URL incorrecte"
            , spanish = todo
            }

        BadUrlExplanation ->
            { english = s "The given URL is invalid."
            , french = s "L'URL fournie n'est pas valide."
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
                        s "Ajouter une description pour cette organisation"

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

        Card ->
            { english = s "Card"
            , french = s "Fiche"
            , spanish = todo
            }

        CardPlaceholder ->
            { english = s "Name of a card"
            , french = s "Nom d'une fiche"
            , spanish = todo
            }

        ChangePassword ->
            { english = s "Change your password"
            , french = s "Changez votre mot de passe"
            , spanish = todo
            }

        ChangePasswordExplanation ->
            { english = s "Enter a new password to be able to sign-in."
            , french = s "Entrez un nouveau mot de passe qui vous servira à vous identifier."
            , spanish = todo
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

        CollectionAdd ->
            { english = s "Add your collection"
            , french = s "Ajouter votre collection"
            , spanish = todo
            }

        CollectionAddDescription ->
            { english = s "Creation of a new collection."
            , french = s "Création d'une nouvelle collection."
            , spanish = todo
            }

        CollectionAddTitle ->
            { english = s "Add your collection"
            , french = s "Ajouter votre collection"
            , spanish = todo
            }

        CollectionDescriptionPlaceholder ->
            { english = s "Presentation of your collection"
            , french = s "Présentation de votre collection"
            , spanish = todo
            }

        CollectionsDescription ->
            { english = s "List of tools and use cases collected by a user"
            , french = s "List d'outils et de cas d'usages collectés par un utilisateur"
            , spanish = todo
            }

        CollectionNamePlaceholder ->
            { english = s "Name of your collection"
            , french = s "Nom de votre collection"
            , spanish = todo
            }

        CollectionsRecommendedBy ->
            { english = s "Recommended by "
            , french = s "Recommandé par "
            , spanish = todo
            }

        CollectionSubmissionFailed ->
            { english = s "Collection submission failed"
            , french = s "Échec de l'envoi de la collection"
            , spanish = todo
            }

        CollectionsTitle ->
            { english = s "Collections"
            , french = s "Collections"
            , spanish = todo
            }

        Colon ->
            { english = s ": "
            , french = s " : "
            , spanish = s ": "
            }

        Compare ->
            { english = s "Compare"
            , french = s "Comparer"
            , spanish = todo
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

        Create ->
            { english = s "Create"
            , french = s "Créer"
            , spanish = todo
            }

        CreateAccountNow ->
            { english = s "Create your account"
            , french = s "Créez votre compte"
            , spanish = todo
            }

        CreateOrganizationPage ->
            { english = s "Create a page for your organization "
            , french = s "Créez une page pour votre organisation"
            , spanish = todo
            }

        CreateYourAccount ->
            { english = s "Create your account"
            , french = s "Créez votre compte"
            , spanish = todo
            }

        Deploy ->
            { english = s "Use this tool by installing it on a server provided by a third-party"
            , french = s "Utiliser cet outil en l'installant sur un serveur fourni par un tiers"
            , spanish = todo
            }

        DeployFrenchGov ->
            { english = s "Service provided by the French government"
            , french = s "Service fourni par le gouvernment Français"
            , spanish = todo
            }

        DeployFrenchGovEligibility ->
            { english = s "Available to French administrations"
            , french = s "Réservé aux administrations françaises"
            , spanish = todo
            }

        Description ->
            { english = s "Description"
            , french = s "Description"
            , spanish = todo
            }

        Download ->
            { english = s "Download link"
            , french = s "Lien de téléchargement"
            , spanish = todo
            }

        DownloadDescription ->
            { english = s "Address to download the tool (URL)"
            , french = s "Adresse pour télécharger l'outil (URL)"
            , spanish = todo
            }

        Edit ->
            { english = s "Edit"
            , french = s "Éditer"
            , spanish = todo
            }

        EditCollection ->
            { english = s "Edit your collection"
            , french = s "Éditer votre collection"
            , spanish = todo
            }

        EditCollectionCatchPhrase ->
            { english = s "A simple way to recommend your favorite tools."
            , french = s "Une façon simple de recommander vos outils favoris."
            , spanish = todo
            }

        EditCollectionDescription ->
            { english = s "Edition of a collection."
            , french = s "Édition d'une collection."
            , spanish = todo
            }

        EditCollectionTitle ->
            { english = s "Edit your collection"
            , french = s "Éditer votre collection"
            , spanish = todo
            }

        Email ->
            { english = s "Email"
            , french = s "Courriel"
            , spanish = todo
            }

        EmailPlaceholder ->
            { english = s "john.doe@example.com"
            , french = s "martine.dupont@exemple.fr"
            , spanish = todo
            }

        EmailSentForAccountActivation email ->
            { english =
                s
                    ("An email has been sent to "
                        ++ email
                        ++ ". Click the link it contains, to activate your account."
                    )
            , french =
                s
                    ("Un courriel a été envoyé à "
                        ++ email
                        ++ ". Cliquez sur le lien qu'il contient pour activer votre compte."
                    )
            , spanish = todo
            }

        EnterCard ->
            { english = s "Please enter the name or the ID of a card"
            , french = s "Veuillez entrer le nom ou l'identifiant d'une fiche"
            , spanish = todo
            }

        EnterDescription ->
            { english = s "Please enter a description"
            , french = s "Veuillez entrer une description"
            , spanish = todo
            }

        EnterEmail ->
            { english = s "Please enter your email"
            , french = s "Veuillez entrer votre courriel"
            , spanish = todo
            }

        EnterName ->
            { english = s "Please enter a name"
            , french = s "Veuillez entrer un nom"
            , spanish = todo
            }

        EnterPassword ->
            { english = s "Please enter your password"
            , french = s "Veuillez entrer votre mot de passe"
            , spanish = todo
            }

        EnterUsername ->
            { english = s "Please enter your username"
            , french = s "Veuillez entrer votre nom d'utilisateur"
            , spanish = todo
            }

        EtalabLogo ->
            { english = s "Etalab logo"
            , french = s "Logo d'Etalab"
            , spanish = todo
            }

        Faq ->
            { english = s "FAQ"
            , french = s "FAQ"
            , spanish = todo
            }

        FaqBug ->
            { english = s "How can I report a bug or suggest a new feature?"
            , french = s "Comment puis-je signaliser un bug ou suggérer une nouvelle fonctionnalité ?"
            , spanish = todo
            }

        FaqBugContent ->
            { english = s "If you can't contribute directly to the code of the OGP Toolbox (cf. previous question), you can still help us by telling us about the problems you've encountered on the platform or about your ideas to improve it. Please file a new issue on this page:"
            , french = s "Si vous ne pouvez pas contribuer directement au code de l'OGP Toolbox (cf. question précédente), vous pouvez apporter une aide en nous indiquant les problèmes que vous avez rencontré en utilisant la plateforme ou vos idées pour l'améliorer. Il vous suffit de saisir une nouvelle entrée ('New Issue') sur cette page :"
            , spanish = todo
            }

        FaqCategories ->
            { english = s "How are tools and use cases categorized?"
            , french = s "Comment sont catégorisés les outils et les cas usages ?"
            , spanish = todo
            }

        FaqCategoriesContent1 ->
            { english = s "Rather than classify each tool (and their use cases) in monolithic and exclusive categories (i.e. “a tool cannot be in more than one category”), the platform is based on tags, allowing to qualify each tool and each usage with as many key words as necessary. This is called social tagging or "
            , french = s "Plutôt que de classer les outils (et leurs usages) dans de grandes catégories monolithiques et exclusives (i.e. \"un outil ne peut pas être dans plus d'une catégorie à la fois\"), la plateforme repose sur un système de \"tags\" (labels), permettant de qualifier chaque outil et chaque usage avec autant de mots clés que vous jugerez nécessaire. C'est ce qu'on appelle \"tagging\" social ou "
            , spanish = todo
            }

        FaqCategoriesContentLink ->
            { english = s "https://en.wikipedia.org/wiki/Folksonomy"
            , french = s "https://fr.wikipedia.org/wiki/Folksonomie"
            , spanish = todo
            }

        FaqCategoriesContentLinkText ->
            { english = s "folksonomy"
            , french = s "folksonomie"
            , spanish = todo
            }

        FaqCategoriesContent2 ->
            { english = s "These tags are represented by bubbles. By cliking in different bubbles, you're simply searching in the Toolbox the tools and use cases matching those key words. Results are updated in real-time on the page."
            , french = s "Ces tags sont représentés sous forme de bulles. En cliquant sur différentes bulles, vous cherchez tout simplement dans la Toolbox les outils et cas d'usage qui correspondent à ces mots clés. Les résultats s'affichent en temps réel sur la page."
            , spanish = todo
            }

        FaqContribution ->
            { english = s "How can I add information about a tool, a use case or a collection?"
            , french = s "Comment puis-je renseigner un outil, un cas d'usage, une collection ?"
            , spanish = todo
            }

        FaqContributionContent ->
            { english = s "It's easy. Creat your account on the platform and click on “Add” at the top right of the screen. You will be guided!"
            , french = s "C'est très simple. Il suffit tout d'abord de créer un compte sur la plateforme. Ensuite, cliquer sur \"Ajouter\" en haut à droite et vous serez guidé."
            , spanish = todo
            }

        FaqCode ->
            { english = s "Where can I find the source code of the OGP Toolbox?"
            , french = s "Où puis-je trouver le code source de l'OGP Toolbox ?"
            , spanish = todo
            }

        FaqData ->
            { english = s "How can I access the data?"
            , french = s "Comment puis-je accéder aux données ?"
            , spanish = todo
            }

        FaqCodeData ->
            { english = s "The OGP Toolbox is an open source (AGPL License) and open data project (CC0 License), that's why we publish its source code as well as all harvested data. You'll find all informations and resources on this page:"
            , french = s "L'OGP Toolbox est un projet open source (Licence AGPL) et open data (Licence CC0), nous donnons donc accès à son code source ainsi qu'à toutes les données moissonnées. Vous trouverez toutes les informations et les ressources sur cette page :"
            , spanish = todo
            }

        FaqDataHarvest ->
            { english = s "What is the source of the data?"
            , french = s "D'où proviennent les données ?"
            , spanish = todo
            }

        FaqDataHarvestContent0 ->
            { english = s "The OGP Toolbox data comes from multiple sources:"
            , french = s "Les données de l'OGP Toolbox proviennent de sources multiples :"
            , spanish = todo
            }

        FaqDataHarvestContent1 ->
            { english = s "Existing catalogs are regularly harvested to feed and update the data base:"
            , french = s "Des catalogues existants sont moissonnés régulièrement pour alimenter et mettre à jour la base de données :"
            , spanish = todo
            }

        FaqDataHarvestContent2 ->
            { english = s "OGP Toolbox users can create new tools, use cases and organizations, or edit existing ones."
            , french = s "Les utilisateurs de l'OGP Toolbox peuvent créer de nouvelles fiches d'outil, de cas d'usage et d'organisation, ou éditer des fiches existantes."
            , spanish = todo
            }

        FaqDescription ->
            { english = s "Frequently asked questions (FAQ)"
            , french = s "Foire aux questions (FAQ)"
            , spanish = todo
            }

        FaqDev ->
            { english = s "Who developed the OGP Toolbox?"
            , french = s "Qui a développé l'OGP Toolbox ?"
            , spanish = todo
            }

        FaqDevContent ->
            { english = s "The OGP Toolbox is a free software developed by Etalab, the Prime Minister taskforce in charge of open data and open government French policy, on behalf of the OGP community. Co-created by the open government and the civic tech international community throughout 2016, the OGP Toolbox is one of the main deliverables of the Global Summit of the Open Government Partnership (7, 8 and 9 December 2016)."
            , french = s "L'OGP Toolbox a été développée par Etalab, service du Premier Ministre en charge de l'ouverture des données publiques et du gouvernement ouvert de la France, pour le compte de la communauté du Partenariat du Gouvernement Ouvert. Co-créée avec les communautés internationales du gouvernement ouvert et de la civic tech tout au long de l'année 2016, l'OGP Toolbox est un des principaux livrables du Sommet mondial du Partenariat pour un Gouvernement Ouvert (7, 8 et 9 décembre 2016)."
            , spanish = todo
            }

        FaqLanguages ->
            { english = s "In which languages is the OGP Toolbox available?"
            , french = s "Dans quelles langues est disponible la plateforme ?"
            , spanish = todo
            }

        FaqLanguagesContent ->
            { english = s "The OGP Toolbox is available in English and French. The platform is crowdsourced, which means that other than the online interface (translated by Etalab), any content can be modified and translated by users, such as the description of tools and use cases, as well as the tags used to categorize them (see below). Content will be displayed in the language you configured. If an element is not available in your language, it will be displayed in English by default, with an invitation to translate it."
            , french = s "OGP Toolbox est disponible en Anglais et en Français. La plateforme est crowdsourcée ce qui signifie qu'au-delà de l'interface du site Internet (traduite par Etalab), chaque élément de contenu peut être modifié et traduit par les utilisateurs, notamment les descriptions des outils et des cas d'usage et les tags permettant de les catégoriser (voir ci-dessous). Les éléments de contenu s'afficheront en priorité dans la langue que vous aurez paramétrée. Si un élément n'est pas disponible dans votre langue, il s'affiche en anglais par défaut, et vous invite à le traduire."
            , spanish = todo
            }

        FaqLead ->
            { english = s "All the answers to your questions about the OGP Toolbox"
            , french = s "Mieux comprendre l'OGP Toolbox"
            , spanish = todo
            }

        FaqModeration ->
            { english = s "How are contributions moderated?"
            , french = s "Comment sont modérées les contributions ?"
            , spanish = todo
            }

        FaqModerationContent ->
            { english = s "The OGP Toolbox is based on community moderation. Data from the harvested catalogues and users’ contributions are automatically sort out through an open vote system. For each field, the most popular suggested description is highlighted in the tool, use case or organization card. The vote on available propositions is accessible by clicking on the “edit” button at the right of each field."
            , french = s "OGP Toolbox s'appuie sur une modération communautaire. Les données provenant des catalogues moissonnées et des contributions des utilisateurs sont triées de façon automatique à travers un système de vote ouvert. Pour chaque champ, la proposition de description ou de valeur la plus votée est mise en avant sur la fiche outil, cas d'usage ou organisation. Le vote sur les propositions disponibles est accessible en cliquant sur le bouton \"edit\" à la droite de chaque champ. "
            , spanish = todo
            }

        FaqTarget ->
            { english = s "Who is the OGP Toolbox for?"
            , french = s "À qui est destinée l'OGP Toolbox ?"
            , spanish = todo
            }

        FaqTargetContent ->
            { english = s "The OGP is intended to all public sector, private sector and civil society organizations that develop projects to promote democracy and promote transparency, participation and collaboration. Any engaged citizen willing to be introduced to new tools and to discover particular use cases will be able to access relevant information, and to get in touch with the users’ community."
            , french = s "L'OGP Toolbox est destinée à tous les acteurs publics, privés et de la société civile portant des projets pour renforcer la démocratie et promouvoir la transparence, la participation et la collaboration dans l'action publique. Tout citoyen engagé voulant s'initier à de nouveaux outils et en découvrir les cas d'usages pourra accéder facilement aux informations pertinentes."
            , spanish = todo
            }

        FaqTypes ->
            { english = s "What can I find in the OGP Toolbox?"
            , french = s "Qu'est-ce-qu'on peut trouver dans l'OGP Toolbox ?"
            , spanish = todo
            }

        FaqTypesContent ->
            { english = s "The platform showcases 4 types of items:"
            , french = s "La plateforme référence 4 types d'éléments :"
            , spanish = todo
            }

        FaqTypesContentCollection ->
            { english = s "A collection is a list of tools recommended by a contributor. The same as bookmarks or favorites, but for tools!"
            , french = s "Une collection est une liste d'outils recommandés par un contributeur. Comme des marque-pages ou des favoris, mais pour des outils !"
            , spanish = todo
            }

        FaqTypesContentOrganization ->
            { english = s "An organization is either the user or the developer of a tool, and is part of the public sector (government, administration, parliament, subnational entity), the private sector (company, startup) or the civil society (non-profit organization, movement)."
            , french = s "Une organisation utilise ou développe des outils, et fait partie de la sphère publique (gouvernement, administration, parlement, collectivité locale), du secteur privé (entreprise, startup) ou de la société civile (association, mouvement)."
            , spanish = todo
            }

        FaqTypesContentTool ->
            { english = s "A digital tool is either a computer program (software, application) or an online service (website, platform, resource)."
            , french = s "Un outil numérique est un programme informatique (logiciel, application) ou un service en ligne (site Internet, plateforme, ressource)."
            , spanish = todo
            }

        FaqTypesContentUseCase ->
            { english = s "A use case is a concrete example showing how one or multiple tools were used by an organization."
            , french = s "Un cas d'usage est un exemple concret d'utilisation d'un ou plusieurs outils par une organisation."
            , spanish = todo
            }

        FaqWhat ->
            { english = s "What is the OGP Toolbox?"
            , french = s "Qu'est ce que l'OGP Toolbox ?"
            , spanish = todo
            }

        FaqWhatContent1 ->
            { english = s "The OGP Toolbox is a collaborative platform that gathers digital tools developed and used throughout the world by organizations to improve democracy and promote transparency, participation and collaboration."
            , french = s "L'OGP Toolbox est une plateforme collaborative qui recense les outils numériques développés et utilisés dans le monde entier par des organisations pour renforcer la démocratie et promouvoir la transparence, la participation et la collaboration dans l'action publique."
            , spanish = todo
            }

        FaqWhatContent2 ->
            { english = s "The OGP Toolbox is designed as a social network: concrete use cases, technical criteria informed by the community and recommendations in the form of tool collections allow to benefit from the experience of users that have already implemented existing solutions."
            , french = s "L'OGP Toolbox est conçue comme un réseau social : des cas d'usages concrets, des critères techniques expertisés par la communauté et des recommandations sous forme de collections d'outils permettent de profiter du savoir-faire des acteurs ayant déjà utilisé les solutions disponibles. "
            , spanish = todo
            }

        FaqWhy ->
            { english = s "Why do we need an OGP Toolbox?"
            , french = s "À quoi sert l'OGP Toolbox ? "
            , spanish = todo
            }

        FaqWhyContent1 ->
            { english = s "The OGP Toolbox aims at empowering organizations by sharing resources and experiences. The objective is to facilitate cooperation and the implementation of concrete engagements related to the open government through the appropriation of digital tools."
            , french = s "L'OGP Toolbox vise à renforcer le pouvoir d'agir des acteurs publics, privés et de la société civile à travers le partage de ressources et d'expériences. L'objectif est de faciliter la mise en oeuvre concrète d'engagements et de coopérations liées au gouvernement ouvert grâce à la maîtrise des outils numériques."
            , spanish = todo
            }

        FaqWhyContent2 ->
            { english = s "The platform enables to find the most adapted tool to each project or initiative through search and comparison functionalities by category, use case, organization or technical criterion. The idea is to simplify access and manipulation of digital tools for everyone."
            , french = s "La plateforme permet de trouver l'outil le mieux adapté à chaque projet ou initiative à travers des recherches et des comparaisons par catégorie, cas d'usage, organisation ou critère technique, ainsi que d'en simplifier l'accès et la prise en main."
            , spanish = todo
            }

        FieldTypeBoolean ->
            { english = s "Yes / No"
            , french = s "Oui / Non"
            , spanish = todo
            }

        FieldTypeEmail ->
            { english = s "Email address"
            , french = s "Adresse email"
            , spanish = todo
            }

        FieldTypeImage ->
            { english = s "Image"
            , french = s "Image"
            , spanish = todo
            }

        FieldTypeInternalLink ->
            { english = s "OGP Toolbox internal link"
            , french = s "Lien interne à l'OGP Toolbox"
            , spanish = todo
            }

        FieldTypeInteger ->
            { english = s "Number"
            , french = s "Nombre"
            , spanish = todo
            }

        FieldTypeMultiLine ->
            { english = s "Multi-line text"
            , french = s "Texte sur plusieurs lignes"
            , spanish = todo
            }

        FieldTypeSingleLine ->
            { english = s "Single line text"
            , french = s "Texte sur une seule ligne"
            , spanish = todo
            }

        FieldTypeURL ->
            { english = s "Web address (URL)"
            , french = s "Adresse web (URL)"
            , spanish = todo
            }

        FindAnotherCard ->
            { english = s "Find another card"
            , french = s "Rechercher une autre fiche"
            , spanish = todo
            }

        FindCard ->
            { english = s "Find a card"
            , french = s "Rechercher fiche"
            , spanish = todo
            }

        FooterAbout ->
            { english = s "About"
            , french = s "À propos"
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

        HaveAnAccount ->
            { english = s "I already have an account"
            , french = s "J'ai déjà un compte"
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

        HomeDescription ->
            { english = s "Digital solutions to improve democracy"
            , french = s "Solutions numériques pour la démocratie"
            , spanish = todo
            }

        HomeResults ->
            { english = s "See results"
            , french = s "Afficher les résultats"
            , spanish = todo
            }

        HomeStart ->
            { english = s "Click on a bubble to start"
            , french = s "Cliquez sur une bulle pour commencer"
            , spanish = todo
            }

        HomeTitle ->
            { english = s "OGP Toolbox"
            , french = s "OGP Toolbox"
            , spanish = todo
            }

        Image ->
            { english = s "Image"
            , french = s "Image"
            , spanish = todo
            }

        ImageAlt ->
            { english = s "The uploaded image"
            , french = s "L'image ajoutée"
            , spanish = todo
            }

        ImageUploadError message ->
            { english = s ("Image upload error: " ++ message)
            , french = s ("Échec du téléversement de l'image :" ++ message)
            , spanish = todo
            }

        ImproveExistingContent ->
            { english = s "Improve existing content"
            , french = s "Améliorez le contenu existant"
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
            , spanish = s "Idioma"
            }

        License ->
            { english = s "License"
            , french = s "Licence"
            , spanish = todo
            }

        LoadingMenu ->
            { english = s "Loading menu..."
            , french = s "Chargement du menu..."
            , spanish = todo
            }

        Logo ->
            { english = s "Logo"
            , french = s "Logo"
            , spanish = todo
            }

        MissingDescription ->
            { english = s "Missing description"
            , french = s "Description manquante"
            , spanish = todo
            }

        MissingValue ->
            { english = s "Missing value"
            , french = s "Valeur manquante"
            , spanish = todo
            }

        Name ->
            { english = s "Name"
            , french = s "Nom"
            , spanish = todo
            }

        NetworkErrorExplanation ->
            { english = s "There was a network error."
            , french = todo
            , spanish = todo
            }

        New ->
            { english = s "New"
            , french = s "Nouveau"
            , spanish = todo
            }

        NewCard ->
            { english = s "Add new"
            , french = s "Ajouter"
            , spanish = todo
            }

        NewCardCollectionCatchPhrase ->
            { english = s "A simple way to recommend your favorite tools."
            , french = s "Une façon simple de recommander vos outils favoris."
            , spanish = todo
            }

        NewCardItemBox ->
            { english = s "Add a new item"
            , french = s "Ajouter un nouvel élément"
            , spanish = todo
            }

        NewCardOrganization ->
            { english = s "Add a new organization"
            , french = s "Ajouter une nouvelle organisation"
            , spanish = todo
            }

        NewCardOrganizationCatchPhrase ->
            { english = s "A developer or user of tools."
            , french = s "Un développeur ou utilisateur d'outil."
            , spanish = todo
            }

        NewCardOrganizationDescription ->
            { english = s "Creating a new organization by giving a few generic informations"
            , french = s "Création d'une nouvelle organisation en fournissant quelques informations générales"
            , spanish = todo
            }

        NewCardOrganizationDescriptionPlaceholder ->
            { english = s "Presentation of the organization"
            , french = s "Présentation de l'organisation"
            , spanish = todo
            }

        NewCardOrganizationName ->
            { english = s "Offical name of the organization (e.g. \"Open Knowledge International\")"
            , french = s "Nom officiel de l'organisation (par ex : \"Open Knowledge International\")"
            , spanish = todo
            }

        NewCardTool ->
            { english = s "Add a new tool"
            , french = s "Ajouter un nouvel outil"
            , spanish = todo
            }

        NewCardToolCatchPhrase ->
            { english = s "A software or a website."
            , french = s "Un logiciel ou un site Internet."
            , spanish = todo
            }

        NewCardToolDescription ->
            { english = s "Creating a new tool by giving a few generic informations."
            , french = s "Création d'un nouvel outil en fournissant quelques informations générales"
            , spanish = todo
            }

        NewCardToolDescriptionPlaceholder ->
            { english = s "Presentation of the tool"
            , french = s "Présentation de l'outil"
            , spanish = todo
            }

        NewCardToolName ->
            { english = s "Official name of the tool (e.g. \"Loomio\")"
            , french = s "Nom officiel de l'outil (par ex : \"Loomio\")"
            , spanish = todo
            }

        NewCardUseCase ->
            { english = s "Add a new use case"
            , french = s "Ajouter un nouveau cas d'usage"
            , spanish = todo
            }

        NewCardUseCaseCatchPhrase ->
            { english = s "A concrete example showing how a tool was used."
            , french = s "Un exemple concret d'utilisation d'un ou plusieurs outils."
            , spanish = todo
            }

        NewCardUseCaseDescription ->
            { english = s "Creating a new use case by giving a few generic informations"
            , french = s "Création d'un nouveau cas d'usage en fournissant quelques informations générales"
            , spanish = todo
            }

        NewCardUseCaseDescriptionPlaceholder ->
            { english = s "Presentation of the use case"
            , french = s "Présentation du cas d'usage"
            , spanish = todo
            }

        NewCardUseCaseName ->
            { english = s "Name of the use case (e.g. \"Open Knowledge Forums\")"
            , french = s "Nom du cas d'usage (par ex : \"Forums d'Open Knowledge\")"
            , spanish = todo
            }

        OGPsummitLink ->
            { english = s "https://en.ogpsummit.org/osem/conference/ogp-summit"
            , french = s "https://fr.ogpsummit.org/osem/conference/ogp-summit"
            , spanish = todo
            }

        OpenGovernmentPartnership ->
            { english = s "Open Government Partnership"
            , french = s "Partenariat pour un gouvernement ouvert"
            , spanish = todo
            }

        OpenGovernmentPartnershipLogo ->
            { english = s "Open Government Partnership logo"
            , french = s "logo du Partenariat pour un gouvernement ouvert"
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

        OrganizationsDescription ->
            { english = s "List of organizations"
            , french = s "Liste d'organisations"
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

        PageNotFoundDescription ->
            { english = s "The request pas doesn't exist."
            , french = s "La page demandée n'existe pas."
            , spanish = todo
            }

        PageNotFoundExplanation ->
            { english = s "Sorry, but the page you were trying to view does not exist."
            , french = s "Désolé mais la page que vous avez demandé n'est pas disponible"
            , spanish = todo
            }

        Password ->
            { english = s "Password"
            , french = s "Mot de passe"
            , spanish = todo
            }

        PasswordChangeFailed ->
            { english = s "Password change failed"
            , french = s "Échec du changement de mot de passe"
            , spanish = todo
            }

        PasswordLost ->
            { english = s "Password lost?"
            , french = s "Mot de passe oublié ?"
            , spanish = todo
            }

        PasswordPlaceholder ->
            { english = s "Your secret password"
            , french = s "Votre mot de passe secret"
            , spanish = todo
            }

        Platform ->
            { english = s "Online service (website, platform, resource)"
            , french = s "Service en ligne (site Internet, plateforme, ressource)"
            , spanish = todo
            }

        Press ->
            { english = s "Press"
            , french = s "Presse"
            , spanish = todo
            }

        PressDescription ->
            getTranslationSet PressLead

        PressLead ->
            { english = s "What the press says of the OGP Toolbox"
            , french = s "La presse parle de la boite à outils de l'OGP"
            , spanish = todo
            }

        ProfileMyCollections ->
            { english = s "My collections"
            , french = s "Mes collections"
            , spanish = todo
            }

        Publish ->
            { english = s "Publish"
            , french = s "Publier"
            , spanish = todo
            }

        PublishCollection ->
            { english = s "Publish your collection"
            , french = s "Publier votre collection"
            , spanish = todo
            }

        PublishOrganization ->
            { english = s "Publish organization"
            , french = s "Publier cette organisation"
            , spanish = todo
            }

        PublishUseCase ->
            { english = s "Publish use case"
            , french = s "Publier ce cas d'usage"
            , spanish = todo
            }

        PublishTool ->
            { english = s "Publish tool"
            , french = s "Publier cet outil"
            , spanish = todo
            }

        ReadingSelectedImage ->
            { english = s "Reading selected image..."
            , french = s "Lecture de l'image sélectionnée..."
            , spanish = todo
            }

        ReadMore ->
            { english = s "Read more"
            , french = s "En savoir plus"
            , spanish = todo
            }

        ReleaseDate ->
            { english = s "Release date"
            , french = s "Date de sortie"
            , spanish = todo
            }

        ReleaseDatePlaceholder ->
            { english = s "Launch date of the last stable version"
            , french = s "Date de lancement de la dernière version stable"
            , spanish = todo
            }

        Register ->
            { english = s "Register"
            , french = s "Créer le compte"
            , spanish = todo
            }

        RegisterNow ->
            { english = s "Register now!"
            , french = s "Inscrivez vous maintenant !"
            , spanish = todo
            }

        Remove ->
            { english = s "Remove"
            , french = s "Enlever"
            , spanish = todo
            }

        ResetPassword ->
            { english = s "Reset Password"
            , french = s "Changer de mot de passe"
            , spanish = todo
            }

        ResetPasswordExplanation ->
            { english = s "Enter your email. We will send you the instructions to create a new password."
            , french = s "Entrez votre courriel. Nous vous enverrons les instructions pour changer de mot de passe."
            , spanish = todo
            }

        ResetPasswordLink ->
            { english = s "I forgot my password"
            , french = s "J'ai oublié mon mot de passe"
            , spanish = todo
            }

        Save ->
            { english = s "Save"
            , french = s "Enregistrer"
            , spanish = todo
            }

        SelectCardOrTypeMoreCharacters ->
            { english = s "Select a card or type more characters"
            , french = s "Sélectionner une fiche ou tapez plus de caractères"
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

        SeeAllAndCompare ->
            { english = s "See all and compare"
            , french = s "Voir tous et comparer"
            , spanish = todo
            }

        Send ->
            { english = s "Send"
            , french = s "Envoyer"
            , spanish = todo
            }

        SendEmailAgain ->
            { english = s "Send email again"
            , french = s "Réenvoyer le courriel"
            , spanish = todo
            }

        ServiceDisclaimer ->
            { english = s "Online service"
            , french = s "Service en ligne"
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

        ShowMore ->
            { english = s "Show more"
            , french = s "Voir plus"
            , spanish = todo
            }

        SignIn ->
            { english = s "Sign In"
            , french = s "Identification"
            , spanish = s "Acceder"
            }

        SignInToContribute ->
            { english = s "Sign in to contribute"
            , french = s "Identifiez-vous pour contribuer"
            , spanish = todo
            }

        SignOut ->
            { english = s "Sign Out"
            , french = s "Me déconnecter"
            , spanish = s "Salir"
            }

        SignOutAndContributeLater ->
            { english = s "Sign out and contribute later"
            , french = s "Déconnectez-vous et contribuez plus tard"
            , spanish = todo
            }

        SignUp ->
            { english = s "Sign Up"
            , french = s "M'inscrire"
            , spanish = s "Registrarse"
            }

        SimilarTools ->
            { english = s "Similar tools"
            , french = s "Outils similaires"
            , spanish = todo
            }

        Software ->
            { english = s "Computer program (software, application)"
            , french = s "Programme informatique (logiciel, application)"
            , spanish = todo
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

        ToolPlaceholder ->
            { english = s "Name of a tool"
            , french = s "Nom d'un outil"
            , spanish = todo
            }

        ToolsDescription ->
            { english = s "List of tools"
            , french = s "Liste d'outils"
            , spanish = todo
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

        UnknownUser ->
            { english = s "User is unknown."
            , french = s "L'utilisateur est inconnu."
            , spanish = todo
            }

        UntitledCard ->
            { english = s "Untitled Card"
            , french = s "Fiche sans titre"
            , spanish = s "Tipo"
            }

        UploadImage ->
            { english = s "Upload an image"
            , french = s "Ajouter une image"
            , spanish = todo
            }

        UploadingImage filename ->
            { english = s ("Uploading image \"" ++ filename ++ "\"...")
            , french = s ("Ajout de l'image \"" ++ filename ++ "\"...")
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
                        s "Caso de uso"

                    Plural ->
                        s "Casos de uso"
            }

        UseCasePlaceholder ->
            { english = s "Name of a use case"
            , french = s "Nom d'un cas d'usage"
            , spanish = todo
            }

        UseCases ->
            { english = s "Use cases"
            , french = s "Cas d'usage"
            , spanish = s "Casos de uso"
            }

        UseCasesDescription ->
            { english = s "List of use cases"
            , french = s "Liste de cas d'usage"
            , spanish = todo
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

        Username ->
            { english = s "Username"
            , french = s "Nom d'utilisateur"
            , spanish = todo
            }

        UsernameOrEmailAlreadyExist ->
            { english = s "Username or email are already used."
            , french = s "Le nom d'utilisateur ou le mot de passe sont déjà utilisés."
            , spanish = todo
            }

        UsernamePlaceholder ->
            { english = s "John Doe"
            , french = s "Françoise Martin"
            , spanish = todo
            }

        UserProfileDescription ->
            { english = s "The profile of user and its favorite collections"
            , french = s "Le profil de l'utilisation et ses collections favorites"
            , spanish = todo
            }

        Uses ->
            { english = s "Uses"
            , french = s "Utilise"
            , spanish = todo
            }

        UseIt ->
            { english = s "Use it"
            , french = s "Utiliser"
            , spanish = todo
            }

        UseTool ->
            { english = s "Use this tool"
            , french = s "Utiliser cet outil"
            , spanish = todo
            }

        VoteBestContributions ->
            { english = s "Vote for the best contributions"
            , french = s "Votez pour les meilleurs contributions"
            , spanish = todo
            }

        Website ->
            { english = s "Website"
            , french = s "Site web"
            , spanish = todo
            }

        WebsiteDescription ->
            { english = s "Address of the official website (URl)"
            , french = s "Adresse du site officiel (URL)"
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


languages : List Language
languages =
    [ English
    , French
    , Spanish
    ]


s : a -> Maybe a
s =
    Just


todo : Maybe a
todo =
    Nothing



-- FUNCTIONS


getManyStrings : Language -> List String -> Card -> Dict String TypedValue -> List String
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
                        |> Maybe.andThen (\valueId -> Dict.get valueId values)
                        |> Maybe.map (\value -> getStrings value.value)
                        |> Maybe.withDefault []
                )
            |> List.filter (not << List.isEmpty)
            |> List.head
            |> Maybe.withDefault []


getOneString : Language -> List String -> Card -> Dict String TypedValue -> Maybe String
getOneString language keyIds card values =
    keyIds
        |> List.map
            (\keyId ->
                Dict.get keyId card.properties
                    |> Maybe.andThen (\valueId -> Dict.get valueId values)
                    |> Maybe.andThen (\value -> getOneStringFromValueType language values value.value)
            )
        |> oneOfMaybes


getOneStringFromValueType : Language -> Dict String TypedValue -> ValueType -> Maybe String
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
                |> Maybe.andThen (\subValue -> getOneStringFromValueType language values subValue.value)

        WrongValue _ _ ->
            Nothing


getName : Language -> Card -> Dict String TypedValue -> String
getName language card values =
    -- Note: Name can be Nothing, if down-voted.
    getOneString language nameKeys card values
        |> Maybe.withDefault (translate language UntitledCard)


getLocalizedStringFromValueId : Language -> Dict String TypedValue -> String -> String
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


getSubTypes : Language -> Card -> Dict String TypedValue -> List String
getSubTypes language card values =
    List.map
        (getLocalizedStringFromValueId language values)
        card.subTypeIds


getTags : Language -> Card -> Dict String TypedValue -> List { tag : String, tagId : String }
getTags language card values =
    List.map
        (\tagId ->
            { tag = getLocalizedStringFromValueId language values tagId
            , tagId = tagId
            }
        )
        card.tagIds


getUsages : Language -> Card -> Dict String TypedValue -> List { tag : String, tagId : String }
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


{-| Pick the first `Maybe` that actually has a value. Useful when you want to
try a couple different things, but there is no default value.

    oneOf [ Nothing, Just 42, Just 71 ] == Just 42
    oneOf [ Nothing, Nothing, Just 71 ] == Just 71
    oneOf [ Nothing, Nothing, Nothing ] == Nothing
-}
oneOfMaybes : List (Maybe a) -> Maybe a
oneOfMaybes maybes =
    case maybes of
        [] ->
            Nothing

        maybe :: rest ->
            case maybe of
                Nothing ->
                    oneOfMaybes rest

                Just _ ->
                    maybe


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
        oneOfMaybes
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
