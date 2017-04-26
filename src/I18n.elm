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
    | AddALogo
    | AddATag
    | AddCard
    | AddCollection
    | AddPropertyKey
    | AdditionalInformations
    | AddOrganization
    | AddTool
    | AddToolOrUseCase
    | AddUseCase
    | AddYourArguments
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
    | BijectiveCardReference
    | Boolean
    | BooleanField
    | CallToActionForArguments CardType
    | CallToActionForCategory
    | CallToActionForDescription CardType
    | Card
    | CardId
    | CardIdArray
    | CardIdField
    | CardLoadingFailed
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
    | Contact
    | ContactContent
    | CountVersionsAvailable Int
    | Create
    | CreateAccountNow
    | CreateOrganizationPage
    | CreateYourAccount
    | Debate
    | DebateArgumentAgainst
    | DebateArgumentFor
    | DebateConsLabel
    | DebateProsLabel
    | DebateTitle
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
    | EnterBoolean
    | EnterCard
    | EnterDescription
    | EnterEmail
    | EnterImage
    | EnterName
    | EnterNumber
    | EnterPassword
    | EnterPropertyKey
    | EnterUrl
    | EnterUsername
    | EnterValue
    | EtalabLogo
    | EveryLanguage
    | FalseWord
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
    | FindAnotherPropertyKey
    | FindCard
    | FindPropertyKey
    | FooterAbout
    | FooterContact
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
    | ImageField
    | ImageUploadError String
    | ImproveExistingContent
    | InputEmailField
    | InputNumberField
    | InputUrlField
    | InvalidNumber
    | Language Language
    | LanguageWord
    | License
    | LoadingMenu
    | LocalizedString
    | Logo
    | MissingArguments
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
    | NewProperty
    | NewPropertyDescription
    | NewValue
    | NewValueDescription
    | Number
    | NumberPlaceholder
    | Ogp
    | OgpDescription
    | OgpTitle
    | OpenGovernmentPartnership
    | OpenGovernmentPartnershipLogo
    | OpenGovParagraph
    | OpenData
    | OpenSource
    | Organization GrammaticalNumber
    | OrganizationId
    | OrganizationIdField
    | OrganizationPlaceholder
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
    | PropertyKeyPlaceholder
    | Proprietary
    | ProsAndCons
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
    | SelectPropertyKeyOrTypeMoreCharacters
    | Send
    | SendEmailAgain
    | ServiceDisclaimer
    | Share
    | ShowAll Int
    | ShowMore
    | ShowMoreCount Int
    | SignIn
    | SignInToContribute
    | SignOut
    | SignOutAndContributeLater
    | SignUp
    | String
    | SimilarTools
    | Software
    | Tags
    | TextField
    | TheProject
    | TimeoutExplanation
    | Tool GrammaticalNumber
    | ToolId
    | ToolIdField
    | ToolPlaceholder
    | ToolsDescription
    | TrueWord
    | TweetMessage String String
    | Type
    | UnknownLanguage
    | UnknownSchemaId String
    | UnknownUser
    | UnknownValue
    | UntitledCard
    | UploadImage
    | UploadingImage String
    | Url
    | UrlPlaceholder
    | UseCase GrammaticalNumber
    | UseCaseId
    | UseCaseIdField
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
    | Value
    | ValueCreationFailed
    | ValueId
    | ValueIdArray
    | ValuePlaceholder
    | VoteBestContributions
    | Website
    | WebsiteDescription


emptyTranslationSet : TranslationSet
emptyTranslationSet =
    { bulgarian = todo
    , croatian = todo
    , czech = todo
    , danish = todo
    , dutch = todo
    , english = todo
    , estonian = todo
    , finnish = todo
    , french = todo
    , german = todo
    , greek = todo
    , hungarian = todo
    , irish = todo
    , italian = todo
    , latvian = todo
    , lithuanian = todo
    , maltese = todo
    , polish = todo
    , portuguese = todo
    , romanian = todo
    , slovak = todo
    , slovenian = todo
    , spanish = todo
    , swedish = todo
    }


