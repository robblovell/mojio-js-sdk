# version 4.0.0
Http = require './HttpNodeWrapper'
SignalR = require './SignalRNodeWrapper'
FormUrlencoded = require 'form-urlencoded'
_ = require 'underscore'
MojioAuthSDK = require './MojioAuthSDK'

module.exports = class MojioRestSDK extends MojioAuthSDK
    defaults = { hostname: 'api2.moj.io', version: 'v2' }

    constructor: (options={}) ->
        super(options)

    mock: (callback) ->
        @callback(callback) if (callback?)
        return @

    save: (callback) -> # PUT or POST depending on if it exists
        @callback(callback) if (callback?)
        return @

    update: (callback) -> # PUT, throw error if it doesn't exist
        @callback(callback) if (callback?)
        return @

    create: (callback) -> # POST, throw error if it already exists
        @callback(callback) if (callback?)
        return @

    query: (callback) -> # GET
        @callback(callback) if (callback?)
        return @

    destroy: (callback) -> # DELETE
        @callback(callback) if (callback?)
        return @

    for: (user, callback) ->
        @callback(callback) if (callback?)
        return @

    users: (callback) ->
        @callback(callback) if (callback?)
        return @

    user: (user, callback) ->
        @callback(callback) if (callback?)
        return @

    vehicles: (callback) ->
        @callback(callback) if (callback?)
        return @

    vehicle: (vehicle, callback) ->
        @callback(callback) if (callback?)
        return @

    mojios: (callback) ->
        @callback(callback) if (callback?)
        return @

    mojio: (mojio, callback) ->
        @callback(callback) if (callback?)
        return @

    trips: (callback) ->
        @callback(callback) if (callback?)
        return @


