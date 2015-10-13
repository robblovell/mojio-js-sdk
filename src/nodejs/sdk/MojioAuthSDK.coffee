# version 4.0.0
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
    defaults = {
    }
    styleParameters = ['callback', 'promise', 'sync', 'subscribe', 'observable', 'async']
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

    setup = (parameters, match, name) =>
        if typeof parameters is 'object'
            for property,value of parameters
                if (property in match)
                    eval("this."+property)(value)
                else
                    throw new error "Parameter not used in "+name+" flow: "+property

    (authorizeParameters = ['username', 'password', 'credentials', 'scope', 'email'])
    .push styleParameters...
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
    authorize: (redirect_url, implicit = null) ->

        # authorization_code or implicit flows (server or browser for end users/consumers.
        # {client_id:, response_type:, redirect_url:, scope:, realm:}, {type=token, user=, password=}
        if !implicit?
            implicit = document?

        setup(redirect_url, authorizeParameters, 'authorize')

        @state.setMethod("POST")
        @state.setEndpoint("accounts")
        @state.setResource("oauth2")
        @state.setAction("authorize")
        if (@sdk_env == 'browser' or implicit)
            @state.setBody({response_type: 'token', redirect_uri: redirect_url, client_id: @client_id})
        else if (@sdk_env == 'nodejs')
            @state.setBody({response_type: 'code', redirect_uri: redirect_url, client_id: @client_id})
        return @

    (unauthorizeParameters = ['login', 'consent', 'loginAndConsent', 'prompt', 'parse', 'code'])
        .push styleParameters...
    # A method that un-authorizes access to a user's data, removing grants to data. Parameters to
    # this function
    # @param {string} redirect_url where to redirect if the user logs in again using the
    # oauth page retrieved as a result of the prompt specified.
    # @example Log the user out, but keep permissions for this application
    # sdk.unauthorize("http://localhost:3000/callback").login().callback(...)
    # @example Log the user out, and deny permissions for this application
    # sdk.unauthorize("http://localhost:3000/callback").login().consent().callback(...)
    # @return {object} this
    unauthorize: (redirect_url, implicit = null) ->
        if (document? and !implict?)
            implicit = true
        else
            implicit = false
        setup(redirect_url, unauthorizeParameters, 'unauthorize')

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

    (tokenParameters= [])
        .push authorizeParameters...

    # A method that returns an authorization token after authorization has returned a code. Used in
    # combination with 'parse', 'refresh', and 'password' to implement completion of an authorization
    # workflow.  Parse is used in conjunction with code and implicit flows, call authorize first, then
    # after the redirect call token().parse(response). Password with token implements the 'password'
    # authorization flow for server based authorization where the server is also the owner of the
    # resources (the user account that will be accessing the vehicles, mojios, and trips for that user
    # account and no one else). This would be token().password('username', 'password') and is done without
    # a prior 'authorize' call.  Refresh is used to refresh already active tokens, giving them an
    # extended expiration timespan, token().refresh().
    #
    # @param redirect_url {string} The response from the authorization workflow.
    #
    # @example Get the token after returning from a consumer application's redirect to the authorization server
    # sdk.token().parse(document.location.hash.match(/access_token=([0-9a-f-]{36})/)) )
    # @example Get the token after returning from an implicit flow
    # sdk.token().parse(response).callback(...)
    # @example Refresh the internal sdk stored token
    # sdk.token().refresh().callback(...)
    # @example Refresh the an arbitrary token
    # sdk.token().refresh(some_token_object).callback(...)
    # @return {object} this
    token: (redirect_url=null) ->
        if (redirect_url?)
            if !setup(redirect_url, tokenParameters, 'token')
                redirect_uri = redirect_url
            else
                redirect_uri = @state.getBody().redirect_uri
        @state.setMethod("POST")
        @state.setEndpoint("accounts")
        @state.setResource("oauth2")
        @state.setAction("token")
        @state.setBody({ client_id: @client_id, client_secret: @client_secret })
        @state.setBody({ redirect_uri: redirect_uri}) if redirect_uri?
        return @

    # second half of authorization code flow, or parse of the return from the implicit flow
    parse: (return_url) ->
        if (return_url? and return_url.query? and return_url.query.code?)
            code = return_url.query.code
            @state.setBody({
                code: code,
                grant_type: 'authorization_code'
            })
            @state.setCallback((error, result) =>
                if (error)
                    console.log('Access Token Error', JSON.stringify(error.content)+"  message:"+error.statusMessage)
                else
                    # recover the token
                    @state.setToken(result)
            )
        else
            if (return_url.location.hash== "")
                @state.setAnswer("")
            else if (return_url.location.hash?)
                @state.setToken(return_url.location.hash)
                @state.setAnswer(return_url.location.hash)
        return @

    # A method that refreshes an authorization token, gives it more active time. Actually, a new token is returned
    # when a refresh call is made.
    #
    # @param refresh_token {object} The authorization-token object's refresh token returned from the authorization/token workflow.
    # the authorization token returned from the authorization workflow is an object that has several fields, one of
    # which is labeled "refresh_token". All of this is cached in the sdk, but you can pass a valid refresh token in, a
    # in a new token will be returned.
    #
    # @example Get the token after returning from a consumer application's redirect to the authorization server
    # sdk.token("http://localhost:3000/callback").refresh().callback(...)
    # @return {string} token
    # password or refresh flow, second half of authorization code flow
    refresh: (refresh_token) ->
        @state.setBody({ refresh_token: refresh_token, grant_type: 'refresh_token' })
        return @

    # A method that specifies that when unauthorize is initiated, the user should be logged out of
    # the application. The application will still have permission to access the user's resources
    # when they log in again with 'authorize'.
    # @example Log the user out and do not deny permissions, go to the oauth2 login prompt
    # sdk.unauthorize("http://localhost:3000/callback").login().callback(...)
    # @return {object} this
    login: () ->
        @prompt ({prompt: 'login'})
        return @

    # A method that specifies that when unauthorize is initiated, the application will no longer have
    # access to the user's resources.
    # @example Deny permissions and go to the oauth2 consent prompt.
    # sdk.unauthorize("http://localhost:3000/callback").loginAndConsent().callback(...)
    # @return {object} this
    consent: () ->
        @prompt ({prompt: 'consent'})
        return @

    # A method that specifies that when unauthorize is initiated, the user should be logged out. The
    # application will also be denied permission to access the user's resources when they log in again
    # with 'authorize' unless permission is given by the user again.
    # @example Log the user out and deny permissions.  Go through the oauth2 login and consent prompts.
    # sdk.unauthorize("http://localhost:3000/callback").loginAndConsent().callback(...)
    # @return {object} this
    loginAndConsent: () ->
        @prompt ({prompt: 'consent,login'})
        return @

    # A helper method to set the body of the REST uri for login and consent calls. Can be used
    # instead of login, consent, or loginAndConsent calls
    # @example Set the unauthorize chain to 'login' and 'consent'
    # sdk.unauthorize("http://localhost:3000/callback").prompt({prompt: 'consent, login'}).callback(...)
    # sdk.unauthorize("http://localhost:3000/callback").prompt('consent, login').callback(...)
    # sdk.unauthorize("http://localhost:3000/callback").prompt(['consent', 'login']).callback(...)
    # sdk.unauthorize("http://localhost:3000/callback").prompt('login').callback(...)
    # @param prompt {object, array, or string} object: {prompt: 'login,consent'}, array: ['login','consent'], string:'login,consent'.
    # @return {object} this
    prompt: (prompt) ->
        if ((@state.getBody().prompt?) and
            ((@state.getBody().prompt is 'login' and prompt.prompt is 'consent' or prompt is 'consent') or
             (@state.getBody().prompt is 'consent' and prompt.prompt is 'login' or prompt is 'login')))
            @state.setBody ({prompt: 'consent,login'})
        else if (typeof prompt is 'string')
            @state.setBody ({prompt: prompt})
        else if (prompt instanceof Array )
            @state.setBody ({prompt: prompt.join()})
        # or as is.
        else
            @state.setBody (prompt)
        return @

    # Set the scope of the authorization workflow. The user will be asked for consent of the given 'scope'
    # for the application to have access to their resources.
    # @param scopes {array or string} Array of scopes, or a space separated list of scopes in a string.
    scope: (scopes) ->
