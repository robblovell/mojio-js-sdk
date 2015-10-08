# version 5.0.0
Rx = require('rx')
# The Mojio SDK. The Mojio SDK provides a means to easily use Mojio's Authentication Server, REST API, and Push API.
module.exports = class MojioReactiveStyle

    # Observable initiates the fluent chain asynchronously by returning a reactive stream that will be updated when the request is complete.
    # It is one of four ways to initiate fluent requests, one of which must be called for requests to be made.
    # @public
    observable: () ->
        stream = Rx.Observable.fromCallback(@state.initiate)
        observable = stream()

        return observable

    # Subscribe initiates the fluent chain asynchronously by returning a reactive stream that will be updated when the request is complete.
    # It is one of four ways to initiate fluent requests, one of which must be called for requests to be made.
    # @public
    subscribe: (result, error, complete) ->
        observable = @observable()
        observer = Rx.Observer.create(result, error, complete)
        return observable.subscribe(observer)


