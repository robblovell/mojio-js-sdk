#_ = require 'underscore'
HttpWrapper = require '../wrappers/HttpWrapper'
MojioValidator = require './MojioValidator'
# @nodoc
module.exports = class MojioSDKState

    accountsURL = "accounts.moj.io"
    pushURL = "push.moj.io"
    apiURL = "api2.moj.io"
    defaultEndpoint = "api"

    # @nodoc
    constructor: (options = {environment: '', version: 'v2'}) ->
        @_state = {}
        @options = {}
        @options[p] = v for p,v of options

        @options.environment = '' if !@options.environment?
        @options.version = 'v2' if !@options.version?
        @options.environment += '-' if @options.environment != ''
        @options.accountsURL = accountsURL if !@options.accountsURL
        @options.apiURL = apiURL if !@options.apiURL
        @options.pushURL = pushURL if !@options.pushURL
        @endpoints = {
            accounts: { uri: "https://" + @options.environment + @options.accountsURL , encoding: true }
            api: { uri: "https://" + @options.environment + @options.apiURL + '/' + @options.version, encoding: false }
            push: { uri: "https://" + @options.environment + @options.pushURL + '/' + @options.version, encoding: false }
        }
        @validator = new MojioValidator()
        @reset()

#    @_makeParameters: (params) ->
#        '' if params.length==0
#        query = '?'
#        for property, value of params
#            query += "#{encodeURIComponent property}=#{encodeURIComponent value}&"
#        return query.slice(0,-1)
#
#    getPath: (resource, id, action, key) ->
#        if (key && id && action && id != '' && action != '')
#            return "/" + encodeURIComponent(resource) + "/" + encodeURIComponent(id) + "/" + encodeURIComponent(action) + "/" + encodeURIComponent(key);
#        else if (id && action && id != '' && action != '')
#            return "/" + encodeURIComponent(resource) + "/" + encodeURIComponent(id) + "/" + encodeURIComponent(action);
#        else if (id && id != '')
#            return "/" + encodeURIComponent(resource) + "/" + encodeURIComponent(id);
#        else if (action && action != '')
#            return "/" + encodeURIComponent(resource) + "/" + encodeURIComponent(action);
#
#        return "/" + encodeURIComponent(resource);

    # @nodoc
    # form the request and make the call
    initiate: (callback) =>
        if @_state.mock
            callback(null, { id: "1" })
        else
            callbacks = (error, result) =>
                @_state.callback(error, result) if (@_state.callback?)
                callback(error,result) if (callback)
    
            if @_state.answer?
                callbacks(null, @_state.answer)
            else
    #            @validator.credentials(@_state.body)
    
                # the http wrapper holds the url, the token, and the encoding type for the endpoint.
                httpWrapper = new HttpWrapper(@_state.token,
                    @endpoints[@_state.endpoint].uri,
                    @endpoints[@_state.endpoint].encoding) # push, accounts, or api
                # the request needs at least method and resource.
                # parameters, method, headers, resource, id, action, key, body.
                httpWrapper.request(@parts(false), callbacks)
            @reset()
    # @nodoc
    redirect: (redirectClass=null) =>
        httpWrapper = new HttpWrapper(@_state.token,
            @endpoints[@_state.endpoint].uri, @endpoints[@_state.endpoint].encoding)
        httpWrapper.redirect(@parts(true), redirectClass)

    # @nodoc
    url: (bodyAsParameters = true) ->
        httpWrapper = new HttpWrapper(@_state.token,
            @endpoints[@_state.endpoint].uri,
            @endpoints[@_state.endpoint].encoding)
        url = httpWrapper.url(@parts(bodyAsParameters))
        return url

    # @nodoc
    parts: (bodyAsParameters = true) ->
        return {
            method: @_state.method,
            resource: @_state.resource,
            pid: @_state.pid,
            action: @_state.action,
            sid: @_state.sid,
            object: @_state.object,
            tid: @_state.tid,
            body: if bodyAsParameters then "" else @_state.body,
            params: if bodyAsParameters then @_state.body else @_state.params
        }

