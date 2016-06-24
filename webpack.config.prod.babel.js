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


// Webpack config for creating the production bundle.


import ExtractTextPlugin from "extract-text-webpack-plugin"
import path from "path"
import webpack from "webpack"

import writeAssets from "./src/server/write-assets"


var assetsPath = path.join(__dirname, "public")


module.exports = {
  devtool: "source-map",
  entry: {
    "main": "./src/client.jsx",
  },
  output: {
    path: assetsPath,
    filename: "[name]-[hash].js",
    publicPath: "/",
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
        test: /\.(js|jsx)$/,
      },
    ],
  },
  resolve: {
    extensions: ["", ".js", ".jsx"],
  },
  progress: true,
  plugins: [

    // set global vars
    new webpack.DefinePlugin({
      "process.env": {
        BROWSER: JSON.stringify(true),
        NODE_ENV: JSON.stringify("production"), // clean up some react stuff
      },
    }),

    new webpack.ProvidePlugin({
      React: "react", // For babel JSX transformation which generates React.createElement.
    }),

    // optimizations
    new webpack.optimize.DedupePlugin(),
    new webpack.optimize.OccurenceOrderPlugin(),
    new webpack.optimize.UglifyJsPlugin({
      compress: {
        warnings: false,
      },
    }),

    function() { this.plugin("done", writeAssets(path.resolve(__dirname, "webpack-assets.json"))) },
  ],
}
