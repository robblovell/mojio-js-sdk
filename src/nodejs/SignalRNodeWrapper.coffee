SignalR = require 'signalr-client'
module.exports = class SignalRNodeWrapper

    observer_callbacks:  {}

    observer_registry: (entity) =>
        if @observer_callbacks[entity._id]
            callback(entity) for callback in @observer_callbacks[entity._id]

    constructor: (url, hubs) ->
        @hub = null
        @signalr = new SignalR.client(url, hubs)

    getHub: (which) ->
        return @hub if (@hub?)

        @hub = @signalr.hub(which);
        @hub.on("Error", (data) ->
            log(data)
        )
        @hub.on("UpdateEntity", @observer_registry) # observer_callback(entity)
        return @hub

    setCallback: (id, futureCallback) ->
        if (!@observer_callbacks[id]?)
            @observer_callbacks[id] = []
        @observer_callbacks[id].push(futureCallback)
        return

    removeCallback: (id, pastCallback) ->
        if (pastCallback == null)
            @observer_callbacks[id] = []
        else
            temp = []
            # reform the obxerver_callbacks list without the given pastCallback
            for callback in @observer_callbacks[id]
                temp[id].push(callback) if (callback != pastCallback)
            @observer_callbacks[id] = temp

    subscribe: (hub, method, subject, object, futureCallback) ->
        @setCallback(subject, futureCallback)
        @getHub(hub).invoke(method, object)

    unsubscribe: (hub, method, subject, object, pastCallback) ->
        @removeCallback(subject, pastCallback)
        if (@observer_callbacks[subject].length == 0)
            @getHub(hub).invoke(method, object)
