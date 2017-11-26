SignalR = require 'signalr-client'
iSignalRWrapper = require '../helpers/iSignalRWrapper'
SignalRRegistry = require '../interfaces/SignalRRegistry'

# @nodoc
module.exports = class SignalRNodeWrapper extends iSignalRWrapper

    registry = new SignalRRegistry()

    constructor: (@url, @hubNames, @options = {}) ->
        @available_hubs = hubNames
        @signalr = null
        super()
        
    getHub: (which, callback, retries = 10) ->
        @signalr ?= new SignalR.client(@url, @available_hubs, null)
        hub = registry.hubs[which]
        return callback(null, hub) if hub?
        
        if hub == @signalr.hub(which)
            hub.on 'error', (data) -> log data
            hub.on 'UpdateEntity', registry.observer_registry
            return callback null, hub
        else if retries-- > 0
            _this = @
            retry = () ->
                _this.getHub which, callback, retries
            setTimeout retry, 1000
        else
            callback "Timed out.", null

    subscribe: (hubName, method, observerId, subject, futureCallback, callback) ->
        registry.setCallback(subject, futureCallback)
        @getHub(hubName, (error, hub) ->
            if error?
                callback(error, null)
            else
                hub.invoke(method, observerId) if hub?
                callback(null, hub)
        )

    unsubscribe: (hubName, method, observerId, subject, pastCallback, callback) ->
        registry.removeCallback(subject, pastCallback)
        if (registry.observer_callbacks[subject].length == 0)
            @getHub(hubName, (error, hub) ->
                if error?
                    callback(error, null)
                else
                    hub.invoke(method, observerId) if hub?
                    callback(null, hub)
            )
        else
            callback(null, true)

