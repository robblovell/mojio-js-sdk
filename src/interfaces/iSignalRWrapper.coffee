SignalR = require 'signalr-client'
# @nodoc
module.exports = class SignalRNodeWrapper

    constructor: () ->

    subscribe: (hubName, method, observerId, subject, futureCallback, callback) ->
        throw new Error("Not implemented")

    unsubscribe: (hubName, method, observerId, subject, pastCallback, callback) ->
        throw new Error("Not implemented")
