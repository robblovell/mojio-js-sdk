#!/bin/sh
echo "Building nodejs SDK"
echo "Copy files from template to source directory"
# copy files to a flat location.
cp template/helpers/* src/nodejs/helpers
cp template/interfaces/* src/nodejs/interfaces
cp template/sdk/* src/nodejs/sdk
cp template/state/* src/nodejs/state
cp template/styles-all/* src/nodejs/styles
cp template/styles-nodejs/* src/nodejs/styles
cp template/wrappers-nodejs/* src/nodejs/wrappers

echo "Build Javascript from Coffeescript..."
coffee --compile src/nodejs
echo "Combine files using browserify..."

cd src/nodejs/sdk
../../../node_modules/.bin/browserify -r ./MojioSDK.js --standalone MojioSDK > ../../../lib/MojioSDK.js
cd ../styles
../../../node_modules/.bin/browserify -r ./MojioPromiseStyle.js --standalone MojioPromiseStyle > ../../../lib/MojioPromiseStyle.js
../../../node_modules/.bin/browserify -r ./MojioReactiveStyle.js --standalone MojioReactiveStyle > ../../../lib/MojioReactiveStyle.js
../../../node_modules/.bin/browserify -r ./MojioAsyncAwaitStyle.js --standalone MojioAsyncAwaitStyle > ../../../lib/MojioAsyncAwaitStyle.js
../../../node_modules/.bin/browserify -r ./MojioSyncStyle.js --standalone MojioSyncStyle > ../../../lib/MojioSyncStyle.js
cd ../../../
echo "Completed nodejs SDK"
echo "Building browser SDK"
echo "Copy files from template to source directory"

cp template/helpers/* src/browser/helpers
cp template/interfaces/* src/browser/interfaces
cp template/sdk/* src/browser/sdk
cp template/state/* src/browser/state
cp template/styles-all/* src/browser/styles
cp template/styles-browser/* src/browser/styles
cp template/wrappers-browser/* src/browser/wrappers
echo "Build Javascript from Coffeescript..."

coffee --compile src/browser
echo "Combine files using browserify..."

cd src/browser/sdk
../../../node_modules/.bin/browserify -r ./MojioSDK.js --standalone MojioSDK > ../../../dist/browser/MojioSDK.js
cd ../styles
../../../node_modules/.bin/browserify -r ./MojioPromiseStyle.js --standalone MojioPromiseStyle > ../../../dist/browser/MojioPromiseStyle.js
../../../node_modules/.bin/browserify -r ./MojioReactiveStyle.js --standalone MojioReactiveStyle > ../../../dist/browser/MojioReactiveStyle.js
#../../../node_modules/.bin/browserify -r ./MojioAsyncAwaitStyle.js --standalone MojioAsyncAwaitStyle > ../../../dist/browser/MojioAsyncAwaitStyle.js
#../../../node_modules/.bin/browserify -r ./MojioSyncStyle.js --standalone MojioSyncStyle > ../../../dist/browser/MojioSyncStyle.js

cd ../../../
echo "Completed browser SDK"

