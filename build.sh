#!/bin/sh

# copy files to a flat location.
cp src/helpers/* lib/nodejs/helpers
cp src/interfaces/* lib/nodejs/interfaces
cp src/sdk/* lib/nodejs/sdk
cp src/state/* lib/nodejs/state
cp src/styles-all/* lib/nodejs/styles
cp src/styles-nodejs/* lib/nodejs/styles
cp src/wrappers-nodejs/* lib/nodejs/wrappers

cp src/helpers/* lib/browser/helpers
cp src/interfaces/* lib/browser/interfaces
cp src/sdk/* lib/browser/sdk
cp src/state/* lib/browser/state
cp src/styles-all/* lib/browser/styles
cp src/styles-browser/* lib/browser/styles
cp src/wrappers-browser/* lib/browser/wrappers

coffee --compile lib/nodejs
coffee --compile lib/browser

