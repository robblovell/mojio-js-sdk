
#!/bin/sh
echo "Copy browser src files to template locations."
echo "Copy helpers"

cp -f src/nodejs/helpers/* template/helpers
echo "Copy interfaces"
cp -f src/nodejs/interfaces/* template/interfaces
echo "Copy sdk"
cp -f src/nodejs/sdk/* template/sdk
echo "Copy stateMachine"
cp -f src/nodejs/state/* template/state
echo "Copy styles, promise"
cp -f src/nodejs/styles/MojioPromiseStyle* template/styles-all
echo "Copy styles, reactive"
cp -f src/nodejs/styles/MojioReactiveStyle* template/styles-all
echo "Copy styles, async/await"
cp -f src/nodejs/styles/MojioAsyncAwaitStyle* template/styles-nodejs
echo "Copy styles, sync"
cp -f src/nodejs/styles/MojioSyncStyle* template/styles-nodejs
echo "Copy wrappers"
cp -f src/nodejs/wrappers/* template/wrappers-nodejs
echo "Completed browser copy-back"
