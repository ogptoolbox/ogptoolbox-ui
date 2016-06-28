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
  "title": "Tool category",
  "enum": [
    "",
    "Cartography and visualization",
    "Communication",
    "Concertation",
    "Consultation",
    "Crowdsourcing",
    "Gamification",
    "Legislative openness",
    "Mobilisation",
    "Open resources",
    "Participatory budget",
    "Public policy monitoring and evaluation",
    "Project management",
    "Transparency",
  ],
}


export const featuresSchema = {
  "type": "array",
  "title": "functionalities",
  "items": {
    "type": "string",
    "enum": [
      "Argument mapping",
      "Chat",
      "Comment",
      "Crowdfunding",
      "Encryption",
      "Geographic mapping",
      "Versioning",
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
  },
  "uniqueItems": true,
}

export const featuresUiSchema = {
  "ui:widget": "checkboxes",
}


export const usersTypesSchema = {
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
    ],
  },
  "uniqueItems": true,
}

export const usersTypesUiSchema = {
  "ui:widget": "checkboxes",
}
