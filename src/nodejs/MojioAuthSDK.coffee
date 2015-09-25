# version 4.0.0
Http = require './HttpNodeWrapper'
SignalR = require './SignalRNodeWrapper'
FormUrlencoded = require 'form-urlencoded'
_ = require 'underscore'
MojioModelSDK = require './MojioModelSDK'

###
# Mojio's authentication sdk.
###

module.exports = class MojioAuthSDK extends MojioModelSDK
    defaults = { hostname: 'api2.moj.io', version: 'v2' }

    # Construct a MojioAuthSDK object.
    #
    # @param [object] options Configurable options for the sdk.
    constructor: (options={}) ->
        @configure(options)
        super(options)

    # Configure the SDK's options
    #
    # @example Basic Configuration
    #   configure({ hostname: 'api2.moj.io', version: 'v2' })
    # @param [object] options Configurable options for the sdk.
    # @return {object} this
    # @private
    configure: (options={}) ->
        _.extend(@, options)
        _.defaults(@, defaults)
        return @

    # A method that authorizes access to a user's data.  There are two ways to authorize users,
    # depending on whether the application is designed to be used by a consumer, or it is designed
    # as a server that users trust to act on their behalf.  Generally, this devides into two camps,
    # client applications for consumers or server applications for enterprise applications.  For
    # client applications, the user is redirected to mojio's authorization server which will collect
    # the user's password outside the application so that the user can give permission to or revoke
    # permission from the application to use their data.  For enterprise or server side applications,
    # the user's password is known to the application and can be sent directly to the authorization
    # server for verification. In both cases, the authorization server will return a token that will
    # be used to access the user's data.
    #
    # @param {object} authorization An object that contains the information needed to authorize a user.
    # @param {function} callback An optional parameter that will initiate the actions of the fluent chain,
    #   when the chain is completed, this function will be called with the results. In the case of a redirect
    #   control will be returned to the url given and you must call authorize again with the results
    #   until 'true' is given in the callback results.
    #
    # @example Client application for consumer authorization. Redirects to the authorization server within a browser and returns a token in a document.
    #   authorize({type: 'code', redirect_url: ''})
    # @example Server based authorization for trusted enterprise applications. Sends username and password with the application key directly to the authorization server.
    #   authorize({type: 'token', user: '', password: ''})
    # @return {object} this
    authorize: (authorization, callback) ->
        @callback(callback) if (callback?)
        return @

