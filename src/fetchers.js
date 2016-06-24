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


import "isomorphic-fetch"
import url from "url"

import config from "./config"


export function fetchApiJson(path, fetchOptions) {
  const fetchUrl = url.resolve(config.apiBaseUrl, path)
  console.log(`Fetching ${fetchUrl}...`)
  return fetch(fetchUrl, fetchOptions)
    .then(response => {
      if (response.ok) {
        return response.json()
          .then(json => json.data)
          .catch(reason => response.text()
            .then(text => Promise.reject({
              code: response.status,
              message: response.statusText,
              text,
            }))
          )
      } else {
        return response.text()
          .then(text => {
            let json
            try {
              json = JSON.parse(text)
            } catch (error) {
              json = {
                code: response.status,
                message: response.statusText,
                text,
              }
            }
            return Promise.reject(json)
          })
      }
    })
}


export function fetchUiJson(path, fetchOptions) {
  const fetchUrl = url.resolve("/", path)
  console.log(`Fetching ${fetchUrl}...`)
  return fetch(fetchUrl, fetchOptions)
    .then(response => {
      if (response.ok) {
        return response.json()
          .catch(reason => response.text()
            .then(text => Promise.reject({
              code: response.status,
              message: response.statusText,
              text,
            }))
          )
      } else {
        return response.text()
          .then(text => {
            let json
            try {
              json = JSON.parse(text)
            } catch (error) {
              json = {
                code: response.status,
                message: response.statusText,
                text,
              }
            }
            return Promise.reject(json)
          })
      }
    })
}