#method: 'POST', resource: if @options.live then '/OAuth2/token' else '/OAuth2Sandbox/token',
#body:
#{
#    username: username
#    password: password
#    client_id: @options.application
#    client_secret: @options.secret
#    grant_type: 'password'
#}
    # @nodoc
    show: () ->
#        console.log(JSON.stringify(@_state))
        return @_state

    # @nodoc
    setCallback: (callback) =>
        @_state.callback = callback
        return

    # @nodoc
    setToken: (token) ->
        @_state.token = token
        return

    getToken: () ->
        return @_state.token
    # @nodoc
    setAnswer: (token) ->
        @_state.answer = token

    # @nodoc
    setBody_ObjectOrJson: (object_or_json_string) ->
        switch typeof object_or_json_string
            when "string"
                @_state.body = object_or_json_string
            when "object"
                @_state.body = object_or_json_string
        return @_state

    # @nodoc
    setEndpoint: (endpoint) ->
        validateEndpoint = (endpoint, endpoints) =>
            found = false
            for name, value of endpoints
                if (endpoint == name)
                    found = true; break

            throw "Endpoint must be accounts, api, or push" if !found
            return found
        if validateEndpoint(endpoint, @endpoints)
            @_state.endpoint = endpoint

    # @nodoc
    setMethod: (method) ->
        @reset()
        @_state.method = method

    # @nodoc
    setResource: (resource) ->
        if @_state.resource == 'Groups'
            @setObject(resource)
        else
            @_state.resource = resource

    # @nodoc
    setObject: (object) ->
        @_state.object = object

    # @nodoc
    setAction: (action) ->
        @_state.action = action

    # @nodoc
    setParams: (parameters) ->
        for property, value of parameters
            @_state.parameters[property] = value
#        _.extend(@_state.parameters, parameters)

# @nodoc
    setBody: (parameters) ->
        for property, value of parameters
            @_state.body[property] = value
#        _.extend(@_state.body, parameters)
        return

    setId: (id) ->
        @setPrimaryId(id)

    setPrimaryId: (id) ->
        @_state.pid = id

    setSecondaryId: (id) ->
        @_state.sid = id

    setTertiaryId: (id) ->
        @_state.tid = id

    # @nodoc
    getBody: () ->
        return @_state.body

    # @nodoc
    getParams: () ->
        return @_state.parameters

    # @nodoc
    setWhere: (id_example_or_query) ->
        @_state.type = "all"
        @_state.where = null

        if (id_example_or_query != null)
            switch typeof id_example_or_query
                when "number"
                    @_state.type = "id"
                    @_state.where = id_example_or_query
                when "string"
                    @_state.type = "query"
                    @_state.where = id_example_or_query
                when "object"
                    @_state.type = "example"
                    @_state.where = id_example_or_query
                else
                    @_state.type = "query"
                    @_state.where = id_example_or_query
        return @_state

    # @nodoc
    fixup: () ->
        # remove capitals from fields and values in the @_state.
        for p, v of @_state
            lowP = p.toLowerCase()
            lowV = v.toLowerCase()
            @_state[lowP]= lowV
            delete @_state[p]

    mock: () ->
        @_state.mock = true

    # @nodoc
    reset: () ->
        @_state.mock = false
        @_state.callback = null
        @_state.answer = null # return this immediately if not null, otherwise make an api call.
        @_state.endpoint = defaultEndpoint
        @_state.method = "GET" # GET, PUT, POST, DELETE
        @_state.resource = "Vehicles" # authorize, vehicle,
        @_state.pid = null
        @_state.sid = null
        @_state.tid = null
        @_state.action = null
        @_state.object = null

        # parameters
        @_state.parameters = {}

        # GET
        @_state.operation = ""
        @_state.limit = 10
        @_state.offset = 0
        @_state.desc = false
        @_state.query = null
        @_state.field = null
        @_state.fields = null

        # GET/DELETE
        # id, object example, query string, or array.
        @_state.type = "all"
        @_state.where = null

        # body
        # PUT/POST
        # can specify an object, json string
        @_state.body = {}