
var path = require('path');
var webpack = require('webpack');
var merge = require('webpack-merge');
var HtmlWebpackPlugin = require('html-webpack-plugin');
var autoprefixer = require('autoprefixer');
var ExtractTextPlugin = require('extract-text-webpack-plugin');
var CopyWebpackPlugin = require('copy-webpack-plugin');

// detemine build env
var TARGET_ENV = process.env.npm_lifecycle_event === 'build' ? 'production' : 'development';

// common webpack config
var commonConfig = {
  output: {
    path: path.resolve(__dirname, 'dist/'),
    publicPath: '/',
    filename: '[hash].js',
  },
  resolve: {
    modulesDirectories: ['node_modules'],
    extensions: ['', '.js', '.elm']
  },
  module: {
    noParse: /\.elm$/,
    loaders: [
      {
        test: /\.(eot|ttf|woff|woff2|png|svg)$/,
        loader: 'file-loader'
      }
    ]
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: 'static/index.html',
      inject: 'body',
      filename: 'index.html'
    })
  ],
  postcss: [ autoprefixer( { browsers: ['last 2 versions'] } ) ],
}

// additional webpack settings for local env (when invoked by 'npm start')
if (TARGET_ENV === 'development') {
  console.log( 'Serving locally...');
  module.exports = merge(commonConfig, {
    entry: [
      'webpack-dev-server/client?http://localhost:3011',
      'expose?$!expose?jQuery!jquery',
      'bootstrap-webpack!./bootstrap.config.js',
      path.join(__dirname, 'static/index.js')
    ],
    devServer: {
      historyApiFallback: true,
      inline: true,
      progress: true
    },
    module: {
      loaders: [
        {
          test: /\.elm$/,
          exclude: [/elm-stuff/, /node_modules/],
          loader: 'elm-hot!elm-webpack?verbose=true&warn=true'
        },
        {
          test: /\.(css|less)$/,
          loaders: ['style', 'css', 'postcss', 'less']
        }
      ]
    }
  });
}

// additional webpack settings for prod env (when invoked via 'npm run build')
if (TARGET_ENV === 'production') {
  console.log('Building for prod...');
  module.exports = merge(commonConfig, {
    entry: [
      'expose?$!expose?jQuery!jquery',
      'bootstrap-webpack!./bootstrap.config.prod.js',
      path.join(__dirname, 'static/index.js')
    ],
    module: {
      loaders: [
        {
          test: /\.elm$/,
          exclude: [/elm-stuff/, /node_modules/],
          loader: 'elm-webpack'
        },
        {
          test: /\.(css|less)$/,
          loader: ExtractTextPlugin.extract('style-loader', [
            'css', 'postcss', 'less'
          ])
        }
      ]
    },
    plugins: [
      new CopyWebpackPlugin([
        {
          from: 'static/img/',
          to: 'img/'
        },
        {
          from: 'static/favicon.ico'
        },
      ]),
      new webpack.optimize.OccurenceOrderPlugin(),
      // extract CSS into a separate file
      new ExtractTextPlugin( './[hash].css', { allChunks: true } ),
      // minify & mangle JS/CSS
      new webpack.optimize.UglifyJsPlugin({
        minimize: true,
        compressor: { warnings: false }
        // mangle:  true
      })
    ]
  });
}
