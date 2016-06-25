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
    // "description",
    // "category",
    // "features",
    // "format",
    // "pricingModel",
    // "hostingType",
    // "scoreUse"
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
    "category": {
      "type": "array",
      "title": "Catégorie(s) du projet",
      "items": {
        "type": "string"
      }
    },
    "features": {
      "type": "array",
      "title": "Fonctionnalité(s) du projet",
      "items": {
        "type": "string"
      }
    },
    "url": {
      "type": "string",
      "title": "Site web du projet (à partir duquel on peut directement l'utiliser ou le télécharger)"
    },
    "urlDemo": {
      "type": "string",
      "title": "Site web de démo du projet (à partir duquel on peut le tester gratuitement)"
    },
    "screenshots": {
      "type": "string",
      "title": "Capture(s) d'écran illustrant les principales fonctionnalités du projet"
    },
    "authorName": {
      "type": "string",
      "title": "Nom officiel, commercial ou commun de l'auteur du projet"
    },
    "authorStatus": {
      "type": "array",
      "title": "Statut juridique de l'auteur du projet",
      "items": {
        "type": "string"
      }
    },
    "authorOrigin": {
      "type": "string",
      "title": "Pays où est domicilié l'auteur du projet",
      "enum": [
        "France",
        "USA",
        "UK"
      ]
    },
    "authorEmail": {
      "type": "string",
      "title": "Adresse e-mail de l'auteur du projet"
    },
    "authorSize": {
      "type": "integer",
      "title": "Nombre de développeurs ou taille estimée de la communauté de développeurs du projet"  
    },
    "format": {
      "type": "array",
      "title": "Forme sous laquelle est disponible le projet",
      "items": {
        "type": "string",
        "enum": [
           "Web",
           "Appli mobile",
           "Desktop"
        ]
      }
    },
    "language": {
      "type": "array",
      "title": "Langue dans laquelle est traduit le projet",
      "items": {
        "type": "string",
        "enum": [
           "Français",
           "Anglais",
           "Espagnol"
        ]
      }
    },
    "programmingLanguage": {
      "type": "array",
      "title": "Principal langage de programmation du code source du projet",
      "items": {
        "type": "string"
      }
    },
    "technology": {
      "type": "array",
      "title": "Technologies informatiques utilisées pour faire fonctionner le projet",
      "items": {
        "type": "string"
      }
    },
    "licence": {
      "type": "string",
      "title": "Licence sous laquelle est distribuée le projet"
    },
    "openSource": {
      "type": "boolean",
      "title": "Licence libre"
    },
    "sourceCode": {
      "type": "string",
      "title": "Site web où le code source du projet est directement accessible (repository)"
    },
    "responsive": {
      "type": "boolean",
      "title": "Site web adaptatif"
    },
    "android": {
      "type": "boolean",
      "title": "Application Android"
    },
    "iOS": {
      "type": "boolean",
      "title": "Application Android"
    },
    "windowsphone": {
      "type": "boolean",
      "title": "Application Windows Phone / Windows 10 Mobile"
    },
    "bugtrackerURL": {
      "type": "string",
      "title": "Site web pour rapporter les bugs du projet"
    },
    "stackexchangeTag": {
      "type": "array",
      "title": "Tag(s) utilisé(s) sur Stack Exchange",
      "items": {
        "type": "string"
      }
    },
    "githubStars": {
      "type": "number",
      "title": "Nombre d'étoiles sur Git Hub"
    },
    "pricingModel": {
      "type": "array",
      "title": "Modèle de tarification",
      "items": {
        "type": "string"
      }      
    },
    "userSize": {
      "type": "integer",
      "title": "Nombre estimé d'utilisateurs"
    },
    "userInteraction": {
      "type": "boolean",
      "title": "Interaction entre utilisateurs (possibilité d'utiliser le projet à plusieurs utilisateurs en même temps)"
    },
    "moderationModel": {
      "type": "array",
      "title": "Modèle de modération (niveau de contrôle que possède le porteur de projet sur les actions des utilisateurs : centralisé, communautaire...)",
      "items": {
        "type": "string"
      }
    },
    "moderationSystem": {
      "type": "array",
      "title": "Système de modération (moment où intervient le contrôle sur les actions : a priori, a posteriori)",
      "items": {
        "type": "string"
      }
    },
    "hostingType": {
      "type": "array",
      "title": "Type d'hébergement (cloud, auto-hébergé...)",
      "items": {
        "type": "string"
      }
    },
    "hostingSelf": {
      "type": "boolean",
      "title": "Possibilité d'héberger le projet sur son propre serveur"
    },
    "hostingLocation": {
      "type": "array",
      "title": "Localisation géographique des serveurs du projet (dans le cas d'un service web)",
      "items": {
        "type": "string"
      }
    },
    "opendata": {
      "type": "boolean",
      "title": "Open Data"
    },
    "dataPrivacy": {
      "type": "string",
      "title": "Accès aux données personnelles"
    },
    "API": {
      "type": "boolean",
      "title": "API proposée"
    },
    "scoreInstallation": {
      "type": "integer",
      "title": "Facilité d'installation (note sur 5)"  
    },
    "scoreUse": {
      "type": "integer",
      "title": "Facilité d'utilisation (note sur 5)"  
    },
    "helpURL": {
      "type": "string",
      "title": "Site web d'aide à la prise en main du projet (guide, tutorial, vidéo...)"
    },
    "support": {
      "type": "boolean",
      "title": "Support technique disponible"
    },
    "accessibility": {
      "type": "boolean",
      "title": "Accessibilité handicap"
    },
    "project": {
      "type": "array",
      "title": "Projet(s) ayant exployé le projet (cas d'usage)",
      "items": {
        "type": "string"
      }
    }
  }
}

export const uiSchema = {
  // description: {
  //   "ui:widget": "textarea",
  // },
}