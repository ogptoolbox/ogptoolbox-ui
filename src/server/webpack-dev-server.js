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


import webpack from "webpack"
import WebpackDevServer from "webpack-dev-server"

import config from "../../webpack.config.dev"


const WEBPACK_HOST = process.env.WEBPACK_HOST || "localhost"
const WEBPACK_PORT = parseInt(process.env.WEBPACK_PORT)


new WebpackDevServer(webpack(config), {
  historyApiFallback: true,
  hot: true,
  noInfo: true,
  publicPath: config.output.publicPath,
  stats: { colors: true },
}).listen(WEBPACK_PORT, WEBPACK_HOST, function (err) {
  if (err) { console.log(err) }
  console.log(`Webpack development server listening on http://${WEBPACK_HOST}:${WEBPACK_PORT}`)
})
