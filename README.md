# OGPToolbox-UI

Web user interface for OGP toolbox

## Install

Currently, OGPToolbox-UI requires a forked version of evancz/url-parser. You need to install it manually:

    git clone https://github.com/ogptoolbox/url-parser
    cd url-parser
    elm-package install
    cd ..

Install OGPToolbox-UI:

    git clone https://github.com/ogptoolbox/ogptoolbox-ui
    cd ogptoolbox-ui

## Install dependencies

    npm install

This will install npm dependencies in `node_modules` and Elm dependencies in `elm-stuff`.

## Development

Start the hot-reloading webpack dev server:

    npm start

Navigate to <http://localhost:3011>.

Any changes you make to your files (.elm, .js, .css, etc.) will trigger
a hot reload.

## Production

When you're ready to deploy:

    npm run build

This will create a `dist` folder (after removing the old one if present):

    .
    ├── dist
    │   ├── index.html
    │   ├── 5df766af1ced8ff1fe0a.css
    │   └── 5df766af1ced8ff1fe0a.js

To test the production build locally:

    npm run serve
    > ogptoolbox-ui@0.0.1 serve /home/cbenz/Dev/ogptoolbox/ogptoolbox-ui
    > static --spa dist

    serving "." at http://127.0.0.1:3012
    serving as a single page app (all non-file requests redirect to index.html)

Navigate to <http://localhost:3012>.
