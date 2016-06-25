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
  "title": "Projet",
  "type": "object",
  "required": [
    "name",
  ],
  "properties": {
    "name": {
      "type": "string",
      "title": "Nom officiel, commercial ou commun du projet"
    },
    "description": {
      "type": "string",
      "title": "Description"
    },
    "url": {
      "type": "string",
      "title": "Site web du projet (à partir duquel on peut directement l'utiliser ou le télécharger)"
    },
    "screenshots": {
      "type": "string",
      "title": "Capture(s) d'écran illustrant les principales fonctionnalités du projet"
    },
    "actorName": {
      "type": "string",
      "title": "Nom officiel, commercial ou commun de l'acteur du projet"
    },
    "actorStatus": {
      "type": "array",
      "title": "Statut juridique de l'acteur du projet",
      "items": {
        "type": "string"
      }
    },
    "actorEmail": {
      "type": "string",
      "title": "Adresse e-mail de l'acteur du projet"
    },
    "location": {
      "type": "string",
      "title": "Lieu du projet (pays, région, etc)",
    },
    "scale": {
      "type": "array",
      "title": "Échelle du projet ",
      "items": {
        "type": "string",
        "enum": [
           "Locale",
           "Nationale",
           "Internationale",
        ]
      }
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
        "1 001 - 10 000",
        "10 001 - 100 000",
        "100 001 - 1 000 000",
        "> 1 000 000",
      ],
    },
    "categories": {
      "type": "array",
      "title": "Besoins et usages du projet",
      "items": {
        "type": "string"
      }
    },
    "features": {
      "type": "array",
      "title": "Fonctionnalité(s) utilisées par le projet",
      "items": {
        "type": "string"
      }
    },
    "customDevelopment": {
      "type": "boolean",
      "title": "Développement spécifique"
    },
    "easeOfUse": {
      "type": "integer",
      "title": "Facilité de prise en main du projet (note sur 5)",
      "minimum": 1,
      "maximum": 5,
    },
    "satisfactionLevel": {
      "type": "integer",
      "title": "Niveau de satisfaction (note sur 5)",
      "minimum": 1,
      "maximum": 5,
    },
  },
}

export const uiSchema = {
  // description: {
  //   "ui:widget": "textarea",
  // },
}