// OGPToolbox-Editor -- Web editor for OGP toolbox
// By: Emmanuel Raviart <emmanuel.raviart@data.gouv.fr>
//
// Copyright (C) 2016 Etalab
// https://git.framasoft.org/etalab/ogptoolbox-editor
//
// OGPToolbox-Editor is free software; you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// OGPToolbox-Editor is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.


import {routerReducer} from "react-router-redux"
import {combineReducers} from "redux"
import {reducer as formReducer} from "redux-form"

import {languageReducer} from "./languages"
import {methodByIdReducer, methodIdsReducer} from "./methods"
import {projectByIdReducer, projectIdsReducer} from "./projects"
import {toolByIdReducer, toolIdsReducer} from "./tools"
import {authenticationReducer} from "./user"


// Updates the data for different actions.
export default combineReducers({
  authentication: authenticationReducer,
  // ballotById: ballotByIdReducer,
  form: formReducer,
  language: languageReducer,
  methodById: methodByIdReducer,
  methodIds: methodIdsReducer,
  projectById: projectByIdReducer,
  projectIds: projectIdsReducer,
  routing: routerReducer,
  toolById: toolByIdReducer,
  toolIds: toolIdsReducer,
})
