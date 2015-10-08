#!/usr/bin/env bash
cp src/nodejs/helpers/* template/helpers
cp src/nodejs/interfaces/* template/interfaces
cp src/nodejs/sdk/* template/nodejs/sdk
cp src/nodejs/state/* template/nodejs/state
cp src/nodejs/styles/MojioPromiseStyle* template/styles-all
cp src/nodejs/styles/MojioReactiveStyle* template/styles-all
cp src/nodejs/styles/MojioAsyncAwaitStyle* template/styles-nodejs
cp src/nodejs/styles/MojioSyncStyle* template/styles-nodejs
cp src/nodejs/wrappers/* template/wrappers-nodejs/wrappers