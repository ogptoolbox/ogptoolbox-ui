// pull in desired CSS/LESS files
require('../css/ogp-style.less');
// require('../css/retruco.less');
require('../css/bubbles.less');


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


// authentication

var authenticationStr = window.localStorage.getItem('authentication');
var authentication = authenticationStr ? JSON.parse(authenticationStr) : null;


// inject bundled Elm app into div#main

var Elm = require('../../src/Main');
var flags = {
    authentication: authentication,
    language: language
};
var main = Elm.Main.embed(document.getElementById('main'), flags);



// Ports

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
    // Remove previous D3 bubbles instances if present in the DOM.
    Array.prototype.forEach.call( document.querySelectorAll("svg.D3Bubbles"), function( node ) {
        node.parentNode.removeChild( node );
    });
    // Use rAF in order to be sure that the port Cmd is called after view is rendered.
    rAF(function() {
        var bubbles = data.popularTags.map(function(popularTag) {
            return { name: popularTag.tag, radius: popularTag.count };
        });
        if (data.selectedTags.length) {
            bubbles = bubbles.concat(data.selectedTags.map(function(selectedTag) {
                var maxRadius = Math.max.apply(null, data.popularTags.map(function(popularTag) {
                    return popularTag.count;
                }));
                return { name: selectedTag, radius: maxRadius * 1.33, type: "selected" };
            }));
        } else {
            var centerBubble = { name: "Open government", radius: 150, type: "main" };
            bubbles = bubbles.concat(centerBubble);
        }
        d3Bubbles.mount({
            selector: ".bubbles",
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


// From https://www.paramander.com/blog/using-ports-to-deal-with-files-in-elm-0-17
main.ports.fileSelected.subscribe(function (id) {
    var node = document.getElementById(id);
    if (node === null) {
        return;
    }

    // If your file upload field allows multiple files, you might
    // want to consider turning this into a `for` loop.
    var file = node.files[0];
    var reader = new FileReader();

    // FileReader API is event based. Once a file is selected
    // it fires events. We hook into the `onload` event for our reader.
    reader.onload = (function(event) {
        // The event carries the `target`. The `target` is the file
        // that was selected. The result is base64 encoded contents of the file.
        var base64encoded = event.target.result;
        // We build up the `ImagePortData` object here that will be passed to our Elm
        // runtime through the `fileContentRead` subscription.
        var portData = {
            contents: base64encoded,
            filename: file.name
        };

        // We call the `fileContentRead` port with the file data
        // which will be sent to our Elm runtime via Subscriptions.
        main.ports.fileContentRead.send(portData);
    });

    // Connect our FileReader with the file that was selected in our `input` node.
    reader.readAsDataURL(file);
});


main.ports.storeAuthentication.subscribe(function (authentication) {
    if (authentication) {
        window.localStorage.setItem('authentication', JSON.stringify(authentication, null, 2));
    } else {
        window.localStorage.removeItem('authentication');
    }
});