#!/bin/sh
bower install
coffee --map --compile src/nodejs
cp src/nodejs/*.js lib/
coffee --map --compile src/browser
cd src/browser
../../node_modules/.bin/browserify -r ./HttpBrowserWrapper.js --standalone HttpBrowserWrapper > ../../dist/browser/HttpBrowserWrapper.js
../../node_modules/.bin/browserify -r ./MojioClient.js --standalone MojioClient > ../../dist/browser/MojioClient.js
cd ../../
mocha