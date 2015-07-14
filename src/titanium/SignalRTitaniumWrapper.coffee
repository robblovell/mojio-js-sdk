# assume's JQuery javascript client (bower install jquery).
module.exports = class SignalRBrowserWrapper

    observer_callbacks:  {}

    observer_registry: (entity) =>
        # need to have the observer id to look this up here.
        # could use the entity type
        return null

    constructor: (url, hubNames) ->  # hubNames not used.
        @url = url
        @hubs = {}
        @signalr = null
        @connectionStatus = false

    getHub: (which, callback) ->
        callback("Titanium support for signalR not available.", null)



    # TODO:: move callback list maintenance to separate class.
    setCallback: (id, futureCallback) ->
        return

    removeCallback: (id, pastCallback) ->
        return

    subscribe: (hubName, method, observerId, subject, futureCallback, callback) ->
        callback("Titanium support for signalR not available.", null)


    unsubscribe: (hubName, method, observerId, subject, pastCallback, callback) ->
        callback("Titanium support for signalR not available.", null)
