# version 5.0.0
_ = require 'underscore'
MojioSDKState = require '../state/MojioSDKState'
MojioPushSDK = require './MojioPushSDK'
Module = require '../helpers/Module'

# The Mojio SDK. The Mojio SDK provides a means to easily use Mojio's Authentication Server, REST API, and Push API.
#
# The SDK works with four code segments: MojioModel, MojioAuth, MojioRest, and MojioPush that work together to provide
# methods for constructing fluent method calls.
#
# MojioModel provides mechanisms for specifying resources and data for resources.
#
# MojioAuth provides a security layer through OAuth2.
#
# MojioRest provides ways to make rest calls to the API and preform CRUD operations as well as update associates with
# secondary resources like permissions, images or tags.
#
# MojioPush methods provide a way to subscribe to changes that occur on primary resources. The Push SDK allows data to
# be sent to the application without it requesting it through transports like SignalR, Http Post, MQTT or others.
#
# Four programming styles are supported, synchronous, asynchronous with callbacks (node js style), asynchronous with promises,
# and asynchronous with reactive streams. Choose one style and or multiple, but each fluent call must operate in one of
# these modes at the end of the fluent chain.
#
# @example initate a fluent chain to retrieve a the vehicle given using a synchronous call. (don't do this very often).
#   sdk = new MojioSDK()
#   result = sdk.get().vehicle(vehicleId).sync()
#   ...
# @example initate a fluent chain to retrieve a the vehicle given using an asynchronous initiation with a callback.
#   sdk = new MojioSDK()
#   sdk.get().vehicle(vehicleId).callback((error, result) ->
#     ...
#   )
# @example initate a fluent chain to retrieve a the vehicle given using an asynchronous initiation with a promise.
#   sdk = new MojioSDK()
#   promise = sdk.get().vehicle(vehicleId).callback()
#   ...
#
# @example initate a fluent chain to retrieve a the vehicle given using an asynchronous initiation with a reative stream.
#   sdk = new MojioSDK()
#   stream = sdk.get().vehicle(vehicleId).callback()
#   ...
#
module.exports = class MojioSDK extends Module
    defaults = {
        sdk_env: 'nodejs'
        test: false
    }
    # MojioSDK is a container for working with the Mojio API.
    # The sdk works with either the PushSDK, or can be paired down to just the REST SDK.
    # The SDK is fluent, so chains of calls are used to construct a desired outcome and then one of the four function
    # calls below initiates the the call to the API in one of the four programming styles.
    # @parameter {object} options
    # @public
    # @nodoc
    constructor: (options={}) ->

        # include the sdk level instance functions.
        @include if options.sdk then options.sdk else MojioPushSDK
        # include the style calls: callback, promise, reactive, async, or sync.
        if options.styles
            for style in options.styles
                @include style
        # don't had sdk and styles options to the instance literally.
        delete options.sdk
        delete options.styles
        # add the rest of the options or defaults to the instance.
        @configure(options, defaults)
        # instantiate the state of the fluent chain.
        @state = new MojioSDKState(options)
        super()

    # Configure the SDK's options
    #
    # @example Basic Configuration
    #   configure({ version: 'v2' })
    # @param [object] options Configurable options for the sdk.
    # @option options [String] version api version to use 'v1' or 'v2't
    # @return {object} this # @private
    # @nodoc
    configure: (options={}, defaults={}) ->
        _.extend(@, options)
        _.defaults(@, defaults)
        return @

    # Sync initiates the fluent chain in a synchronous call, blocking until results are returned. Sync is one of four
    # ways to initiate fluent requests, one of which must be called for requests to be made. This is the least desireable
    # way to initiate a call because it will block until an answer is returned or a timeout occurs.
    # @public
    sync: () ->
        @state.initiate((error, result) ->
        )

        # make the rest call here.
        result = true
        return result

    # Callback initiates the fluent chain asynchronously by providing a callback(error, result) that will be called once
    # the request has returned. It is one of four ways to initiate fluent requests, one of which must be called for requests to be made.
    # In the case of a redirect (in the auth sdk) control will be returned to a url given and you must call authorize again with the results
    # until 'true' is given in the callback results.
    # @param callback {function} A function to call when the fluent chain is complete.
    # @public
    callback: (callback) ->
        # execute the rest request and return the result in the callback.
        console.log(@state.url())

        @state.initiate(callback)

    show: () ->
        return @state.show()
