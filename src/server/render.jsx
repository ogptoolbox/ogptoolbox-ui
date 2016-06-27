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
import {renderToStaticMarkup, renderToString} from "react-dom/server"
import {Provider} from "react-redux"
import {createMemoryHistory, match, RouterContext} from "react-router"
import {syncHistoryWithStore} from "react-router-redux"
import {END} from "redux-saga"

import configureStore from "../store"
import Routes from "../routes"
import rootSaga from "../sagas"
import HtmlDocument from "./html-document"


export default function handleRender(req, res, next) {
  const memoryHistory = createMemoryHistory(req.url)
  const store = configureStore(memoryHistory)
  const history = syncHistoryWithStore(memoryHistory, store)
  const routes = Routes(store)

  match({history, routes, location: req.url}, (error, redirectLocation, renderProps) => {
    if (error) {
      // // TODO Disable in production?
      next(error)
      // res.status(500).send(error.message)
    } else if (redirectLocation) {
      res.redirect(302, redirectLocation.pathname + redirectLocation.search)
    } else if (renderProps && renderProps.components) {
      const rootTask = store.runSaga(rootSaga)
      // Trigger the universal Saga tasks.
      cookie.plugToRequest(req, res)
      renderHtmlDocument(renderProps, store)
      // Trigger a saga END action. See: https://github.com/yelouafi/redux-saga/issues/255
      store.dispatch(END)

      rootTask.done.then(() => {
        res.send(renderHtmlDocument(renderProps, store))
      }).catch((e) => {
        console.log(e.message)
        next(e)
        // res.status(500).send(e.message)
      })
    } else {
      res.status(404).send("Not found")
    }
  })
}


function loadWebpackAssets() {
  const webpackAssetsFilePath = "../../webpack-assets.json"
  let webpackAssets
  if (process.env.NODE_ENV === "production") {
    webpackAssets = require(webpackAssetsFilePath)
  } else if (process.env.NODE_ENV === "development") {
    webpackAssets = require(webpackAssetsFilePath)
    // Do not cache webpack stats: the script file would change since
    // hot module replacement is enabled in the development env
    delete require.cache[require.resolve(webpackAssetsFilePath)]
  }
  return webpackAssets
}


function renderHtmlDocument(renderProps, store) {
  const appHtml = renderToString(
    <Provider store={store}>
      <RouterContext {...renderProps} />
    </Provider>
  )
  const webpackAssets = loadWebpackAssets()
  const html = renderToStaticMarkup(
    <HtmlDocument
      appHtml={appHtml}
      appInitialState={store.getState()}
      cssUrls={webpackAssets.main.css}
      jsUrls={webpackAssets.main.js}
    />
  )
  const doctype = "<!DOCTYPE html>"
  return doctype + html
}
