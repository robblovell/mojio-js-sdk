# version 5.0.0
_ = require 'underscore'
MojioPushSDK = require './MojioPushSDK'
Module = require 'Module'
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
    state = {}

    # MojioSDK is a container for working with the Mojio API.
    # The sdk works with either the PushSDK, or can be paired down to just the REST SDK.
    # The SDK is fluent, so chains of calls are used to construct a desired outcome and then one of the four function
    # calls below initiates the the call to the API in one of the four programming styles.
    # @parameter {object} options
    # @public
    # @nodoc
    constructor: (options) ->
        super()
        options = {} unless options?
        @include if options.sdk then options.sdk else MojioPushSDK
        delete options.sdk
        options.test = false unless (options.test?)
        @configure(options)
        console.log("test:"+@test)
        reset()

    # Sync initiates the fluent chain in a synchronous call, blocking until results are returned. Sync is one of four
    # ways to initiate fluent requests, one of which must be called for requests to be made. This is the least desireable
    # way to initiate a call because it will block until an answer is returned or a timeout occurs.
    # @public
    sync: () ->
        sync()
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
        # use generator to yield
        initiate()
        callback(null, true)
        return true

    # Submit initiates the fluent chain asynchronously and returns a promise that will be udated once
    # the request has returned. It is one of four ways to initiate fluent requests, one of which must be called for requests to be made.
    # When the actions of the chain are completed, the promise is updated and its then clause executed. Anyone
    # attaching to the promise is also called.
    # @public
    submit: () ->
        initiate()
        promise = null
        return promise

    # Stream initiates the fluent chain asynchronously by returning a reactive stream that will be updated when the request is complete.
    # It is one of four ways to initiate fluent requests, one of which must be called for requests to be made.
    # @public
    stream: () ->
        initiate()
        stream = null
        return stream

    # @nodoc
    initiate= () ->
        # form the request
        # make the call
        #

    # @nodoc
    reset = () ->
        state.resource = "Vehicles"
        state.action = ""
        # GET
        state.operation = "get"
        state.lmiit = 10
        state.offset = 0
        state.desc = false
        state.id = null
        state.query = null

        # GET/DELETE
        # id, object example, query string, or array.
        state.type = "all"
        state.where = null

        # PUT/POST
        # can specify an object, json string
        state.object = {}

    # @nodoc
    setObject = (object_or_json_string) ->
        switch typeof object_or_json_string
            when "string"
                state.object = object_or_json_string
            when "object"
                state.object = JSON.stringify(object_or_json_string)
        return state

    # @nodoc
    setState = (operation) ->
        reset()
        state.operation = operation

    # @nodoc
    setWhere = (id_example_or_query) ->
        state.type = "all"
        state.where = null

        if (id_example_or_query != null)
            switch typeof id_example_or_query
                when "number"
                    state.type = "id"
                    state.where = id_example_or_query
                when "string"
                    state.type = "query"
                    state.where = id_example_or_query
                when "object"
                    state.type = "example"
                    state.where = id_example_or_query
                else
                    state.type = "query"
                    state.where = id_example_or_query
        return state

    fixup = () ->
        # remove capitals from fields and values in the state.
        for p, v of state
            lowP = p.toLowerCase()
            lowV = v.toLowerCase()
            state[lowP]= lowV
            delete state[p]

    validate = () ->
        switch state.operation
            when 'authorize'
                switch state.type
                    when 'code'
                        if (state.redirect_url? or state.redirect? or state.redirectUrl? or
                        state.return_url? or state.return? or state.returnUrl?)
                            return true
                        else
                            return "Must specify a return url (returnUrl or redirectUrl) field when using 'code' type OAuth2 authorization"
                    when 'token'
                        if (state.user? or state.username? or state.email? or state.usernameoremail? ) and
                        (state.password? or state.pass?)
                            return true
                        else
                            return "Must specify a username or email and a password when using 'token' type OAuth2 authorization"
                    else
                        return 'When authorizing, you must specify token or code authorization.'
            else
                return 'Must Specify an operation: authorize, get, put, post, delete, query, retreive, create, destroy.'
