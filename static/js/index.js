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

main.ports.setDocumentTitle.subscribe(function(str) {
    var titleElements = document.head.getElementsByTagName('title');
    if (titleElements.length) {
        var titleElement = titleElements[0];
        titleElement.innerText = str + " – OGP Toolbox";
    }
});

main.ports.mountd3bubbles.subscribe(function(data) {
    // Use rAF in order to be sure that the port Cmd is called after view is rendered.
    rAF(function() {
        var bubbles = data.map(function(bubble) {
            if (bubble.selected) {
                bubble.type = "selected";
                bubble.radius = 90;
            }
            return bubble;
        });
        var noBubbleSelected = data.filter(function(bubble) {
            return bubble.selected;
        }).length == 0;
        if (noBubbleSelected) {
            var centerBubble = { tag: "Open government", count: 150, type: "main" };
            bubbles = bubbles.concat(centerBubble);
        }
        bubbles = bubbles.map(function(bubble) {
            bubble.name = bubble.tag;
            bubble.radius = bubble.count;
            return bubble;
        });
        d3Bubbles.mount({
            data: bubbles,
            onSelect: main.ports.bubbleSelections.send,
            onDeselect: main.ports.bubbleDeselections.send,
        });
    })
});
