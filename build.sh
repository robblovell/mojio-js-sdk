#!/bin/sh
echo "Building nodejs SDK"
echo "Copy files from template to nodejs source directory"
# copy files to a flat location.
cp -f template/helpers/* src/nodejs/helpers
cp -f template/interfaces/* src/nodejs/interfaces
cp -f template/sdk/* src/nodejs/sdk
cp -f template/state/* src/nodejs/state
cp -f template/styles-all/* src/nodejs/styles
cp -f template/styles-nodejs/* src/nodejs/styles
cp -f template/wrappers-nodejs/* src/nodejs/wrappers

echo "Build Javascript from Coffeescript..."
node_modules/.bin/coffee --compile src/nodejs

#echo "Build the documentation"
#cd src/nodejs/sdk
#codo -o ../../../lib/docs *.coffee
#codo -o ../../../docs *.coffee
#cd ../../../

echo "Combine files using browserify..."

cd src/nodejs/sdk
../../../node_modules/.bin/browserify -r ./MojioSDK.js --standalone MojioSDK > ../../../lib/mojio-sdk.js
cd ../styles
../../../node_modules/.bin/browserify -r ./MojioPromiseStyle.js --standalone MojioPromiseStyle > ../../../lib/mojio-sdk-promise.js
../../../node_modules/.bin/browserify -r ./MojioReactiveStyle.js --standalone MojioReactiveStyle > ../../../lib/mojio-sdk-reactive.js
../../../node_modules/.bin/browserify -r ./MojioAsyncAwaitStyle.js --standalone MojioAsyncAwaitStyle > ../../../lib/mojio-sdk-asyncawait.js
../../../node_modules/.bin/browserify -r ./MojioSyncStyle.js --standalone MojioSyncStyle > ../../../lib/mojio-sdk-sync.js
cd ../../../
echo "Completed nodejs SDK"
echo "Building browser SDK"
echo "Copy files from template to browser source directory"

cp -f template/helpers/* src/browser/helpers
cp -f template/interfaces/* src/browser/interfaces
cp -f template/sdk/* src/browser/sdk
cp -f template/state/* src/browser/state
cp -f template/styles-all/* src/browser/styles
cp -f template/styles-browser/* src/browser/styles
cp -f template/wrappers-browser/* src/browser/wrappers
echo "Build Javascript from Coffeescript..."

coffee --compile src/browser

echo "Build the documentation"
cd src/browser/sdk
codo -o ../../../dist/docs *.coffee
cd ../../../

echo "Combine files using browserify..."

cd src/browser/sdk
../../../node_modules/.bin/browserify -r ./MojioSDK.js --standalone MojioSDK > ../../../dist/mojio-sdk.js
cd ../styles
../../../node_modules/.bin/browserify -r ./MojioPromiseStyle.js --standalone MojioPromiseStyle > ../../../dist/mojio-sdk-promise.js
../../../node_modules/.bin/browserify -r ./MojioReactiveStyle.js --standalone MojioReactiveStyle > ../../../dist/mojio-sdk-reactive.js
#../../../node_modules/.bin/browserify -r ./MojioAsyncAwaitStyle.js --standalone MojioAsyncAwaitStyle > ../../../dist/mojio-sdk-asyncawait.js
#../../../node_modules/.bin/browserify -r ./MojioSyncStyle.js --standalone MojioSyncStyle > ../../../dist/mojio-sdk-sync.js

echo "Uglify and minimize browser sdk..."
cd ../../../dist
uglifyjs --preamble "// version 4.0.0" mojio-sdk.js -o ./mojio-sdk.min.js
uglifyjs --preamble "// version 4.0.0" mojio-sdk-promise.js  -o ./mojio-sdk-promise.min.js
uglifyjs --preamble "// version 4.0.0" mojio-sdk-reactive.js -o ./mojio-sdk-reactive.min.js
cd ../../../
echo "Completed browser SDK"

