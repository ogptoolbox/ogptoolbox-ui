// OGPToolbox-Editor -- Web editor for OGP toolbox
// By: Emmanuel Raviart <emmanuel.raviart@data.gouv.fr>
//
// Copyright (C) 2016 Etalab
// https://git.framasoft.org/etalab/ogptoolbox-editor
//
// OGPToolbox-Editor is free software you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// OGPToolbox-Editor is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.


export const categorySchema = {
  "type": "string",
  "title": "Catégorie",
  "enum": [
    "",
    "Participatory budget",
    "Cartography and visualization",
    "Legislative openness",
    "Communication",
    "Concertation",
    "Consultation",
    "Crowdsourcing",
    "Gamification",
    "Project management",
    "Mobilisation",
    "Open resources",
    "Public policy monitoring and evaluation",
    "Transparency",
  ],
  "enumNames": [
    "",
    "Budget participatif",
    "Cartographie et visualisation",
    "Co-écriture de la loi",
    "Communication",
    "Concertation",
    "Consultation",
    "Crowdsourcing",
    "Gamification",
    "Gestion de projet", 
    "Mobilisation",
    "Partage de ressources", 
    "Suivi et évaluation des politiques publiques",
    "Transparence",
  ],
}


export const featuresSchema = {
  "type": "array",
  "title": "Fonctionnalités",
  "items": {
    "type": "string",
    "enum": [
      "Argument mapping",
      "Geographic mapping",
      "Chat",
      "Encryption",
      "Comment",
      "Versioning",
      "Crowdfunding",
      "Massive diffusion",
      "Text co-editing",
      "Discussion thread",
      "Citizen relationship management (CRM)",
      "Document and data sharing",
      "Petition",
      "Poll",
      "Workflow management", 
      "Video conference", 
      "Vote",
    ],
    "enumNames": [
      "Cartographie d'arguments",
      "Cartographie géographique",
      "Chat",
      "Chiffrement",
      "Commentaire",
      "Comparaison de versions", 
      "Crowdfunding",
      "Diffusion massive",
      "Écriture collaborative de texte",
      "Flux de discussion",
      "Gestion de la relation citoyen (GRC)",
      "Partage de documents et données",
      "Petition",
      "Sondage",
      "Suivi de tâches", 
      "Visio-conférence",
      "Vote",
    ],
  },
  "uniqueItems": true,
}

export const featuresUiSchema = {
  "ui:widget": "checkboxes",
}