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


export const schema = {
  "title": "Méthode",
  "type": "object",
  "required": [
    "name",
  ],
  "properties": {
    "name": {
      "type": "string",
      "title": "Nom de la méthode"
    },
    "description": {
      "type": "string",
      "title": "Description"
    },
    "categories": {
      "type": "array",
      "title": "Besoins et usages de la méthode",
      "items": {
        "type": "string"
      }
    },
    "url": {
      "type": "string",
      "title": "Page web de référence"
    },
    "screenshots": {
      "type": "string",
      "title": "Capture(s) d'écran illustrant la méthode"
    },
    "valueProposition": {
      "type": "string",
      "title": "Proposition de valeur de la méthode",
    },
    "methodologicalStepByStep": {
      "type": "string",
      "title": "Pas à pas méthodologique",
    },
    "usageConditions": {
      "type": "string",
      "title": "Conditions d'utilisation",
    },
    "actorName": {
      "type": "string",
      "title": "Nom de l'acteur de référence de la méthode",
    },
    "actorStatus": {
      "type": "array",
      "title": "Statut juridique de l'acteur de référence de la méthode",
      "items": {
        "type": "string"
      }
    },
    "actorEmail": {
      "type": "string",
      "title": "Adresse e-mail de l'acteur de référence de la méthode"
    },
    "actorSize": {
      "type": "integer",
      "title": "Nombre de personnes ayant contribué à la méthode"
    },
    "location": {
      "type": "string",
      "title": "Lieu d'origine de la méthode'",
    },
    "usersTypes": {
      "type": "array",
      "title": "Types d'utilisateurs ",
      "items": {
        "type": "string",
        "enum": [
           "Administrations",
           "Associations",
           "Citoyens",
           "Élus",
           "Organisations non gouvernementales (ONG)",
        ]
      }
    },
    "usersCount": {
      "type": "string",
      "title": "Nombre d'utilisateurs ",
      "enum": [
        "",
        "1 - 10",
        "11 - 100",
        "101 - 1 000",
        "> 1 000",
      ],
    },
    "easeOfUse": {
      "type": "integer",
      "title": "Facilité de prise en main de la méthode (note sur 5)",
      "minimum": 1,
      "maximum": 5,
    },
    "satisfactionLevel": {
      "type": "integer",
      "title": "Niveau de satisfaction (note sur 5)",
      "minimum": 1,
      "maximum": 5,
    },
    "tools": {
      "type": "array",
      "title": "Outils utilisés par la méthode",
      "items": {
        "type": "string"
      }
    },
    "projects": {
      "type": "array",
      "title": "Projets ayant eu recours à la méthode",
      "items": {
        "type": "string"
      }
    }
  },
}

export const uiSchema = {
  // description: {
  //   "ui:widget": "textarea",
  // },
}