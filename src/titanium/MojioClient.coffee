# version 3.5.2
Http = require './HttpTitaniumWrapper'
SignalR = require './SignalRTitaniumWrapper'
FormUrlencoded = require 'form-urlencoded'

module.exports = class MojioClient

    defaults = {
        hostname: 'api.moj.io', authUrl: 'accounts.moj.io',
        port: '443', version: 'v2', scheme: 'https',
        signalr_scheme: 'https', signalr_port: '443',
        signalr_hub: 'ObserverHub', live: true
    }

    constructor: (@options) ->
        @options ?= { hostname: @defaults.hostname, port: @defaults.port, version: @defaults.version, scheme: @defaults.scheme, live: @defaults.live }
        @options.hostname ?= defaults.hostname
        @options.authUrl ?= defaults.authUrl
        @options.port ?= defaults.port
        @options.version ?= defaults.version
        @options.scheme ?= defaults.scheme
        @options.signalr_port ?= defaults.signalr_port
        @options.signalr_scheme ?= defaults.signalr_scheme
        @options.signalr_hub ?= defaults.signalr_hub
        @options.observerTransport = 'SingalR'
        @conn = null
        @hub = null
        @connStatus = null
        @setToken(null)
        @options.tokenRequester ?= @getTokenId()
        @options.tokenRequesterImplicit ?= (() -> return null)

        @signalr = new SignalR(@options.signalr_scheme+"://"+@options.hostname+":"+@options.signalr_port+"/v1/signalr",[@options.signalr_hub])

    ###
        Helpers
    ###
    getResults: (type, results) ->
        objects = []
        if (results instanceof Array)
            arrlength = results.length;
            objects.push(new type(result)) for result in results
        else if (results.Data instanceof Array)
            arrlength = results.Data.length;
            objects.push(new type(result)) for result in results.Data
        else if ((result.Data != null))
            objects.push(new type(result.Data))
        else
            objects.push(new type(result))

        return objects


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

    dataByMethod: (data, method) ->
        switch (method.toUpperCase())
            when 'POST' or 'PUT' then return @stringify(data)
            else return data

    stringify: (data) ->
        return JSON.stringify(data)

    request: (request, callback, isOauth = false) ->
        if (isOauth is null)
            isOauth = false

        parts = {
            hostname: @options.hostname
            port: @options.port
            scheme: @options.scheme
            path: (if isOauth then '' else '/' + @options.version)
            method: request.method,
            withCredentials: false
        }
        if (isOauth)
            parts.hostname = @options.authUrl
        parts.host = parts.hostbame
        parts.path = parts.path + @getPath(request.resource, request.id, request.action, request.key)

        if (request.parameters? and Object.keys(request.parameters).length > 0)
            parts.path += MojioClient._makeParameters(request.parameters)

        parts.headers = {}
        parts.headers["MojioAPIToken"] = @getTokenId() if @getTokenId()?
        parts.headers += request.headers if (request.headers?)
        #parts.headers["Access-Control-Allow-Credentials"] = 'true'
        parts.headers["Content-Type"] = 'application/json'

        if (request.body?)
            if (isOauth)
                parts.body = FormUrlencoded.encode(request.body)
            else
                parts.body = request.body

        http = new Http()
        http.request(parts, callback)

    ###
        Authorize and Login
    ###
    login_resource: 'Login'
    auth_response_type: 'token'

    authorize: (redirect_url, type="token", scope='full', state=null, callback) ->
        @auth_response_type = type
        if (@options? and @options.secret? and @options.username? and @options.password?)
            @_login(@options.username, @options.password, callback)
        else
            parts = {
                hostname: @options.authUrl
                port: @options.port
                scheme: @options.scheme
                path: if @options.live then '/OAuth2/authorize' else '/OAuth2Sandbox/authorize'
                method: 'Get'
                withCredentials: false
            }
            parts.path += "?response_type="+type
            parts.path += "&client_id=" + @options.application
            parts.path += "&redirect_uri="+redirect_url

            if (scope)
                parts.path += "&scope=" + scope

            if (state)
                parts.path += "&state="+state

            parts.headers = {}
            parts.headers["MojioAPIToken"] = @getTokenId() if @getTokenId()?
            parts.headers["Content-Type"] = 'application/json'

            # url = parts.scheme+"://"+parts.host+":"+parts.port+parts.path
            http = new Http();
            http.redirect(parts, (error, result) ->
                @setToken(result)
                return if (!callback?)
                callback(error, null) if error?
                callback(null, result)
            )

    token: (callback) ->
        @user = null

        token1 = @options.tokenRequester()
        match1 = !!token1&& token1[1]
        token2 = @options.tokenRequesterImplicit()
        match2 = !!token2&& token2[1]
        match = match1 || match2
        if (!match)
            callback("token for authorization not found.", null)
        else if (@auth_response_type is "token" || @auth_response_type is "password")
            @setToken(match)
            return callback(null, match);
        else
            # get the user id by requesting login information, then set the auth_token:
            @request(
                {
                    method: 'GET', resource: @login_resource, id: match
                },
            (error, result) =>
                if error
                    callback(error, null)
                else
                    @setToken(result)
                    callback(null, @getToken())
            )

    unauthorize: (callback) ->
        if (@options? and @options.secret? and @options.username? and @options.password?)
            @_logout(callback)
        else if (@options? and @options.secret? and @options.application?)
            @_logout(callback)
        else
            @setToken(null)
            callback(null, "ok")

    _login: (username, password, callback) -> # Use if you want the raw result of the call.
        @request(
            {
                method: 'POST', resource: if @options.live then '/OAuth2/token' else '/OAuth2Sandbox/token',
                body:
                    {
                        username: username
                        password: password
                        client_id: @options.application
                        client_secret: @options.secret
                        grant_type: 'password'
                    }

            }, (error, result) =>
                @setToken(result)
                callback(error, result)
            , true

        )

    # Login
    login: (username, password, callback) ->
        @_login(username, password, (error, result) =>
            @setToken(result)
            callback(error, result)
        )

    _logout: (callback) ->
        @request(
            {
                method: 'DELETE', resource: @login_resource,
                id: if mojio_token? then mojio_token else @getTokenId()
            }, (error, result) =>
                @setToken(null)
                callback(error, result)
        )

    # Logout
    logout: (callback) ->
        @_logout((error, result) =>
            @setToken(null)
            callback(error, result)
        )

    mojio_models = {}  # this is so model can use a string to constuct the model.


    App = require('../models/App');
    mojio_models['App'] = App

    Login = require('../models/Login');
    mojio_models['Login'] = Login

    Mojio = require('../models/Mojio');
    mojio_models['Mojio'] = Mojio

    Trip = require('../models/Trip');
    mojio_models['Trip'] = Trip

    User = require('../models/User');
    mojio_models['User'] = User

    Vehicle = require('../models/Vehicle');
    mojio_models['Vehicle'] = Vehicle

    Product = require('../models/Product');
    mojio_models['Product'] = Product

    Subscription = require('../models/Subscription');
    mojio_models['Subscription'] = Subscription

    Event = require('../models/Event');
    mojio_models['Event'] = Event


    Observer = require('../models/Observer');
    mojio_models['Observer'] = Observer

    # Make an app from a result
    model: (type, json=null) ->
        if (json == null)
            return mojio_models[type]
        else if (json.Data? and json.Data instanceof Array)
            object = json
            object.Objects = new Array()
            object.Objects.push(new mojio_models[type](data)) for data in json.Data
        else if (json.Data?)
            object = new mojio_models[type](json.Data)
        else
            object = new mojio_models[type](json)
        object._client = @
        return object

    # Model CRUD
    # query(model, { criteria={ }, limit=10, offset=0, sortby="name", desc=false }, callback) # take parameters as parameters.
    # query(model, { criteria={ name="blah", field="blah" }, limit=10, offset=0, sortby="name", desc=false }, callback) # take parameters as parameters.
    # query(model, { criteria="name=blah; field=blah", limit=10, offset=0, sortby="name", desc=false }, callback)
    # query(model, { limit=10, offset=0, sortby="name", desc=false }, callback)
    query: (model, parameters, callback) ->
        if (parameters instanceof Object)
            # convert criteria to a semicolon separated list of property values if it's an object.
            if (parameters.criteria instanceof Object) # if the list contain "Criteria" as an object
                # convert to semicolon separated list.
                query_criteria = ""
                for property, value of parameters.criteria
                    query_criteria += "#{property}=#{value};"
                parameters.criteria = query_criteria;

            @request({ method: 'GET',  resource: model.resource(), parameters: parameters}, (error, result) =>
                callback(error, @model(model.model(), result))
            )
        else if (typeof parameters == "string") # instanceof only works for coffeescript classes.

            @request({ method: 'GET',  resource: model.resource(), parameters: {id: parameters} }, (error, result) =>
                callback(error, @model(model.model(), result))
            )
        else
            callback("criteria given is not in understood format, string or object.",null)


    get: (model, criteria, callback) ->
        @query(model, criteria, callback)

    save: (model, callback) ->
        @request({ method: 'PUT', resource: model.resource(), body: model.stringify(), parameters: {id: model._id} }, callback)

    put: (model, callback) ->
        @save(model, callback)

    create: (model, callback) ->
        @request({ method: 'POST', resource: model.resource(), body: model.stringify() }, callback)

    post: (model, callback) ->
        @create(model, callback)

    delete: (model, callback) ->
        @request({ method: 'DELETE',  resource: model.resource(), parameters: {id: model._id} }, callback)

    ###
            Schema
    ###
    _schema: (callback) -> # Use if you want the raw result of the call.
        @request({ method: 'GET', resource: 'Schema'}, callback)

    schema: (callback) ->
        @_schema((error, result) => callback(error, result))

    ###
            Observers
    ###

    watch: (observer, observer_callback, callback) ->
        @request({ method: 'POST', resource: Observer.resource(), body: observer.stringify()}, (error, result) =>
            if error
                callback(error, null)
            else
                observer = new Observer(result)
                @signalr.subscribe(@options.signalr_hub, 'Subscribe', observer.id(), observer.Subject, observer_callback, (error, result) ->
                    callback(null, observer)
                )
                return observer
        )

    ignore: (observer, observer_callback, callback) ->
        if !observer
            callback("Observer required.")
        if (observer['subject']?)
            if (observer.parent == null)
                @signalr.unsubscribe(@options.signalr_hub, 'Unsubscribe', observer.id(), observer.subject.id(), observer_callback, callback)
            else
                @signalr.unsubscribe(@options.signalr_hub, 'Unsubscribe', observer.id(), observer.subject.model(), observer_callback, callback)
        else
            if (observer.parent == null)
                @signalr.unsubscribe(@options.signalr_hub, 'Unsubscribe', observer.id(), observer.SubjectId, observer_callback, callback)
            else
                @signalr.unsubscribe(@options.signalr_hub, 'Unsubscribe', observer.id(), observer.Subject, observer_callback, callback)

    observe: (subject, parent=null, observer_callback, callback) ->
        # subject is { model: type, _id: id }
        if (parent == null)
            observer = new Observer(
                {
                    ObserverType: "Generic", Status: "Approved", Name: "Test"+Math.random(),
                    Subject: subject.model(), SubjectId: subject.id(), "Transports": "SignalR"
                }
            )
            @request({ method: 'PUT', resource: Observer.resource(), body: observer.stringify()}, (error, result) =>
                if error
                    callback(error, null)
                else
                    observer = new Observer(result)
                    @signalr.subscribe(@options.signalr_hub, 'Subscribe', observer.id(), observer.SubjectId, observer_callback, (error, result) ->
                        callback(null, observer)
                    )
            )

        else
            observer = new Observer(
                {
                    ObserverType: "Generic", Status: "Approved", Name: "Test"+Math.random(),
                    Subject: subject.model(),
                    Parent: parent.model(), ParentId: parent.id(), "Transports": "SignalR"
                }
            )
            @request({ method: 'PUT', resource: Observer.resource(), body: observer.stringify()}, (error, result) =>
                if error
                    callback(error, null)
                else
                    observer = new Observer(result)
                    @signalr.subscribe(@options.signalr_hub, 'Subscribe', observer.id(), subject.model(), observer_callback, (error, result) ->
                        callback(null, observer)
                    )
            )

    unobserve: (observer, subject, parent, observer_callback, callback) ->
        if !observer || !subject?
            callback("Observer and subject required.")
        else if (parent == null)
            @signalr.unsubscribe(@options.signalr_hub, 'Unsubscribe', observer.id(), subject.id(), observer_callback, callback)
        else
            @signalr.unsubscribe(@options.signalr_hub, 'Unsubscribe', observer.id(), subject.model(), observer_callback, callback)

    ###
        Storage
    ###

    store: (model, key, value, callback) ->
        if !model || !model._id
            callback("Storage requires an object with a valid id.")
        else
            @request({ method: 'PUT', resource: model.resource(), id: model.id(), action: 'store', key: key, body: JSON.stringify(value) }, (error, result) =>
                if error
                    callback(error, null)
                else
                    callback(null, result)
            )
    storage: (model, key, callback) ->
        if !model || !model._id
            callback("Get of storage requires an object with a valid id.")
        else
            @request({ method: 'GET', resource: model.resource(), id: model.id(), action: 'store', key: key}, (error, result) =>
                if error
                    callback(error, null)
                else
                    callback(null, result)
            )

    unstore: (model, key, callback) ->
        if !model || !model._id
            callback("Storage requires an object with a valid id.")
        else
            @request({ method: 'DELETE', resource: model.resource(), id: model.id(), action: 'store', key: key}, (error, result) =>
                if error
                    callback(error, null)
                else
                    callback(null, result)
            )

    ###
        Token/User
    ###
    isAuthorized: () ->
        return @auth_token? and @getToken()?

    setToken: (token) ->
        # fix up the returned token and set _id and access_token fields to be the mojio token.
        if (token == null)
            @auth_token = { _id: null, access_token: null }
        else if typeof token is 'object' # token is an object of one of two structures
            @auth_token = token
            if (!@auth_token._id and token.access_token?) # token has access_token field but not _id
                @auth_token._id = token.access_token
            else if (!@auth_token.access_token and token._id?) # token has _id but not access_token
                @auth_token.access_token = token._id

            if (!@auth_token.access_token? and !@auth_token._id?)
                @auth_token.access_token = null
                @auth_token._id = null
        else # token is just a string.
            @auth_token = { _id: token, access_token: token } if token?

    getToken: () ->
        return @auth_token.access_token

    getTokenId:  () ->
        return @getToken()

    getRefreshToken: () ->
        return @auth_token.refresh_token

    getUserId:  () ->
        return @auth_token.UserId if @auth_token.UserId
        return null

    isLoggedIn: () ->
        return @getUserId() != null || @getToken()?

    getCurrentUser: (callback) ->
        if (@user?)
            callback(null, @user)
        else if (@isLoggedIn())
            @get(Login, @getToken(), (error, result) =>
                if error?
                    callback(error, null)
                else if (result.UserId?)
                    @get(User, result.UserId, (error, result) =>
                        if error?
                            callback(error, null)
                        else
                            @user = result
                            callback(null, @user)
                    )
                else
                    callback("User not found", null)
            )
        else
            callback("User not found", null)
            return false
        return true
