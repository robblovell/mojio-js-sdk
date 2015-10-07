# version 5.0.0

# The Mojio SDK. The Mojio SDK provides a means to easily use Mojio's Authentication Server, REST API, and Push API.
wait=require('wait.for')
module.exports = class MojioSyncStyle


    # Sync initiates the fluent chain in a synchronous call, blocking until results are returned. Sync is one of four
    # ways to initiate fluent requests, one of which must be called for requests to be made. This is the least desireable
    # way to initiate a call because it will block until an answer is returned or a timeout occurs.
    # @public
    sync: () =>
        console.log('fiber start')
        result = wait.for(@state.initiate);
        console.log('function returned:', result)
        console.log('fiber end')
        return result

#    launch: () =>
#        wait.launchFiber(@sync)


