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


import {categorySchema, featuresSchema, featuresUiSchema} from "./fields"


export const schema = {
  "title": "Tool",
  "type": "object",
  "required": [
    "name",
  ],
  "properties": {
    "name": {
      "type": "string",
      "title": "Tool official, commercial or common name"
    },
    "description_en": {
      "type": "string",
      "title": "Description"
    },
    "category": categorySchema,
    // "otherCategories": {
    //   "type": "array",
    //   "title": "Other categories",
    //   "items": {
    //     "type": "string",
    //   },
    // },
    "features": featuresSchema,
    "url": {
      "type": "string",
      "title": "Tool website (user interface or download link)"
    },
    "urlDemo": {
      "type": "string",
      "title": "Tool demo website (free test link)"
    },
    "screenshots": {
      "type": "string",
      "title": "Screenshot(s) illustrating the main functionality(ies) of the tool"
    },
    "authorName": {
      "type": "string",
      "title": "Tool author official, commercial or common name"
    },
    "authorStatus": {
      "type": "array",
      "title": "Tool author legal status",
      "items": {
        "type": "string"
      }
    },
    "authorOrigin": {
      "type": "string",
      "title": "Tool author origin (country)",
    },
    "authorEmail": {
      "type": "string",
      "title": "Tool author e-mail adress"
    },
    "authorSize": {
      "type": "integer",
      "title": "Number of developers or estimated size of the tool's developers community"
    },
    "format": {
      "type": "array",
      "title": "Available format(s) of the tool",
      "items": {
        "type": "string",
        "enum": [
           "Web",
           "Mobile app",
           "Desktop"
        ]
      }
    },
    "languages": {
      "type": "array",
      "title": "Tool available language(s)",
      "items": {
        "type": "string",
        "enum": [
           "fr",
           "en",
           "es",
        ],
        "enumNames": [
           "French",
           "English",
           "Spanish",
        ],
      },
      "uniqueItems": true,
    },
    "programmingLanguage": {
      "type": "array",
      "title": "Tool source code main programming language",
      "items": {
        "type": "string"
      }
    },
    "technologies": {
      "type": "array",
      "title": "Tool computer technologies",
      "items": {
        "type": "string"
      }
    },
    "license": {
      "type": "string",
      "title": "Tool license"
    },
    "openSource": {
      "type": "boolean",
      "title": "Free license"
    },
    "sourceCode": {
      "type": "string",
      "title": "Source code website (repository)"
    },
    "responsive": {
      "type": "boolean",
      "title": "Responsive website"
    },
    "android": {
      "type": "boolean",
      "title": "Android application"
    },
    "iOS": {
      "type": "boolean",
      "title": "iOS application"
    },
    "windowsphone": {
      "type": "boolean",
      "title": "Windows Phone / Windows 10 Mobile application"
    },
    "bugtrackerURL": {
      "type": "string",
      "title": "Bugtracker website"
    },
    "stackexchangeTag": {
      "type": "string",
      "title": "Stack Exchange tag",
    },
    "githubStars": {
      "type": "number",
      "title": "Number of Git Hub stars"
    },
    "pricingModel": {
      "type": "array",
      "title": "Pricing model",
      "items": {
        "type": "string"
      }
    },
    "userSize": {
      "type": "integer",
      "title": "Estimated number of users"
    },
    "userInteraction": {
      "type": "boolean",
      "title": "User interaction (can the tool be used by several users at the same time?)",
    },
    "moderationModel": {
      "type": "array",
      "title": "Moderation model (level of control over users' actions : centralized, distributed...)",
      "items": {
        "type": "string"
      }
    },
    "moderationSystem": {
      "type": "array",
      "title": "Moderation system (moment when actions are controlled : a priori, a posteriori)",
      "items": {
        "type": "string"
      }
    },
    "hostingType": {
      "type": "array",
      "title": "Hosting type (cloud, self-hosted...)",
      "items": {
        "type": "string"
      }
    },
    "hostingSelf": {
      "type": "boolean",
      "title": "Possibility of self-hosting the tool"
    },
    "hostingLocation": {
      "type": "array",
      "title": "Tool hosting geographical location (if web service)",
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
      "title": "Access to personal data"
    },
    "API": {
      "type": "boolean",
      "title": "API"
    },
    "easeOfInstallation": {
      "type": "integer",
      "title": "Ease of installation (1 to 5 rating scale)",
      "minimum": 1,
      "maximum": 5,
    },
    "easeOfUse": {
      "type": "integer",
      "title": "Ease of use (1 to 5 rating scale)",
      "minimum": 1,
      "maximum": 5,
    },
    "helpURL": {
      "type": "string",
      "title": "Assistance website (guide, tutorial, video...)"
    },
    "support": {
      "type": "boolean",
      "title": "Technical support availability"
    },
    "accessibility": {
      "type": "boolean",
      "title": "Handicap accessibility"
    },
    "projects": {
      "type": "array",
      "title": "Project(s) having deployed the tool (use cases)",
      "items": {
        "type": "string"
      }
    },
    "methods": {
      "type": "array",
      "title": "Method(s) linked to the tool",
      "items": {
        "type": "string"
      }
    }
  }
}

export const uiSchema = {
  // description_en: {
  //   "ui:widget": "textarea",
  // },
  "features": featuresUiSchema,
  "languages": {
    "ui:widget": "checkboxes",
  },
}
