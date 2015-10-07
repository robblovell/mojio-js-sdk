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
module.exports = class MojioAuthSDK
    defaults = {
        parseToken: ((result) ->  token = result)
        site: 'https://accounts.moj.io'
        tokenPath: '/oauth2/token'
        authorizationPath: '/oauth2/authorize'
    }
    token = null
    # Construct a MojioAuthSDK object.
    #
    # @example New MojioAuthSDK
    #   Mojio = new MojioAuthSDK({ version: 'v2' })
    # @param [object] options Configurable options for the sdk.
    # @option options [String] version api version to use 'v1' or 'v2't
    # @return {object} Returns a new MojioAuthSDK object
    # @nodoc
    constructor: (options={}) ->
        super()
        @configure(options, defaults)
        @user = null
        # set up the state variables needed for the Auth SDK
        @state.client = @client_id
        @state.secret = @client_secret
        @state.site = @site
        @state.tokenPath = @tokenPath
        @state.authorizationPath = @authorizationPath

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
    authorize: (redirect_url, implicit = false) ->
        # authorization_code or implicit flows (server or browser for end users/consumers.
        # {client_id:, response_type:, redirect_url:, scope:, realm:}, {type=token, user=, password=}
        @state.setMethod("POST")
        @state.setEndpoint("accounts")
        @state.setResource("oauth2")
        @state.setAction("authorize")
        if (@sdk_env == 'browser' or implicit)
            @state.setBody({response_type: 'token', redirect_uri: redirect_url, client_id: @client_id})
        else if (@sdk_env == 'nodejs')
            @state.setBody({response_type: 'code', redirect_uri: redirect_url, client_id: @client_id})
        return @
    # A method that un-authorizes access to a user's data, removing grants to data.
    # @return {object} this
    unauthorize: (redirect_url, implicit = false) ->
        # authorization_code or implicit flows (server or browser for end users/consumers.
        # {client_id:, response_type:, redirect_url:, scope:, realm:}, {type=token, user=, password=}
        @state.setMethod("POST")
        @state.setEndpoint("accounts")
        @state.setResource("oauth2")
        @state.setAction("authorize")
        if (@sdk_env == 'browser' or implicit)
            @state.setBody({response_type: 'token', redirect_uri: redirect_url, client_id: @client_id})
        else if (@sdk_env == 'nodejs')
            @state.setBody({response_type: 'code', redirect_uri: redirect_url, client_id: @client_id})

        return @

    # A method that logs the user out.
    # @return {object} this
    login: () ->
        @prompt ({prompt: 'login'})
        return @

    # A method that logs the user out.
    # @return {object} this
    consent: () ->
        @prompt ({prompt: 'consent'})
        return @

    # A method that logs the user out.
    # @return {object} this
    loginAndConsent: () ->
        @prompt ({prompt: 'consent,login'})
        return @

    prompt: (prompt) ->
        # both if alread set
        if (@state.getBody().prompt?) and
                (@state.getBody().prompt is 'login' and prompt.prompt is 'consent') or
                (@state.getBody().prompt is 'consent' and prompt.prompt is 'login')
            @state.setBody({prompt: 'consent,login'})
        # or as is.
        else
            @state.setBody(prompt)
        @state.show()
        return @
    # A method that returns an authorization token after authorization
    #
    # @param {string} The response from the authorization workflow.
    #
    # @example Get the token after returning from a consumer application's redirect to the authorization server
    # apitoken = token( document.location.hash.match(/access_token=([0-9a-f-]{36})/)) )
    # @return {string} token
    # password or refresh flow, second half of authorization code flow
    token: () ->
        redirect_uri = @state.getBody().redirect_uri
        console.log(@state.url())
        @state.setMethod("POST")
        @state.setEndpoint("accounts")
        @state.setResource("oauth2")
        @state.setAction("token")
        @state.setBody({ client_id: @client_id, client_secret: @client_secret })
        @state.setBody({ redirect_uri: redirect_uri}) if redirect_uri?
        return @

    # password flow
    credentials: (username_or_credentials, password=null) ->
        if (typeof username_or_credentials is 'object')
            credentails=username_or_credentials
        else
            credentails={ username: username_or_credentials, password: password, grant_type: 'password' }
        @validator.credentials(credentails)
        @state.setBody(credentails)
        return @

    # second half of authorization code flow, or parse of the return from the implicit flow
    parse: (return_url, redirect_uri=null) ->
        if (return_url.query.code and redirect_uri?)
            code = return_url.query.code

            @state.setBody({
                code: code,
                grant_type: 'authorization_code'
            })
            @state.setBody({ redirect_uri: redirect_uri}) if redirect_uri?
        else
            # todo:: set the token for implicit flow.
            @state.setToken(req.query.access_token)
            @state.setAnswer(req.query.access_token)
        return @
    code: (req) ->
        code = req.query.code
        @state.setBody( { authorization_code: code })
        return @

    # refresh flow.
    refresh: (refresh_token) ->
        @state.setBody({ refresh_token: 'some code', grant_type: 'refresh_token' })
        return @

    scope: (scopes) ->
        @validator.validateScope(scopes, @scopes)
        param = ''
        scopes.map (scope) -> param+=scope+' '
        @state.setBody({ scope: param.slice(0,-1) })
        return @

#    realm: (realm) ->
#        @state.setParams({ realm: realm })
#        return @

    url: () ->
        console.log("URL: #{JSON.stringify(@state.url())}")
        return @state.url()

    redirect: (redirectFunction) ->
        redirectFunction.redirect(@url())
        return @

    username: (username) ->
        @state.setBody({ username: username})
        return @

    email: (email) ->
        @state.setBody({ username: email})
        return @

    password: (password) ->
        @state.setBody({ password: password })
        return @

    with: (usernameOrEmail, password) ->
        @state.setBody({ username: usernameOrEmail, password: password })
        return @

