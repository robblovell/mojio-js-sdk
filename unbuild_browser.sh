#!/bin/sh
echo "Copy browser src files to template locations."
echo "Copy helpers"

cp -f src/browser/helpers/* template/helpers
echo "Copy interfaces"
cp -f src/browser/interfaces/* template/interfaces
echo "Copy sdk"
cp -f src/browser/sdk/* template/sdk
echo "Copy stateMachine"
cp -f src/browser/state/* template/state
echo "Copy styles, promise"
cp -f src/browser/styles/MojioPromiseStyle* template/styles-all
echo "Copy styles, reactive"
cp -f src/browser/styles/MojioReactiveStyle* template/styles-all
#cp src/browser/styles/MojioAsyncAwaitStyle* template/styles-browser
#cp src/browser/styles/MojioSyncStyle* template/styles-browser
echo "Copy wrappers"
cp -f src/browser/wrappers/* template/wrappers-browser
echo "Completed browser copy-back"