getTranslationSet : TranslationId -> TranslationSet
getTranslationSet translationId =
    case translationId of
        About ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "About"
                , french = s "À propos"
                , spanish = s "Sobre"
            }

        AboutCredits ->
            { emptyTranslationSet
                | dutch = s "Credits"
                , english = s "Credits"
                , french = s "Crédits"
                , spanish = s "Créditos"
            }

        AboutCreditsContent ->
            { emptyTranslationSet
                | dutch = s "De bellen module voor de termen is gebaseerd op "
                , english = s "The bubble tags navigation system is based on "
                , french = s "Le système de navigations des tags par bulles est basé sur la solution "
                , spanish = todo
            }

        AboutDescription ->
            getTranslationSet AboutLead

        AboutLead ->
            { emptyTranslationSet
                | dutch = s "Over de OGP Toolbox"
                , english = s "About the OGP Toolbox"
                , french = s "À propos de la boite à outils OGP"
                , spanish = todo
            }

        AboutLegal ->
            { emptyTranslationSet
                | dutch = s "Disclaimer"
                , english = s "Legal notices"
                , french = s "Mentions légales"
                , spanish = s "Nota legal"
            }

        AboutLegalContent ->
            { emptyTranslationSet
                | dutch = s "OGPtoolobox.org wordt verzorgd door Etalab, 39 quai André Citroën 75015 PARIS, FRANKRIJK"
                , english = s "OGPtoolobox.org is maintained by Etalab, 39 quai André Citroën 75015 PARIS, FRANCE"
                , french = s "OGPtoolobox.org est édité par la mission Etalab, service du Premier Ministre, 39 quai André Citroën 75015 PARIS."
                , spanish = todo
            }

        AccountCreationFailed ->
            { emptyTranslationSet
                | dutch = s "Account maken is mislukt"
                , english = s "Account création failed"
                , french = s "Échec de la création du compte"
                , spanish = todo
            }

        ActivationDescription ->
            { emptyTranslationSet
                | dutch = s "Verificatie van het emailadres"
                , english = s "Verification of the user's email address."
                , french = s "Vérification de l'adresse courriel de l'utilisateur."
                , spanish = todo
            }

        ActivationFailed ->
            { emptyTranslationSet
                | dutch = s "Verificatie van het emailadres is mislukt. Probeer het nogmaals"
                , english = s "The verification of your email address has failed. Please try again."
                , french = s "La vérification de votre adresse courriel a échoué. Veuillez réessayer."
                , spanish = todo
            }

        ActivationInProgress ->
            { emptyTranslationSet
                | dutch = s "Email adres wordt geverifieeerd..."
                , english = s "Verifying your email address..."
                , french = s "Vérification de votre adresse courriel..."
                , spanish = todo
            }

        ActivationNotRequested ->
            { emptyTranslationSet
                | dutch = s "Email adres wordt geverifieeerd..."
                , english = s "Your email address will be verified shortly..."
                , french = s "Votre adresse courriel va bientôt être vérifiée..."
                , spanish = todo
            }

        ActivationSucceeded ->
            { emptyTranslationSet
                | dutch = s "Verificatie van het emailadres is gelukt. Account is geactiveerd"
                , english = s "Verification of your email address has succeeded. Account is now activated!"
                , french = s "La vérification de votre adresse courriel a réussi. Votre compte est maintenant activé !"
                , spanish = todo
            }

        ActivationTitle ->
            { emptyTranslationSet
                | dutch = s "Account verificatie"
                , english = s "User Account Activation"
                , french = s "Activation du compte utilisateur"
                , spanish = todo
            }

        Add ->
            { emptyTranslationSet
                | dutch = s "Nieuw"
                , english = s "Add"
                , french = s "Ajouter"
                , spanish = todo
            }

        AddALogo ->
            { emptyTranslationSet
                | dutch = s "+ Nieuw logo"
                , english = s "+ Add a logo"
                , french = s "+ Ajouter un logo"
                , spanish = todo
            }

        AddATag ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "+ Add a tag"
                , french = s "+ Ajouter un tag"
                , spanish = todo
            }

        AddCard ->
            { emptyTranslationSet
                | dutch = s "Nieuwe kaart"
                , english = s "Add card"
                , french = s "Ajouter un fiche"
                , spanish = todo
            }

        AddCollection ->
            { emptyTranslationSet
                | dutch = s "Nieuwe collectie"
                , english = s "Add your collection"
                , french = s "Ajouter votre collection"
                , spanish = todo
            }

        AddPropertyKey ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "Add property"
                , french = s "Ajouter une propriété"
                , spanish = todo
            }

        AdditionalInformations ->
            { emptyTranslationSet
                | dutch = s "Aanvullende informatie"
                , english = s "Additional information"
                , french = s "Informations supplémentaires"
                , spanish = todo
            }

        AddOrganization ->
            { emptyTranslationSet
                | dutch = s "Nieuw organisatie"
                , english = s "Add an organization"
                , french = s "Ajouter une organisation"
                , spanish = todo
            }

        AddTool ->
            { emptyTranslationSet
                | dutch = s "Nieuw platform"
                , english = s "Add a tool"
                , french = s "Ajouter un outil"
                , spanish = todo
            }

        AddToolOrUseCase ->
            { emptyTranslationSet
                | dutch = s "Nieuwe toepassing of platform"
                , english = s "Add a new tool or use case"
                , french = s "Ajoutez un nouvel outil ou cas d'usage"
                , spanish = todo
            }

        AddUseCase ->
            { emptyTranslationSet
                | dutch = s "Nieuwe toepassing"
                , english = s "Add a use case"
                , french = s "Ajouter un cas d'usage"
                , spanish = todo
            }

        AddYourArguments ->
            { emptyTranslationSet
                | english = s "Add arguments"
                , french = s "Ajouter vos arguments"
            }

        AddYourContribution ->
            { emptyTranslationSet
                | dutch = s "Informatie toevoegen"
                , english = s "Contribute information"
                , french = s "Ajouter votre contribution"
                , spanish = todo
            }

        AuthenticationFailed ->
            { emptyTranslationSet
                | dutch = s "Authenticatie mislukt"
                , english = s "Authentication failed"
                , french = s "L'authentification a échoué"
                , spanish = todo
            }

        AuthenticationRequired ->
            { emptyTranslationSet
                | dutch = s "Authenticatie vereist"
                , english = s "Authentication required"
                , french = todo
                , spanish = todo
            }

        AuthenticationRequiredExplanation ->
            { emptyTranslationSet
                | dutch = s "Je moet aangemeld zijn om deze pagina te bekijken."
                , english = s "You must sign in to display this page."
                , french = todo
                , spanish = todo
            }

        BadAuthorization ->
            { emptyTranslationSet
                | dutch = s "De authorizatie code is fout of verlopen."
                , english = s "Authorization code is wrong or obsolete."
                , french = s "Le code d'autorisation est erroné ou périmé."
                , spanish = todo
            }

        BadEmailOrPassword ->
            { emptyTranslationSet
                | dutch = s "Emailadres of wachtwoord onjuist"
                , english = s "Either email address is unknown or password is wrong."
                , french = s "Soit l'adresse courriel est inconnue, soit le mot de passe est erroné."
                , spanish = todo
            }

        BadPayload ->
            { emptyTranslationSet
                | dutch = s "Foutieve inhoud"
                , english = s "Bad payload"
                , french = s "Contenu incorrect"
                , spanish = todo
            }

        BadPayloadExplanation ->
            { emptyTranslationSet
                | dutch = s "De server retourneerde onjuiste gegevens."
                , english = s "The server returned unexpected data."
                , french = s "Le server a retourné des données imprévues"
                , spanish = todo
            }

        BadStatus ->
            { emptyTranslationSet
                | dutch = s "Foutieve status"
                , english = s "Bad status"
                , french = s "Statut incorrect"
                , spanish = todo
            }

        BadUrl ->
            { emptyTranslationSet
                | dutch = s "Foutieve URL"
                , english = s "Bad URL"
                , french = s "URL incorrecte"
                , spanish = todo
            }

        BadUrlExplanation ->
            { emptyTranslationSet
                | dutch = s "De opgegeven URL is onjuist."
                , english = s "The given URL is invalid."
                , french = s "L'URL fournie n'est pas valide."
                , spanish = todo
            }

        BestOf count ->
            { emptyTranslationSet
                | dutch = s ("Beste van " ++ (toString count))
                , english = s ("Best of " ++ (toString count))
                , french = s ("Meilleur parmi " ++ (toString count))
                , spanish = todo
            }

        BijectiveCardReference ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "Bijective link to a card"
                , french = s "Lien bijectif vers une fiche"
                , spanish = todo
            }

        Boolean ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "Boolean"
                , french = s "Booléen"
                , spanish = todo
            }

        BooleanField ->
            getTranslationSet Boolean

        CallToActionForArguments cardType ->
            { emptyTranslationSet
                | dutch =
                    case cardType of
                        UseCaseCard ->
                            todo

                        OrganizationCard ->
                            todo

                        ToolCard ->
                            todo
                , english =
                    case cardType of
                        UseCaseCard ->
                            s "Add pros & cons for this use case"

                        OrganizationCard ->
                            s "Add pros & cons for this organization"

                        ToolCard ->
                            s "Add a pros & cons for this tool"
                , french =
                    case cardType of
                        UseCaseCard ->
                            s "Ajouter des arguments pour ou contre ce cas d'usage"

                        OrganizationCard ->
                            s "Ajouter des arguments pour ou contre cette organisation"

                        ToolCard ->
                            s "Ajouter des arguments pour ou contre cet outil"
                , spanish =
                    case cardType of
                        UseCaseCard ->
                            todo

                        OrganizationCard ->
                            todo

                        ToolCard ->
                            todo
            }

        CallToActionForCategory ->
            { emptyTranslationSet
                | dutch = s "+ Nieuwe categorie"
                , english = s "+ Add category"
                , french = s "+ Ajouter une catégorie"
                , spanish = todo
            }

        CallToActionForDescription cardType ->
            { emptyTranslationSet
                | dutch =
                    case cardType of
                        UseCaseCard ->
                            s "Omschrijf deze toepassing"

                        OrganizationCard ->
                            s "Omschrijf deze organisatie"

                        ToolCard ->
                            s "Omschrijf dit platform"
                , english =
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
            { emptyTranslationSet
                | dutch = s "Kaart"
                , english = s "Card"
                , french = s "Fiche"
                , spanish = todo
            }

        CardId ->
            { emptyTranslationSet
                | dutch = s "Kaart"
                , english = s "Card"
                , french = s "Fiche"
                , spanish = todo
            }

        CardIdArray ->
            { emptyTranslationSet
                | dutch = s "Lijst van links naar kaarten"
                , english = s "Array of links to cards"
                , french = s "Tableau de liens vers des fiches"
                , spanish = todo
            }

        CardIdField ->
            getTranslationSet CardId

        CardLoadingFailed ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "Card retrieval failed"
                , french = s "Échec de la récupération de la fiche"
                , spanish = todo
            }

        CardPlaceholder ->
            { emptyTranslationSet
                | dutch = s "Kaartnaam"
                , english = s "Name of a card"
                , french = s "Nom d'une fiche"
                , spanish = todo
            }

        ChangePassword ->
            { emptyTranslationSet
                | dutch = s "Wijzig je wachtwoord"
                , english = s "Change your password"
                , french = s "Changez votre mot de passe"
                , spanish = todo
            }

        ChangePasswordExplanation ->
            { emptyTranslationSet
                | dutch = s "Kies een wachtwoord om mee aan te kunnen melden"
                , english = s "Enter a new password to be able to sign-in."
                , french = s "Entrez un nouveau mot de passe qui vous servira à vous identifier."
                , spanish = todo
            }

        Close ->
            { emptyTranslationSet
                | dutch = s "Gesloten"
                , english = s "Close"
                , french = s "Fermer"
                , spanish = todo
            }

        Collection number ->
            { emptyTranslationSet
                | dutch =
                    case number of
                        Singular ->
                            s "Collectie"

                        Plural ->
                            s "Collecties"
                , english =
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
            { emptyTranslationSet
                | dutch = s "Nieuwe collectie"
                , english = s "Add your collection"
                , french = s "Ajouter votre collection"
                , spanish = todo
            }

        CollectionAddDescription ->
            { emptyTranslationSet
                | dutch = s "Een nieuwe collectie aanmaken."
                , english = s "Creation of a new collection."
                , french = s "Création d'une nouvelle collection."
                , spanish = todo
            }

        CollectionAddTitle ->
            { emptyTranslationSet
                | dutch = s "Nieuwe collectie"
                , english = s "Add your collection"
                , french = s "Ajouter votre collection"
                , spanish = todo
            }

        CollectionDescriptionPlaceholder ->
            { emptyTranslationSet
                | dutch = s "Presentatie van de collectie"
                , english = s "Presentation of your collection"
                , french = s "Présentation de votre collection"
                , spanish = todo
            }

        CollectionsDescription ->
            { emptyTranslationSet
                | dutch = s "Lijst van platformen en toepassingen"
                , english = s "List of tools and use cases collected by a user"
                , french = s "List d'outils et de cas d'usages collectés par un utilisateur"
                , spanish = todo
            }

        CollectionNamePlaceholder ->
            { emptyTranslationSet
                | dutch = s "Naam van de collectie"
                , english = s "Name of your collection"
                , french = s "Nom de votre collection"
                , spanish = todo
            }

        CollectionsRecommendedBy ->
            { emptyTranslationSet
                | dutch = s "Aanbevolen door"
                , english = s "Recommended by "
                , french = s "Recommandé par "
                , spanish = todo
            }

        CollectionSubmissionFailed ->
            { emptyTranslationSet
                | dutch = s "Collectie aanmaken mislukt"
                , english = s "Collection submission failed"
                , french = s "Échec de l'envoi de la collection"
                , spanish = todo
            }

        CollectionsTitle ->
            { emptyTranslationSet
                | dutch = s "Collecties"
                , english = s "Collections"
                , french = s "Collections"
                , spanish = s "Colecciones"
            }

        Colon ->
            { bulgarian = s ": "
            , croatian = s ": "
            , czech = s ": "
            , danish = s ": "
            , dutch = s ": "
            , english = s ": "
            , estonian = s ": "
            , finnish = s ": "
            , french = s " : "
            , german = s ": "
            , greek = s ": "
            , hungarian = s ": "
            , irish = s ": "
            , italian = s ": "
            , latvian = s ": "
            , lithuanian = s ": "
            , maltese = s ": "
            , polish = s ": "
            , portuguese = s ": "
            , romanian = s ": "
            , slovak = s ": "
            , slovenian = s ": "
            , spanish = s ": "
            , swedish = s ": "
            }

        Compare ->
            { emptyTranslationSet
                | dutch = s "Vergelijken"
                , english = s "Compare"
                , french = s "Comparer"
                , spanish = todo
            }

        Contact ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "How can I contact the team behind the OGP Toolbox?"
                , french = s "Comment puis-je contacter l'équipe derrière l'OGP Toolbox ?"
                , spanish = todo
            }

        ContactContent ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "For all questions, please send us an email:"
                , french = s "Pour toute question, vous pouvez nous envoyer un email à cette adresse :"
                , spanish = todo
            }

        CountVersionsAvailable count ->
            { emptyTranslationSet
                | dutch =
                    case count of
                        0 ->
                            s "geen informatie"

                        1 ->
                            s "1 versie"

                        _ ->
                            s ((toString count) ++ " versies")
                , english =
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
            { emptyTranslationSet
                | dutch = s "Maak"
                , english = s "Create"
                , french = s "Créer"
                , spanish = todo
            }

        CreateAccountNow ->
            { emptyTranslationSet
                | dutch = s "Maak een account"
                , english = s "Create your account"
                , french = s "Créez votre compte"
                , spanish = todo
            }

        CreateOrganizationPage ->
            { emptyTranslationSet
                | dutch = s "Maak een pagina voor de organisatie"
                , english = s "Create a page for your organization "
                , french = s "Créez une page pour votre organisation"
                , spanish = todo
            }

        CreateYourAccount ->
            { emptyTranslationSet
                | dutch = s "Account aanmaken"
                , english = s "Create your account"
                , french = s "Créez votre compte"
                , spanish = todo
            }

        Debate ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "Debate"
                , french = s "Débattre"
                , spanish = todo
            }

        DebateArgumentAgainst ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "Argument Against"
                , french = s "Argument contre"
                , spanish = todo
            }

        DebateArgumentFor ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "Argument For"
                , french = s "Argument pour"
                , spanish = todo
            }

        DebateConsLabel ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "- Argument Against"
                , french = s "- Argument contre"
                , spanish = todo
            }

        DebateProsLabel ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "+ Argument For"
                , french = s "+ Argument pour"
                , spanish = todo
            }

        DebateTitle ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "Debate"
                , french = s "Débat"
                , spanish = todo
            }

        Deploy ->
            { emptyTranslationSet
                | dutch = s "Gebruik dit platorm door het te installeren op een internet omgeving"
                , english = s "Use this tool by installing it on a server provided by a third-party"
                , french = s "Utiliser cet outil en l'installant sur un serveur fourni par un tiers"
                , spanish = todo
            }

        DeployFrenchGov ->
            { emptyTranslationSet
                | dutch = s "Deze dienst is mogelijk gemaakt door de franse regering"
                , english = s "Service provided by the French government"
                , french = s "Service fourni par le gouvernment Français"
                , spanish = todo
            }

        DeployFrenchGovEligibility ->
            { emptyTranslationSet
                | dutch = s "Beschikbaar voor franse overheden"
                , english = s "Available to French administrations"
                , french = s "Réservé aux administrations françaises"
                , spanish = todo
            }

        Description ->
            { emptyTranslationSet
                | dutch = s "Omschrijving"
                , english = s "Description"
                , french = s "Description"
                , spanish = todo
            }

        Download ->
            { emptyTranslationSet
                | dutch = s "Download link"
                , english = s "Download link"
                , french = s "Lien de téléchargement"
                , spanish = todo
            }

        DownloadDescription ->
            { emptyTranslationSet
                | dutch = s "Internetadres om het platform te downloaden (URL)"
                , english = s "Address to download the tool (URL)"
                , french = s "Adresse pour télécharger l'outil (URL)"
                , spanish = todo
            }

        Edit ->
            { emptyTranslationSet
                | dutch = s "Wijzig"
                , english = s "Edit"
                , french = s "Éditer"
                , spanish = todo
            }

        EditCollection ->
            { emptyTranslationSet
                | dutch = s "Collectie bewerken"
                , english = s "Edit your collection"
                , french = s "Éditer votre collection"
                , spanish = todo
            }

        EditCollectionCatchPhrase ->
            { emptyTranslationSet
                | dutch = s "Groepeer gelijkvormige of afhankelijke platformen"
                , english = s "A simple way to recommend your favorite tools."
                , french = s "Une façon simple de recommander vos outils favoris."
                , spanish = todo
            }

        EditCollectionDescription ->
            { emptyTranslationSet
                | dutch = s "Bewerk een collectie"
                , english = s "Edit a collection."
                , french = s "Édition d'une collection."
                , spanish = todo
            }

        EditCollectionTitle ->
            { emptyTranslationSet
                | dutch = s "Bewerk jouw collectie"
                , english = s "Edit your collection"
                , french = s "Éditer votre collection"
                , spanish = todo
            }

        Email ->
            { emptyTranslationSet
                | dutch = s "Email"
                , english = s "Email"
                , french = s "Courriel"
                , spanish = todo
            }

        EmailPlaceholder ->
            { emptyTranslationSet
                | dutch = s "jan.jansen@voorbeeld.nl"
                , english = s "john.doe@example.com"
                , french = s "martin.dupont@exemple.fr"
                , spanish = todo
            }

        EmailSentForAccountActivation email ->
            { emptyTranslationSet
                | dutch =
                    s
                        ("Er is een email verzonden naar "
                            ++ email
                            ++ ". Klik op de link in de email om je account te activeren."
                        )
                , english =
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

        EnterBoolean ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "Please check or uncheck the box"
                , french = s "Veuillez cocher ou décocher la case"
                , spanish = todo
            }

        EnterCard ->
            { emptyTranslationSet
                | dutch = s "Geef de naam of id van een kaart"
                , english = s "Please enter the name or the ID of a card"
                , french = s "Veuillez entrer le nom ou l'identifiant d'une fiche"
                , spanish = todo
            }

        EnterDescription ->
            { emptyTranslationSet
                | dutch = s "Geef een omschrijving"
                , english = s "Please enter a description"
                , french = s "Veuillez entrer une description"
                , spanish = todo
            }

        EnterEmail ->
            { emptyTranslationSet
                | dutch = s "Geef een emailadres"
                , english = s "Please enter your email"
                , french = s "Veuillez entrer votre courriel"
                , spanish = todo
            }

        EnterImage ->
            { emptyTranslationSet
                | dutch = s "Selecteer een afbeelding"
                , english = s "Please select an image"
                , french = s "Veuillez sélectionner une image"
                , spanish = todo
            }

        EnterName ->
            { emptyTranslationSet
                | dutch = s "Geef een naam"
                , english = s "Please enter a name"
                , french = s "Veuillez entrer un nom"
                , spanish = todo
            }

        EnterNumber ->
            { emptyTranslationSet
                | dutch = s "Geef een nummer"
                , english = s "Please enter a number"
                , french = s "Veuillez entrer un nombre"
                , spanish = todo
            }

        EnterPassword ->
            { emptyTranslationSet
                | dutch = s "Geef een wachtwoord"
                , english = s "Please enter your password"
                , french = s "Veuillez entrer votre mot de passe"
                , spanish = todo
            }

        EnterPropertyKey ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "Please enter the name or the ID of a property"
                , french = s "Veuillez entrer le nom ou l'identifiant d'une propriété"
                , spanish = todo
            }

        EnterUrl ->
            { emptyTranslationSet
                | dutch = s "Geef een link (URL)"
                , english = s "Please enter a link (an URL)"
                , french = s "Veuillez entrer un lien (une URL)"
                , spanish = todo
            }

        EnterUsername ->
            { emptyTranslationSet
                | dutch = s "Geef een gebruikersnaam"
                , english = s "Please enter your username"
                , french = s "Veuillez entrer votre nom d'utilisateur"
                , spanish = todo
            }

        EnterValue ->
            { emptyTranslationSet
                | dutch = s "Geef een waarde"
                , english = s "Please enter value"
                , french = s "Veuillez entrer une valeur"
                , spanish = todo
            }

        EtalabLogo ->
            { emptyTranslationSet
                | dutch = s "Etalab logo"
                , english = s "Etalab logo"
                , french = s "Logo d'Etalab"
                , spanish = todo
            }

        EveryLanguage ->
            { emptyTranslationSet
                | dutch = s "Alle talen"
                , english = s "Every language"
                , french = s "Toutes les langues"
                , spanish = todo
            }

        FalseWord ->
            { emptyTranslationSet
                | dutch = s "Onwaar"
                , english = s "False"
                , french = s "Faux"
                , spanish = todo
            }

        Faq ->
            { emptyTranslationSet
                | dutch = s "Veelgestelde vragen"
                , english = s "FAQ"
                , french = s "FAQ"
                , spanish = todo
            }

        FaqBug ->
            { emptyTranslationSet
                | dutch = s "Hoe kan ik een fout melden of een idee indienen?"
                , english = s "How can I report a bug or suggest a new feature?"
                , french = s "Comment puis-je signaliser un bug ou suggérer une nouvelle fonctionnalité ?"
                , spanish = todo
            }

        FaqBugContent ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "If you can't contribute directly to the code of the OGP Toolbox (cf. previous question), you can still help us by telling us about the problems you've encountered on the platform or about your ideas to improve it. Please file a new issue on this page:"
                , french = s "Si vous ne pouvez pas contribuer directement au code de l'OGP Toolbox (cf. question précédente), vous pouvez apporter une aide en nous indiquant les problèmes que vous avez rencontré en utilisant la plateforme ou vos idées pour l'améliorer. Il vous suffit de saisir une nouvelle entrée ('New Issue') sur cette page :"
                , spanish = todo
            }

        FaqCategories ->
            { emptyTranslationSet
                | dutch = s "How worden platformen en toepassingen gecategoriseerd?"
                , english = s "How are tools and use cases categorized?"
                , french = s "Comment sont catégorisés les outils et les cas usages ?"
                , spanish = todo
            }

        FaqCategoriesContent1 ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "Rather than classify each tool (and their use cases) in monolithic and exclusive categories (i.e. “a tool cannot be in more than one category”), the platform is based on tags, allowing to qualify each tool and each usage with as many key words as necessary. This is called social tagging or "
                , french = s "Plutôt que de classer les outils (et leurs usages) dans de grandes catégories monolithiques et exclusives (i.e. \"un outil ne peut pas être dans plus d'une catégorie à la fois\"), la plateforme repose sur un système de \"tags\" (labels), permettant de qualifier chaque outil et chaque usage avec autant de mots clés que vous jugerez nécessaire. C'est ce qu'on appelle \"tagging\" social ou "
                , spanish = todo
            }

        FaqCategoriesContentLink ->
            { emptyTranslationSet
                | dutch = s "https://nl.wikipedia.org/wiki/Folksonomie"
                , english = s "https://en.wikipedia.org/wiki/Folksonomy"
                , french = s "https://fr.wikipedia.org/wiki/Folksonomie"
                , spanish = todo
            }

        FaqCategoriesContentLinkText ->
            { emptyTranslationSet
                | dutch = s "Folksonomie"
                , english = s "folksonomy"
                , french = s "folksonomie"
                , spanish = todo
            }

        FaqCategoriesContent2 ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "These tags are represented by bubbles. By cliking in different bubbles, you're simply searching in the Toolbox the tools and use cases matching those key words. Results are updated in real-time on the page."
                , french = s "Ces tags sont représentés sous forme de bulles. En cliquant sur différentes bulles, vous cherchez tout simplement dans la Toolbox les outils et cas d'usage qui correspondent à ces mots clés. Les résultats s'affichent en temps réel sur la page."
                , spanish = todo
            }

        FaqContribution ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "How can I add information about a tool, a use case or a collection?"
                , french = s "Comment puis-je renseigner un outil, un cas d'usage, une collection ?"
                , spanish = todo
            }

        FaqContributionContent ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "It's easy. Creat your account on the platform and click on “Add” at the top right of the screen. You will be guided!"
                , french = s "C'est très simple. Il suffit tout d'abord de créer un compte sur la plateforme. Ensuite, cliquer sur \"Ajouter\" en haut à droite et vous serez guidé."
                , spanish = todo
            }

        FaqCode ->
            { emptyTranslationSet
                | dutch = s "Waar vind ik de broncode van de OGP Toolbox?"
                , english = s "Where can I find the source code of the OGP Toolbox?"
                , french = s "Où puis-je trouver le code source de l'OGP Toolbox ?"
                , spanish = todo
            }

        FaqData ->
            { emptyTranslationSet
                | dutch = s "Kan ik de data gebruiken?"
                , english = s "How can I access the data?"
                , french = s "Comment puis-je accéder aux données ?"
                , spanish = todo
            }

        FaqCodeData ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "The OGP Toolbox is an open source (AGPL License) and open data project (CC0 License), that's why we publish its source code as well as all harvested data. You'll find all informations and resources on this page:"
                , french = s "L'OGP Toolbox est un projet open source (Licence AGPL) et open data (Licence CC0), nous donnons donc accès à son code source ainsi qu'à toutes les données moissonnées. Vous trouverez toutes les informations et les ressources sur cette page :"
                , spanish = todo
            }

        FaqDataHarvest ->
            { emptyTranslationSet
                | dutch = s "Waar komt de data vandaan?"
                , english = s "What is the source of the data?"
                , french = s "D'où proviennent les données ?"
                , spanish = todo
            }

        FaqDataHarvestContent0 ->
            { emptyTranslationSet
                | dutch = s "Data voor de OGP Toolbox komt uit meerdere bronnen:"
                , english = s "The OGP Toolbox data comes from multiple sources:"
                , french = s "Les données de l'OGP Toolbox proviennent de sources multiples :"
                , spanish = todo
            }

        FaqDataHarvestContent1 ->
            { emptyTranslationSet
                | dutch = s "De data wordt regelmatig vernieuwd door bestaande catalogi uit te lezen:"
                , english = s "Existing catalogs are regularly harvested to feed and update the data base:"
                , french = s "Des catalogues existants sont moissonnés régulièrement pour alimenter et mettre à jour la base de données :"
                , spanish = todo
            }

        FaqDataHarvestContent2 ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "OGP Toolbox users can create new tools, use cases and organizations, or edit existing ones."
                , french = s "Les utilisateurs de l'OGP Toolbox peuvent créer de nouvelles fiches d'outil, de cas d'usage et d'organisation, ou éditer des fiches existantes."
                , spanish = todo
            }

        FaqDescription ->
            { emptyTranslationSet
                | dutch = s "Veelgestelde vragen"
                , english = s "Frequently asked questions (FAQ)"
                , french = s "Foire aux questions (FAQ)"
                , spanish = todo
            }

        FaqDev ->
            { emptyTranslationSet
                | dutch = s "Door wie is de OGP Toolbox gemaakt?"
                , english = s "Who developed the OGP Toolbox?"
                , french = s "Qui a développé l'OGP Toolbox ?"
                , spanish = todo
            }

        FaqDevContent ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "The OGP Toolbox is a free software developed by Etalab, the Prime Minister taskforce in charge of open data and open government French policy, on behalf of the OGP community. Co-created by the open government and the civic tech international community throughout 2016, the OGP Toolbox is one of the main deliverables of the Global Summit of the Open Government Partnership (7, 8 and 9 December 2016)."
                , french = s "L'OGP Toolbox a été développée par Etalab, service du Premier Ministre en charge de l'ouverture des données publiques et du gouvernement ouvert de la France, pour le compte de la communauté du Partenariat du Gouvernement Ouvert. Co-créée avec les communautés internationales du gouvernement ouvert et de la civic tech tout au long de l'année 2016, l'OGP Toolbox est un des principaux livrables du Sommet mondial du Partenariat pour un Gouvernement Ouvert (7, 8 et 9 décembre 2016)."
                , spanish = todo
            }

        FaqLanguages ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "In which languages is the OGP Toolbox available?"
                , french = s "Dans quelles langues est disponible la plateforme ?"
                , spanish = todo
            }

        FaqLanguagesContent ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "The OGP Toolbox is available in English and French. The platform is crowdsourced, which means that other than the online interface (translated by Etalab), any content can be modified and translated by users, such as the description of tools and use cases, as well as the tags used to categorize them (see below). Content will be displayed in the language you configured. If an element is not available in your language, it will be displayed in English by default, with an invitation to translate it."
                , french = s "OGP Toolbox est disponible en Anglais et en Français. La plateforme est crowdsourcée ce qui signifie qu'au-delà de l'interface du site Internet (traduite par Etalab), chaque élément de contenu peut être modifié et traduit par les utilisateurs, notamment les descriptions des outils et des cas d'usage et les tags permettant de les catégoriser (voir ci-dessous). Les éléments de contenu s'afficheront en priorité dans la langue que vous aurez paramétrée. Si un élément n'est pas disponible dans votre langue, il s'affiche en anglais par défaut, et vous invite à le traduire."
                , spanish = todo
            }

        FaqLead ->
            { emptyTranslationSet
                | dutch = s "Veelgestelde vragen over de OGP Toolbox"
                , english = s "All the answers to your questions about the OGP Toolbox"
                , french = s "Mieux comprendre l'OGP Toolbox"
                , spanish = todo
            }

        FaqModeration ->
            { emptyTranslationSet
                | dutch = s "Wordt de inhoud gecontroleerd?"
                , english = s "How are contributions moderated?"
                , french = s "Comment sont modérées les contributions ?"
                , spanish = todo
            }

        FaqModerationContent ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "The OGP Toolbox is based on community moderation. Data from the harvested catalogues and users’ contributions are automatically sort out through an open vote system. For each field, the most popular suggested description is highlighted in the tool, use case or organization card. The vote on available propositions is accessible by clicking on the “edit” button at the right of each field."
                , french = s "OGP Toolbox s'appuie sur une modération communautaire. Les données provenant des catalogues moissonnées et des contributions des utilisateurs sont triées de façon automatique à travers un système de vote ouvert. Pour chaque champ, la proposition de description ou de valeur la plus votée est mise en avant sur la fiche outil, cas d'usage ou organisation. Le vote sur les propositions disponibles est accessible en cliquant sur le bouton \"edit\" à la droite de chaque champ. "
                , spanish = todo
            }

        FaqTarget ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "Who is the OGP Toolbox for?"
                , french = s "À qui est destinée l'OGP Toolbox ?"
                , spanish = todo
            }

        FaqTargetContent ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "The OGP is intended to all public sector, private sector and civil society organizations that develop projects to promote democracy and promote transparency, participation and collaboration. Any engaged citizen willing to be introduced to new tools and to discover particular use cases will be able to access relevant information, and to get in touch with the users’ community."
                , french = s "L'OGP Toolbox est destinée à tous les acteurs publics, privés et de la société civile portant des projets pour renforcer la démocratie et promouvoir la transparence, la participation et la collaboration dans l'action publique. Tout citoyen engagé voulant s'initier à de nouveaux outils et en découvrir les cas d'usages pourra accéder facilement aux informations pertinentes."
                , spanish = todo
            }

        FaqTypes ->
            { emptyTranslationSet
                | dutch = s "Wat vind ik in de OGP Toolbox?"
                , english = s "What can I find in the OGP Toolbox?"
                , french = s "Qu'est-ce-qu'on peut trouver dans l'OGP Toolbox ?"
                , spanish = todo
            }

        FaqTypesContent ->
            { emptyTranslationSet
                | dutch = s "Er zijn 4 categoriën"
                , english = s "The platform showcases 4 types of items:"
                , french = s "La plateforme référence 4 types d'éléments :"
                , spanish = todo
            }

        FaqTypesContentCollection ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "A collection is a list of tools recommended by a contributor. The same as bookmarks or favorites, but for tools!"
                , french = s "Une collection est une liste d'outils recommandés par un contributeur. Comme des marque-pages ou des favoris, mais pour des outils !"
                , spanish = todo
            }

        FaqTypesContentOrganization ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "An organization is either the user or the developer of a tool, and is part of the public sector (government, administration, parliament, subnational entity), the private sector (company, startup) or the civil society (non-profit organization, movement)."
                , french = s "Une organisation utilise ou développe des outils, et fait partie de la sphère publique (gouvernement, administration, parlement, collectivité locale), du secteur privé (entreprise, startup) ou de la société civile (association, mouvement)."
                , spanish = todo
            }

        FaqTypesContentTool ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "A digital tool is either a computer program (software, application) or an online service (website, platform, resource)."
                , french = s "Un outil numérique est un programme informatique (logiciel, application) ou un service en ligne (site Internet, plateforme, ressource)."
                , spanish = todo
            }

        FaqTypesContentUseCase ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "A use case is a concrete example showing how one or multiple tools were used by an organization."
                , french = s "Un cas d'usage est un exemple concret d'utilisation d'un ou plusieurs outils par une organisation."
                , spanish = todo
            }

        FaqWhat ->
            { emptyTranslationSet
                | dutch = s "Wat is de OGP Toolbox?"
                , english = s "What is the OGP Toolbox?"
                , french = s "Qu'est ce que l'OGP Toolbox ?"
                , spanish = todo
            }

        FaqWhatContent1 ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "The OGP Toolbox is a collaborative platform that gathers digital tools developed and used throughout the world by organizations to improve democracy and promote transparency, participation and collaboration."
                , french = s "L'OGP Toolbox est une plateforme collaborative qui recense les outils numériques développés et utilisés dans le monde entier par des organisations pour renforcer la démocratie et promouvoir la transparence, la participation et la collaboration dans l'action publique."
                , spanish = todo
            }

        FaqWhatContent2 ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "The OGP Toolbox is designed as a social network: concrete use cases, technical criteria informed by the community and recommendations in the form of tool collections allow to benefit from the experience of users that have already implemented existing solutions."
                , french = s "L'OGP Toolbox est conçue comme un réseau social : des cas d'usages concrets, des critères techniques expertisés par la communauté et des recommandations sous forme de collections d'outils permettent de profiter du savoir-faire des acteurs ayant déjà utilisé les solutions disponibles. "
                , spanish = todo
            }

        FaqWhy ->
            { emptyTranslationSet
                | dutch = s "Waarom de OGP Toolbox?"
                , english = s "Why do we need an OGP Toolbox?"
                , french = s "À quoi sert l'OGP Toolbox ? "
                , spanish = todo
            }

        FaqWhyContent1 ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "The OGP Toolbox aims at empowering organizations by sharing resources and experiences. The objective is to facilitate cooperation and the implementation of concrete engagements related to the open government through the appropriation of digital tools."
                , french = s "L'OGP Toolbox vise à renforcer le pouvoir d'agir des acteurs publics, privés et de la société civile à travers le partage de ressources et d'expériences. L'objectif est de faciliter la mise en oeuvre concrète d'engagements et de coopérations liées au gouvernement ouvert grâce à la maîtrise des outils numériques."
                , spanish = todo
            }

        FaqWhyContent2 ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "The platform enables to find the most adapted tool to each project or initiative through search and comparison functionalities by category, use case, organization or technical criterion. The idea is to simplify access and manipulation of digital tools for everyone."
                , french = s "La plateforme permet de trouver l'outil le mieux adapté à chaque projet ou initiative à travers des recherches et des comparaisons par catégorie, cas d'usage, organisation ou critère technique, ainsi que d'en simplifier l'accès et la prise en main."
                , spanish = todo
            }

        FieldTypeBoolean ->
            { emptyTranslationSet
                | dutch = s "Ja / Nee"
                , english = s "Yes / No"
                , french = s "Oui / Non"
                , spanish = todo
            }

        FieldTypeEmail ->
            { emptyTranslationSet
                | dutch = s "Emailadres"
                , english = s "Email address"
                , french = s "Adresse email"
                , spanish = todo
            }

        FieldTypeImage ->
            { emptyTranslationSet
                | dutch = s "Afbeelding"
                , english = s "Image"
                , french = s "Image"
                , spanish = todo
            }

        FieldTypeInternalLink ->
            { emptyTranslationSet
                | dutch = s "OGP Toolbox interne link"
                , english = s "OGP Toolbox internal link"
                , french = s "Lien interne à l'OGP Toolbox"
                , spanish = todo
            }

        FieldTypeInteger ->
            { emptyTranslationSet
                | dutch = s "Nummer"
                , english = s "Number"
                , french = s "Nombre"
                , spanish = todo
            }

        FieldTypeMultiLine ->
            { emptyTranslationSet
                | dutch = s "Meerdere regels tekst"
                , english = s "Multi-line text"
                , french = s "Texte sur plusieurs lignes"
                , spanish = todo
            }

        FieldTypeSingleLine ->
            { emptyTranslationSet
                | dutch = s "Een regel tekst"
                , english = s "Single line text"
                , french = s "Texte sur une seule ligne"
                , spanish = todo
            }

        FieldTypeURL ->
            { emptyTranslationSet
                | dutch = s "Internetadres (URL)"
                , english = s "Web address (URL)"
                , french = s "Adresse web (URL)"
                , spanish = todo
            }

        FindAnotherCard ->
            { emptyTranslationSet
                | dutch = s "Zoek een andere kaart"
                , english = s "Find another card"
                , french = s "Rechercher une autre fiche"
                , spanish = todo
            }

        FindAnotherPropertyKey ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "Find another property"
                , french = s "Rechercher une autre propriété"
                , spanish = todo
            }

        FindCard ->
            { emptyTranslationSet
                | dutch = s "Zoek een kaart"
                , english = s "Find a card"
                , french = s "Rechercher une fiche"
                , spanish = todo
            }

        FindPropertyKey ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "Find a property"
                , french = s "Rechercher une propriété"
                , spanish = todo
            }

        FooterAbout ->
            { emptyTranslationSet
                | dutch = s "Over"
                , english = s "About"
                , french = s "À propos"
                , spanish = s "Acerca"
            }

        FooterContact ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "Contact"
                , french = s "Contact"
                , spanish = todo
            }

        FooterDiscover ->
            { emptyTranslationSet
                | dutch = s "Inhoud"
                , english = s "Content"
                , french = s "Découvrir"
                , spanish = s "Descubrir"
            }

        GenericError ->
            { emptyTranslationSet
                | dutch = s "Er is iets misgegaan."
                , english = s "Something went wrong."
                , french = s "Quelque chose s'est mal passé !"
                , spanish = todo
            }

        HaveAnAccount ->
            { emptyTranslationSet
                | dutch = s "Ik heb al een account"
                , english = s "I already have an account"
                , french = s "J'ai déjà un compte"
                , spanish = todo
            }

        HeaderTitle ->
            { emptyTranslationSet
                | dutch = s "Software voor de digitale democratie"
                , english = s "digital solutions to improve democracy"
                , french = s "solutions numériques pour la démocratie"
                , spanish = todo
            }

        Help ->
            { emptyTranslationSet
                | dutch = s "Veelgestelde vragen"
                , english = s "FAQ"
                , french = s "Aide"
                , spanish = s "Ayuda"
            }

        Home ->
            { emptyTranslationSet
                | dutch = s "Home"
                , english = s "Home"
                , french = s "Accueil"
                , spanish = s "Inicio"
            }

        HomeDescription ->
            { emptyTranslationSet
                | dutch = s "Digitale oplossingen voor het verbeteren van de democratie"
                , english = s "Digital solutions to improve democracy"
                , french = s "Solutions numériques pour la démocratie"
                , spanish = todo
            }

        HomeResults ->
            { emptyTranslationSet
                | dutch = s "Resultaten bekijken"
                , english = s "See results"
                , french = s "Afficher les résultats"
                , spanish = todo
            }

        HomeStart ->
            { emptyTranslationSet
                | dutch = s "Klik op een term om deze te selecteren"
                , english = s "Click on a bubble to start"
                , french = s "Cliquez sur une bulle pour commencer"
                , spanish = todo
            }

        HomeTitle ->
            { emptyTranslationSet
                | dutch = s "OGP Toolbox"
                , english = s "OGP Toolbox"
                , french = s "OGP Toolbox"
                , spanish = todo
            }

        Image ->
            { emptyTranslationSet
                | dutch = s "Afbeeldingen"
                , english = s "Image"
                , french = s "Image"
                , spanish = todo
            }

        ImageAlt ->
            { emptyTranslationSet
                | dutch = s "Geuploade Afbeelding"
                , english = s "The uploaded image"
                , french = s "L'image ajoutée"
                , spanish = todo
            }

        ImageField ->
            getTranslationSet Image

        ImageUploadError message ->
            { emptyTranslationSet
                | dutch = s ("Fout bij het uploaden van: " ++ message)
                , english = s ("Image upload error: " ++ message)
                , french = s ("Échec du téléversement de l'image :" ++ message)
                , spanish = todo
            }

        ImproveExistingContent ->
            { emptyTranslationSet
                | dutch = s "Inhoud verbeteren"
                , english = s "Improve existing content"
                , french = s "Améliorez le contenu existant"
                , spanish = todo
            }

        InputEmailField ->
            getTranslationSet Email

        InputNumberField ->
            getTranslationSet Number

        InputUrlField ->
            getTranslationSet Url

        InvalidNumber ->
            { emptyTranslationSet
                | dutch = s "Geen geldig nummer"
                , english = s "Not a valid number"
                , french = s "Ce n'est pas un nombre valide."
                , spanish = todo
            }

        Language language ->
            case language of
                Bulgarian ->
                    { emptyTranslationSet
                        | dutch = s "Bulgaars"
                        , english = s "Bulgarian"
                        , french = s "Bulgare"
                        , spanish = todo
                    }

                Croatian ->
                    { emptyTranslationSet
                        | dutch = s "Kroatisch"
                        , english = s "Croatian"
                        , french = s "Croate"
                        , spanish = todo
                    }

                Czech ->
                    { emptyTranslationSet
                        | dutch = s "Tsjechisch"
                        , english = s "Czech"
                        , french = s "Tchèque"
                        , spanish = todo
                    }

                Danish ->
                    { emptyTranslationSet
                        | dutch = s "Deens"
                        , english = s "Danish"
                        , french = s "Danois"
                        , spanish = todo
                    }

                Dutch ->
                    { emptyTranslationSet
                        | dutch = s "Nederlands"
                        , english = s "Dutch"
                        , french = s "Néerlandais"
                        , spanish = s "Holandés"
                    }

                English ->
                    { emptyTranslationSet
                        | dutch = s "Engels"
                        , english = s "English"
                        , french = s "Anglais"
                        , spanish = todo
                    }

                Estonian ->
                    { emptyTranslationSet
                        | dutch = s "Estisch"
                        , english = s "Estonian"
                        , french = s "Estonien"
                        , spanish = todo
                    }

                Finnish ->
                    { emptyTranslationSet
                        | dutch = s "Fins"
                        , english = s "Finnish"
                        , french = s "Finlandais"
                        , spanish = todo
                    }

                French ->
                    { emptyTranslationSet
                        | dutch = s "Frans"
                        , english = s "French"
                        , french = s "Français"
                        , spanish = s "Francés"
                    }

                German ->
                    { emptyTranslationSet
                        | dutch = s "Duits"
                        , french = s "Allemand"
                        , spanish = todo
                    }

                Greek ->
                    { emptyTranslationSet
                        | dutch = s "Grieks"
                        , english = s "Greek"
                        , french = s "Grec"
                        , spanish = todo
                    }

                Hungarian ->
                    { emptyTranslationSet
                        | dutch = s "Hongaars"
                        , english = s "Hungarian"
                        , french = s "Hongrois"
                        , spanish = todo
                    }

                Irish ->
                    { emptyTranslationSet
                        | dutch = s "Iers"
                        , english = s "Irish"
                        , french = s "Irlandais"
                        , spanish = todo
                    }

                Italian ->
                    { emptyTranslationSet
                        | dutch = s "Italiaans"
                        , english = s "Italian"
                        , french = s "Italien"
                        , spanish = todo
                    }

                Latvian ->
                    { emptyTranslationSet
                        | dutch = s "Lets"
                        , english = s "Latvian"
                        , french = s "Letton"
                        , spanish = todo
                    }

                Lithuanian ->
                    { emptyTranslationSet
                        | dutch = s "Litouws"
                        , english = s "Lithuanian"
                        , french = s "Lituanien"
                        , spanish = todo
                    }

                Maltese ->
                    { emptyTranslationSet
                        | dutch = s "Maltees"
                        , english = s "Maltese"
                        , french = s "Maltais"
                        , spanish = todo
                    }

                Polish ->
                    { emptyTranslationSet
                        | dutch = s "Pools"
                        , english = s "Polish"
                        , french = s "Polonais"
                        , spanish = todo
                    }

                Portuguese ->
                    { emptyTranslationSet
                        | dutch = s "Portugees"
                        , english = s "Portuguese"
                        , french = s "Portugais"
                        , spanish = todo
                    }

                Romanian ->
                    { emptyTranslationSet
                        | dutch = s "Roemeens"
                        , english = s "Romanian"
                        , french = s "Roumain"
                        , spanish = todo
                    }

                Slovak ->
                    { emptyTranslationSet
                        | dutch = s "Slovaaks"
                        , english = s "Slovak"
                        , french = s "Slovaque"
                        , spanish = todo
                    }

                Slovenian ->
                    { emptyTranslationSet
                        | dutch = s "Sloveens"
                        , english = s "Slovenian"
                        , french = s "Slovène"
                        , spanish = todo
                    }

                Spanish ->
                    { emptyTranslationSet
                        | dutch = s "Spaans"
                        , english = s "Spanish"
                        , french = s "Espagnol"
                        , spanish = s "Español"
                    }

                Swedish ->
                    { emptyTranslationSet
                        | dutch = s "Zweeds"
                        , english = s "Swedish"
                        , french = s "Suédois"
                        , spanish = todo
                    }

        LanguageWord ->
            { emptyTranslationSet
                | dutch = s "Taal"
                , english = s "Language"
                , french = s "Langue"
                , spanish = s "Idioma"
            }

        License ->
            { emptyTranslationSet
                | dutch = s "Licentie"
                , english = s "License"
                , french = s "Licence"
                , spanish = s "Idioma"
            }

        LoadingMenu ->
            { emptyTranslationSet
                | dutch = s "Menu wordt geladen..."
                , english = s "Loading menu..."
                , french = s "Chargement du menu..."
                , spanish = todo
            }

        LocalizedString ->
            { emptyTranslationSet
                | dutch = s "Vertaalde tekenreeks"
                , english = s "Localized string"
                , french = s "Chaîne de caractères localisée"
                , spanish = todo
            }

        Logo ->
            { emptyTranslationSet
                | dutch = s "Logo"
                , english = s "Logo"
                , french = s "Logo"
                , spanish = todo
            }

        MissingArguments ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "No arguments. Let's be the first to express your opinion!"
                , french = s "Aucun argument. Soyez le premier à donner votre avis !"
                , spanish = todo
            }

        MissingDescription ->
            { emptyTranslationSet
                | dutch = s "Omschrijving ontbreekt"
                , english = s "Missing description"
                , french = s "Description manquante"
                , spanish = todo
            }

        MissingValue ->
            { emptyTranslationSet
                | dutch = s "Verplicht veld"
                , english = s "Missing value"
                , french = s "Valeur manquante"
                , spanish = todo
            }

        Name ->
            { emptyTranslationSet
                | dutch = s "Naam"
                , english = s "Name"
                , french = s "Nom"
                , spanish = todo
            }

        NetworkErrorExplanation ->
            { emptyTranslationSet
                | dutch = s "Er is een netwerkfout opgetreden."
                , english = s "There was a network error."
                , french = todo
                , spanish = todo
            }

        New ->
            { emptyTranslationSet
                | dutch = s "Nieuw"
                , english = s "New"
                , french = s "Nouveau"
                , spanish = todo
            }

        NewCard ->
            { emptyTranslationSet
                | dutch = s "Nieuw"
                , english = s "Add new"
                , french = s "Ajouter"
                , spanish = s "Añadir nuevo"
            }

        NewCardCollectionCatchPhrase ->
            { emptyTranslationSet
                | dutch = s "Een eenvoudige manier om je favoriete platform aan te bevelen."
                , english = s "A simple way to recommend your favorite tools."
                , french = s "Une façon simple de recommander vos outils favoris."
                , spanish = todo
            }

        NewCardItemBox ->
            { emptyTranslationSet
                | dutch = s "Nieuw onderdeel"
                , english = s "Add a new item"
                , french = s "Ajouter un nouvel élément"
                , spanish = todo
            }

        NewCardOrganization ->
            { emptyTranslationSet
                | dutch = s "Nieuwe organisatie"
                , english = s "Add a new organization"
                , french = s "Ajouter une nouvelle organisation"
                , spanish = todo
            }

        NewCardOrganizationCatchPhrase ->
            { emptyTranslationSet
                | dutch = s "Een organisatie die platformen gebruikt of maakt"
                , english = s "A developer or user of tools."
                , french = s "Un développeur ou utilisateur d'outil."
                , spanish = todo
            }

        NewCardOrganizationDescription ->
            { emptyTranslationSet
                | dutch = s "Voeg een organisatie toe door algemene informatie op te geven"
                , english = s "Create a new organization by giving some generic information"
                , french = s "Création d'une nouvelle organisation en fournissant quelques informations générales"
                , spanish = todo
            }

        NewCardOrganizationDescriptionPlaceholder ->
            { emptyTranslationSet
                | dutch = s "Presentatie van de organisatie"
                , english = s "Presentation of the organization"
                , french = s "Présentation de l'organisation"
                , spanish = todo
            }

        NewCardOrganizationName ->
            { emptyTranslationSet
                | dutch = s "Officiële naam van de organisatie (b.v. \"Open Knowledge International\")"
                , english = s "Offical name of the organization (e.g. \"Open Knowledge International\")"
                , french = s "Nom officiel de l'organisation (par ex : \"Open Knowledge International\")"
                , spanish = todo
            }

        NewCardTool ->
            { emptyTranslationSet
                | dutch = s "Nieuw platform"
                , english = s "Add a new tool"
                , french = s "Ajouter un nouvel outil"
                , spanish = todo
            }

        NewCardToolCatchPhrase ->
            { emptyTranslationSet
                | dutch = s "Software of een internet platform"
                , english = s "Software or a website."
                , french = s "Un logiciel ou un site Internet."
                , spanish = todo
            }

        NewCardToolDescription ->
            { emptyTranslationSet
                | dutch = s "Registreer een platform door algemene informatie in te vullen"
                , english = s "Creating a new tool by giving a few generic informations."
                , french = s "Création d'un nouvel outil en fournissant quelques informations générales"
                , spanish = todo
            }

        NewCardToolDescriptionPlaceholder ->
            { emptyTranslationSet
                | dutch = s "Presentatie van het platform"
                , english = s "Presentation of the tool"
                , french = s "Présentation de l'outil"
                , spanish = todo
            }

        NewCardToolName ->
            { emptyTranslationSet
                | dutch = s "Officiële naam van het platform (b.v. \"Loomio\")"
                , english = s "Official name of the tool (e.g. \"Loomio\")"
                , french = s "Nom officiel de l'outil (par ex : \"Loomio\")"
                , spanish = todo
            }

        NewCardUseCase ->
            { emptyTranslationSet
                | dutch = s "Voeg een toepassing toe"
                , english = s "Add a new use case"
                , french = s "Ajouter un nouveau cas d'usage"
                , spanish = todo
            }

        NewCardUseCaseCatchPhrase ->
            { emptyTranslationSet
                | dutch = s "Een platform toegepast in de praktijk"
                , english = s "A concrete example showing how a tool was used."
                , french = s "Un exemple concret d'utilisation d'un ou plusieurs outils."
                , spanish = todo
            }

        NewCardUseCaseDescription ->
            { emptyTranslationSet
                | dutch = s "Registreer een toepassing door het opgeven van algemene informatie"
                , english = s "Creating a new use case by giving a few generic informations"
                , french = s "Création d'un nouveau cas d'usage en fournissant quelques informations générales"
                , spanish = todo
            }

        NewCardUseCaseDescriptionPlaceholder ->
            { emptyTranslationSet
                | dutch = s "Presentatie van de toepassing"
                , english = s "Presentation of the use case"
                , french = s "Présentation du cas d'usage"
                , spanish = todo
            }

        NewCardUseCaseName ->
            { emptyTranslationSet
                | dutch = s "Naam van de toepassing (b.v. \"data.overheid.nl\")"
                , english = s "Name of the use case (e.g. \"Open Knowledge Forums\")"
                , french = s "Nom du cas d'usage (par ex : \"Forums d'Open Knowledge\")"
                , spanish = todo
            }

        NewProperty ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "New Property"
                , french = s "Nouvelle propriété"
                , spanish = todo
            }

        NewPropertyDescription ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "Form to enter a new property"
                , french = s "Formulaire de création d'une nouvelle propriété"
                , spanish = todo
            }

        NewValue ->
            { emptyTranslationSet
                | dutch = s "Nieuwe waarde"
                , english = s "New Value"
                , french = s "Nouvelle valeur"
                , spanish = todo
            }

        NewValueDescription ->
            { emptyTranslationSet
                | dutch = s "Formulier voor het toevoegen van een waarde"
                , english = s "Form to enter a new value"
                , french = s "Formulaire de création d'une nouvelle valeur"
                , spanish = todo
            }

        Number ->
            { emptyTranslationSet
                | dutch = s "Nummer"
                , english = s "Number"
                , french = s "Nombre"
                , spanish = s "Número"
            }

        NumberPlaceholder ->
            { emptyTranslationSet
                | dutch = s "3.1415927"
                , english = s "3.1415927"
                , french = s "3.1415927"
                , spanish = s "3.1415927"
            }

        Ogp ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "OGP"
                , french = s "PGO"
                , spanish = todo
            }

        OgpDescription ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "Digital solutions to improve open governments"
                , french = s "Solutions numériques pour gouvernements ouverts"
                , spanish = todo
            }

        OgpTitle ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "OGP Toolbox (OGP version)"
                , french = s "OGP Toolbox (version OGP)"
                , spanish = todo
            }

        OpenGovernmentPartnership ->
            { emptyTranslationSet
                | dutch = s "Open Government Partnership"
                , english = s "Open Government Partnership"
                , french = s "Partenariat pour un gouvernement ouvert"
                , spanish = todo
            }

        OpenGovernmentPartnershipLogo ->
            { emptyTranslationSet
                | dutch = s "Logo van Open Government Partnership"
                , english = s "Open Government Partnership logo"
                , french = s "logo du Partenariat pour un gouvernement ouvert"
                , spanish = todo
            }

        OpenGovParagraph ->
            { emptyTranslationSet
                | dutch = s """
Open Government Partnership is een initiatief dat streeft naar samenwerking tussen overheden bij het streven naar
transparantie, vergroten van burgerparticipatie, voorkomen van onduidelijkheid en het omarmen van technologie voor het
verbeteren van de dienstverlening door overheden.
"""
                , english = s """
The Open Government Partnership is a multilateral initiative that aims to secure concrete commitments
from governments to promote transparency, empower citizens, fight corruption, and harness new technologies
to strengthen governance.
"""
                , french = s "Le Partenariat pour un gouvernement ouvert est une initiative multilatérale créée en 2011 par huit pays fondateurs, qui s’attache à promouvoir la transparence et l’intégrité du gouvernement ainsi que l’utilisation des nouvelles technologies pour faciliter son ouverture."
                , spanish = todo
            }

        Organization number ->
            { emptyTranslationSet
                | dutch =
                    case number of
                        Singular ->
                            s "Organisatie"

                        Plural ->
                            s "Organisaties"
                , english =
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

        OpenData ->
            { emptyTranslationSet
                | dutch = s "Open data"
                , english = s "Open Data"
                , french = todo
                , spanish = todo
            }

        OpenSource ->
            { emptyTranslationSet
                | dutch = s "Open Source Software"
                , english = s "Free Open Source Software"
                , french = s "Logiciel Libre Open Source"
                , spanish = todo
            }

        OrganizationId ->
            { emptyTranslationSet
                | dutch = s "Organisatie"
                , english = s "Organization"
                , french = s "Organisation"
                , spanish = todo
            }

        OrganizationIdField ->
            getTranslationSet OrganizationId

        OrganizationPlaceholder ->
            { emptyTranslationSet
                | dutch = s "Naam van een organisatie"
                , english = s "Name of an organization"
                , french = s "Nom d'une organisation"
                , spanish = todo
            }

        OrganizationsDescription ->
            { emptyTranslationSet
                | dutch = s "Lijst van organisaties"
                , english = s "List of organizations"
                , french = s "Liste d'organisations"
                , spanish = todo
            }

        PageLoading ->
            { emptyTranslationSet
                | dutch = s "De pagina wordt geladen"
                , english = s "Page is loading"
                , french = s "Chargement en cours"
                , spanish = todo
            }

        PageLoadingExplanation ->
            { emptyTranslationSet
                | dutch = s "De gegevens worden geladen. Ogenblik geduld."
                , english = s "Data is loading and should be displayed quite soon."
                , french = todo
                , spanish = todo
            }

        PageNotFound ->
            { emptyTranslationSet
                | dutch = s "Pagina niet gevonden"
                , english = s "Page Not Found"
                , french = s "Page non trouvée"
                , spanish = todo
            }

        PageNotFoundDescription ->
            { emptyTranslationSet
                | dutch = s "De gevraagde pagina bestaat niet"
                , english = s "The requested page doesn't exist."
                , french = s "La page demandée n'existe pas."
                , spanish = todo
            }

        PageNotFoundExplanation ->
            { emptyTranslationSet
                | dutch = s "De pagina die je probeert op te vragen bestaat niet."
                , english = s "Sorry, but the page you were trying to view does not exist."
                , french = s "Désolé mais la page que vous avez demandé n'est pas disponible"
                , spanish = todo
            }

        Password ->
            { emptyTranslationSet
                | dutch = s "Wachtwoord"
                , english = s "Password"
                , french = s "Mot de passe"
                , spanish = todo
            }

        PasswordChangeFailed ->
            { emptyTranslationSet
                | dutch = s "Wachtwoord wijzigen mislukt"
                , english = s "Password change failed"
                , french = s "Échec du changement de mot de passe"
                , spanish = todo
            }

        PasswordLost ->
            { emptyTranslationSet
                | dutch = s "Wachtwoord vergeten?"
                , english = s "Password lost?"
                , french = s "Mot de passe oublié ?"
                , spanish = todo
            }

        PasswordPlaceholder ->
            { emptyTranslationSet
                | dutch = s "Je wachtwoord"
                , english = s "Your secret password"
                , french = s "Votre mot de passe secret"
                , spanish = todo
            }

        Platform ->
            { emptyTranslationSet
                | dutch = s "Internetdienst (website, platform, bron)"
                , english = s "Online service (website, platform, resource)"
                , french = s "Service en ligne (site Internet, plateforme, ressource)"
                , spanish = todo
            }

        Press ->
            { emptyTranslationSet
                | dutch = s "In het nieuws"
                , english = s "Press"
                , french = s "Presse"
                , spanish = todo
            }

        PressDescription ->
            getTranslationSet PressLead

        PressLead ->
            { emptyTranslationSet
                | dutch = s "Diverse nieuwsberichten over de OGP Toolbox"
                , english = s "What the press says of the OGP Toolbox"
                , french = s "La presse parle de la boite à outils de l'OGP"
                , spanish = todo
            }

        ProfileMyCollections ->
            { emptyTranslationSet
                | dutch = s "Mijn collecties"
                , english = s "My collections"
                , french = s "Mes collections"
                , spanish = s "Mis colecciones"
            }

        PropertyKeyPlaceholder ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "Name of a property"
                , french = s "Nom d'une propriété"
                , spanish = todo
            }

        Proprietary ->
            { emptyTranslationSet
                | dutch = s "Commercieel"
                , english = s "Closed Proprietary Software"
                , french = s "Logiciel propriétaire fermé"
                , spanish = todo
            }

        ProsAndCons ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "Pros & Cons Arguments"
                , french = s "Arguments pour et contre"
                , spanish = todo
            }

        Publish ->
            { emptyTranslationSet
                | dutch = s "Publiceren"
                , english = s "Publish"
                , french = s "Publier"
                , spanish = s "Publicar"
            }

        PublishCollection ->
            { emptyTranslationSet
                | dutch = s "Publiceer je collectie"
                , english = s "Publish your collection"
                , french = s "Publier votre collection"
                , spanish = s "Publicar sus colecciones"
            }

        PublishOrganization ->
            { emptyTranslationSet
                | dutch = s "Publiceer organisatie"
                , english = s "Publish organization"
                , french = s "Publier cette organisation"
                , spanish = todo
            }

        PublishUseCase ->
            { emptyTranslationSet
                | dutch = s "Publiceer toepassing"
                , english = s "Publish use case"
                , french = s "Publier ce cas d'usage"
                , spanish = todo
            }

        PublishTool ->
            { emptyTranslationSet
                | dutch = s "Publiceer platform"
                , english = s "Publish tool"
                , french = s "Publier cet outil"
                , spanish = todo
            }

        ReadingSelectedImage ->
            { emptyTranslationSet
                | dutch = s "Geselecteerde afbeelding wordt geladen..."
                , english = s "Reading selected image..."
                , french = s "Lecture de l'image sélectionnée..."
                , spanish = todo
            }

        ReadMore ->
            { emptyTranslationSet
                | dutch = s "Meer..."
                , english = s "Read more"
                , french = s "En savoir plus"
                , spanish = todo
            }

        ReleaseDate ->
            { emptyTranslationSet
                | dutch = s "Datum van uitgave"
                , english = s "Release date"
                , french = s "Date de sortie"
                , spanish = todo
            }

        ReleaseDatePlaceholder ->
            { emptyTranslationSet
                | dutch = s "Datum waarop de stabiele versie is uitgegeven"
                , english = s "Launch date of the last stable version"
                , french = s "Date de lancement de la dernière version stable"
                , spanish = todo
            }

        Register ->
            { emptyTranslationSet
                | dutch = s "Registreren"
                , english = s "Register"
                , french = s "Créer le compte"
                , spanish = todo
            }

        RegisterNow ->
            { emptyTranslationSet
                | dutch = s "Registreer nu"
                , english = s "Register now!"
                , french = s "Inscrivez vous maintenant !"
                , spanish = todo
            }

        Remove ->
            { emptyTranslationSet
                | dutch = s "Verwijder"
                , english = s "Remove"
                , french = s "Enlever"
                , spanish = todo
            }

        ResetPassword ->
            { emptyTranslationSet
                | dutch = s "Wachtwoord herstellen"
                , english = s "Reset Password"
                , french = s "Changer de mot de passe"
                , spanish = todo
            }

        ResetPasswordExplanation ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "Enter your email. We will send you the instructions to create a new password."
                , french = s "Entrez votre courriel. Nous vous enverrons les instructions pour changer de mot de passe."
                , spanish = todo
            }

        ResetPasswordLink ->
            { emptyTranslationSet
                | dutch = s "Wachtwoord vergeten"
                , english = s "I forgot my password"
                , french = s "J'ai oublié mon mot de passe"
                , spanish = todo
            }

        Save ->
            { emptyTranslationSet
                | dutch = s "Opslaan"
                , english = s "Save"
                , french = s "Enregistrer"
                , spanish = todo
            }

        SelectCardOrTypeMoreCharacters ->
            { emptyTranslationSet
                | dutch = s "Selecteer een kaart of begin met typen"
                , english = s "Select a card or type more characters"
                , french = s "Sélectionner une fiche ou taper plus de caractères"
                , spanish = todo
            }

        SelectPropertyKeyOrTypeMoreCharacters ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "Select a property or type more characters"
                , french = s "Sélectionner une propriété ou taper plus de caractères"
                , spanish = todo
            }

        Score ->
            { emptyTranslationSet
                | dutch = s "Score"
                , english = s "Score"
                , french = s "Score"
                , spanish = s "Score"
            }

        SearchInputPlaceholder ->
            { emptyTranslationSet
                | dutch = s "Zoeken..."
                , english = s "Search for a tool, use case or organization"
                , french = s "Rechercher un outil, un cas d'usage ou une organisation"
                , spanish = todo
            }

        SeeAllAndCompare ->
            { emptyTranslationSet
                | dutch = s "Alles bekijken en vergelijken"
                , english = s "See all and compare"
                , french = s "Voir tous et comparer"
                , spanish = todo
            }

        Send ->
            { emptyTranslationSet
                | dutch = s "Verzenden"
                , english = s "Send"
                , french = s "Envoyer"
                , spanish = s "Enviar"
            }

        SendEmailAgain ->
            { emptyTranslationSet
                | dutch = s "Email opnieuw versturen"
                , english = s "Send email again"
                , french = s "Réenvoyer le courriel"
                , spanish = todo
            }

        ServiceDisclaimer ->
            { emptyTranslationSet
                | dutch = s "Internetdienst"
                , english = s "Online service"
                , french = s "Service en ligne"
                , spanish = todo
            }

        Share ->
            { emptyTranslationSet
                | dutch = s "Delen"
                , english = s "Share"
                , french = s "Partager"
                , spanish = s "Compartir"
            }

        ShowAll count ->
            { emptyTranslationSet
                | dutch = s ("Toon alles (" ++ (toString count) ++ ")")
                , english = s ("Show all " ++ (toString count))
                , french = s ("Voir tous (" ++ (toString count) ++ ")")
                , spanish = s ("Ver todo (" ++ (toString count) ++ ")")
            }

        ShowMore ->
            { emptyTranslationSet
                | dutch = s "Meer..."
                , english = s "Show more"
                , french = s "Voir plus"
                , spanish = s "Mostrar más"
            }

        ShowMoreCount count ->
            { emptyTranslationSet
                | dutch = s ("Toon " ++ (toString count) ++ " meer")
                , english = s ("Show " ++ (toString count) ++ " more")
                , french = s ("Voir " ++ (toString count) ++ " plus")
                , spanish = s ("Mostrar " ++ (toString count) ++ " más")
            }

        SignIn ->
            { emptyTranslationSet
                | dutch = s "Aanmelden"
                , english = s "Sign In"
                , french = s "Identification"
                , spanish = s "Acceder"
            }

        SignInToContribute ->
            { emptyTranslationSet
                | dutch = s "Meld je aan om deel te nemen"
                , english = s "Sign in to contribute"
                , french = s "Identifiez-vous pour contribuer"
                , spanish = todo
            }

        SignOut ->
            { emptyTranslationSet
                | dutch = s "Afmelden"
                , english = s "Sign Out"
                , french = s "Me déconnecter"
                , spanish = s "Salir"
            }

        SignOutAndContributeLater ->
            { emptyTranslationSet
                | dutch = s "Afmelden en een andere keer deelnemen"
                , english = s "Sign out and contribute later"
                , french = s "Déconnectez-vous et contribuez plus tard"
                , spanish = todo
            }

        SignUp ->
            { emptyTranslationSet
                | dutch = s "Registreren"
                , english = s "Sign Up"
                , french = s "M'inscrire"
                , spanish = s "Registrarse"
            }

        SimilarTools ->
            { emptyTranslationSet
                | dutch = s "Overeenkomstige platformen"
                , english = s "Similar tools"
                , french = s "Outils similaires"
                , spanish = todo
            }

        Software ->
            { emptyTranslationSet
                | dutch = s "Computer programma (software, applicatie)"
                , english = s "Computer program (software, application)"
                , french = s "Programme informatique (logiciel, application)"
                , spanish = todo
            }

        String ->
            { emptyTranslationSet
                | dutch = s "Tekenreeks"
                , english = s "String"
                , french = s "Chaîne de caractères"
                , spanish = s "Cadena"
            }

        Tags ->
            { emptyTranslationSet
                | dutch = s "Termen"
                , english = s "Tags"
                , french = s "Étiquettes"
                , spanish = s "Etiquetas"
            }

        TextField ->
            { emptyTranslationSet
                | dutch = s "Tekst"
                , english = s "Text"
                , french = s "Texte"
                , spanish = s "Texto"
            }

        TheProject ->
            { emptyTranslationSet
                | dutch = todo
                , english = s "The Project"
                , french = s "Le projet"
                , spanish = todo
            }

        TimeoutExplanation ->
            { emptyTranslationSet
                | dutch = s "Er is een timeout opgetreden"
                , english = s "The server was too slow to respond (timeout)."
                , french = s "Le servert a mis trop de temps à repondre (timeout)"
                , spanish = todo
            }

        Tool number ->
            { emptyTranslationSet
                | dutch =
                    case number of
                        Singular ->
                            s "Platform"

                        Plural ->
                            s "Platformen"
                , english =
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

        ToolId ->
            { emptyTranslationSet
                | dutch = s "Platform"
                , english = s "Tool"
                , french = s "Outil"
                , spanish = s "Herramienta"
            }

        ToolIdField ->
            getTranslationSet ToolId

        ToolPlaceholder ->
            { emptyTranslationSet
                | dutch = s "Naam van het hulmiddel"
                , english = s "Name of a tool"
                , french = s "Nom d'un outil"
                , spanish = todo
            }

        ToolsDescription ->
            { emptyTranslationSet
                | dutch = s "Lijst van hulpmiddelen"
                , english = s "List of tools"
                , french = s "Liste d'outils"
                , spanish = todo
            }

        TrueWord ->
            { emptyTranslationSet
                | dutch = s "Waar"
                , english = s "True"
                , french = s "Vrai"
                , spanish = s "Cierto"
            }

        TweetMessage name url ->
            { emptyTranslationSet
                | dutch = s ("Ontdek " ++ name ++ " op OGPToolbox.org : " ++ url)
                , english = s ("Discover " ++ name ++ " on OGPToolbox.org: " ++ url)
                , french = s ("Découvrez " ++ name ++ " dans OGPToolbox.org : " ++ url)
                , spanish = todo
            }

        Type ->
            { emptyTranslationSet
                | dutch = s "Type"
                , english = s "Type"
                , french = s "Type"
                , spanish = s "Tipo"
            }

        UnknownLanguage ->
            { emptyTranslationSet
                | dutch = s "Taal niet ondersteund"
                , english = s "Unsupported language"
                , french = s "Langue inconnue"
                , spanish = todo
            }

        UnknownSchemaId schemaId ->
            { emptyTranslationSet
                | dutch = s ("Rerentie naar een onbekend schema: " ++ schemaId)
                , english = s ("Reference to an unknown schema: " ++ schemaId)
                , french = s ("Référence à un schema inconnu: " ++ schemaId)
                , spanish = todo
            }

        UnknownUser ->
            { emptyTranslationSet
                | dutch = s "Gebruiker onbekend"
                , english = s "User is unknown."
                , french = s "L'utilisateur est inconnu."
                , spanish = todo
            }

        UnknownValue ->
            { emptyTranslationSet
                | dutch = s "Onbekende waarde"
                , english = s "Unknown value"
                , french = s "Valeur inconnue"
                , spanish = todo
            }

        UntitledCard ->
            { emptyTranslationSet
                | dutch = s "Kaart zonder titel"
                , english = s "Untitled Card"
                , french = s "Fiche sans titre"
                , spanish = todo
            }

        UploadImage ->
            { emptyTranslationSet
                | dutch = s "Afbeelding uploaden"
                , english = s "Upload an image"
                , french = s "Ajouter une image"
                , spanish = todo
            }

        UploadingImage filename ->
            { emptyTranslationSet
                | dutch = s ("Afbeelding \"" ++ filename ++ "\" wordt geupload...")
                , english = s ("Uploading image \"" ++ filename ++ "\"...")
                , french = s ("Ajout de l'image \"" ++ filename ++ "\"...")
                , spanish = todo
            }

        Url ->
            { emptyTranslationSet
                | dutch = s "Link (URL)"
                , english = s "Link (URL)"
                , french = s "Lien (URL)"
                , spanish = todo
            }

        UrlPlaceholder ->
            { emptyTranslationSet
                | dutch = s "https://www.voorbeeldnl/voorbeeld-pagina"
                , english = s "https://www.example.com/sample-page"
                , french = s "https://www.exemple.fr/exemple-de-page"
                , spanish = todo
            }

        UseCase number ->
            { emptyTranslationSet
                | dutch =
                    case number of
                        Singular ->
                            s "Toepassing"

                        Plural ->
                            s "Toepassingen"
                , english =
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

        UseCaseId ->
            { emptyTranslationSet
                | dutch = s "Toepassing"
                , english = s "Use case"
                , french = s "Cas d'usage"
                , spanish = todo
            }

        UseCaseIdField ->
            getTranslationSet UseCaseId

        UseCasePlaceholder ->
            { emptyTranslationSet
                | dutch = s "Naam van de toepassing"
                , english = s "Name of a use case"
                , french = s "Nom d'un cas d'usage"
                , spanish = todo
            }

        UseCases ->
            { emptyTranslationSet
                | dutch = s "Toepassingen"
                , english = s "Use cases"
                , french = s "Cas d'usage"
                , spanish = s "Casos de uso"
            }

        UseCasesDescription ->
            { emptyTranslationSet
                | dutch = s "Lijst van toepassingen"
                , english = s "List of use cases"
                , french = s "Liste de cas d'usage"
                , spanish = todo
            }

        UsedBy ->
            { emptyTranslationSet
                | dutch = s "Gebruikt door"
                , english = s "Used by"
                , french = s "Utilisé par"
                , spanish = todo
            }

        UsedFor ->
            { emptyTranslationSet
                | dutch = s "Gebruikt voor"
                , english = s "Used for"
                , french = s "Utilisé pour"
                , spanish = todo
            }

        Username ->
            { emptyTranslationSet
                | dutch = s "Gebruikersnaam"
                , english = s "Username"
                , french = s "Nom d'utilisateur"
                , spanish = todo
            }

        UsernameOrEmailAlreadyExist ->
            { emptyTranslationSet
                | dutch = s "Gebruikersnaam of email is al in gebruik."
                , english = s "Username or email are already used."
                , french = s "Le nom d'utilisateur ou le mot de passe sont déjà utilisés."
                , spanish = todo
            }

        UsernamePlaceholder ->
            { emptyTranslationSet
                | dutch = s "Jan Jansen"
                , english = s "John Doe"
                , french = s "Françoise Martin"
                , spanish = todo
            }

        UserProfileDescription ->
            { emptyTranslationSet
                | dutch = s "Het profiel van de gebruiker en zijn collecties"
                , english = s "The profile of user and its favorite collections"
                , french = s "Le profil de l'utilisation et ses collections favorites"
                , spanish = todo
            }

        Uses ->
            { emptyTranslationSet
                | dutch = s "Maakt gebruik van"
                , english = s "Uses"
                , french = s "Utilise"
                , spanish = todo
            }

        UseIt ->
            { emptyTranslationSet
                | dutch = s "Gebruik"
                , english = s "Use it"
                , french = s "Utiliser"
                , spanish = todo
            }

        UseTool ->
            { emptyTranslationSet
                | dutch = s "Gebruik deze software"
                , english = s "Use this tool"
                , french = s "Utiliser cet outil"
                , spanish = s "Utilice esta herramienta"
            }

        Value ->
            { emptyTranslationSet
                | dutch = s "Waarde"
                , english = s "Value"
                , french = s "Valeur"
                , spanish = s "Valor"
            }

        ValueCreationFailed ->
            { emptyTranslationSet
                | dutch = s "Maken van de waarde mislukt"
                , english = s "Value creation failed"
                , french = s "Échec de la création de la valeur"
                , spanish = s "Falló la creación de valor"
            }

        ValueId ->
            { emptyTranslationSet
                | dutch = s "Koppel aan een waarde"
                , english = s "Link to a value"
                , french = s "Lien vers une valeur"
                , spanish = todo
            }

        ValueIdArray ->
            { emptyTranslationSet
                | dutch = s "lijst met koppelingen naar waarden"
                , english = s "Array of links to values"
                , french = s "Tableau de liens vers des valeurs"
                , spanish = todo
            }

        ValuePlaceholder ->
            { emptyTranslationSet
                | dutch = s "De waarde..."
                , english = s "The value..."
                , french = s "La valeur"
                , spanish = todo
            }

        VoteBestContributions ->
            { emptyTranslationSet
                | dutch = s "Stem op de beste bijdragen"
                , english = s "Vote for the best contributions"
                , french = s "Votez pour les meilleurs contributions"
                , spanish = s "Vote por las mejores contribuciones"
            }

        Website ->
            { emptyTranslationSet
                | dutch = s "Website"
                , english = s "Website"
                , french = s "Site web"
                , spanish = s "Sitio web"
            }

        WebsiteDescription ->
            { emptyTranslationSet
                | dutch = s "Adres van de officiële website (URL)"
                , english = s "Address of the official website (URL)"
                , french = s "Adresse du site officiel (URL)"
                , spanish = todo
            }



-- INTERNALS


type Language
    = Bulgarian
    | Croatian
    | Czech
    | Danish
    | Dutch
    | English
    | Estonian
    | Finnish
    | French
    | German
    | Greek
    | Hungarian
    | Irish
    | Italian
    | Latvian
    | Lithuanian
    | Maltese
    | Polish
    | Portuguese
    | Romanian
    | Slovak
    | Slovenian
    | Spanish
    | Swedish


type alias TranslationSet =
    { bulgarian : Maybe String
    , croatian : Maybe String
    , czech : Maybe String
    , danish : Maybe String
    , dutch : Maybe String
    , english : Maybe String
    , estonian : Maybe String
    , finnish : Maybe String
    , french : Maybe String
    , german : Maybe String
    , greek : Maybe String
    , hungarian : Maybe String
    , irish : Maybe String
    , italian : Maybe String
    , latvian : Maybe String
    , lithuanian : Maybe String
    , maltese : Maybe String
    , polish : Maybe String
    , portuguese : Maybe String
    , romanian : Maybe String
    , slovak : Maybe String
    , slovenian : Maybe String
    , spanish : Maybe String
    , swedish : Maybe String
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
    [ Bulgarian
    , Croatian
    , Czech
    , Danish
    , Dutch
    , English
    , Estonian
    , Finnish
    , French
    , German
    , Greek
    , Hungarian
    , Irish
    , Italian
    , Latvian
    , Lithuanian
    , Maltese
    , Polish
    , Portuguese
    , Romanian
    , Slovak
    , Slovenian
    , Spanish
    , Swedish
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
                BijectiveCardReferenceValue _ ->
                    []

                BooleanValue _ ->
                    []

                CardIdArrayValue ids ->
                    []

                CardIdValue cardId ->
                    []

                EmailValue value ->
                    [ value ]

                ImagePathValue path ->
                    []

                LocalizedStringValue valueByLanguage ->
                    case getValueByPreferredLanguage language valueByLanguage of
                        Nothing ->
                            []

                        Just value ->
                            [ value ]

                NumberValue _ ->
                    []

                StringValue value ->
                    [ value ]

                UrlValue value ->
                    [ value ]

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
        BijectiveCardReferenceValue _ ->
            Nothing

        BooleanValue _ ->
            Nothing

        CardIdArrayValue _ ->
            Nothing

        CardIdValue cardId ->
            Nothing

        EmailValue value ->
            Just value

        ImagePathValue path ->
            Just path

        LocalizedStringValue valueByLanguage ->
            getValueByPreferredLanguage language valueByLanguage

        NumberValue _ ->
            Nothing

        StringValue value ->
            Just value

        UrlValue value ->
            Just value

        ValueIdArrayValue [] ->
            Nothing

        ValueIdArrayValue (childValue :: _) ->
            getOneStringFromValueType language values (ValueIdValue childValue)

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
        "bg" ->
            Just Bulgarian

        "hr" ->
            Just Croatian

        "cs" ->
            Just Czech

        "da" ->
            Just Danish

        "nl" ->
            Just Dutch

        "en" ->
            Just English

        "et" ->
            Just Estonian

        "fi" ->
            Just Finnish

        "fr" ->
            Just French

        "de" ->
            Just German

        "el" ->
            Just Greek

        "hu" ->
            Just Hungarian

        "ga" ->
            Just Irish

        "it" ->
            Just Italian

        "lv" ->
            Just Latvian

        "lt" ->
            Just Lithuanian

        "mt" ->
            Just Maltese

        "pl" ->
            Just Polish

        "pt" ->
            Just Portuguese

        "ro" ->
            Just Romanian

        "sk" ->
            Just Slovak

        "sl" ->
            Just Slovenian

        "es" ->
            Just Spanish

        "sv" ->
            Just Swedish

        _ ->
            Nothing


iso639_1FromLanguage : Language -> String
iso639_1FromLanguage language =
    case language of
        Bulgarian ->
            "bg"

        Croatian ->
            "hr"

        Czech ->
            "cs"

        Danish ->
            "da"

        Dutch ->
            "nl"

        English ->
            "en"

        Estonian ->
            "et"

        Finnish ->
            "fi"

        French ->
            "fr"

        German ->
            "de"

        Greek ->
            "el"

        Hungarian ->
            "hu"

        Irish ->
            "ga"

        Italian ->
            "it"

        Latvian ->
            "lv"

        Lithuanian ->
            "lt"

        Maltese ->
            "mt"

        Polish ->
            "pl"

        Portuguese ->
            "pt"

        Romanian ->
            "ro"

        Slovak ->
            "sk"

        Slovenian ->
            "sl"

        Spanish ->
            "es"

        Swedish ->
            "sv"


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
                Bulgarian ->
                    translationSet.bulgarian

                Croatian ->
                    translationSet.croatian

                Czech ->
                    translationSet.czech

                Danish ->
                    translationSet.danish

                Dutch ->
                    translationSet.dutch

                English ->
                    translationSet.english

                Estonian ->
                    translationSet.estonian

                Finnish ->
                    translationSet.finnish

                French ->
                    translationSet.french

                German ->
                    translationSet.german

                Greek ->
                    translationSet.greek

                Hungarian ->
                    translationSet.hungarian

                Irish ->
                    translationSet.irish

                Italian ->
                    translationSet.italian

                Latvian ->
                    translationSet.latvian

                Lithuanian ->
                    translationSet.lithuanian

                Maltese ->
                    translationSet.maltese

                Polish ->
                    translationSet.polish

                Portuguese ->
                    translationSet.portuguese

                Romanian ->
                    translationSet.romanian

                Slovak ->
                    translationSet.slovak

                Slovenian ->
                    translationSet.slovenian

                Spanish ->
                    translationSet.spanish

                Swedish ->
                    translationSet.swedish
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
