#_ = require 'underscore'
HttpWrapper = require '../wrappers/HttpWrapper'
MojioValidator = require './MojioValidator'
# @nodoc
module.exports = class MojioSDKState
    state = {}

    accountsURL = "accounts.moj.io"
    pushURL = "push.moj.io"
    apiURL = "api2.moj.io"
    defaultEndpoint = "api"

    # @nodoc
    constructor: (options = {environment: '', version: 'v2'}) ->
        options.environment = '' if !options.environment?
        options.version = 'v2' if !options.version?

        options.environment += '-' if options.environment != ''
        @endpoints = {
            accounts: { uri: "https://" + options.environment + accountsURL , encoding: true }
            api: { uri: "https://" + options.environment + apiURL + '/' + options.version, encoding: false }
            push: { uri: "https://" + options.environment + pushURL + '/' + options.version, encoding: false }
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
        callbacks = (error, result) ->
            state.callback(error, result) if (state.callback?)
            callback(error,result) if (callback)

        if state.answer?
            callbacks(null, state.answer)
        else
#            @validator.credentials(state.body)

            # the http wrapper holds the url, the token, and the encoding type for the endpoint.
            httpWrapper = new HttpWrapper(state.token,
                @endpoints[state.endpoint].uri,
                @endpoints[state.endpoint].encoding) # push, accounts, or api
            # the request needs at least method and resource.
            # parameters, method, headers, resource, id, action, key, body.
            httpWrapper.request(@parts(false), callbacks)
        @reset()
    # @nodoc
    redirect: (redirectClass=null) =>
        httpWrapper = new HttpWrapper(state.token,
            @endpoints[state.endpoint].uri, @endpoints[state.endpoint].encoding)
        httpWrapper.redirect(@parts(true), redirectClass)

    # @nodoc
    url: (bodyAsParameters = true) ->
        httpWrapper = new HttpWrapper(state.token,
            @endpoints[state.endpoint].uri, @endpoints[state.endpoint].encoding)
        url = httpWrapper.url(@parts(bodyAsParameters))
        return url

    # @nodoc
    parts: (bodyAsParameters = true) ->
        return {
            method: state.method,
            resource: state.resource,
            pid: state.pid,
            action: state.action,
            sid: state.sid,
            object: state.object,
            tid: state.tid,
            key: state.key,
            body: if bodyAsParameters then "" else state.body,
            params: if bodyAsParameters then state.body else state.params
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
        console.log(JSON.stringify(state))
        return state

    # @nodoc
    setCallback: (callback) ->
        state.callback = callback
        return

    # @nodoc
    setToken: (token) ->
        state.token = token
        return

    # @nodoc
    setAnswer: (token) ->
        state.answer = token

    # @nodoc
    setObject: (object_or_json_string) ->
        switch typeof object_or_json_string
            when "string"
                state.body = object_or_json_string
            when "object"
                state.body = JSON.stringify(object_or_json_string)
        return state

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
            state.endpoint = endpoint

    # @nodoc
    setMethod: (method) ->
        @reset()
        state.method = method

    # @nodoc
    setResource: (resource) ->
        if state.resource == 'Groups'
            @setObject(resource)
        else
            state.resource = resource

    # @nodoc
    setObject: (object) ->
        state.object = object

    # @nodoc
    setAction: (action) ->
        state.action = action

    # @nodoc
    setParams: (parameters) ->
        for property, value of parameters
            state.parameters[property] = value
#        _.extend(state.parameters, parameters)

# @nodoc
    setBody: (parameters) ->
        for property, value of parameters
            state.body[property] = value
#        _.extend(state.body, parameters)
        return

    setId: (id) ->
        @setPrimaryId(id)

    setPrimaryId: (id) ->
        state.pid = id

    setSecondaryId: (id) ->
        state.sid = id

    setTertiaryId: (id) ->
        state.tid = id

    # @nodoc
    getBody: () ->
        return state.body

    # @nodoc
    getParams: () ->
        return state.parameters

    # @nodoc
    setWhere: (id_example_or_query) ->
        state.type = "all"
        state.where = null

        if (id_example_or_query != null)
            switch typeof id_example_or_query
                when "number"
                    state.type = "id"
                    state.where = id_example_or_query
                when "string"
                    state.type = "query"
                    state.where = id_example_or_query
                when "object"
                    state.type = "example"
                    state.where = id_example_or_query
                else
                    state.type = "query"
                    state.where = id_example_or_query
        return state

    # @nodoc
    fixup: () ->
        # remove capitals from fields and values in the state.
        for p, v of state
            lowP = p.toLowerCase()
            lowV = v.toLowerCase()
            state[lowP]= lowV
            delete state[p]

    mock: () ->
        state.mock = true

    # @nodoc
    reset: () ->
        state.mock = false
        state.callback = null
        state.answer = null # return this immediately if not null, otherwise make an api call.
        state.endpoint = defaultEndpoint
        state.method = "GET" # GET, PUT, POST, DELETE
        state.resource = "Vehicles" # authorize, vehicle,
        state.pid = null
        state.sid = null
        state.tid = null
        state.action = null
        state.key = null

        # parameters
        state.parameters = {}

        # GET
        state.operation = ""
        state.limit = 10
        state.offset = 0
        state.desc = false
        state.query = null
        state.field = null
        state.fields = null

        # GET/DELETE
        # id, object example, query string, or array.
        state.type = "all"
        state.where = null

        # body
        # PUT/POST
        # can specify an object, json string
        state.body = {}