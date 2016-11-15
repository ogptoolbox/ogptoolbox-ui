const bootstrapConfig = require('./bootstrap.config')

module.exports = Object.assign({}, bootstrapConfig, {
  // Overwrite styleLoader to use Webpack extract-text-plugin.
  styleLoader: require('extract-text-webpack-plugin').extract('style-loader', 'css-loader!postcss-loader!less-loader'),
});
