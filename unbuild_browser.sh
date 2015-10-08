#!/usr/bin/env bash
cp lib/browser/helpers/* src/helpers
cp lib/browser/interfaces/* src/interfaces
cp lib/browser/sdk/* src/browser/sdk
cp lib/browser/state/* src/browser/state
cp lib/browser/styles/MojioPromiseStyle* src/styles-all
cp lib/browser/styles/MojioReactiveStyle* src/styles-all
#cp lib/browser/styles/MojioAsyncAwaitStyle* src/styles-browser
#cp lib/browser/styles/MojioSyncStyle* src/styles-browser
cp lib/browser/wrappers/* src/wrappers-browser/wrappers