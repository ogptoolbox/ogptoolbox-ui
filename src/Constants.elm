module Constants exposing (..)

-- KEYS


debateKeyIds : List String
debateKeyIds =
    [ "cons", "pros" ]


descriptionKeyIds : List String
descriptionKeyIds =
    [ "description" ]


imageLogoPathKeyIds : List String
imageLogoPathKeyIds =
    [ "logo" ]


imageScreenshotPathKeyIds : List String
imageScreenshotPathKeyIds =
    [ "screenshot" ]


imagePathKeyIds : List String
imagePathKeyIds =
    imageLogoPathKeyIds ++ imageScreenshotPathKeyIds


licenseKeyIds : List String
licenseKeyIds =
    [ "license" ]


nameKeyIds : List String
nameKeyIds =
    [ "name" ]


openSourceKeyIds : List String
openSourceKeyIds =
    [ "9647" ]


repoKeyIds : List String
repoKeyIds =
    [ "12795" ]


sourceCodeKeyIds : List String
sourceCodeKeyIds =
    [ "source-code" ]


urlKeyIds : List String
urlKeyIds =
    [ "website" ]


usedByKeyIds : List String
usedByKeyIds =
    [ "used-by" ]



-- CARD TYPES


cardTypesForOrganization : List String
cardTypesForOrganization =
    [ "organization" ]


cardTypesForSoftware : List String
cardTypesForSoftware =
    [ "software" ]


cardTypesForTool : List String
cardTypesForTool =
    [ "software", "platform" ]


cardTypesForUseCase : List String
cardTypesForUseCase =
    [ "use-case" ]
