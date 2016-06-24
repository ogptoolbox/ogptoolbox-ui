# OGPToolbox-Editor

## Start

The first time only:

    npm install

To launch the web server:

    npm run dev

Then open http://localhost:3021/

## Production build

    npm run clean
    npm run build

Serve the contents of the `public` dir
(for example using [http-server](https://www.npmjs.com/package/http-server))):

    http-server public

Open `http://localhost:8080` in your browser.
