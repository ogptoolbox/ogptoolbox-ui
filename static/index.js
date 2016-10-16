
// pull in desired CSS/LESS files
require('./css/ogp-style.less');
require('./css/retruco.less');

// inject bundled Elm app into div#main

var Elm = require('../src/Main');
Elm.Main.embed(document.getElementById('main'));
