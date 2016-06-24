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


export function authenticationReducer(state = null, action) {
  switch (action.type) {
  case actions.LOADING_AUTHENTICATION_COOKIE.FAILURE:
    return {}  // null is used only when cookie has not been tried to be loaded yet.
  case actions.LOADING_AUTHENTICATION_COOKIE.SUCCESS:
    return {...action.authentication}
  case actions.SIGNING_IN.SUCCESS:
  case actions.SIGNING_UP.SUCCESS:
    return {...action.authentication}
  case actions.SIGNING_OUT.SUCCESS:
    return {}  // null is used only when cookie has not been tried to be loaded yet.
  default:
    return state
  }
}
