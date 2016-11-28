// pull in desired CSS/LESS files
require('../css/ogp-style.less');
require('../css/retruco.less');
require('../css/bubbles.css');


// user prefered language (http://stackoverflow.com/a/38150585/3548266)

var language = navigator.languages && navigator.languages[0] || // Chrome / Firefox
               navigator.language ||   // All browsers
               navigator.userLanguage; // IE <= 10


// D3 Bubbles

var d3Bubbles = require('./d3bubbles');
d3Bubbles.installPolyfill();

var rAF = typeof requestAnimationFrame !== 'undefined'
    ? requestAnimationFrame
    : function(callback) { setTimeout(function() { callback(); }, 0); };


// inject bundled Elm app into div#main

var Elm = require('../../src/Main');
var main = Elm.Main.embed(document.getElementById('main'), language);

main.ports.setDocumentMetatags.subscribe(function(metatags) {
    if (metatags.hasOwnProperty('imageUrl')) {
        var element = document.head.querySelector('meta[property="og:image"]');
        if (element) {
            element.setAttribute('content', metatags.imageUrl);
        }
    }
    if (metatags.hasOwnProperty('title')) {
        var elements = document.head.getElementsByTagName('title');
        if (elements.length) {
            var element = elements[0];
            var genericTitle = "OGP Toolbox";
            element.innerText = metatags.title
                ? metatags.title + " – " + genericTitle
                : genericTitle;
        }
    }
});

main.ports.mountd3bubbles.subscribe(function(data) {
    var popularTags = data[0];
    var selectedTags = data[1];
    // Use rAF in order to be sure that the port Cmd is called after view is rendered.
    rAF(function() {
        var bubbles = popularTags.map(function(popularTag) {
            return { name: popularTag.tag, radius: popularTag.count };
        });
        if (selectedTags.length) {
            bubbles = bubbles.concat(selectedTags.map(function(selectedTag) {
                return { name: selectedTag, radius: 90, type: "selected" };
            }));
        } else {
            var centerBubble = { name: "Open government", radius: 150, type: "main" };
            bubbles = bubbles.concat(centerBubble);
        }
        d3Bubbles.mount({
            data: bubbles,
            onSelect: function (bubble) {
                main.ports.bubbleSelections.send(bubble.name);
            },
            onDeselect: function (bubble) {
                main.ports.bubbleDeselections.send(bubble.name);
            },
        });
    })
});
