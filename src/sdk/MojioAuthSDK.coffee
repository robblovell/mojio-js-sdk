# version 4.0.0
#Http = require './HttpNodeWrapper'
FormUrlencoded = require 'form-urlencoded'
_ = require 'underscore'
MojioModelSDK = require './MojioModelSDK'

# The authentication segment of the Mojio SDK. Authentication is accomplished through the use of a Mojio OAuth server.
# Consumer applications authenticate by redirecting to the OAuth server and waiting for a redirect back to the application's
# authentication return url.  Once the authentication server has validated the user's credentials it passes back a token
# through the redirect url to the consumer application.
#
# For server applications that have their own username and password within the Mojio API, the OAuth server provides a means
# to directly authenticate the server with it's credentials with a direct client-server request.
#
# @example
#   mojioAuthSdk = new MojioSDK({sdk: MojioAuthSDK}) # instantiate the mojioSDK to do only authentication methods.
#
module.exports = class MojioAuthSDK extends MojioModelSDK
    defaults = { hostname: 'api2.moj.io', version: 'v2' }

    # Construct a MojioAuthSDK object.
    #
    # @example New MojioAuthSDK
    #   Mojio = new MojioAuthSDK({ version: 'v2' })
    # @param [object] options Configurable options for the sdk.
    # @option options [String] version api version to use 'v1' or 'v2't
    # @return {object} Returns a new MojioAuthSDK object
    # @nodoc
    constructor: (options={}) ->
        @configure(options)
        super()

    # Configure the SDK's options
    #
    # @example Basic Configuration
    #   configure({ version: 'v2' })
    # @param [object] options Configurable options for the sdk.
    # @option options [String] version api version to use 'v1' or 'v2't
    # @return {object} this
    # @private
    # @nodoc
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
    #
    # @example Client application for consumer authorization. Redirects to the authorization server within a browser and returns a token in a document.
    #   authorize({type: 'code', redirect_url: ''})
    # @example Server based authorization for trusted enterprise applications. Sends username and password with the application key directly to the authorization server.
    #   authorize({type: 'token', user: '', password: ''})
    # @return {object} this
    authorize: (authorization) ->
        return @

    # A method that returns an authorization token after authorization
    #
    # @param {string} The response from the authorization workflow.
    #
    # @example Get the token after returning from a consumer application's redirect to the authorization server
    # apitoken = token( document.location.hash.match(/access_token=([0-9a-f-]{36})/)) )
    # @return {string} token
    token: (response) ->
        return "token"

