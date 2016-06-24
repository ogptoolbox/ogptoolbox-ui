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


import cookie from "react-cookie"
import {browserHistory} from "react-router"
import {END} from "redux-saga"
import {call, fork, put, select, take} from "redux-saga/effects"

import * as actions from "./actions"
import {fetchApiJson, fetchUiJson} from "./fetchers"


function* createTool(authentication, values) {
  yield put(actions.creatingTool.request(authentication, values))
  try {
    const tool = yield call(
      fetchApiJson,
      "tools",
      {
        body: JSON.stringify(values),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "OGPToolbox-API-Key": authentication.apiKey,
        },
        method: "post",
      },
    )
    yield put(actions.creatingTool.success(tool))
    browserHistory.push(`/tools/${tool.id}`)
  } catch (error) {
    yield put(actions.creatingTool.failure(authentication, values, error))
  }
}


function* deleteTool(authentication, id) {
  yield put(actions.deletingTool.request(authentication, id))
  try {
    const tool = yield call(
      fetchApiJson,
      `tools/${id}`,
      {
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "OGPToolbox-API-Key": authentication.apiKey,
        },
        method: "delete",
      },
    )
    yield put(actions.deletingTool.success(tool))
    browserHistory.push("/tools")
  } catch (error) {
    yield put(actions.deletingTool.failure(authentication, id, error))
  }
}


export function* fetchTool(authentication, id) {
  yield put(actions.loadingTool.request(authentication, id))
  const authenticationHeaders = authentication && authentication.apiKey ?
    {"OGPToolbox-API-Key": authentication.apiKey} :
    {}
  try {
    const tool = yield call(
      fetchApiJson,
      `tools/${id}`,
      {
        headers: {
          "Accept": "application/json",
          ...authenticationHeaders,
        },
      },
    )
    yield put(actions.loadingTool.success(tool))
  } catch (error) {
    yield put(actions.loadingTool.failure(authentication, id, error))
  }
}


export function* fetchTools(authentication) {
  yield put(actions.loadingTools.request(authentication))
  const authenticationHeaders = authentication && authentication.apiKey ?
    {"OGPToolbox-API-Key": authentication.apiKey} :
    {}
  try {
    const tools = yield call(
      fetchApiJson,
      "tools",
      {
        headers: {
          "Accept": "application/json",
          ...authenticationHeaders,
        },
      },
    )
    yield put(actions.loadingTools.success(tools))
  } catch (error) {
    yield put(actions.loadingTools.failure(authentication, error))
  }
}


function getTool(state, id) {
  // return state.toolById && state.toolById[id]
  return state.toolById[id]
}


function getToolIds(state) {
  return state.toolIds
}


function* loadAuthenticationCookie() {
  const authentication = cookie.load("ogptoolbox-editor.authentication")
  if (!authentication) yield put(actions.loadingAuthenticationCookie.failure())
  else yield put(actions.loadingAuthenticationCookie.success(authentication))
}

function* loadTool(authentication, id) {
  const tool = yield select(getTool, id)
  if (!tool) yield call(fetchTool, authentication, id)
}


function* loadTools(authentication) {
  const toolIds = yield select(getToolIds)
  if (toolIds === null) yield call(fetchTools, authentication)
}


function* signIn(values, resolve, reject) {
  yield put(actions.signingIn.request(values))
  try {
    const authentication = yield call(fetchUiJson, "api/sign_in", {
      body: JSON.stringify(values),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      method: "post",
    })
    yield put(actions.signingIn.success(authentication))
    cookie.save("ogptoolbox-editor.authentication", JSON.stringify(authentication))
    resolve()
    browserHistory.push("/")  // TODO
  } catch (error) {
    yield put(actions.signingIn.failure(values, error))
    if (error.code && error.code >= 400 && error.code < 500) {
      reject({username: error.message || "Authentication failed."})
    } else {
      reject({username: "Authentication failed."})
    }
  }
}


function* signOut(resolve, reject) {
  yield put(actions.signingOut.request())
  try {
    yield call(fetchUiJson, "api/sign_out", {
      body: JSON.stringify({}),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      method: "post",
    })
    yield put(actions.signingOut.success())
    cookie.remove("ogptoolbox-editor.authentication")
    resolve()
    browserHistory.push("/")  // TODO
  } catch (error) {
    yield put(actions.signingOut.failure(error))
    reject({})
  }
}


