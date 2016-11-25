
// pull in desired CSS/LESS files
require('./css/ogp-style.less');
require('./css/retruco.less');

// user prefered language (http://stackoverflow.com/a/38150585/3548266)

var language = navigator.languages && navigator.languages[0] || // Chrome / Firefox
               navigator.language ||   // All browsers
               navigator.userLanguage; // IE <= 10

// inject bundled Elm app into div#main

var Elm = require('../src/Main');
var main = Elm.Main.embed(document.getElementById('main'), language);

main.ports.setDocumentTitle.subscribe(function(str) {
    var titleElements = document.head.getElementsByTagName('title');
    if (titleElements.length) {
        var titleElement = titleElements[0];
        titleElement.innerText = str + " – OGP Toolbox";
    }
});
