_ = require 'underscore'
HttpNodeWrapper = require '../wrappers/nodejs/HttpWrapper'
MojioValidator = require './MojioValidator'

module.exports = class MojioSDKState
    state = {}

    accountsURL = "accounts.moj.io"
    pushURL = "push.moj.io"
    apiURL = "api.moj.io"
    defaultEndpoint = "api"

    # @nodoc
    constructor: (options = {environment: 'staging', version: 'v2'}) ->
        options.environment = 'staging' if !options.environment?
        options.version = 'v2' if !options.version?

        options.environment += '-' if options.environment != ''
        @endpoints = {
            accounts: { uri: "https://" + options.environment + accountsURL , encoding: true }
            api: { uri: "https://" + options.environment + apiURL + '/' + options.version, encoding: false }
            push: { uri: "https://" + options.environment + pushURL + '/' + options.version, encoding: false }
        }
        @validator = new MojioValidator()
        @reset()

    @_makeParameters: (params) ->
        '' if params.length==0
        query = '?'
        for property, value of params
            query += "#{encodeURIComponent property}=#{encodeURIComponent value}&"
        return query.slice(0,-1)

    getPath: (resource, id, action, key) ->
        if (key && id && action && id != '' && action != '')
            return "/" + encodeURIComponent(resource) + "/" + encodeURIComponent(id) + "/" + encodeURIComponent(action) + "/" + encodeURIComponent(key);
        else if (id && action && id != '' && action != '')
            return "/" + encodeURIComponent(resource) + "/" + encodeURIComponent(id) + "/" + encodeURIComponent(action);
        else if (id && id != '')
            return "/" + encodeURIComponent(resource) + "/" + encodeURIComponent(id);
        else if (action && action != '')
            return "/" + encodeURIComponent(resource) + "/" + encodeURIComponent(action);

        return "/" + encodeURIComponent(resource);

    # @nodoc
    # form the request and make the call
    initiate: (callback) =>
        if state.answer?
            callback(null, state.answer)
        else
            @validator.credentials(state.body)

            # the http wrapper holds the url, the token, and the encoding type for the endpoint.
            httpNodeWrapper = new HttpNodeWrapper(state.token,
                @endpoints[state.endpoint].uri,
                @endpoints[state.endpoint].encoding) # push, accounts, or api
            # the request needs at least method and resource.
            # parameters, method, headers, resource, id, action, key, body.
            httpNodeWrapper.request({
                    method: state.method,
                    resource: state.resource,
                    id: state.id,
                    action: state.action,
                    key: state.key,
                    body: state.body,
                    params: state.params
                }, callback)

    url: (bodyAsParameters = true) ->
        httpNodeWrapper = new HttpNodeWrapper(state.token,
            @endpoints[state.endpoint].uri, @endpoints[state.endpoint].encoding)
        url = httpNodeWrapper.url({
            method: state.method,
            resource: state.resource,
            id: state.id,
            action: state.action,
            key: state.key,
            body: if bodyAsParameters then "" else state.body,
            params: if bodyAsParameters then state.body else state.params
        })
        return url

#method: 'POST', resource: if @options.live then '/OAuth2/token' else '/OAuth2Sandbox/token',
#body:
#{
#    username: username
#    password: password
#    client_id: @options.application
#    client_secret: @options.secret
#    grant_type: 'password'
#}
    #
    show: () ->
        console.log(JSON.stringify(state))
        return state

    setToken: (token) ->
        state.token = token

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
        state.resource = resource

    # @nodoc
    setAction: (action) ->
        state.action = action

    setParams: (parameters) ->
        _.extend(state.parameters, parameters)

    setBody: (parameters) ->
        _.extend(state.body, parameters)
        return

    getBody: () ->
        return state.body

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

    fixup: () ->
    # remove capitals from fields and values in the state.
        for p, v of state
            lowP = p.toLowerCase()
            lowV = v.toLowerCase()
            state[lowP]= lowV
            delete state[p]

    # @nodoc
    reset: () ->
        state.answer = null # return this immediately if not null, otherwise make an api call.
        state.endpoint = defaultEndpoint
        state.method = null # GET, PUT, POST, DELETE
        state.resource = null # authorize, vehicle,
        state.id = null
        state.action = null
        state.key = null

        # parameters
        state.parameters = {}

        # GET
        state.operation = ""
        state.lmiit = 10
        state.offset = 0
        state.desc = false
        state.query = null


        # GET/DELETE
        # id, object example, query string, or array.
        state.type = "all"
        state.where = null

        # body
        # PUT/POST
        # can specify an object, json string
        state.body = {}