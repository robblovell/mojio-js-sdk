# assume's JQuery javascript client (bower install jquery).
module.exports = class SignalRBrowserWrapper

    observer_callbacks:  {}

    observer_registry: (entity) =>
        if @observer_callbacks[entity._id]
            callback(entity) for callback in @observer_callbacks[entity._id]

        @conn = null
        @connStatus = null
        @hub = null

    constructor: (@$, @url, @hubs) ->

    getHub: (which) ->
        if (@hub)
            return @hub;

        @conn = $.hubConnection(@url, { useDefaultPath: false })
        @hub = @conn.createHubProxy(which);

        @hub.on("error", (data) ->
            log(data);
        )
        @hub.on("UpdateEntity", @observer_registry)
        @conn.start().done( () ->
            console.log("Connection started")
        )

        return @hub

    subscribe: (hubName, method, subject, object, futureCallback, callback) ->
        @setCallback(subject, futureCallback)
        hub = @getHub(hubName)

        if (hub.connection.state != 1)
            if (@connStatus)
                @connStatus.done(() =>
                    console.log("Hub Connection done")
                    @subscribe(hubName, method, subject, object, futureCallback, callback)
                )
            else
                @connStatus = hub.connection.start().done(() =>
                    console.log("Hub Connection restarted")
                    @subscribe(hubName, method, subject, object, futureCallback, callback)
                )
            console.log("subscribe exiting.");

            callback(null, @connStatus) if callback
        else
            console.log("Call invoke.");

            hub.invoke(method, object)
            console.log("subscribe exiting.");

            callback(null, true) if callback

#        @signalr = $.hubConnection(url, { useDefaultPath: false })
#        @hubs = {}
#        @connectionStatus = null
#
#        for hub in hubs
#            @hubs[hub] = @signalr.createHubProxy(hub)
#            # todo: "UpdateEntity" doesn't belong here.
#            @hubs[hub].on("UpdateEntity", @observer_registry)
#            @hubs[hub].start().done(() ->
#                console.log("Hub connection started!")
#            )
#
#        @connectionStatus = @signalr.start({ transport: ['webSockets', 'longPolling'] }, () ->
#            console.log("connection started!")
#        )

#    reconnect: (which, callback) ->
#        if (@hubs[which].connection.state != 1)
#            if (@connectionStatus[which]?) # Connection may still be in progress.
#                @connectionStatus[which].done(callback)
#            else # new connection.
#                @connectionStatus[which] = @hubs[which].connection.start().done(callback)
#        else
#            callback(null, true)
#
#    getHub: (which) ->
#        if (@hubs[which]?)
#            return @hubs[which];
#
#        @signalr = $.hubConnection(@url, { useDefaultPath: false })
#
#        @hubs[which] = @signalr.createHubProxy(which);
#        @hubs[which].on("UpdateEntity", @observer_registry)
#
#        @connectionStatus = @signalr.start({ transport: ['webSockets', 'longPolling'] }, () ->
#            @connectionStatus = null
#            console.log("connection started!")
#        )
#
#        return @hubs[which]

#        if !@hubs[which]?
#            @hubs[which] = @signalr.createHubProxy(which)
#
#        @reconnect(which, (error, result) ->
#            callback(error, null) if error?
#            # todo: "UpdateEntity" doesn't belong here.
#            @hubs[which].on("UpdateEntity", @observer_registry) # observer_callback(entity)
#            callback(null, @hubs[which])
#        )

    # TODO:: move callback list maintenance to separate class.
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
                temp.push(callback) if (callback != pastCallback)
            @observer_callbacks[id] = temp
        return

#    subscribe: (hubName, method, subject, object, futureCallback, callback) ->
#        @setCallback(subject, futureCallback)
#        hub = @getHub(hubName)
#        if (hub.connection.state != 1)
#            if (@connection_status) # Connection may still be in progress.
#                @connection_status.done( () =>
#                    @subscribe(hubName, method, subject, object, futureCallback, null)
#                )
#            else # new connection.
#                @connection_status = hub.connection.start().done( () =>
#                    @subscribe(hubName, method, subject, object, futureCallback, null)
#                )
#        else
#            hub.invoke(method, object)
#        callback(null, true) if (callback)


#        @getHub(hubName, (error, hub) ->
#            callback(error, null) if error?
#            hub.invoke(method, object) if hub?
#            callback(null, true)
#        )

    unsubscribe: (hubName, method, subject, object, pastCallback, callback) ->
        @removeCallback(subject, pastCallback)
        if (@observer_callbacks[subject].length == 0)
            @getHub(hubName, (error, hub) ->
                callback(error, null) if error?
                hub.invoke(method, object) if hub?
                callback(null, true)
            )
        else
            callback(null, true)