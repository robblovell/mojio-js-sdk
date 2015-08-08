# version 4.0.0
Http = require './HttpNodeWrapper'
SignalR = require './SignalRNodeWrapper'
FormUrlencoded = require 'form-urlencoded'
_ = require 'underscore'

module.exports = class MojioAuthSDK
    defaults = { hostname: 'api2.moj.io', version: 'v2' }

    constructor: (options={}) ->
        @configure(options)

    ###
     * @private
     * @examples
     * configure()     // => { hostname: 'api2.moj.io', port: '443', version: 'v2', scheme: 'https' }
    ###
    configure: (options={}) ->
        _.extend(@, options)
        _.defaults(@, defaults)

    authorize: (authorization, callback) ->
        @callback(callback) if (callback?)
        return @

    callback: (callback) ->

        callback(null, true)
        return @