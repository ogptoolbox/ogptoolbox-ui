module I18nHtml exposing (..)

import Html exposing (a, div, Html, li, p, span, text, ul)
import Html.Attributes exposing (class, href, target)
import I18n exposing (Language(..), oneOfMaybes, s, todo)


type TranslationId
    = CopyrightLine
    | TheProjectPresentationParagraphs


type alias TranslationSet msg =
    { bulgarian : Maybe (Html msg)
    , croatian : Maybe (Html msg)
    , czech : Maybe (Html msg)
    , danish : Maybe (Html msg)
    , dutch : Maybe (Html msg)
    , english : Maybe (Html msg)
    , estonian : Maybe (Html msg)
    , finnish : Maybe (Html msg)
    , french : Maybe (Html msg)
    , german : Maybe (Html msg)
    , greek : Maybe (Html msg)
    , hungarian : Maybe (Html msg)
    , irish : Maybe (Html msg)
    , italian : Maybe (Html msg)
    , latvian : Maybe (Html msg)
    , lithuanian : Maybe (Html msg)
    , maltese : Maybe (Html msg)
    , polish : Maybe (Html msg)
    , portuguese : Maybe (Html msg)
    , romanian : Maybe (Html msg)
    , slovak : Maybe (Html msg)
    , slovenian : Maybe (Html msg)
    , spanish : Maybe (Html msg)
    , swedish : Maybe (Html msg)
    }