function* signUp(values, resolve, reject) {
  yield put(actions.signingUp.request(values))
  try {
    const authentication = yield call(fetchUiJson, "api/sign_up", {
      body: JSON.stringify(values),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      method: "post",
    })
    yield put(actions.signingUp.success(authentication))
    cookie.save("ogptoolbox-editor.authentication", JSON.stringify(authentication))
    resolve()
    browserHistory.push("/")  // TODO
  } catch (error) {
    yield put(actions.signingUp.failure(values, error))
    if (error.code && error.code >= 400 && error.code < 500) {
      reject({username: error.message || "Sign up failed."})
    } else {
      reject({username: "Sign up failed."})
    }
  }
}


function* updateTool(authentication, id, values) {
  values = {...values}
  for (let key in values) {
    if (values[key] === null || values[key] === undefined) delete values[key]
  }
  yield put(actions.updatingTool.request(authentication, id, values))
  try {
    const tool = yield call(
      fetchApiJson,
      `tools/${id}`,
      {
        body: JSON.stringify(values),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "OGPToolbox-API-Key": authentication.apiKey,
        },
        method: "put",
      },
    )
    yield put(actions.updatingTool.success(tool))
    browserHistory.push(`/tools/${tool.id}`)
  } catch (error) {
    yield put(actions.updatingTool.failure(authentication, id, values, error))
  }
}


function* watchCreateTool() {
  let action = yield take(actions.CREATE_TOOL)
  while (action !== END) {
    const {authentication, values} = action
    yield fork(createTool, authentication, values)
    action = yield take(actions.CREATE_TOOL)
  }
}


function* watchDeleteTool() {
  let action = yield take(actions.DELETE_TOOL)
  while (action !== END) {
    const {authentication, id} = action
    yield fork(deleteTool, authentication, id)
    action = yield take(actions.DELETE_TOOL)
  }
}


function* watchLoadAuthenticationCookie() {
  let action = yield take(actions.LOAD_AUTHENTICATION_COOKIE)
  while (action !== END) {
    yield fork(loadAuthenticationCookie)
    action = yield take(actions.LOAD_AUTHENTICATION_COOKIE)
  }
}


function* watchLoadTool() {
  let action = yield take(actions.LOAD_TOOL)
  while (action !== END) {
    const {authentication, id} = action
    yield fork(loadTool, authentication, id)
    action = yield take(actions.LOAD_TOOL)
  }
}


function* watchLoadTools() {
  let action = yield take(actions.LOAD_TOOLS)
  while (action !== END) {
    const {authentication} = action
    yield fork(loadTools, authentication)
    action = yield take(actions.LOAD_TOOLS)
  }
}


function* watchSignIn() {
  let action = yield take(actions.SIGN_IN)
  while (action !== END) {
    const {reject, resolve, values} = action
    yield fork(signIn, values, resolve, reject)
    action = yield take(actions.SIGN_IN)
  }
}


function* watchSignOut() {
  let action = yield take(actions.SIGN_OUT)
  while (action !== END) {
    const {reject, resolve} = action
    yield fork(signOut, resolve, reject)
    action = yield take(actions.SIGN_OUT)
  }
}


function* watchSignUp() {
  let action = yield take(actions.SIGN_UP)
  while (action !== END) {
    const {reject, resolve, values} = action
    yield fork(signUp, values, resolve, reject)
    action = yield take(actions.SIGN_UP)
  }
}


function* watchUpdateTool() {
  let action = yield take(actions.UPDATE_TOOL)
  while (action !== END) {
    const {authentication, id, values} = action
    yield fork(updateTool, authentication, id, values)
    action = yield take(actions.UPDATE_TOOL)
  }
}


export default function* root() {
  yield [
    call(watchCreateTool),
    call(watchDeleteTool),
    call(watchLoadAuthenticationCookie),
    call(watchLoadTool),
    call(watchLoadTools),
    call(watchSignIn),
    call(watchSignOut),
    call(watchSignUp),
    call(watchUpdateTool),
  ]
}
