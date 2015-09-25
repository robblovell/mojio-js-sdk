# version 4.0.0
Http = require './HttpNodeWrapper'
SignalR = require './SignalRNodeWrapper'
FormUrlencoded = require 'form-urlencoded'
_ = require 'underscore'
MojioRestSDK = require './MojioRestSDK'

module.exports = class MojioGroupingSDK extends MojioRestSDK

    constructor: (options={}) ->
        super(options)

    # grouping
    group: (name, callback) ->
        @callback(callback) if (callback?)
        return @

    add: (name, callback) ->
        @callback(callback) if (callback?)
        return @

    remove: (name, callback) ->
        @callback(callback) if (callback?)
        return @

    into: (callback) ->
        @callback(callback) if (callback?)
        return @

    outof: (callback) ->
        @callback(callback) if (callback?)
        return @
