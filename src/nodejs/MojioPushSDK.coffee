# version 4.0.0
Http = require './HttpNodeWrapper'
SignalR = require './SignalRNodeWrapper'
FormUrlencoded = require 'form-urlencoded'
_ = require 'underscore'
MojioRestSDK = require './MojioRestSDK'

module.exports = class MojioPushSDK extends MojioRestSDK

    constructor: (options={}) ->
        super(options)

    observe: (key, callback) ->
        @callback(callback) if (callback?)
        return @

    fields: (fields, callback) ->
        @callback(callback) if (callback?)
        return @

    where: (clause, callback) ->
        @callback(callback) if (callback?)
        return @

    transport: (transport, callback) ->
        @callback(callback) if (callback?)
        return @

    throttle: (throttle, callback) ->
        @callback(callback) if (callback?)
        return @

    debounce: (debounce, callback) ->
        @callback(callback) if (callback?)
        return @
