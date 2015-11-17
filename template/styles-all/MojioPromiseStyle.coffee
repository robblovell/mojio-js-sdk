# version 5.0.0

Promise = require('promise')

# The Mojio SDK. The Mojio SDK provides a means to easily use Mojio's Authentication Server, REST API, and Push API.
#
module.exports = class MojioPromiseStyle

    # Promise initiates the fluent chain asynchronously and returns a promise that will be udated once
    # the request has returned. It is one of four ways to initiate fluent requests, one of which must be called for requests to be made.
    # When the actions of the chain are completed, the promise is updated and its then clause executed. Anyone
    # attaching to the promise is also called.
    # @public
    promise: () ->
        promise = new Promise((resolve, reject) =>
            # make the rest call here.
            @stateMachine.initiate((error, result) ->
                # fulfill the promise !
                resolve(result) if result?
                reject(error) if error?
            )
        )
        return promise
