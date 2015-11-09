# version 5.0.0

async = require('asyncawait/async')
await = require('asyncawait/await')

module.exports = class MojioAsyncAwaitStyle
    # async initiates the fluent chain asynchronously using async await constructs that will be updated once
    # the request has returned. It is one of four ways to initiate fluent requests, one of which must be called for requests to be made.
    # When the actions of the chain are completed, the promise is updated and its then clause executed. Anyone
    # attaching to the promise is also called.
    # @public
    async: async () ->
        await @stateMachine.initiate((error, result) ->
            return result if result?
            return error if error?
        )


