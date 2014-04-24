# mojio-js

Mojio javascript REST client.  Mojio provides a standard REST platform for writing connected car applications.

This repository contains a node js client and a browser js client.

The client is built in coffeescript and compiled to js for use in the browser and node-js environments.  Built code
is in the /dist directory.

The browser client needs jquery to work properly.  See the example directory for usage in
example/login.html.

Test:
```
npm install
bower install
mocha
```

To rebuild js clients in the dist directory:

All code must be compiled from coffeescript to javascript first.  The webstorm project is setup to call browserify and
to copy all built code to the dist directory in the proper place.

Manual steps are:

For nodejs code
```
coffee --map --output src/nodejs --compile src/nodejs/Mojio.coffee
cp src/nodejs/*.js dist/nodejs/
```

For browser code
```
cd src/browser
coffee --map --compile Mojio.coffee
coffee --map --compile HttpBrowser.coffee
browserify -r ./HttpBrowser.js --standalone HttpBrowser > ../../dist/browser/HttpBrowser.js
browserify -r ./Mojio.js --standalone Mojio > ../../dist/browser/Mojio.js
```

Todo:

Make browser code compile from nodejs client.
Need models
POST, PUT, DELETE for resources.
Hyperlinks for resources
