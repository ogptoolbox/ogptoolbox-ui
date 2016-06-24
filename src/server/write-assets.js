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


// A webpack plugin to write webpack stats that can be consumed when rendering
// the page (e.g. it attach the public path to the script names)
// These stats basically contains the path of the script files to
// <script>-load in the browser.

// Inspired from http://webpack.github.io/docs/long-term-caching.html#get-filenames-from-stats


import fs from "fs"
import path from "path"


// Write only a relevant subset of the stats and attach the public path to it
export default function writeAssets(filepath) {
  return function writeAssetsFunc(stats) {
    const publicPath = this.options.output.publicPath
    const json = stats.toJson()

    function getChunks(name, ext) {
      let chunk = json.assetsByChunkName[name]
      // a chunk could be a string or an array, so make sure it is an array
      if (!(Array.isArray(chunk))) {
        chunk = [chunk]
      }
      return chunk
        .filter(chunk2 => path.extname(chunk2) === `.${ext}`) // filter by extension
        .map(chunk2 => `${publicPath}${chunk2}`) // add public path to it
    }

    const chunkName = "main"
    const content = {
      main: {
        css: getChunks(chunkName, "css"),
        js: getChunks(chunkName, "js"),
      },
    }
    fs.writeFileSync(filepath, JSON.stringify(content))
  }
}
