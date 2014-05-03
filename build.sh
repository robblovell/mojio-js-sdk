#!/bin/sh
bower install
coffee --map --compile src/nodejs
cp src/nodejs/*.js lib/
coffee --map --compile src/browser
cd src/browser
../../node_modules/.bin/browserify -r ./HttpBrowser.js --standalone HttpBrowser > ../../dist/browser/HttpBrowser.js
../../node_modules/.bin/browserify -r ./Mojio.js --standalone Mojio > ../../dist/browser/Mojio.js
cd ../../
mocha