# version 4.0.0
Http = require './HttpNodeWrapper'
SignalR = require './SignalRNodeWrapper'
FormUrlencoded = require 'form-urlencoded'
_ = require 'underscore'
MojioGroupingSDK = require './MojioGroupingSDK'

module.exports = class MojioSharingSDK extends MojioGroupingSDK

    constructor: (options={}) ->
        super(options)

    # sharing and access
    share: (user, callback) ->
        @callback(callback) if (callback?)
        return @

    with: (user, callback) ->
        @callback(callback) if (callback?)
        return @

    access: (rules, callback) ->
        @callback(callback) if (callback?)
        return @

    revoke: (user, callback) ->
        @callback(callback) if (callback?)
        return @

    from: (user, callback) ->
        @callback(callback) if (callback?)
        return @
