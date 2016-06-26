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


export function methodByIdReducer(state = {}, action) {
  switch (action.type) {
  case actions.CREATING_METHOD.SUCCESS:
  case actions.DELETING_METHOD.SUCCESS:
  case actions.LOADING_METHOD.SUCCESS:
  case actions.UPDATING_METHOD.SUCCESS:
    const {method} = action
    if (method) {
      state = {...state}
      if (method.deleted) delete state[method.id]
      else state[method.id] = method
    }
    return state
  case actions.LOADING_METHODS.SUCCESS:
    const {methods} = action
    if (methods) {
      state = {...state}
      for (let method of methods) {
        if (method.deleted) delete state[method.id]
        else state[method.id] = method
      }
    }
    return state
  default:
    return state
  }
}


export function methodIdsReducer(state = null, action) {
  switch (action.type) {
  case actions.CREATING_METHOD.SUCCESS:
  case actions.DELETING_METHOD.SUCCESS:
  case actions.LOADING_METHOD.SUCCESS:
  case actions.UPDATING_METHOD.SUCCESS:
    const {method} = action
    // Optimistic optimizations
    if (method.deleted) {
      if (state !== null) state = state.filter(id => id !== method.id)
    } else if (state !== null && !state.includes(method.id)) {
      state = [method.id, ...state]
    }
    return state
  case actions.LOADING_METHODS.SUCCESS:
    const {methods} = action
    return [...methods.map(method => method.id)]
  default:
    return state
  }
}
