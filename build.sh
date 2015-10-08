#!/bin/sh

# copy files to a flat location.
cp template/helpers/* src/nodejs/helpers
cp template/interfaces/* src/nodejs/interfaces
cp template/sdk/* src/nodejs/sdk
cp template/state/* src/nodejs/state
cp template/styles-all/* src/nodejs/styles
cp template/styles-nodejs/* src/nodejs/styles
cp template/wrappers-nodejs/* src/nodejs/wrappers

cp template/helpers/* src/browser/helpers
cp template/interfaces/* src/browser/interfaces
cp template/sdk/* src/browser/sdk
cp template/state/* src/browser/state
cp template/styles-all/* src/browser/styles
cp template/styles-browser/* src/browser/styles
cp template/wrappers-browser/* src/browser/wrappers

coffee --compile src/nodejs
coffee --compile src/browser

