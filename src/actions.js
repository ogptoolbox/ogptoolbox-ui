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


const FAILURE = "FAILURE"
const REQUEST = "REQUEST"
const SUCCESS = "SUCCESS"


function createRequestTypes(base) {
  const res = {};
  [REQUEST, SUCCESS, FAILURE].forEach(type => res[type] = `${base}_${type}`)
  return res
}


export const CREATE_TOOL = "CREATE_TOOL"
export const CREATING_TOOL = createRequestTypes("CREATING_TOOL")
export const DELETE_TOOL = "DELETE_TOOL"
export const DELETING_TOOL = createRequestTypes("DELETING_TOOL")
export const LOAD_AUTHENTICATION_COOKIE = "LOAD_AUTHENTICATION_COOKIE"
export const LOAD_TOOL = "LOAD_TOOL"
export const LOAD_TOOLS = "LOAD_TOOLS"
export const LOADING_AUTHENTICATION_COOKIE = createRequestTypes("LOADING_AUTHENTICATION_COOKIE")
export const LOADING_TOOL = createRequestTypes("LOADING_TOOL")
export const LOADING_TOOLS = createRequestTypes("LOADING_TOOLS")
export const SIGN_IN = "SIGN_IN"
export const SIGN_OUT = "SIGN_OUT"
export const SIGN_UP = "SIGN_UP"
export const SIGNING_IN = createRequestTypes("SIGNING_IN")
export const SIGNING_OUT = createRequestTypes("SIGNING_OUT")
export const SIGNING_UP = createRequestTypes("SIGNING_UP")
export const UPDATE_TOOL = "UPDATE_TOOL"
export const UPDATING_TOOL = createRequestTypes("UPDATING_TOOL")


function action(type, payload = {}) {
  return {type, ...payload}
}


export const creatingTool = {
  failure: (authentication, values, error) => action(CREATING_TOOL.FAILURE, {authentication, values, error}),
  request: (authentication, values) => action(CREATING_TOOL.REQUEST, {authentication, values}),
  success: tool => action(CREATING_TOOL.SUCCESS, {tool}),
}

export const deletingTool = {
  failure: (authentication, id, error) => action(DELETING_TOOL.FAILURE, {authentication, id, error}),
  request: (authentication, id) => action(DELETING_TOOL.REQUEST, {authentication, id}),
  success: tool => action(DELETING_TOOL.SUCCESS, {tool}),
}

export const loadingAuthenticationCookie = {
  failure: () => action(LOADING_AUTHENTICATION_COOKIE.FAILURE),
  success: (authentication) => action(LOADING_AUTHENTICATION_COOKIE.SUCCESS, {authentication}),
}

export const loadingTool = {
  failure: (authentication, id, error) => action(LOADING_TOOL.FAILURE, {authentication, id, error}),
  request: (authentication, id) => action(LOADING_TOOL.REQUEST, {authentication, id}),
  success: tool => action(LOADING_TOOL.SUCCESS, {tool}),
}

export const loadingTools = {
  failure: (authentication, error) => action(LOADING_TOOLS.FAILURE, {authentication, error}),
  request: (authentication) => action(LOADING_TOOLS.REQUEST, {authentication}),
  success: tools => action(LOADING_TOOLS.SUCCESS, {tools}),
}

export const signingIn = {
  failure: (values, error) => action(SIGNING_IN.FAILURE, {values, error}),
  request: (values) => action(SIGNING_IN.REQUEST, {values}),
  success: (authentication) => action(SIGNING_IN.SUCCESS, {authentication}),
}

export const signingOut = {
  failure: error => action(SIGNING_OUT.FAILURE, {error}),
  request: () => action(SIGNING_OUT.REQUEST),
  success: () => action(SIGNING_OUT.SUCCESS),
}

export const signingUp = {
  failure: (values, error) => action(SIGNING_UP.FAILURE, {values, error}),
  request: (values) => action(SIGNING_UP.REQUEST, {values}),
  success: (authentication) => action(SIGNING_UP.SUCCESS, {authentication}),
}

export const updatingTool = {
  failure: (authentication, id, values, error) => action(UPDATING_TOOL.FAILURE, {authentication, id, values, error}),
  request: (authentication, id, values) => action(UPDATING_TOOL.REQUEST, {authentication, id, values}),
  success: tool => action(UPDATING_TOOL.SUCCESS, {tool}),
}


export const createTool = (authentication, values) => action(CREATE_TOOL, {authentication, values})
export const deleteTool = (authentication, id) => action(DELETE_TOOL, {authentication, id})
export const loadAuthenticationCookie = () => action(LOAD_AUTHENTICATION_COOKIE)
export const loadTool = (authentication, id) => action(LOAD_TOOL, {authentication, id})
export const loadTools = (authentication) => action(LOAD_TOOLS, {authentication})
export const signIn = (values, resolve, reject) => action(SIGN_IN, {values, resolve, reject})
export const signOut = (resolve, reject) => action(SIGN_OUT, {resolve, reject})
export const signUp = (values, resolve, reject) => action(SIGN_UP, {values, resolve, reject})
export const updateTool = (authentication, id, values) => action(UPDATE_TOOL, {authentication, id, values})
