# assume's JQuery javascript client (bower install jquery).
iSignalRWrapper = require './iSignalRWrapper'
SignalRRegistry = require './SignalRRegistry'
module.exports = class SignalRBrowserWrapper extends iSignalRWrapper
    registry = new SignalRRegistry()

    constructor: (@url, @hubNames, jquery) ->  # hubNames not used.
        @$ = jquery
        @available_hubs = hubNames
        @signalr = null
        @connectionStatus = false
        super()

    getHub: (which, callback) ->
        if (registry.hubs[which])
            callback(null, registry.hubs[which])
        else
            if (!@signalr?)
                @signalr = @$.hubConnection(@url, { useDefaultPath: false })
                @signalr.error( (error) ->
                    console.log("Connection error"+error)
                    callback(error, null)
                )

            registry.hubs[which] = @signalr.createHubProxy(which)
            hub = registry.hubs[which]

            hub.on("error", (data) ->
                console.log("Hub '"+which+"' has error"+data)
            )
            hub.on("UpdateEntity", registry.observer_registry)

            if (hub.connection.state != 1)
                if (!@connectionStatus)
                    @signalr.start().done( () =>
                        @connectionStatus = true
                        hub.connection.start().done( () =>
                            callback(null, hub)
                        )
                    )
                else
                    hub.connection.start().done( () =>
                        callback(null, hub)
                    )
            else
                callback(null, hub)

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
