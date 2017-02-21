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
    | CallToActionForCategory
    | CallToActionForDescription CardType
    | Card
    | CardId
    | CardIdArray
    | CardIdField
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
    | NewValue
    | NewValueDescription
    | Number
    | NumberPlaceholder
    | OGPsummitLink
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


getTranslationSet : TranslationId -> TranslationSet
getTranslationSet translationId =
    case translationId of
        About ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Algemeen"
            , english = s "General"
            , estonian = todo
            , finnish = todo
            , french = s "À propos"
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
            , spanish = s "Sobre"
            , swedish = todo
            }

        AboutCredits ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Credits"
            , english = s "Credits"
            , estonian = todo
            , finnish = todo
            , french = s "Crédits"
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
            , spanish = s "Créditos"
            , swedish = todo
            }

        AboutCreditsContent ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "De bellen module voor de termen is gebaseerd op "
            , english = s "The bubble tags navigation system is based on "
            , estonian = todo
            , finnish = todo
            , french = s "Le système de navigations des tag par bulles est basé sur la solution "
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

        AboutDescription ->
            getTranslationSet AboutLead

        AboutLead ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Over de OGP Toolbox"
            , english = s "About the OGP Toolbox"
            , estonian = todo
            , finnish = todo
            , french = s "À propos de la boite à outils OGP"
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

        AboutLegal ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Disclaimer"
            , english = s "Legal notices"
            , estonian = todo
            , finnish = todo
            , french = s "Mentions légales"
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
            , spanish = s "Nota legal"
            , swedish = todo
            }

        AboutLegalContent ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "OGPtoolobox.org wordt verzorgd door Etalab, 39 quai André Citroën 75015 PARIS, FRANKRIJK"
            , english = s "OGPtoolobox.org is maintained by Etalab, 39 quai André Citroën 75015 PARIS, FRANCE"
            , estonian = todo
            , finnish = todo
            , french = s "OGPtoolobox.org est édité par la mission Etalab, service du Premier Ministre, 39 quai André Citroën 75015 PARIS."
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

        AccountCreationFailed ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Account maken is mislukt"
            , english = s "Account création failed"
            , estonian = todo
            , finnish = todo
            , french = s "Échec de la création du compte"
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

        ActivationDescription ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Verificatie van het emailadres"
            , english = s "Verification of the user's email address."
            , estonian = todo
            , finnish = todo
            , french = s "Vérification de l'adresse courriel de l'utilisateur."
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

        ActivationFailed ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Verificatie van het emailadres is mislukt. Probeer het nogmaals"
            , english = s "The verification of your email address has failed. Please try again."
            , estonian = todo
            , finnish = todo
            , french = s "La vérification de votre adresse courriel a échoué. Veuillez réessayer."
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

        ActivationInProgress ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Email adres wordt geverifieeerd..."
            , english = s "Verifying your email address..."
            , estonian = todo
            , finnish = todo
            , french = s "Vérification de votre adresse courriel..."
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

        ActivationNotRequested ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Email adres wordt geverifieeerd..."
            , english = s "Your email address will be verified shortly..."
            , estonian = todo
            , finnish = todo
            , french = s "Votre adresse courriel va bientôt être vérifiée..."
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

        ActivationSucceeded ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Verificatie van het emailadres is gelukt. Account is geactiveerd"
            , english = s "Verification of your email address has succeeded. Account is now activated!"
            , estonian = todo
            , finnish = todo
            , french = s "La vérification de votre adresse courriel a réussi. Votre compte est maintenant activé !"
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

        ActivationTitle ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Account verificatie"
            , english = s "User Account Activation"
            , estonian = todo
            , finnish = todo
            , french = s "Activation du compte utilisateur"
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

        Add ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Nieuw"
            , english = s "Add"
            , estonian = todo
            , finnish = todo
            , french = s "Ajouter"
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

        AddALogo ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "+ Nieuw logo"
            , english = s "+ Add a logo"
            , estonian = todo
            , finnish = todo
            , french = s "+ Ajouter un logo"
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

        AddATag ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = todo
            , english = s "+ Add a tag"
            , estonian = todo
            , finnish = todo
            , french = s "+ Ajouter un tag"
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

        AddCard ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Nieuwe kaart"
            , english = s "Add card"
            , estonian = todo
            , finnish = todo
            , french = s "Ajouter un fiche"
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

        AddCollection ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Nieuwe collectie"
            , english = s "Add your collection"
            , estonian = todo
            , finnish = todo
            , french = s "Ajouter votre collection"
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

        AddPropertyKey ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = todo
            , english = s "Add property"
            , estonian = todo
            , finnish = todo
            , french = s "Ajouter une propriété"
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

        AdditionalInformations ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Aanvullende informatie"
            , english = s "Additional information"
            , estonian = todo
            , finnish = todo
            , french = s "Informations supplémentaires"
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

        AddOrganization ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Nieuw organisatie"
            , english = s "Add an organization"
            , estonian = todo
            , finnish = todo
            , french = s "Ajouter une organisation"
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

        AddTool ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Nieuw platform"
            , english = s "Add a tool"
            , estonian = todo
            , finnish = todo
            , french = s "Ajouter un outil"
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

        AddToolOrUseCase ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Nieuwe toepassing of platform"
            , english = s "Add a new tool or use case"
            , estonian = todo
            , finnish = todo
            , french = s "Ajoutez un nouvel outil ou cas d'usage"
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

        AddUseCase ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Nieuwe toepassing"
            , english = s "Add a use case"
            , estonian = todo
            , finnish = todo
            , french = s "Ajouter un cas d'usage"
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

        AddYourContribution ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Informatie toevoegen"
            , english = s "Contribute information"
            , estonian = todo
            , finnish = todo
            , french = s "Ajouter votre contribution"
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

        AuthenticationFailed ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Authenticatie mislukt"
            , english = s "Authentication failed"
            , estonian = todo
            , finnish = todo
            , french = s "L'authentification a échoué"
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

        AuthenticationRequired ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Authenticatie vereist"
            , english = s "Authentication required"
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

        AuthenticationRequiredExplanation ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Je moet aangemeld zijn om deze pagina te bekijken."
            , english = s "You must sign in to display this page."
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

        BadAuthorization ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "De authorizatie code is fout of verlopen."
            , english = s "Authorization code is wrong or obsolete."
            , estonian = todo
            , finnish = todo
            , french = s "Le code d'autorisation est erroné ou périmé."
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

        BadEmailOrPassword ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Emailadres of wachtwoord onjuist"
            , english = s "Either email address is unknown or password is wrong."
            , estonian = todo
            , finnish = todo
            , french = s "Soit l'adresse courriel est inconnue, soit le mot de passe est erroné."
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

        BadPayload ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Foutieve inhoud"
            , english = s "Bad payload"
            , estonian = todo
            , finnish = todo
            , french = s "Contenu incorrect"
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

        BadPayloadExplanation ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "De server retourneerde onjuiste gegevens."
            , english = s "The server returned unexpected data."
            , estonian = todo
            , finnish = todo
            , french = s "Le server a retourné des données imprévues"
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

        BadStatus ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Foutieve status"
            , english = s "Bad status"
            , estonian = todo
            , finnish = todo
            , french = s "Statut incorrect"
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

        BadUrl ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Foutieve URL"
            , english = s "Bad URL"
            , estonian = todo
            , finnish = todo
            , french = s "URL incorrecte"
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

        BadUrlExplanation ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "De opgegeven URL is onjuist."
            , english = s "The given URL is invalid."
            , estonian = todo
            , finnish = todo
            , french = s "L'URL fournie n'est pas valide."
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

        BestOf count ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s ("Beste van " ++ (toString count))
            , english = s ("Best of " ++ (toString count))
            , estonian = todo
            , finnish = todo
            , french = s ("Meilleur parmi " ++ (toString count))
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

        BijectiveCardReference ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = todo
            , english = s "Bijective link to a card"
            , estonian = todo
            , finnish = todo
            , french = s "Lien bijectif vers une fiche"
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

        Boolean ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = todo
            , english = s "Boolean"
            , estonian = todo
            , finnish = todo
            , french = s "Booléen"
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

        BooleanField ->
            getTranslationSet Boolean

        CallToActionForCategory ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "+ Nieuwe categorie"
            , english = s "+ Add category"
            , estonian = todo
            , finnish = todo
            , french = s "+ Ajouter une catégorie"
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

        CallToActionForDescription cardType ->
            { bulgarian =
                case cardType of
                    UseCaseCard ->
                        todo

                    OrganizationCard ->
                        todo

                    ToolCard ->
                        todo
            , croatian =
                case cardType of
                    UseCaseCard ->
                        todo

                    OrganizationCard ->
                        todo

                    ToolCard ->
                        todo
            , czech =
                case cardType of
                    UseCaseCard ->
                        todo

                    OrganizationCard ->
                        todo

                    ToolCard ->
                        todo
            , danish =
                case cardType of
                    UseCaseCard ->
                        todo

                    OrganizationCard ->
                        todo

                    ToolCard ->
                        todo
            , dutch =
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
            , estonian =
                case cardType of
                    UseCaseCard ->
                        todo

                    OrganizationCard ->
                        todo

                    ToolCard ->
                        todo
            , finnish =
                case cardType of
                    UseCaseCard ->
                        todo

                    OrganizationCard ->
                        todo

                    ToolCard ->
                        todo
            , french =
                case cardType of
                    UseCaseCard ->
                        s "Ajouter une description pour ce cas d'usage"

                    OrganizationCard ->
                        s "Ajouter une description pour cette organisation"

                    ToolCard ->
                        s "Ajouter une description pour cet outil"
            , german =
                case cardType of
                    UseCaseCard ->
                        todo

                    OrganizationCard ->
                        todo

                    ToolCard ->
                        todo
            , greek =
                case cardType of
                    UseCaseCard ->
                        todo

                    OrganizationCard ->
                        todo

                    ToolCard ->
                        todo
            , hungarian =
                case cardType of
                    UseCaseCard ->
                        todo

                    OrganizationCard ->
                        todo

                    ToolCard ->
                        todo
            , irish =
                case cardType of
                    UseCaseCard ->
                        todo

                    OrganizationCard ->
                        todo

                    ToolCard ->
                        todo
            , italian =
                case cardType of
                    UseCaseCard ->
                        todo

                    OrganizationCard ->
                        todo

                    ToolCard ->
                        todo
            , latvian =
                case cardType of
                    UseCaseCard ->
                        todo

                    OrganizationCard ->
                        todo

                    ToolCard ->
                        todo
            , lithuanian =
                case cardType of
                    UseCaseCard ->
                        todo

                    OrganizationCard ->
                        todo

                    ToolCard ->
                        todo
            , maltese =
                case cardType of
                    UseCaseCard ->
                        todo

                    OrganizationCard ->
                        todo

                    ToolCard ->
                        todo
            , polish =
                case cardType of
                    UseCaseCard ->
                        todo

                    OrganizationCard ->
                        todo

                    ToolCard ->
                        todo
            , portuguese =
                case cardType of
                    UseCaseCard ->
                        todo

                    OrganizationCard ->
                        todo

                    ToolCard ->
                        todo
            , romanian =
                case cardType of
                    UseCaseCard ->
                        todo

                    OrganizationCard ->
                        todo

                    ToolCard ->
                        todo
            , slovak =
                case cardType of
                    UseCaseCard ->
                        todo

                    OrganizationCard ->
                        todo

                    ToolCard ->
                        todo
            , slovenian =
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
            , swedish =
                case cardType of
                    UseCaseCard ->
                        todo

                    OrganizationCard ->
                        todo

                    ToolCard ->
                        todo
            }

        Card ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Kaart"
            , english = s "Card"
            , estonian = todo
            , finnish = todo
            , french = s "Fiche"
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

        CardId ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Kaart"
            , english = s "Card"
            , estonian = todo
            , finnish = todo
            , french = s "Fiche"
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

        CardIdArray ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Lijst van links naar kaarten"
            , english = s "Array of links to cards"
            , estonian = todo
            , finnish = todo
            , french = s "Tableau de liens vers des fiches"
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

        CardIdField ->
            getTranslationSet CardId

        CardPlaceholder ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Kaartnaam"
            , english = s "Name of a card"
            , estonian = todo
            , finnish = todo
            , french = s "Nom d'une fiche"
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

        ChangePassword ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Wijzig je wachtwoord"
            , english = s "Change your password"
            , estonian = todo
            , finnish = todo
            , french = s "Changez votre mot de passe"
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

        ChangePasswordExplanation ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Kies een wachtwoord om mee aan te kunnen melden"
            , english = s "Enter a new password to be able to sign-in."
            , estonian = todo
            , finnish = todo
            , french = s "Entrez un nouveau mot de passe qui vous servira à vous identifier."
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

        Close ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Gesloten"
            , english = s "Close"
            , estonian = todo
            , finnish = todo
            , french = s "Fermer"
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

        Collection number ->
            { bulgarian =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , croatian =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , czech =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , danish =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , dutch =
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
            , estonian =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , finnish =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , french =
                case number of
                    Singular ->
                        s "Collection"

                    Plural ->
                        s "Collections"
            , german =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , greek =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , hungarian =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , irish =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , italian =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , latvian =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , lithuanian =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , maltese =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , polish =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , portuguese =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , romanian =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , slovak =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , slovenian =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , spanish =
                case number of
                    Singular ->
                        s "Colección"

                    Plural ->
                        s "Colecciones"
            , swedish =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            }

        CollectionAdd ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Nieuwe collectie"
            , english = s "Add your collection"
            , estonian = todo
            , finnish = todo
            , french = s "Ajouter votre collection"
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

        CollectionAddDescription ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Een nieuwe collectie aanmaken."
            , english = s "Creation of a new collection."
            , estonian = todo
            , finnish = todo
            , french = s "Création d'une nouvelle collection."
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

        CollectionAddTitle ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Nieuwe collectie"
            , english = s "Add your collection"
            , estonian = todo
            , finnish = todo
            , french = s "Ajouter votre collection"
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

        CollectionDescriptionPlaceholder ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Presentatie van de collectie"
            , english = s "Presentation of your collection"
            , estonian = todo
            , finnish = todo
            , french = s "Présentation de votre collection"
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

        CollectionsDescription ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Lijst van platformen en toepassingen"
            , english = s "List of tools and use cases collected by a user"
            , estonian = todo
            , finnish = todo
            , french = s "List d'outils et de cas d'usages collectés par un utilisateur"
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

        CollectionNamePlaceholder ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Naam van de collectie"
            , english = s "Name of your collection"
            , estonian = todo
            , finnish = todo
            , french = s "Nom de votre collection"
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

        CollectionsRecommendedBy ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Aanbevolen door"
            , english = s "Recommended by "
            , estonian = todo
            , finnish = todo
            , french = s "Recommandé par "
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

        CollectionSubmissionFailed ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Collectie aanmaken mislukt"
            , english = s "Collection submission failed"
            , estonian = todo
            , finnish = todo
            , french = s "Échec de l'envoi de la collection"
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

        CollectionsTitle ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Collecties"
            , english = s "Collections"
            , estonian = todo
            , finnish = todo
            , french = s "Collections"
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
            , spanish = s "Colecciones"
            , swedish = todo
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
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Vergelijken"
            , english = s "Compare"
            , estonian = todo
            , finnish = todo
            , french = s "Comparer"
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

        Contact ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = todo
            , english = s "How can I contact the team behind the OGP Toolbox?"
            , estonian = todo
            , finnish = todo
            , french = s "Comment puis-je contacter l'équipe derrière l'OGP Toolbox ?"
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

        ContactContent ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = todo
            , english = s "For all questions, please send us an email:"
            , estonian = todo
            , finnish = todo
            , french = s "Pour toute question, vous pouvez nous envoyer un email à cette adresse :"
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

        Copyright ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "© 2016 Etalab. Ontworpen door Nodesign.net"
            , english = s "© 2016 Etalab. Design by Nodesign.net"
            , estonian = todo
            , finnish = todo
            , french = s "© 2016 Etalab. Design par Nodesign.net"
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

        CountVersionsAvailable count ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch =
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
            , estonian = todo
            , finnish = todo
            , french =
                case count of
                    0 ->
                        s "Aucune version disponible"

                    1 ->
                        s "1 version disponible"

                    _ ->
                        s ((toString count) ++ " versions disponibles")
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

        Create ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Maak"
            , english = s "Create"
            , estonian = todo
            , finnish = todo
            , french = s "Créer"
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

        CreateAccountNow ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Maak een account"
            , english = s "Create your account"
            , estonian = todo
            , finnish = todo
            , french = s "Créez votre compte"
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

        CreateOrganizationPage ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Maak een pagina voor de organisatie"
            , english = s "Create a page for your organization "
            , estonian = todo
            , finnish = todo
            , french = s "Créez une page pour votre organisation"
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

        CreateYourAccount ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Account aanmaken"
            , english = s "Create your account"
            , estonian = todo
            , finnish = todo
            , french = s "Créez votre compte"
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

        Deploy ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Gebruik dit platorm door het te installeren op een internet omgeving"
            , english = s "Use this tool by installing it on a server provided by a third-party"
            , estonian = todo
            , finnish = todo
            , french = s "Utiliser cet outil en l'installant sur un serveur fourni par un tiers"
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

        DeployFrenchGov ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Deze dienst is mogelijk gemaakt door de franse regering"
            , english = s "Service provided by the French government"
            , estonian = todo
            , finnish = todo
            , french = s "Service fourni par le gouvernment Français"
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

        DeployFrenchGovEligibility ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Beschikbaar voor franse overheden"
            , english = s "Available to French administrations"
            , estonian = todo
            , finnish = todo
            , french = s "Réservé aux administrations françaises"
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

        Description ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Omschrijving"
            , english = s "Description"
            , estonian = todo
            , finnish = todo
            , french = s "Description"
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

        Download ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Download link"
            , english = s "Download link"
            , estonian = todo
            , finnish = todo
            , french = s "Lien de téléchargement"
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

        DownloadDescription ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Internetadres om het platform te downloaden (URL)"
            , english = s "Address to download the tool (URL)"
            , estonian = todo
            , finnish = todo
            , french = s "Adresse pour télécharger l'outil (URL)"
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

        Edit ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Wijzig"
            , english = s "Edit"
            , estonian = todo
            , finnish = todo
            , french = s "Éditer"
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

        EditCollection ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Collectie bewerken"
            , english = s "Edit your collection"
            , estonian = todo
            , finnish = todo
            , french = s "Éditer votre collection"
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

        EditCollectionCatchPhrase ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Groepeer gelijkvormige of afhankelijke platformen"
            , english = s "A simple way to recommend your favorite tools."
            , estonian = todo
            , finnish = todo
            , french = s "Une façon simple de recommander vos outils favoris."
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

        EditCollectionDescription ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Bewerk een collectie"
            , english = s "Edit a collection."
            , estonian = todo
            , finnish = todo
            , french = s "Édition d'une collection."
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

        EditCollectionTitle ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Bewerk jouw collectie"
            , english = s "Edit your collection"
            , estonian = todo
            , finnish = todo
            , french = s "Éditer votre collection"
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

        Email ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Email"
            , english = s "Email"
            , estonian = todo
            , finnish = todo
            , french = s "Courriel"
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

        EmailPlaceholder ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "jan.jansen@voorbeeld.nl"
            , english = s "john.doe@example.com"
            , estonian = todo
            , finnish = todo
            , french = s "martin.dupont@exemple.fr"
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

        EmailSentForAccountActivation email ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch =
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
            , estonian = todo
            , finnish = todo
            , french =
                s
                    ("Un courriel a été envoyé à "
                        ++ email
                        ++ ". Cliquez sur le lien qu'il contient pour activer votre compte."
                    )
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

        EnterBoolean ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = todo
            , english = s "Please check or uncheck the box"
            , estonian = todo
            , finnish = todo
            , french = s "Veuillez cocher ou décocher la case"
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

        EnterCard ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Geef de naam of id van een kaart"
            , english = s "Please enter the name or the ID of a card"
            , estonian = todo
            , finnish = todo
            , french = s "Veuillez entrer le nom ou l'identifiant d'une fiche"
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

        EnterDescription ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Geef een omschrijving"
            , english = s "Please enter a description"
            , estonian = todo
            , finnish = todo
            , french = s "Veuillez entrer une description"
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

        EnterEmail ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Geef een emailadres"
            , english = s "Please enter your email"
            , estonian = todo
            , finnish = todo
            , french = s "Veuillez entrer votre courriel"
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

        EnterImage ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Selecteer een afbeelding"
            , english = s "Please select an image"
            , estonian = todo
            , finnish = todo
            , french = s "Veuillez sélectionner une image"
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

        EnterName ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Geef een naam"
            , english = s "Please enter a name"
            , estonian = todo
            , finnish = todo
            , french = s "Veuillez entrer un nom"
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

        EnterNumber ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Geef een nummer"
            , english = s "Please enter a number"
            , estonian = todo
            , finnish = todo
            , french = s "Veuillez entrer un nombre"
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

        EnterPassword ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Geef een wachtwoord"
            , english = s "Please enter your password"
            , estonian = todo
            , finnish = todo
            , french = s "Veuillez entrer votre mot de passe"
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

        EnterPropertyKey ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = todo
            , english = s "Please enter the name or the ID of a property"
            , estonian = todo
            , finnish = todo
            , french = s "Veuillez entrer le nom ou l'identifiant d'une propriété"
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

        EnterUrl ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Geef een link (URL)"
            , english = s "Please enter a link (an URL)"
            , estonian = todo
            , finnish = todo
            , french = s "Veuillez entrer un lien (une URL)"
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

        EnterUsername ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Geef een gebruikersnaam"
            , english = s "Please enter your username"
            , estonian = todo
            , finnish = todo
            , french = s "Veuillez entrer votre nom d'utilisateur"
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

        EnterValue ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Geef een waarde"
            , english = s "Please enter value"
            , estonian = todo
            , finnish = todo
            , french = s "Veuillez entrer une valeur"
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

        EtalabLogo ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Etalab logo"
            , english = s "Etalab logo"
            , estonian = todo
            , finnish = todo
            , french = s "Logo d'Etalab"
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

        EveryLanguage ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Alle talen"
            , english = s "Every language"
            , estonian = todo
            , finnish = todo
            , french = s "Toutes les langues"
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

        FalseWord ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Onwaar"
            , english = s "False"
            , estonian = todo
            , finnish = todo
            , french = s "Faux"
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

        Faq ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Veelgestelde vragen"
            , english = s "FAQ"
            , estonian = todo
            , finnish = todo
            , french = s "FAQ"
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

        FaqBug ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Hoe kan ik een fout melden of een idee indienen?"
            , english = s "How can I report a bug or suggest a new feature?"
            , estonian = todo
            , finnish = todo
            , french = s "Comment puis-je signaliser un bug ou suggérer une nouvelle fonctionnalité ?"
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

        FaqBugContent ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = todo
            , english = s "If you can't contribute directly to the code of the OGP Toolbox (cf. previous question), you can still help us by telling us about the problems you've encountered on the platform or about your ideas to improve it. Please file a new issue on this page:"
            , estonian = todo
            , finnish = todo
            , french = s "Si vous ne pouvez pas contribuer directement au code de l'OGP Toolbox (cf. question précédente), vous pouvez apporter une aide en nous indiquant les problèmes que vous avez rencontré en utilisant la plateforme ou vos idées pour l'améliorer. Il vous suffit de saisir une nouvelle entrée ('New Issue') sur cette page :"
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

        FaqCategories ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "How worden platformen en toepassingen gecategoriseerd?"
            , english = s "How are tools and use cases categorized?"
            , estonian = todo
            , finnish = todo
            , french = s "Comment sont catégorisés les outils et les cas usages ?"
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

        FaqCategoriesContent1 ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = todo
            , english = s "Rather than classify each tool (and their use cases) in monolithic and exclusive categories (i.e. “a tool cannot be in more than one category”), the platform is based on tags, allowing to qualify each tool and each usage with as many key words as necessary. This is called social tagging or "
            , estonian = todo
            , finnish = todo
            , french = s "Plutôt que de classer les outils (et leurs usages) dans de grandes catégories monolithiques et exclusives (i.e. \"un outil ne peut pas être dans plus d'une catégorie à la fois\"), la plateforme repose sur un système de \"tags\" (labels), permettant de qualifier chaque outil et chaque usage avec autant de mots clés que vous jugerez nécessaire. C'est ce qu'on appelle \"tagging\" social ou "
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

        FaqCategoriesContentLink ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "https://nl.wikipedia.org/wiki/Folksonomie"
            , english = s "https://en.wikipedia.org/wiki/Folksonomy"
            , estonian = todo
            , finnish = todo
            , french = s "https://fr.wikipedia.org/wiki/Folksonomie"
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

        FaqCategoriesContentLinkText ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Folksonomie"
            , english = s "folksonomy"
            , estonian = todo
            , finnish = todo
            , french = s "folksonomie"
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

        FaqCategoriesContent2 ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = todo
            , english = s "These tags are represented by bubbles. By cliking in different bubbles, you're simply searching in the Toolbox the tools and use cases matching those key words. Results are updated in real-time on the page."
            , estonian = todo
            , finnish = todo
            , french = s "Ces tags sont représentés sous forme de bulles. En cliquant sur différentes bulles, vous cherchez tout simplement dans la Toolbox les outils et cas d'usage qui correspondent à ces mots clés. Les résultats s'affichent en temps réel sur la page."
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

        FaqContribution ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = todo
            , english = s "How can I add information about a tool, a use case or a collection?"
            , estonian = todo
            , finnish = todo
            , french = s "Comment puis-je renseigner un outil, un cas d'usage, une collection ?"
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

        FaqContributionContent ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = todo
            , english = s "It's easy. Creat your account on the platform and click on “Add” at the top right of the screen. You will be guided!"
            , estonian = todo
            , finnish = todo
            , french = s "C'est très simple. Il suffit tout d'abord de créer un compte sur la plateforme. Ensuite, cliquer sur \"Ajouter\" en haut à droite et vous serez guidé."
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

        FaqCode ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Waar vind ik de broncode van de OGP Toolbox?"
            , english = s "Where can I find the source code of the OGP Toolbox?"
            , estonian = todo
            , finnish = todo
            , french = s "Où puis-je trouver le code source de l'OGP Toolbox ?"
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

        FaqData ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Kan ik de data gebruiken?"
            , english = s "How can I access the data?"
            , estonian = todo
            , finnish = todo
            , french = s "Comment puis-je accéder aux données ?"
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

        FaqCodeData ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = todo
            , english = s "The OGP Toolbox is an open source (AGPL License) and open data project (CC0 License), that's why we publish its source code as well as all harvested data. You'll find all informations and resources on this page:"
            , estonian = todo
            , finnish = todo
            , french = s "L'OGP Toolbox est un projet open source (Licence AGPL) et open data (Licence CC0), nous donnons donc accès à son code source ainsi qu'à toutes les données moissonnées. Vous trouverez toutes les informations et les ressources sur cette page :"
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

        FaqDataHarvest ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Waar komt de data vandaan?"
            , english = s "What is the source of the data?"
            , estonian = todo
            , finnish = todo
            , french = s "D'où proviennent les données ?"
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

        FaqDataHarvestContent0 ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Data voor de OGP Toolbox komt uit meerdere bronnen:"
            , english = s "The OGP Toolbox data comes from multiple sources:"
            , estonian = todo
            , finnish = todo
            , french = s "Les données de l'OGP Toolbox proviennent de sources multiples :"
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

        FaqDataHarvestContent1 ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "De data wordt regelmatig vernieuwd door bestaande catalogi uit te lezen:"
            , english = s "Existing catalogs are regularly harvested to feed and update the data base:"
            , estonian = todo
            , finnish = todo
            , french = s "Des catalogues existants sont moissonnés régulièrement pour alimenter et mettre à jour la base de données :"
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

        FaqDataHarvestContent2 ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = todo
            , english = s "OGP Toolbox users can create new tools, use cases and organizations, or edit existing ones."
            , estonian = todo
            , finnish = todo
            , french = s "Les utilisateurs de l'OGP Toolbox peuvent créer de nouvelles fiches d'outil, de cas d'usage et d'organisation, ou éditer des fiches existantes."
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

        FaqDescription ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Veelgestelde vragen"
            , english = s "Frequently asked questions (FAQ)"
            , estonian = todo
            , finnish = todo
            , french = s "Foire aux questions (FAQ)"
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

        FaqDev ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Door wie is de OGP Toolbox gemaakt?"
            , english = s "Who developed the OGP Toolbox?"
            , estonian = todo
            , finnish = todo
            , french = s "Qui a développé l'OGP Toolbox ?"
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

        FaqDevContent ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = todo
            , english = s "The OGP Toolbox is a free software developed by Etalab, the Prime Minister taskforce in charge of open data and open government French policy, on behalf of the OGP community. Co-created by the open government and the civic tech international community throughout 2016, the OGP Toolbox is one of the main deliverables of the Global Summit of the Open Government Partnership (7, 8 and 9 December 2016)."
            , estonian = todo
            , finnish = todo
            , french = s "L'OGP Toolbox a été développée par Etalab, service du Premier Ministre en charge de l'ouverture des données publiques et du gouvernement ouvert de la France, pour le compte de la communauté du Partenariat du Gouvernement Ouvert. Co-créée avec les communautés internationales du gouvernement ouvert et de la civic tech tout au long de l'année 2016, l'OGP Toolbox est un des principaux livrables du Sommet mondial du Partenariat pour un Gouvernement Ouvert (7, 8 et 9 décembre 2016)."
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

        FaqLanguages ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = todo
            , english = s "In which languages is the OGP Toolbox available?"
            , estonian = todo
            , finnish = todo
            , french = s "Dans quelles langues est disponible la plateforme ?"
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

        FaqLanguagesContent ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = todo
            , english = s "The OGP Toolbox is available in English and French. The platform is crowdsourced, which means that other than the online interface (translated by Etalab), any content can be modified and translated by users, such as the description of tools and use cases, as well as the tags used to categorize them (see below). Content will be displayed in the language you configured. If an element is not available in your language, it will be displayed in English by default, with an invitation to translate it."
            , estonian = todo
            , finnish = todo
            , french = s "OGP Toolbox est disponible en Anglais et en Français. La plateforme est crowdsourcée ce qui signifie qu'au-delà de l'interface du site Internet (traduite par Etalab), chaque élément de contenu peut être modifié et traduit par les utilisateurs, notamment les descriptions des outils et des cas d'usage et les tags permettant de les catégoriser (voir ci-dessous). Les éléments de contenu s'afficheront en priorité dans la langue que vous aurez paramétrée. Si un élément n'est pas disponible dans votre langue, il s'affiche en anglais par défaut, et vous invite à le traduire."
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

        FaqLead ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Veelgestelde vragen over de OGP Toolbox"
            , english = s "All the answers to your questions about the OGP Toolbox"
            , estonian = todo
            , finnish = todo
            , french = s "Mieux comprendre l'OGP Toolbox"
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

        FaqModeration ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Wordt de inhoud gecontroleerd?"
            , english = s "How are contributions moderated?"
            , estonian = todo
            , finnish = todo
            , french = s "Comment sont modérées les contributions ?"
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

        FaqModerationContent ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = todo
            , english = s "The OGP Toolbox is based on community moderation. Data from the harvested catalogues and users’ contributions are automatically sort out through an open vote system. For each field, the most popular suggested description is highlighted in the tool, use case or organization card. The vote on available propositions is accessible by clicking on the “edit” button at the right of each field."
            , estonian = todo
            , finnish = todo
            , french = s "OGP Toolbox s'appuie sur une modération communautaire. Les données provenant des catalogues moissonnées et des contributions des utilisateurs sont triées de façon automatique à travers un système de vote ouvert. Pour chaque champ, la proposition de description ou de valeur la plus votée est mise en avant sur la fiche outil, cas d'usage ou organisation. Le vote sur les propositions disponibles est accessible en cliquant sur le bouton \"edit\" à la droite de chaque champ. "
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

        FaqTarget ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = todo
            , english = s "Who is the OGP Toolbox for?"
            , estonian = todo
            , finnish = todo
            , french = s "À qui est destinée l'OGP Toolbox ?"
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

        FaqTargetContent ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = todo
            , english = s "The OGP is intended to all public sector, private sector and civil society organizations that develop projects to promote democracy and promote transparency, participation and collaboration. Any engaged citizen willing to be introduced to new tools and to discover particular use cases will be able to access relevant information, and to get in touch with the users’ community."
            , estonian = todo
            , finnish = todo
            , french = s "L'OGP Toolbox est destinée à tous les acteurs publics, privés et de la société civile portant des projets pour renforcer la démocratie et promouvoir la transparence, la participation et la collaboration dans l'action publique. Tout citoyen engagé voulant s'initier à de nouveaux outils et en découvrir les cas d'usages pourra accéder facilement aux informations pertinentes."
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

        FaqTypes ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Wat vind ik in de OGP Toolbox?"
            , english = s "What can I find in the OGP Toolbox?"
            , estonian = todo
            , finnish = todo
            , french = s "Qu'est-ce-qu'on peut trouver dans l'OGP Toolbox ?"
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

        FaqTypesContent ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Er zijn 4 categoriën"
            , english = s "The platform showcases 4 types of items:"
            , estonian = todo
            , finnish = todo
            , french = s "La plateforme référence 4 types d'éléments :"
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

        FaqTypesContentCollection ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = todo
            , english = s "A collection is a list of tools recommended by a contributor. The same as bookmarks or favorites, but for tools!"
            , estonian = todo
            , finnish = todo
            , french = s "Une collection est une liste d'outils recommandés par un contributeur. Comme des marque-pages ou des favoris, mais pour des outils !"
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

        FaqTypesContentOrganization ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = todo
            , english = s "An organization is either the user or the developer of a tool, and is part of the public sector (government, administration, parliament, subnational entity), the private sector (company, startup) or the civil society (non-profit organization, movement)."
            , estonian = todo
            , finnish = todo
            , french = s "Une organisation utilise ou développe des outils, et fait partie de la sphère publique (gouvernement, administration, parlement, collectivité locale), du secteur privé (entreprise, startup) ou de la société civile (association, mouvement)."
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

        FaqTypesContentTool ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = todo
            , english = s "A digital tool is either a computer program (software, application) or an online service (website, platform, resource)."
            , estonian = todo
            , finnish = todo
            , french = s "Un outil numérique est un programme informatique (logiciel, application) ou un service en ligne (site Internet, plateforme, ressource)."
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

        FaqTypesContentUseCase ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = todo
            , english = s "A use case is a concrete example showing how one or multiple tools were used by an organization."
            , estonian = todo
            , finnish = todo
            , french = s "Un cas d'usage est un exemple concret d'utilisation d'un ou plusieurs outils par une organisation."
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

        FaqWhat ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Wat is de OGP Toolbox?"
            , english = s "What is the OGP Toolbox?"
            , estonian = todo
            , finnish = todo
            , french = s "Qu'est ce que l'OGP Toolbox ?"
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

        FaqWhatContent1 ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = todo
            , english = s "The OGP Toolbox is a collaborative platform that gathers digital tools developed and used throughout the world by organizations to improve democracy and promote transparency, participation and collaboration."
            , estonian = todo
            , finnish = todo
            , french = s "L'OGP Toolbox est une plateforme collaborative qui recense les outils numériques développés et utilisés dans le monde entier par des organisations pour renforcer la démocratie et promouvoir la transparence, la participation et la collaboration dans l'action publique."
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

        FaqWhatContent2 ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = todo
            , english = s "The OGP Toolbox is designed as a social network: concrete use cases, technical criteria informed by the community and recommendations in the form of tool collections allow to benefit from the experience of users that have already implemented existing solutions."
            , estonian = todo
            , finnish = todo
            , french = s "L'OGP Toolbox est conçue comme un réseau social : des cas d'usages concrets, des critères techniques expertisés par la communauté et des recommandations sous forme de collections d'outils permettent de profiter du savoir-faire des acteurs ayant déjà utilisé les solutions disponibles. "
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

        FaqWhy ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Waarom de OGP Toolbox?"
            , english = s "Why do we need an OGP Toolbox?"
            , estonian = todo
            , finnish = todo
            , french = s "À quoi sert l'OGP Toolbox ? "
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

        FaqWhyContent1 ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = todo
            , english = s "The OGP Toolbox aims at empowering organizations by sharing resources and experiences. The objective is to facilitate cooperation and the implementation of concrete engagements related to the open government through the appropriation of digital tools."
            , estonian = todo
            , finnish = todo
            , french = s "L'OGP Toolbox vise à renforcer le pouvoir d'agir des acteurs publics, privés et de la société civile à travers le partage de ressources et d'expériences. L'objectif est de faciliter la mise en oeuvre concrète d'engagements et de coopérations liées au gouvernement ouvert grâce à la maîtrise des outils numériques."
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

        FaqWhyContent2 ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = todo
            , english = s "The platform enables to find the most adapted tool to each project or initiative through search and comparison functionalities by category, use case, organization or technical criterion. The idea is to simplify access and manipulation of digital tools for everyone."
            , estonian = todo
            , finnish = todo
            , french = s "La plateforme permet de trouver l'outil le mieux adapté à chaque projet ou initiative à travers des recherches et des comparaisons par catégorie, cas d'usage, organisation ou critère technique, ainsi que d'en simplifier l'accès et la prise en main."
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

        FieldTypeBoolean ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Ja / Nee"
            , english = s "Yes / No"
            , estonian = todo
            , finnish = todo
            , french = s "Oui / Non"
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

        FieldTypeEmail ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Emailadres"
            , english = s "Email address"
            , estonian = todo
            , finnish = todo
            , french = s "Adresse email"
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

        FieldTypeImage ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Afbeelding"
            , english = s "Image"
            , estonian = todo
            , finnish = todo
            , french = s "Image"
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

        FieldTypeInternalLink ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "OGP Toolbox interne link"
            , english = s "OGP Toolbox internal link"
            , estonian = todo
            , finnish = todo
            , french = s "Lien interne à l'OGP Toolbox"
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

        FieldTypeInteger ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Nummer"
            , english = s "Number"
            , estonian = todo
            , finnish = todo
            , french = s "Nombre"
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

        FieldTypeMultiLine ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Meerdere regels tekst"
            , english = s "Multi-line text"
            , estonian = todo
            , finnish = todo
            , french = s "Texte sur plusieurs lignes"
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

        FieldTypeSingleLine ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Een regel tekst"
            , english = s "Single line text"
            , estonian = todo
            , finnish = todo
            , french = s "Texte sur une seule ligne"
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

        FieldTypeURL ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Internetadres (URL)"
            , english = s "Web address (URL)"
            , estonian = todo
            , finnish = todo
            , french = s "Adresse web (URL)"
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

        FindAnotherCard ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Zoek een andere kaart"
            , english = s "Find another card"
            , estonian = todo
            , finnish = todo
            , french = s "Rechercher une autre fiche"
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

        FindAnotherPropertyKey ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = todo
            , english = s "Find another property"
            , estonian = todo
            , finnish = todo
            , french = s "Rechercher une autre propriété"
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

        FindCard ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Zoek een kaart"
            , english = s "Find a card"
            , estonian = todo
            , finnish = todo
            , french = s "Rechercher une fiche"
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

        FindPropertyKey ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = todo
            , english = s "Find a property"
            , estonian = todo
            , finnish = todo
            , french = s "Rechercher une propriété"
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

        FooterAbout ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Over"
            , english = s "About"
            , estonian = todo
            , finnish = todo
            , french = s "À propos"
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
            , spanish = s "Acerca"
            , swedish = todo
            }

        FooterDiscover ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Inhoud"
            , english = s "Content"
            , estonian = todo
            , finnish = todo
            , french = s "Découvrir"
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
            , spanish = s "Descubrir"
            , swedish = todo
            }

        GenericError ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Er is iets misgegaan."
            , english = s "Something went wrong."
            , estonian = todo
            , finnish = todo
            , french = s "Quelque chose s'est mal passé !"
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

        HaveAnAccount ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Ik heb al een account"
            , english = s "I already have an account"
            , estonian = todo
            , finnish = todo
            , french = s "J'ai déjà un compte"
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

        HeaderTitle ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Software voor de digitale democratie"
            , english = s "digital solutions to improve democracy"
            , estonian = todo
            , finnish = todo
            , french = s "solutions numériques pour la démocratie"
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

        Help ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Veelgestelde vragen"
            , english = s "FAQ"
            , estonian = todo
            , finnish = todo
            , french = s "Aide"
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
            , spanish = s "Ayuda"
            , swedish = todo
            }

        Home ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Home"
            , english = s "Home"
            , estonian = todo
            , finnish = todo
            , french = s "Accueil"
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
            , spanish = s "Inicio"
            , swedish = todo
            }

        HomeDescription ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Digitale oplossingen voor het verbeteren van de democratie"
            , english = s "Digital solutions to improve democracy"
            , estonian = todo
            , finnish = todo
            , french = s "Solutions numériques pour la démocratie"
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

        HomeResults ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Resultaten bekijken"
            , english = s "See results"
            , estonian = todo
            , finnish = todo
            , french = s "Afficher les résultats"
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

        HomeStart ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Klik op een term om deze te selecteren"
            , english = s "Click on a bubble to start"
            , estonian = todo
            , finnish = todo
            , french = s "Cliquez sur une bulle pour commencer"
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

        HomeTitle ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "OGP Toolbox"
            , english = s "OGP Toolbox"
            , estonian = todo
            , finnish = todo
            , french = s "OGP Toolbox"
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

        Image ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Afbeeldingen"
            , english = s "Image"
            , estonian = todo
            , finnish = todo
            , french = s "Image"
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

        ImageAlt ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Geuploade Afbeelding"
            , english = s "The uploaded image"
            , estonian = todo
            , finnish = todo
            , french = s "L'image ajoutée"
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

        ImageField ->
            getTranslationSet Image

        ImageUploadError message ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s ("Fout bij het uploaden van: " ++ message)
            , english = s ("Image upload error: " ++ message)
            , estonian = todo
            , finnish = todo
            , french = s ("Échec du téléversement de l'image :" ++ message)
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

        ImproveExistingContent ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Inhoud verbeteren"
            , english = s "Improve existing content"
            , estonian = todo
            , finnish = todo
            , french = s "Améliorez le contenu existant"
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

        InputEmailField ->
            getTranslationSet Email

        InputNumberField ->
            getTranslationSet Number

        InputUrlField ->
            getTranslationSet Url

        InvalidNumber ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Geen geldig nummer"
            , english = s "Not a valid number"
            , estonian = todo
            , finnish = todo
            , french = s "Ce n'est pas un nombre valide."
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

        Language language ->
            case language of
                Bulgarian ->
                    { bulgarian = todo
                    , croatian = todo
                    , czech = todo
                    , danish = todo
                    , dutch = s "Bulgaars"
                    , english = s "Bulgarian"
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

                Croatian ->
                    { bulgarian = todo
                    , croatian = todo
                    , czech = todo
                    , danish = todo
                    , dutch = s "Kroatisch"
                    , english = s "Croatian"
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

                Czech ->
                    { bulgarian = todo
                    , croatian = todo
                    , czech = todo
                    , danish = todo
                    , dutch = s "Tsjechisch"
                    , english = s "Czech"
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

                Danish ->
                    { bulgarian = todo
                    , croatian = todo
                    , czech = todo
                    , danish = todo
                    , dutch = s "Deens"
                    , english = s "Danish"
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

                Dutch ->
                    { bulgarian = todo
                    , croatian = todo
                    , czech = todo
                    , danish = todo
                    , dutch = s "Nederlands"
                    , english = s "Dutch"
                    , estonian = todo
                    , finnish = todo
                    , french = s "Néerlandais"
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
                    , spanish = s "Holandés"
                    , swedish = todo
                    }

                English ->
                    { bulgarian = todo
                    , croatian = todo
                    , czech = todo
                    , danish = todo
                    , dutch = s "Engels"
                    , english = s "English"
                    , estonian = todo
                    , finnish = todo
                    , french = s "Anglais"
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

                Estonian ->
                    { bulgarian = todo
                    , croatian = todo
                    , czech = todo
                    , danish = todo
                    , dutch = s "Estisch"
                    , english = s "Estonian"
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

                Finnish ->
                    { bulgarian = todo
                    , croatian = todo
                    , czech = todo
                    , danish = todo
                    , dutch = s "Fins"
                    , english = s "Finnish"
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

                French ->
                    { bulgarian = todo
                    , croatian = todo
                    , czech = todo
                    , danish = todo
                    , dutch = s "Frans"
                    , english = s "French"
                    , estonian = todo
                    , finnish = todo
                    , french = s "Français"
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
                    , spanish = s "Francés"
                    , swedish = todo
                    }

                German ->
                    { bulgarian = todo
                    , croatian = todo
                    , czech = todo
                    , danish = todo
                    , dutch = s "Duits"
                    , english = s "German"
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

                Greek ->
                    { bulgarian = todo
                    , croatian = todo
                    , czech = todo
                    , danish = todo
                    , dutch = s "Grieks"
                    , english = s "Greek"
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

                Hungarian ->
                    { bulgarian = todo
                    , croatian = todo
                    , czech = todo
                    , danish = todo
                    , dutch = s "Hongaars"
                    , english = s "Hungarian"
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

                Irish ->
                    { bulgarian = todo
                    , croatian = todo
                    , czech = todo
                    , danish = todo
                    , dutch = s "Iers"
                    , english = s "Irish"
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

                Italian ->
                    { bulgarian = todo
                    , croatian = todo
                    , czech = todo
                    , danish = todo
                    , dutch = s "Italiaans"
                    , english = s "Italian"
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

                Latvian ->
                    { bulgarian = todo
                    , croatian = todo
                    , czech = todo
                    , danish = todo
                    , dutch = s "Lets"
                    , english = s "Latvian"
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

                Lithuanian ->
                    { bulgarian = todo
                    , croatian = todo
                    , czech = todo
                    , danish = todo
                    , dutch = s "Litouws"
                    , english = s "Lithuanian"
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

                Maltese ->
                    { bulgarian = todo
                    , croatian = todo
                    , czech = todo
                    , danish = todo
                    , dutch = s "Maltees"
                    , english = s "Maltese"
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

                Polish ->
                    { bulgarian = todo
                    , croatian = todo
                    , czech = todo
                    , danish = todo
                    , dutch = s "Pools"
                    , english = s "Polish"
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

                Portuguese ->
                    { bulgarian = todo
                    , croatian = todo
                    , czech = todo
                    , danish = todo
                    , dutch = s "Portugees"
                    , english = s "Portuguese"
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

                Romanian ->
                    { bulgarian = todo
                    , croatian = todo
                    , czech = todo
                    , danish = todo
                    , dutch = s "Roemeens"
                    , english = s "Romanian"
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

                Slovak ->
                    { bulgarian = todo
                    , croatian = todo
                    , czech = todo
                    , danish = todo
                    , dutch = s "Slovaaks"
                    , english = s "Slovak"
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

                Slovenian ->
                    { bulgarian = todo
                    , croatian = todo
                    , czech = todo
                    , danish = todo
                    , dutch = s "Sloveens"
                    , english = s "Slovenian"
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

                Spanish ->
                    { bulgarian = todo
                    , croatian = todo
                    , czech = todo
                    , danish = todo
                    , dutch = s "Spaans"
                    , english = s "Spanish"
                    , estonian = todo
                    , finnish = todo
                    , french = s "Espagnol"
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
                    , spanish = s "Español"
                    , swedish = todo
                    }

                Swedish ->
                    { bulgarian = todo
                    , croatian = todo
                    , czech = todo
                    , danish = todo
                    , dutch = s "Zweeds"
                    , english = s "Swedish"
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

        LanguageWord ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Taal"
            , english = s "Language"
            , estonian = todo
            , finnish = todo
            , french = s "Langue"
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
            , spanish = s "Idioma"
            , swedish = todo
            }

        License ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Licentie"
            , english = s "License"
            , estonian = todo
            , finnish = todo
            , french = s "Licence"
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
            , spanish = s "Idioma"
            , swedish = todo
            }

        LoadingMenu ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Menu wordt geladen..."
            , english = s "Loading menu..."
            , estonian = todo
            , finnish = todo
            , french = s "Chargement du menu..."
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

        LocalizedString ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Vertaalde tekenreeks"
            , english = s "Localized string"
            , estonian = todo
            , finnish = todo
            , french = s "Chaîne de caractères localisée"
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

        Logo ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Logo"
            , english = s "Logo"
            , estonian = todo
            , finnish = todo
            , french = s "Logo"
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

        MissingDescription ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Omschrijving ontbreekt"
            , english = s "Missing description"
            , estonian = todo
            , finnish = todo
            , french = s "Description manquante"
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

        MissingValue ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Verplicht veld"
            , english = s "Missing value"
            , estonian = todo
            , finnish = todo
            , french = s "Valeur manquante"
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

        Name ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Naam"
            , english = s "Name"
            , estonian = todo
            , finnish = todo
            , french = s "Nom"
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

        NetworkErrorExplanation ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Er is een netwerkfout opgetreden."
            , english = s "There was a network error."
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

        New ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Nieuw"
            , english = s "New"
            , estonian = todo
            , finnish = todo
            , french = s "Nouveau"
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

        NewCard ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Nieuw"
            , english = s "Add new"
            , estonian = todo
            , finnish = todo
            , french = s "Ajouter"
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
            , spanish = s "Añadir nuevo"
            , swedish = todo
            }

        NewCardCollectionCatchPhrase ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Een eenvoudige manier om je favoriete platform aan te bevelen."
            , english = s "A simple way to recommend your favorite tools."
            , estonian = todo
            , finnish = todo
            , french = s "Une façon simple de recommander vos outils favoris."
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

        NewCardItemBox ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Nieuw onderdeel"
            , english = s "Add a new item"
            , estonian = todo
            , finnish = todo
            , french = s "Ajouter un nouvel élément"
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

        NewCardOrganization ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Nieuwe organisatie"
            , english = s "Add a new organization"
            , estonian = todo
            , finnish = todo
            , french = s "Ajouter une nouvelle organisation"
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

        NewCardOrganizationCatchPhrase ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Een organisatie die platformen gebruikt of maakt"
            , english = s "A developer or user of tools."
            , estonian = todo
            , finnish = todo
            , french = s "Un développeur ou utilisateur d'outil."
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

        NewCardOrganizationDescription ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Voeg een organisatie toe door algemene informatie op te geven"
            , english = s "Create a new organization by giving some generic information"
            , estonian = todo
            , finnish = todo
            , french = s "Création d'une nouvelle organisation en fournissant quelques informations générales"
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

        NewCardOrganizationDescriptionPlaceholder ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Presentatie van de organisatie"
            , english = s "Presentation of the organization"
            , estonian = todo
            , finnish = todo
            , french = s "Présentation de l'organisation"
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

        NewCardOrganizationName ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Officiële naam van de organisatie (b.v. \"Open Knowledge International\")"
            , english = s "Offical name of the organization (e.g. \"Open Knowledge International\")"
            , estonian = todo
            , finnish = todo
            , french = s "Nom officiel de l'organisation (par ex : \"Open Knowledge International\")"
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

        NewCardTool ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Nieuw platform"
            , english = s "Add a new tool"
            , estonian = todo
            , finnish = todo
            , french = s "Ajouter un nouvel outil"
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

        NewCardToolCatchPhrase ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Software of een internet platform"
            , english = s "Software or a website."
            , estonian = todo
            , finnish = todo
            , french = s "Un logiciel ou un site Internet."
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

        NewCardToolDescription ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Registreer een platform door algemene informatie in te vullen"
            , english = s "Creating a new tool by giving a few generic informations."
            , estonian = todo
            , finnish = todo
            , french = s "Création d'un nouvel outil en fournissant quelques informations générales"
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

        NewCardToolDescriptionPlaceholder ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Presentatie van het platform"
            , english = s "Presentation of the tool"
            , estonian = todo
            , finnish = todo
            , french = s "Présentation de l'outil"
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

        NewCardToolName ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Officiële naam van het platform (b.v. \"Loomio\")"
            , english = s "Official name of the tool (e.g. \"Loomio\")"
            , estonian = todo
            , finnish = todo
            , french = s "Nom officiel de l'outil (par ex : \"Loomio\")"
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

        NewCardUseCase ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Voeg een toepassing toe"
            , english = s "Add a new use case"
            , estonian = todo
            , finnish = todo
            , french = s "Ajouter un nouveau cas d'usage"
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

        NewCardUseCaseCatchPhrase ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Een platform toegepast in de praktijk"
            , english = s "A concrete example showing how a tool was used."
            , estonian = todo
            , finnish = todo
            , french = s "Un exemple concret d'utilisation d'un ou plusieurs outils."
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

        NewCardUseCaseDescription ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Registreer een toepassing door het opgeven van algemene informatie"
            , english = s "Creating a new use case by giving a few generic informations"
            , estonian = todo
            , finnish = todo
            , french = s "Création d'un nouveau cas d'usage en fournissant quelques informations générales"
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

        NewCardUseCaseDescriptionPlaceholder ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Presentatie van de toepassing"
            , english = s "Presentation of the use case"
            , estonian = todo
            , finnish = todo
            , french = s "Présentation du cas d'usage"
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

        NewCardUseCaseName ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Naam van de toepassing (b.v. \"data.overheid.nl\")"
            , english = s "Name of the use case (e.g. \"Open Knowledge Forums\")"
            , estonian = todo
            , finnish = todo
            , french = s "Nom du cas d'usage (par ex : \"Forums d'Open Knowledge\")"
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

        NewValue ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Nieuwe waarde"
            , english = s "New Value"
            , estonian = todo
            , finnish = todo
            , french = s "Nouvelle valeur"
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

        NewValueDescription ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Formulier voor het toevoegen van een waarde"
            , english = s "Form to enter a new value"
            , estonian = todo
            , finnish = todo
            , french = s "Formulaire de création d'une nouvelle valeur"
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

        Number ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Nummer"
            , english = s "Number"
            , estonian = todo
            , finnish = todo
            , french = s "Nombre"
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
            , spanish = s "Número"
            , swedish = todo
            }

        NumberPlaceholder ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "3.1415927"
            , english = s "3.1415927"
            , estonian = todo
            , finnish = todo
            , french = s "3.1415927"
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
            , spanish = s "3.1415927"
            , swedish = todo
            }

        OGPsummitLink ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "https://nl.ogpsummit.org/osem/conference/ogp-summit"
            , english = s "https://en.ogpsummit.org/osem/conference/ogp-summit"
            , estonian = todo
            , finnish = todo
            , french = s "https://fr.ogpsummit.org/osem/conference/ogp-summit"
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
            , spanish = s "https://es.ogpsummit.org/osem/conference/ogp-summit"
            , swedish = todo
            }

        OpenGovernmentPartnership ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Open Government Partnership"
            , english = s "Open Government Partnership"
            , estonian = todo
            , finnish = todo
            , french = s "Partenariat pour un gouvernement ouvert"
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

        OpenGovernmentPartnershipLogo ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Logo van Open Government Partnership"
            , english = s "Open Government Partnership logo"
            , estonian = todo
            , finnish = todo
            , french = s "logo du Partenariat pour un gouvernement ouvert"
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

        OpenGovParagraph ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s """
Open Government Partnership is een initiatief dat streeft naar samenwerking tussen overheden bij het streven naar
transparantie, vergroten van burgerparticipatie, voorkomen van onduidelijkheid en het omarmen van technologie voor het
verbeteren van de dienstverlening door overheden.
"""
            , english = s """
The Open Government Partnership is a multilateral initiative that aims to secure concrete commitments
from governments to promote transparency, empower citizens, fight corruption, and harness new technologies
to strengthen governance.
"""
            , estonian = todo
            , finnish = todo
            , french = s "Le Partenariat pour un gouvernement ouvert est une initiative multilatérale créée en 2011 par huit pays fondateurs, qui s’attache à promouvoir la transparence et l’intégrité du gouvernement ainsi que l’utilisation des nouvelles technologies pour faciliter son ouverture."
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

        Organization number ->
            { bulgarian =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , croatian =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , czech =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , danish =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , dutch =
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
            , estonian =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , finnish =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , french =
                case number of
                    Singular ->
                        s "Organisation"

                    Plural ->
                        s "Organisations"
            , german =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , greek =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , hungarian =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , irish =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , italian =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , latvian =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , lithuanian =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , maltese =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , polish =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , portuguese =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , romanian =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , slovak =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , slovenian =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , spanish =
                case number of
                    Singular ->
                        s "Organización"

                    Plural ->
                        s "Organizaciones"
            , swedish =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            }

        OpenData ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Open data"
            , english = s "Open Data"
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

        OpenSource ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Open Source Software"
            , english = s "Free Open Source Software"
            , estonian = todo
            , finnish = todo
            , french = s "Logiciel Libre Open Source"
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

        OrganizationId ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Organisatie"
            , english = s "Organization"
            , estonian = todo
            , finnish = todo
            , french = s "Organisation"
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

        OrganizationIdField ->
            getTranslationSet OrganizationId

        OrganizationPlaceholder ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Naam van een organisatie"
            , english = s "Name of an organization"
            , estonian = todo
            , finnish = todo
            , french = s "Nom d'une organisation"
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

        OrganizationsDescription ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Lijst van organisaties"
            , english = s "List of organizations"
            , estonian = todo
            , finnish = todo
            , french = s "Liste d'organisations"
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

        PageLoading ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "De pagina wordt geladen"
            , english = s "Page is loading"
            , estonian = todo
            , finnish = todo
            , french = s "Chargement en cours"
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

        PageLoadingExplanation ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "De gegevens worden geladen. Ogenblik geduld."
            , english = s "Data is loading and should be displayed quite soon."
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

        PageNotFound ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Pagina niet gevonden"
            , english = s "Page Not Found"
            , estonian = todo
            , finnish = todo
            , french = s "Page non trouvée"
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

        PageNotFoundDescription ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "De gevraagde pagina bestaat niet"
            , english = s "The requested page doesn't exist."
            , estonian = todo
            , finnish = todo
            , french = s "La page demandée n'existe pas."
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

        PageNotFoundExplanation ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "De pagina die je probeert op te vragen bestaat niet."
            , english = s "Sorry, but the page you were trying to view does not exist."
            , estonian = todo
            , finnish = todo
            , french = s "Désolé mais la page que vous avez demandé n'est pas disponible"
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

        Password ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Wachtwoord"
            , english = s "Password"
            , estonian = todo
            , finnish = todo
            , french = s "Mot de passe"
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

        PasswordChangeFailed ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Wachtwoord wijzigen mislukt"
            , english = s "Password change failed"
            , estonian = todo
            , finnish = todo
            , french = s "Échec du changement de mot de passe"
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

        PasswordLost ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Wachtwoord vergeten?"
            , english = s "Password lost?"
            , estonian = todo
            , finnish = todo
            , french = s "Mot de passe oublié ?"
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

        PasswordPlaceholder ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Je wachtwoord"
            , english = s "Your secret password"
            , estonian = todo
            , finnish = todo
            , french = s "Votre mot de passe secret"
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

        Platform ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Internetdienst (website, platform, bron)"
            , english = s "Online service (website, platform, resource)"
            , estonian = todo
            , finnish = todo
            , french = s "Service en ligne (site Internet, plateforme, ressource)"
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

        Press ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "In het nieuws"
            , english = s "Press"
            , estonian = todo
            , finnish = todo
            , french = s "Presse"
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

        PressDescription ->
            getTranslationSet PressLead

        PressLead ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Diverse nieuwsberichten over de OGP Toolbox"
            , english = s "What the press says of the OGP Toolbox"
            , estonian = todo
            , finnish = todo
            , french = s "La presse parle de la boite à outils de l'OGP"
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

        ProfileMyCollections ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Mijn collecties"
            , english = s "My collections"
            , estonian = todo
            , finnish = todo
            , french = s "Mes collections"
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
            , spanish = s "Mis colecciones"
            , swedish = todo
            }

        PropertyKeyPlaceholder ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = todo
            , english = s "Name of a property"
            , estonian = todo
            , finnish = todo
            , french = s "Nom d'une propriété"
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

        Proprietary ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Commercieel"
            , english = s "Closed Proprietary Software"
            , estonian = todo
            , finnish = todo
            , french = s "Logiciel propriétaire fermé"
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

        Publish ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Publiceren"
            , english = s "Publish"
            , estonian = todo
            , finnish = todo
            , french = s "Publier"
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
            , spanish = s "Publicar"
            , swedish = todo
            }

        PublishCollection ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Publiceer je collectie"
            , english = s "Publish your collection"
            , estonian = todo
            , finnish = todo
            , french = s "Publier votre collection"
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
            , spanish = s "Publicar sus colecciones"
            , swedish = todo
            }

        PublishOrganization ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Publiceer organisatie"
            , english = s "Publish organization"
            , estonian = todo
            , finnish = todo
            , french = s "Publier cette organisation"
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

        PublishUseCase ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Publiceer toepassing"
            , english = s "Publish use case"
            , estonian = todo
            , finnish = todo
            , french = s "Publier ce cas d'usage"
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

        PublishTool ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Publiceer platform"
            , english = s "Publish tool"
            , estonian = todo
            , finnish = todo
            , french = s "Publier cet outil"
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

        ReadingSelectedImage ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Geselecteerde afbeelding wordt geladen..."
            , english = s "Reading selected image..."
            , estonian = todo
            , finnish = todo
            , french = s "Lecture de l'image sélectionnée..."
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

        ReadMore ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Meer..."
            , english = s "Read more"
            , estonian = todo
            , finnish = todo
            , french = s "En savoir plus"
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

        ReleaseDate ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Datum van uitgave"
            , english = s "Release date"
            , estonian = todo
            , finnish = todo
            , french = s "Date de sortie"
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

        ReleaseDatePlaceholder ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Datum waarop de stabiele versie is uitgegeven"
            , english = s "Launch date of the last stable version"
            , estonian = todo
            , finnish = todo
            , french = s "Date de lancement de la dernière version stable"
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

        Register ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Registreren"
            , english = s "Register"
            , estonian = todo
            , finnish = todo
            , french = s "Créer le compte"
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

        RegisterNow ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Registreer nu"
            , english = s "Register now!"
            , estonian = todo
            , finnish = todo
            , french = s "Inscrivez vous maintenant !"
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

        Remove ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Verwijder"
            , english = s "Remove"
            , estonian = todo
            , finnish = todo
            , french = s "Enlever"
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

        ResetPassword ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Wachtwoord herstellen"
            , english = s "Reset Password"
            , estonian = todo
            , finnish = todo
            , french = s "Changer de mot de passe"
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

        ResetPasswordExplanation ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = todo
            , english = s "Enter your email. We will send you the instructions to create a new password."
            , estonian = todo
            , finnish = todo
            , french = s "Entrez votre courriel. Nous vous enverrons les instructions pour changer de mot de passe."
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

        ResetPasswordLink ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Wachtwoord vergeten"
            , english = s "I forgot my password"
            , estonian = todo
            , finnish = todo
            , french = s "J'ai oublié mon mot de passe"
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

        Save ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Opslaan"
            , english = s "Save"
            , estonian = todo
            , finnish = todo
            , french = s "Enregistrer"
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

        SelectCardOrTypeMoreCharacters ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Selecteer een kaart of begin met typen"
            , english = s "Select a card or type more characters"
            , estonian = todo
            , finnish = todo
            , french = s "Sélectionner une fiche ou taper plus de caractères"
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

        SelectPropertyKeyOrTypeMoreCharacters ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = todo
            , english = s "Select a property or type more characters"
            , estonian = todo
            , finnish = todo
            , french = s "Sélectionner une propriété ou taper plus de caractères"
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

        Score ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Score"
            , english = s "Score"
            , estonian = todo
            , finnish = todo
            , french = s "Score"
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
            , spanish = s "Score"
            , swedish = todo
            }

        SearchInputPlaceholder ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Zoeken..."
            , english = s "Search for a tool, use case or organization"
            , estonian = todo
            , finnish = todo
            , french = s "Rechercher un outil, un cas d'usage ou une organisation"
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

        SeeAllAndCompare ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Alles bekijken en vergelijken"
            , english = s "See all and compare"
            , estonian = todo
            , finnish = todo
            , french = s "Voir tous et comparer"
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

        Send ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Verzenden"
            , english = s "Send"
            , estonian = todo
            , finnish = todo
            , french = s "Envoyer"
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
            , spanish = s "Enviar"
            , swedish = todo
            }

        SendEmailAgain ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Email opnieuw versturen"
            , english = s "Send email again"
            , estonian = todo
            , finnish = todo
            , french = s "Réenvoyer le courriel"
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

        ServiceDisclaimer ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Internetdienst"
            , english = s "Online service"
            , estonian = todo
            , finnish = todo
            , french = s "Service en ligne"
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

        Share ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Delen"
            , english = s "Share"
            , estonian = todo
            , finnish = todo
            , french = s "Partager"
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
            , spanish = s "Compartir"
            , swedish = todo
            }

        ShowAll count ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s ("Toon alles (" ++ (toString count) ++ ")")
            , english = s ("Show all " ++ (toString count))
            , estonian = todo
            , finnish = todo
            , french = s ("Voir tous (" ++ (toString count) ++ ")")
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
            , spanish = s ("Ver todo (" ++ (toString count) ++ ")")
            , swedish = todo
            }

        ShowMore ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Meer..."
            , english = s "Show more"
            , estonian = todo
            , finnish = todo
            , french = s "Voir plus"
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
            , spanish = s "Mostrar más"
            , swedish = todo
            }

        ShowMoreCount count ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s ("Toon " ++ (toString count) ++ " meer")
            , english = s ("Show " ++ (toString count) ++ " more")
            , estonian = todo
            , finnish = todo
            , french = s ("Voir " ++ (toString count) ++ " plus")
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
            , spanish = s ("Mostrar " ++ (toString count) ++ " más")
            , swedish = todo
            }

        SignIn ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Aanmelden"
            , english = s "Sign In"
            , estonian = todo
            , finnish = todo
            , french = s "Identification"
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
            , spanish = s "Acceder"
            , swedish = todo
            }

        SignInToContribute ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Meld je aan om deel te nemen"
            , english = s "Sign in to contribute"
            , estonian = todo
            , finnish = todo
            , french = s "Identifiez-vous pour contribuer"
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

        SignOut ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Afmelden"
            , english = s "Sign Out"
            , estonian = todo
            , finnish = todo
            , french = s "Me déconnecter"
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
            , spanish = s "Salir"
            , swedish = todo
            }

        SignOutAndContributeLater ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Afmelden en een andere keer deelnemen"
            , english = s "Sign out and contribute later"
            , estonian = todo
            , finnish = todo
            , french = s "Déconnectez-vous et contribuez plus tard"
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

        SignUp ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Registreren"
            , english = s "Sign Up"
            , estonian = todo
            , finnish = todo
            , french = s "M'inscrire"
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
            , spanish = s "Registrarse"
            , swedish = todo
            }

        SimilarTools ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Overeenkomstige platformen"
            , english = s "Similar tools"
            , estonian = todo
            , finnish = todo
            , french = s "Outils similaires"
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

        Software ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Computer programma (software, applicatie)"
            , english = s "Computer program (software, application)"
            , estonian = todo
            , finnish = todo
            , french = s "Programme informatique (logiciel, application)"
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

        String ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Tekenreeks"
            , english = s "String"
            , estonian = todo
            , finnish = todo
            , french = s "Chaîne de caractères"
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
            , spanish = s "Cadena"
            , swedish = todo
            }

        Tags ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Termen"
            , english = s "Tags"
            , estonian = todo
            , finnish = todo
            , french = s "Étiquettes"
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
            , spanish = s "Etiquetas"
            , swedish = todo
            }

        TextField ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Tekst"
            , english = s "Text"
            , estonian = todo
            , finnish = todo
            , french = s "Texte"
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
            , spanish = s "Texto"
            , swedish = todo
            }

        TimeoutExplanation ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Er is een timeout opgetreden"
            , english = s "The server was too slow to respond (timeout)."
            , estonian = todo
            , finnish = todo
            , french = s "Le servert a mis trop de temps à repondre (timeout)"
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

        Tool number ->
            { bulgarian =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , croatian =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , czech =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , danish =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , dutch =
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
            , estonian =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , finnish =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , french =
                case number of
                    Singular ->
                        s "Outil"

                    Plural ->
                        s "Outils"
            , german =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , greek =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , hungarian =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , irish =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , italian =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , latvian =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , lithuanian =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , maltese =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , polish =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , portuguese =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , romanian =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , slovak =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , slovenian =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , spanish =
                case number of
                    Singular ->
                        s "Herramienta"

                    Plural ->
                        s "Herramientas"
            , swedish =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            }

        ToolId ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Platform"
            , english = s "Tool"
            , estonian = todo
            , finnish = todo
            , french = s "Outil"
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
            , spanish = s "Herramienta"
            , swedish = todo
            }

        ToolIdField ->
            getTranslationSet ToolId

        ToolPlaceholder ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Naam van het hulmiddel"
            , english = s "Name of a tool"
            , estonian = todo
            , finnish = todo
            , french = s "Nom d'un outil"
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

        ToolsDescription ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Lijst van hulpmiddelen"
            , english = s "List of tools"
            , estonian = todo
            , finnish = todo
            , french = s "Liste d'outils"
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

        TrueWord ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Waar"
            , english = s "True"
            , estonian = todo
            , finnish = todo
            , french = s "Vrai"
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
            , spanish = s "Cierto"
            , swedish = todo
            }

        TweetMessage name url ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s ("Ontdek " ++ name ++ " op OGPToolbox.org : " ++ url)
            , english = s ("Discover " ++ name ++ " on OGPToolbox.org: " ++ url)
            , estonian = todo
            , finnish = todo
            , french = s ("Découvrez " ++ name ++ " dans OGPToolbox.org : " ++ url)
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

        Type ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Type"
            , english = s "Type"
            , estonian = todo
            , finnish = todo
            , french = s "Type"
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
            , spanish = s "Tipo"
            , swedish = todo
            }

        UnknownLanguage ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Taal niet ondersteund"
            , english = s "Unsupported language"
            , estonian = todo
            , finnish = todo
            , french = s "Langue inconnue"
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

        UnknownSchemaId schemaId ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s ("Rerentie naar een onbekend schema: " ++ schemaId)
            , english = s ("Reference to an unknown schema: " ++ schemaId)
            , estonian = todo
            , finnish = todo
            , french = s ("Référence à un schema inconnu: " ++ schemaId)
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

        UnknownUser ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Gebruiker onbekend"
            , english = s "User is unknown."
            , estonian = todo
            , finnish = todo
            , french = s "L'utilisateur est inconnu."
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

        UnknownValue ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Onbekende waarde"
            , english = s "Unknown value"
            , estonian = todo
            , finnish = todo
            , french = s "Valeur inconnue"
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

        UntitledCard ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Kaart zonder titel"
            , english = s "Untitled Card"
            , estonian = todo
            , finnish = todo
            , french = s "Fiche sans titre"
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

        UploadImage ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Afbeelding uploaden"
            , english = s "Upload an image"
            , estonian = todo
            , finnish = todo
            , french = s "Ajouter une image"
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

        UploadingImage filename ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s ("Afbeelding \"" ++ filename ++ "\" wordt geupload...")
            , english = s ("Uploading image \"" ++ filename ++ "\"...")
            , estonian = todo
            , finnish = todo
            , french = s ("Ajout de l'image \"" ++ filename ++ "\"...")
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

        Url ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Link (URL)"
            , english = s "Link (URL)"
            , estonian = todo
            , finnish = todo
            , french = s "Lien (URL)"
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

        UrlPlaceholder ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "https://www.voorbeeldnl/voorbeeld-pagina"
            , english = s "https://www.example.com/sample-page"
            , estonian = todo
            , finnish = todo
            , french = s "https://www.exemple.fr/exemple-de-page"
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

        UseCase number ->
            { bulgarian =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , croatian =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , czech =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , danish =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , dutch =
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
            , estonian =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , finnish =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , french =
                case number of
                    Singular ->
                        s "Cas d'usage"

                    Plural ->
                        s "Cas d'usage"
            , german =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , greek =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , hungarian =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , irish =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , italian =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , latvian =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , lithuanian =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , maltese =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , polish =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , portuguese =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , romanian =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , slovak =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , slovenian =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            , spanish =
                case number of
                    Singular ->
                        s "Caso de uso"

                    Plural ->
                        s "Casos de uso"
            , swedish =
                case number of
                    Singular ->
                        todo

                    Plural ->
                        todo
            }

        UseCaseId ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Toepassing"
            , english = s "Use case"
            , estonian = todo
            , finnish = todo
            , french = s "Cas d'usage"
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

        UseCaseIdField ->
            getTranslationSet UseCaseId

        UseCasePlaceholder ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Naam van de toepassing"
            , english = s "Name of a use case"
            , estonian = todo
            , finnish = todo
            , french = s "Nom d'un cas d'usage"
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

        UseCases ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Toepassingen"
            , english = s "Use cases"
            , estonian = todo
            , finnish = todo
            , french = s "Cas d'usage"
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
            , spanish = s "Casos de uso"
            , swedish = todo
            }

        UseCasesDescription ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Lijst van toepassingen"
            , english = s "List of use cases"
            , estonian = todo
            , finnish = todo
            , french = s "Liste de cas d'usage"
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

        UsedBy ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Gebruikt door"
            , english = s "Used by"
            , estonian = todo
            , finnish = todo
            , french = s "Utilisé par"
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

        UsedFor ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Gebruikt voor"
            , english = s "Used for"
            , estonian = todo
            , finnish = todo
            , french = s "Utilisé pour"
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

        Username ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Gebruikersnaam"
            , english = s "Username"
            , estonian = todo
            , finnish = todo
            , french = s "Nom d'utilisateur"
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

        UsernameOrEmailAlreadyExist ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Gebruikersnaam of email is al in gebruik."
            , english = s "Username or email are already used."
            , estonian = todo
            , finnish = todo
            , french = s "Le nom d'utilisateur ou le mot de passe sont déjà utilisés."
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

        UsernamePlaceholder ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Jan Jansen"
            , english = s "John Doe"
            , estonian = todo
            , finnish = todo
            , french = s "Françoise Martin"
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

        UserProfileDescription ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Het profiel van de gebruiker en zijn collecties"
            , english = s "The profile of user and its favorite collections"
            , estonian = todo
            , finnish = todo
            , french = s "Le profil de l'utilisation et ses collections favorites"
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

        Uses ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Maakt gebruik van"
            , english = s "Uses"
            , estonian = todo
            , finnish = todo
            , french = s "Utilise"
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

        UseIt ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Gebruik"
            , english = s "Use it"
            , estonian = todo
            , finnish = todo
            , french = s "Utiliser"
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

        UseTool ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Gebruik deze software"
            , english = s "Use this tool"
            , estonian = todo
            , finnish = todo
            , french = s "Utiliser cet outil"
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
            , spanish = s "Utilice esta herramienta"
            , swedish = todo
            }

        Value ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Waarde"
            , english = s "Value"
            , estonian = todo
            , finnish = todo
            , french = s "Valeur"
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
            , spanish = s "Valor"
            , swedish = todo
            }

        ValueCreationFailed ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Maken van de waarde mislukt"
            , english = s "Value creation failed"
            , estonian = todo
            , finnish = todo
            , french = s "Échec de la création de la valeur"
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
            , spanish = s "Falló la creación de valor"
            , swedish = todo
            }

        ValueId ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Koppel aan een waarde"
            , english = s "Link to a value"
            , estonian = todo
            , finnish = todo
            , french = s "Lien vers une valeur"
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

        ValueIdArray ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "lijst met koppelingen naar waarden"
            , english = s "Array of links to values"
            , estonian = todo
            , finnish = todo
            , french = s "Tableau de liens vers des valeurs"
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

        ValuePlaceholder ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "De waarde..."
            , english = s "The value..."
            , estonian = todo
            , finnish = todo
            , french = s "La valeur"
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

        VoteBestContributions ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Stem op de beste bijdragen"
            , english = s "Vote for the best contributions"
            , estonian = todo
            , finnish = todo
            , french = s "Votez pour les meilleurs contributions"
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
            , spanish = s "Vote por las mejores contribuciones"
            , swedish = todo
            }

        Website ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Website"
            , english = s "Website"
            , estonian = todo
            , finnish = todo
            , french = s "Site web"
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
            , spanish = s "Sitio web"
            , swedish = todo
            }

        WebsiteDescription ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = s "Adres van de officiële website (URL)"
            , english = s "Address of the official website (URL)"
            , estonian = todo
            , finnish = todo
            , french = s "Adresse du site officiel (URL)"
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
