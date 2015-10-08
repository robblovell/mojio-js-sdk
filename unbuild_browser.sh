#!/usr/bin/env bash
cp src/browser/helpers/* template/helpers
cp src/browser/interfaces/* template/interfaces
cp src/browser/sdk/* template/browser/sdk
cp src/browser/state/* template/browser/state
cp src/browser/styles/MojioPromiseStyle* template/styles-all
cp src/browser/styles/MojioReactiveStyle* template/styles-all
#cp src/browser/styles/MojioAsyncAwaitStyle* template/styles-browser
#cp src/browser/styles/MojioSyncStyle* template/styles-browser
cp src/browser/wrappers/* template/wrappers-browser/wrappers