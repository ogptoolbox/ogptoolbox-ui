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


// This is the webpack config to use during development.
// It enables the hot module replacement, the source maps and inline CSS styles.


import ErrorNotificationPlugin from "webpack-error-notification"
import ExtractTextPlugin from "extract-text-webpack-plugin"
import path from "path"
import webpack from "webpack"

import writeAssets from "./src/server/write-assets"


const assetsPath = path.resolve(__dirname, "public")
const WEBPACK_HOST = process.env.WEBPACK_HOST || "localhost"
const WEBPACK_PORT = parseInt(process.env.WEBPACK_PORT)


export default {
  // devtool: "eval", // Transformed code
  devtool: "source-map", // Original code
  entry: {
    "main": [
      `webpack-dev-server/client?http://${WEBPACK_HOST}:${WEBPACK_PORT}`,
      "webpack/hot/only-dev-server",
      "./src/client.jsx",
    ],
  },
  output: {
    path: assetsPath,
    filename: "[name]-bundle-[hash].js",
    publicPath: `http://${WEBPACK_HOST}:${WEBPACK_PORT}/`,
  },
  module: {
    loaders: [
      {
        loader: ExtractTextPlugin.extract("css-loader!postcss-loader"),
        test: /\.css$/,
      },
      {
        exclude: /node_modules/,
        loader: "babel",
        query: {
          "plugins": [
            ["react-transform", {
              "transforms": [{
                "transform": "react-transform-hmr",
                "imports": ["react"],
                "locals": ["module"],
              }],
            }],
          ],
        },
        test: /\.(js|jsx)$/,
      },
      {
        loader: "node",
        test: /\.node$/,
      },
    ],
  },
  resolve: {
    extensions: ["", ".js", ".jsx"],
  },
  progress: true,
  plugins: [
    // hot reload
    new webpack.HotModuleReplacementPlugin(),

    new webpack.NoErrorsPlugin(),

    // print a webpack progress
    new webpack.ProgressPlugin((percentage) => {
      if (percentage === 1) {
        process.stdout.write("Bundle is ready")
      }
    }),

    new ErrorNotificationPlugin(process.platform === "linux" && function(msg) {
      if (!this.lastBuildSucceeded) {
        require("child_process").exec("notify-send --hint=int:transient:1 Webpack " + msg)
      }
    }),

    new webpack.DefinePlugin({
      "process.env": {
        BROWSER: JSON.stringify(true),
        HOST: JSON.stringify(process.env.HOST),
        NODE_ENV: JSON.stringify("development"),
      },
    }),

    new webpack.ProvidePlugin({
      React: "react", // For babel JSX transformation which generates React.createElement.
    }),

    function() { this.plugin("done", writeAssets(path.resolve(__dirname, "webpack-assets.json"))) },
  ],
}
