#!/bin/sh
bower install
coffee --map --compile src/nodejs_shim
coffee --map --compile src/models
coffee --map --compile src
cp src/nodejs_shim/*.js lib/nodejs_shim
cp src/*.js lib/
cp src/models/*.js lib/models
coffee --map --compile src/browser
cd src/browser
../../node_modules/.bin/browserify -r ./HttpBrowserWrapper.js --standalone HttpBrowserWrapper > ../../dist/browser/HttpBrowserWrapper.js
../../node_modules/.bin/browserify -r ./MojioClient.js --standalone MojioClient > ../../dist/browser/MojioClient.js
cd ../models
../../node_modules/.bin/browserify -r ./App.js --standalone App > ../../dist/browser/App.js
../../node_modules/.bin/browserify -r ./Event.js --standalone App > ../../dist/browser/Event.js
../../node_modules/.bin/browserify -r ./Location.js --standalone App > ../../dist/browser/Location.js
../../node_modules/.bin/browserify -r ./Mojio.js --standalone App > ../../dist/browser/Mojio.js
../../node_modules/.bin/browserify -r ./Observer.js --standalone App > ../../dist/browser/Observer.js
../../node_modules/.bin/browserify -r ./Product.js --standalone App > ../../dist/browser/Product.js
../../node_modules/.bin/browserify -r ./Subscription.js --standalone App > ../../dist/browser/Subscription.js
../../node_modules/.bin/browserify -r ./Trip.js --standalone App > ../../dist/browser/Trip.js
../../node_modules/.bin/browserify -r ./User.js --standalone App > ../../dist/browser/User.js
../../node_modules/.bin/browserify -r ./Vehicle.js --standalone App > ../../dist/browser/Vehicle.js
cd ../../
# mocha -t 12000