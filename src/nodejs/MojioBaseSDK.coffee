# version 4.0.0
Http = require './HttpNodeWrapper'
SignalR = require './SignalRNodeWrapper'
FormUrlencoded = require 'form-urlencoded'
_ = require 'underscore'

module.exports = class MojioBaseSDK

    constructor: (options={}) ->
#        super(options)

    
    # Create models entities for testing purposes.
    #
    # Mocks up objects for testing, objects are not persisted and are created with random values.
    # @param {string} type The model type: Vehicle, User, Mojio, or Trip.
    # @example Create a Vehicle for unit testing
    #   sdk.mock((error, result) ->
    #       Vehicle = result
    #   )
    mock: (callback) ->
        @callback(callback) if (callback?)
        return @

    # An optional call that will initiate the actions of the fluent chain. When the actions of the
    # chain are completed, the given function will be called with the results. In the case of a redirect
    # control will be returned to the url given and you must call authorize again with the results
    # until 'true' is given in the callback results.
    # @param callback {function} A function to call when the fluent chain is complete.
    # @public
    callback: (callback) ->
        callback(null, true)
        return @
