module Cards.Helpers exposing (..)

import Dict exposing (Dict)
import I18n
import Types exposing (..)


isOpenSource : I18n.Language -> Dict String TypedValue -> Card -> Bool
isOpenSource language values card =
    let
        repo =
            (case I18n.getOneString language repoKeys card values of
                Just value ->
                    String.length value > 8

                Nothing ->
                    False
            )

        sourceCode =
            (case I18n.getOneString language sourceCodeKeys card values of
                Just value ->
                    String.length value > 8

                Nothing ->
                    False
            )

        openSource =
            (case I18n.getOneString language openSourceKeys card values of
                Just value ->
                    let
                        lowerValue =
                            String.toLower value
                    in
                        (lowerValue == "yes") || (lowerValue == "oui")

                Nothing ->
                    False
            )

        license =
            (case I18n.getOneString language licenseKeys card values of
                Just value ->
                    String.toLower value

                Nothing ->
                    ""
            )

        openLicense =
            ((String.length license > 1)
                && not (String.contains "proprieta" license)
                && not (String.contains "non-free" license)
            )
    in
        repo || sourceCode || openSource || openLicense