getTranslationSet : TranslationId -> TranslationSet msg
getTranslationSet translationId =
    case translationId of
        CopyrightLine ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch =
                s <|
                    span []
                        [ text "© 2016 "
                        , a [ href "http://www.etalab.gouv.fr/", target "_blank" ] [ text "Etalab" ]
                        , text " — © 2017 "
                        , a
                            [ href "https://framagit.org/ogptoolbox/ogptoolbox-ui/blob/master/CONTRIBUTORS.md"
                            , target "_blank"
                            ]
                            [ text "OGP Toolbox contributors" ]
                        , text " — Ontworpen door "
                        , a [ href "http://www.nodesign.net/", target "_blank" ] [ text "Nodesign.net" ]
                        ]
            , english =
                s <|
                    p []
                        [ text "© 2016 "
                        , a [ href "http://www.etalab.gouv.fr/", target "_blank" ] [ text "Etalab" ]
                        , text " — © 2017 "
                        , a
                            [ href "https://framagit.org/ogptoolbox/ogptoolbox-ui/blob/master/CONTRIBUTORS.md"
                            , target "_blank"
                            ]
                            [ text "OGP Toolbox contributors" ]
                        , text " — Design by "
                        , a [ href "http://www.nodesign.net/", target "_blank" ] [ text "Nodesign.net" ]
                        ]
            , estonian = todo
            , finnish = todo
            , french =
                s <|
                    p []
                        [ text "© 2016 "
                        , a [ href "http://www.etalab.gouv.fr/", target "_blank" ] [ text "Etalab" ]
                        , text " — © 2017 "
                        , a
                            [ href "https://framagit.org/ogptoolbox/ogptoolbox-ui/blob/master/CONTRIBUTORS.md"
                            , target "_blank"
                            ]
                            [ text "Contributeurs OGP Toolbox" ]
                        , text " — Design par "
                        , a [ href "http://www.nodesign.net/", target "_blank" ] [ text "Nodesign.net" ]
                        ]
            , german = todo
            , greek = todo
            , hungarian = todo
            , irish = todo
            , italian = todo
            , latvian = todo
            , lithuanian = todo
            , maltese = todo
            , polish = todo
            , portuguese = todo
            , romanian = todo
            , slovak = todo
            , slovenian = todo
            , spanish = todo
            , swedish = todo
            }

        TheProjectPresentationParagraphs ->
            { bulgarian = todo
            , croatian = todo
            , czech = todo
            , danish = todo
            , dutch = todo
            , english =
                s <|
                    div [ class "col-md-12" ]
                        [ p [ class "lead" ]
                            [ text "The OGP Toolbox is a free software initially developed by "
                            , a [ href "http://www.etalab.gouv.fr/", target "_blank" ] [ text "Etalab" ]
                            , text ", the Prime Minister taskforce in charge of open data and open government French policy, on behalf of the "
                            , a [ href "http://www.opengovpartnership.org/", target "_blank" ] [ text "Open Government Partnership" ]
                            , text " community. Co-created by the open government and the civic tech international community throughout 2016, the OGP Toolbox is one of the main deliverables of the "
                            , a [ href "https://ogpsummit.org/", target "_blank" ] [ text "OGP Global Summit" ]
                            , text " "
                            , a [ href "http://www.opengovpartnership.org/blog/paula-forteza/2017/01/11/ogp-toolbox-global-hackathon-beyond", target "_blank" ] [ text "hackathon" ]
                            , text " (7, 8 and 9 December 2016)."
                            ]
                        , p [ class "lead" ]
                            [ text "In order to guarantee sustainability, independence and the capacity to associate various actors at the international level in the long term, the governance of the project has, since, evolved. In February 2017, the "
                            , a [ href "https://forum.ogptoolbox.org/t/association-launch-meeting-minutes/42", target "_blank" ] [ text "OGPToolbox.org" ]
                            , text " association was created to fulfill the mission associated to the platform."
                            ]
                        , p [ class "lead" ]
                            [ text "The object of the association is to empower public, private and civil society actors worldwide by sharing digital tools and resources, in order to promote democracy, transparency, participation and collaboration." ]
                        , p [ class "lead" ]
                            [ text "The goals of the association, using the OGPToolbox.org platform and every means at its disposal, are to:" ]
                        , ul []
                            [ li [ class "lead" ] [ text "allow actors to identify the digital tools better suited to their needs, by collecting and describing them in the most objective way possible;" ]
                            , li [ class "lead" ] [ text "collaborate to make digital tools more accessible and easier to use;" ]
                            , li [ class "lead" ] [ text "create favourable conditions to further the development of better digital tools;" ]
                            , li [ class "lead" ] [ text "foster the sharing of experience between actors and giving feedback on existing tools." ]
                            ]
                        , p [ class "lead" ]
                            [ text "To participate to the activities of the OGPToolbox.org association, follow the latest news on the "
                            , a [ href "https://forum.ogptoolbox.org/", target "_blank" ] [ text "forum" ]
                            , text "."
                            ]
                        ]
            , estonian = todo
            , finnish = todo
            , french =
                s <|
                    div [ class "col-md-12" ]
                        [ p [ class "lead" ]
                            [ text "L'OGP Toolbox est un logiciel libre initialement développé par "
                            , a [ href "http://www.etalab.gouv.fr/", target "_blank" ] [ text "Etalab" ]
                            , text ", service du Premier Ministre en charge de l'ouverture des données publiques et du gouvernement ouvert de la France, pour le compte de la communauté du "
                            , a [ href "http://www.opengovpartnership.org/", target "_blank" ] [ text "Partenariat du Gouvernement Ouvert (OGP)" ]
                            , text ". Co-créée avec les communautés internationales du gouvernement ouvert et de la civic tech tout au long de l'année 2016, l'OGP Toolbox est un des principaux livrables du "
                            , a [ href "http://www.opengovpartnership.org/blog/paula-forteza/2017/01/11/ogp-toolbox-global-hackathon-beyond", target "_blank" ] [ text "hackathon" ]
                            , text " du "
                            , a [ href "https://ogpsummit.org/", target "_blank" ] [ text "Sommet mondial de l'OGP" ]
                            , text " (7, 8 et 9 décembre 2016)."
                            ]
                        , p [ class "lead" ]
                            [ text "En vues de garantir la pérennité, l'indépendance et la faculté d'associer des acteurs divers à l'international et sur le long terme, le modèle de gouvernance du projet a, depuis, évolué. En février 2017, l'association "
                            , a [ href "https://forum.ogptoolbox.org/t/association-launch-meeting-minutes/42", target "_blank" ] [ text "OGPToolbox.org" ]
                            , text " a été créée pour assurer le bon développement de la mission associée à la plateforme."
                            ]
                        , p [ class "lead" ]
                            [ text "L'objet de l'association est de renforcer le pouvoir d'agir des acteurs publics, privés et de la société civile du monde entier à travers le partage d’outils et de ressources numériques pour promouvoir la démocratie, la transparence, la participation et la collaboration dans l'action publique." ]
                        , p [ class "lead" ]
                            [ text "L’association, en s’appuyant sur la plateforme OGPToolbox.org et l’ensemble des ressources à sa disposition, se donne comme objectifs de :" ]
                        , ul []
                            [ li [ class "lead" ] [ text "permettre aux acteurs d’identifier les outils numériques les mieux adaptés à leurs initiatives en les recensant et les décrivant de la façon la plus objective possible ;" ]
                            , li [ class "lead" ] [ text "collaborer pour rendre les outils numériques plus accessibles et simples à utiliser ;" ]
                            , li [ class "lead" ] [ text "créer les conditions favorables à une émulation positive permettant d’améliorer la qualité des outils numériques ;" ]
                            , li [ class "lead" ] [ text "favoriser le partage d’expériences entre acteurs ayant déjà utilisé les outils numériques disponibles." ]
                            ]
                        , p [ class "lead" ]
                            [ text "Pour participer aux activités de l'association OGPToolbox.org, suivez les actualités sur le "
                            , a [ href "https://forum.ogptoolbox.org/", target "_blank" ] [ text "forum" ]
                            , text "."
                            ]
                        ]
            , german = todo
            , greek = todo
            , hungarian = todo
            , irish = todo
            , italian = todo
            , latvian = todo
            , lithuanian = todo
            , maltese = todo
            , polish = todo
            , portuguese = todo
            , romanian = todo
            , slovak = todo
            , slovenian = todo
            , spanish = todo
            , swedish = todo
            }


translate : Language -> TranslationId -> Html msg
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
            ]
            |> Maybe.withDefault
                (text
                    ("TODO translate the ID "
                        ++ (toString translationId)
                        ++ " in "
                        ++ (toString language)
                    )
                )
