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
  "title": "Method",
  "type": "object",
  "required": [
    "name",
  ],
  "properties": {
    "name": {
      "type": "string",
      "title": "Method name"
    },
    "description": {
      "type": "string",
      "title": "Description"
    },
    "categories": {
      "type": "array",
      "title": "Method need(s) and usage(s)",
      "items": {
        "type": "string"
      }
    },
    "url": {
      "type": "string",
      "title": "Reference website(s)"
    },
    "screenshots": {
      "type": "string",
      "title": "Screenshot(s) illustrating the method"
    },
    "valueProposition": {
      "type": "string",
      "title": "Method value proposition",
    },
    "methodologicalStepByStep": {
      "type": "string",
      "title": "Methodological step by step",
    },
    "usageConditions": {
      "type": "string",
      "title": "Usage conditions",
    },
    "actorName": {
      "type": "string",
      "title": "Method reference actor",
    },
    "actorStatus": {
      "type": "array",
      "title": "Method reference actor legal status",
      "items": {
        "type": "string"
      }
    },
    "actorEmail": {
      "type": "string",
      "title": "Method reference actor e-mail adress"
    },
    "actorSize": {
      "type": "integer",
      "title": "Number of people contributing to the method"
    },
    "location": {
      "type": "string",
      "title": "Method origin (country)",
    },
    "usersTypes": {
      "type": "array",
      "title": "User type",
      "items": {
        "type": "string",
        "enum": [
           "Administrations",
           "Associations",
           "Citizens",
           "Representatives",
           "Non-governmental organizations (NGOs)",
        ]
      }
    },
    "usersCount": {
      "type": "string",
      "title": "Number of users",
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
      "title": "Method ease of use (1 to 5 rating scale)",
      "minimum": 1,
      "maximum": 5,
    },
    "satisfactionLevel": {
      "type": "integer",
      "title": "Satisfaction level (1 to 5 rating level)",
      "minimum": 1,
      "maximum": 5,
    },
    "tools": {
      "type": "array",
      "title": "Tool(s) used by the method",
      "items": {
        "type": "string"
      }
    },
    "projects": {
      "type": "array",
      "title": "Project(s) having used the method",
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
