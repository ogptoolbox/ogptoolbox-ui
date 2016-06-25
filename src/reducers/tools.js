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


import * as actions from "../actions"


export function toolByIdReducer(state = {}, action) {
  switch (action.type) {
  case actions.CREATING_TOOL.SUCCESS:
  case actions.DELETING_TOOL.SUCCESS:
  case actions.LOADING_TOOL.SUCCESS:
  case actions.UPDATING_TOOL.SUCCESS:
    const {tool} = action
    if (tool) {
      state = {...state}
      if (tool.deleted) delete state[tool.id]
      else state[tool.id] = tool
    }
    return state
  case actions.LOADING_TOOLS.SUCCESS:
    const {tools} = action
    if (tools) {
      state = {...state}
      for (let tool of tools) {
        if (tool.deleted) delete state[tool.id]
        else state[tool.id] = tool
      }
    }
    return state
  default:
    return state
  }
}


export function toolIdsReducer(state = null, action) {
  switch (action.type) {
  case actions.CREATING_TOOL.SUCCESS:
  case actions.DELETING_TOOL.SUCCESS:
  case actions.LOADING_TOOL.SUCCESS:
  case actions.UPDATING_TOOL.SUCCESS:
    const {tool} = action
    // Optimistic optimizations
    if (tool.deleted) {
      if (state !== null) state = state.filter(id => id !== tool.id)
    } else if (state !== null && !state.includes(tool.id)) {
      state = [tool.id, ...state]
    }
    return state
  case actions.LOADING_TOOLS.SUCCESS:
    const {tools} = action
    return [...tools.map(tool => tool.id)]
  default:
    return state
  }
}
