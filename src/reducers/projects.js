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


export function projectByIdReducer(state = {}, action) {
  switch (action.type) {
  case actions.CREATING_PROJECT.SUCCESS:
  case actions.DELETING_PROJECT.SUCCESS:
  case actions.LOADING_PROJECT.SUCCESS:
  case actions.UPDATING_PROJECT.SUCCESS:
    const {project} = action
    if (project) {
      state = {...state}
      if (project.deleted) delete state[project.id]
      else state[project.id] = project
    }
    return state
  case actions.LOADING_PROJECTS.SUCCESS:
    const {projects} = action
    if (projects) {
      state = {...state}
      for (let project of projects) {
        if (project.deleted) delete state[project.id]
        else state[project.id] = project
      }
    }
    return state
  default:
    return state
  }
}


export function projectIdsReducer(state = null, action) {
  switch (action.type) {
  case actions.CREATING_PROJECT.SUCCESS:
  case actions.DELETING_PROJECT.SUCCESS:
  case actions.LOADING_PROJECT.SUCCESS:
  case actions.UPDATING_PROJECT.SUCCESS:
    const {project} = action
    if (project.deleted) {
      // Optimistic optimization
      if (state !== null) state = state.filter(id => id !== project.id)
    } else {
      // Optimistic optimization
      if (state === null) state = [project.id]
      else if (!state.includes(project.id)) state = [project.id, ...state]
    }
    return state
  case actions.LOADING_PROJECTS.SUCCESS:
    const {projects} = action
    return [...projects.map(project => project.id)]
  default:
    return state
  }
}