#        @validator.validateScope(scopes, @scopes)
        if (typeof scopes is 'string')
            param = scopes.replace(/,/g,' ') # remove commas if given.
            @state.setBody({scope: param })
        else
            param = ''
            scopes.map (scope) -> param+=scope+' '
            @state.setBody({ scope: param.slice(0,-1) })
        return @

    # Set the username for a server side, resource owner 'password' authorization workflow.
    # @param username {string} The username to use for the password authorization.
    # @return {object} this
    username: (username) ->
        @state.setBody({ username: username})
        return @

    # Set the email for a server side, resource owner 'password' authorization workflow.
    # @param email {string} The email to use for the password authorization.
    # @return {object} this
    email: (email) ->
        @state.setBody({ username: email})
        return @

    # Set the password for a server side, resource owner 'password' authorization workflow.
    # @param password {string} The password to use for the password authorization.
    # @return {object} this
    password: (password) ->
        @state.setBody({ password: password })
        return @

    # This call is used to specify both username and password for an authorization workflow.
    # @param usernameOrEmail_or_credentials {string or object} In the case of a string, this is the
    # username. In the case of an object, it's both username and password given in the following
    # format: {username: '', password: ''}
    # @param password {string} The password if username and password aren't given in the first parameter.
    # @return {object} this
    credentials: (usernameOrEmail_or_credentials, password=null) ->
        if (typeof usernameOrEmail_or_credentials is 'object')
            credentials=usernameOrEmail_or_credentials
        else
            credentials={ username: usernameOrEmail_or_credentials, password: password }
        @state.validator.credentials(credentials)
        credentials['grant_type'] = 'password'
        @state.setBody(credentials)
        return @

    # Synonym for the credentials() call.
    # @param username_or_credentials {string or object} In the case of a string, this is the
    # username. In the case of an object, it's both username and password given in the following
    # format: {username: '', password: ''}
    # @param password {string} The password if username and password aren't given in the first parameter.
    # @return {object} this
    with: (usernameOrEmail_or_credentials, password=null) ->
        return @credentials(usernameOrEmail_or_credentials, password)


