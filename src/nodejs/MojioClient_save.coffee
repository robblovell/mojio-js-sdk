Http = require './HttpNodeWrapper'

module.exports = class MojioClient

    defaults = { hostname: 'sandbox.api.moj.io', port: '80', version: 'v1' }

    constructor: (@options) ->
        @options ?= { hostname: defaults.hostname, port: @defaults.port, version: @defaults.version }
        @options.hostname ?= defaults.hostname
        @options.port ?= defaults.port
        @options.version ?= defaults.version
        @options.application = @options.application
        @options.secret = @options.secret  # TODO:: header and https only
        @options.observerTransport = 'SingalR'
        @conn = null
        @hub = null
        @connStatus = null
        @token = null

    ###
        Helpers
    ###
    @_makeParameters: (params) ->
        '' if params.length==0
        query = '?'
        for property, value of params
            query += "#{property}=#{value}&"
        return query.slice(0,-1)

    request: (request, callback) ->
        parts = {
            hostname: @options.hostname
            host: @options.hostname
            port: @options.port
            path: '/'+@options.version
            method: request.method,
            withCredentials: false
        }
        parts.path += '/'+request.resource if (request.resource?)
        parts.path += '/'+request.id if (request.id? && request.id != '')
        if (request.parameters? and Object.keys(request.parameters).length > 0)
            parts.path += MojioClient._makeParameters(request.parameters)

        parts.headers = {}
        parts.headers["MojioAPIToken"] = @getTokenId()
        parts.headers += request.headers if (request.headers?)
        #parts.headers["Access-Control-Allow-Credentials"] = 'true'
        parts.headers["Content-Type"] = 'application/json'

        parts.body = request.body if request.body?

        http = new Http()
        http.request(parts, callback)
    ###
        Login
    ###
    login_resource: 'Login'

    _login: (username, password, callback) -> # Use if you want the raw result of the call.
        @request(
            {
                method: 'POST', resource: @login_resource, id: @options.application,
                parameters:
                    {
                        userOrEmail: username
                        password: password
                        secretKey: @options.secret
                    }
            }, callback
        )

    # Login
    login: (username, password, callback) ->
        @_login(username, password, (error, result) =>
            if (result?)
                @token = result
            callback(error, result)
        )

    _logout: (callback) ->
        @request(
            {
                method: 'DELETE', resource: @login_resource,
                id: if mojio_token? then mojio_token else @getTokenId()
            }, callback
        )

    # Logout
    logout: (callback) ->
        @_logout((error, result) =>
            @token = null
            callback(error, result)
        )

    mojio_models = {}  # this is so make_model can use a string to constuct the model.
    App = require('./../models/App');
    mojio_models['App'] = App

    # Make an app from a result
    make_model: (type, json) ->
        if (json.Data instanceof Array)
            object = new Array()
            object.push(new mojio_models[type](data)) for data in json.Data
        else if (json.Data?)
            object = new mojio_models[type](json.Data)
        else
            object = new mojio_models[type](json)
        return object

    # Model CRUD
    query: (model, criteria, callback) ->

        if (criteria instanceof Object)
            @request({ method: 'GET',  resource: model.resource(), parameters: criteria }, (error, result) =>
                callback(error, @make_model(model.model(), result))
            )
        else if (typeof criteria == "string") # instanceof only works for coffeescript classes.
            @request({ method: 'GET',  resource: model.resource(), parameters: {id: criteria} }, (error, result) =>
                callback(error, @make_model(model.model(), result))
            )
        else
            callback("criteria given is not in understood format, string or object.",null)

    save: (model, callback) ->
        @request({ method: 'PUT', resource: model.resource(), body: model.stringify() }, callback)

    # Delete App
    delete: (model, callback) ->
        @request({ method: 'DELETE',  resource: model.resource(), parameters: {id: model._id} }, callback)



    # Create an Observer of an App
    observeApp: (id, callback) ->
        @request({ method: 'PUT',  resource: 'Observer', parameters: {Subject: 'App', SubjectId: id} }, callback)

    # Delete App_observer
    unobserveApp: (id, callback) ->
        @request({ method: 'DELETE',  resource: 'Observer', parameters: {Subject: 'App', SubjectId: id} }, callback)


    validateEntityDescriptor: (entities, callback) ->
        if (entities? and entities typeof Array)
            callback(null, entities)
        else if (entities? and entities type of Object)
            callback(null, [entities])
        else
            callback("Entity must be an objects specifying a type and a guid id: { type: string id: string } or an array of objects.",null)


    _observe: (entity, callback) ->
        #

    _unobserve: (entity, callback) ->
        #
    _unobserveAll: () ->
        #

        # entityDescriptor is an object with the schema: { type: string id: string } or
        # an array of these objects.  Type is the type of entity to observe, one of the Mojio models
        # id is the guid id of the specific entity to observe.
    observe: (entityDescriptor, callback) ->
        @validateEntityDescriptor(entityDescriptor, (error, entities) ->
            return if error?
            observers = []
            @observe(entity, (error, result) ->
                observers.push(result)
            ) for entity in entities
            callback(null, "Subscribed")
        )

    unobserve: (entityDescriptor, callback) ->
        unless (entityDescriptor?)
            @unobserveAll()
            callback(null, "Un-Subscribed")

        else
            @validateEntityDescriptor(entityDescriptor, (error, entities) ->
                callback(error, null) if error?
                @unobserve(entity) for entity in entities
                callback(null, "Un-Subscribed")
            )


    ###
            Schema
    ###
    schema_resource: 'Schema'

    _schema: (callback) -> # Use if you want the raw result of the call.
        @request({ method: 'GET', resource: @schema_resource}, callback)

    schema: (callback) ->
        @_schema((error, result) => callback(error, result))

    ###
            Observer
    ###
    observer_resource: 'Observe'

    _observer: (callback) -> # Use if you want the raw result of the call.
        @request({ method: 'GET', resource: @observer_resource}, callback)

    observer: (callback) ->
        @_observer((error, result) => callback(error, result))

    ###
        Signal R
    ###

    getTokenId:  () ->
        return if @token? then @token._id else null

    getUserId:  () ->
        return if @token? then @token.UserId else null

    isLoggedIn: () ->
        return getUserId() != null

    getCurrentUser: (func) ->
        if (@user?)
            func(@user)
        else if (isLoggedIn())
            get('users', getUserId())
            .done( (user) ->
                    return unless (user?)
                    @user = user if (getUserId() == @user._id)
                    func(@user)
                )
        else
            return false
        return true

    dataByMethod: (data, method) ->
        switch (method.toUpperCase())
            when 'POST', 'PUT' then return JSON.stringify(data)
            else return data

    getHub: () ->
        return @hub if (@hub?)

        @conn = $.hubConnection(settings.url + "/signalr", { useDefaultPath: false })
        @hub = _conn.createHubProxy('hub')

        @hub.on("error", (data) ->
            log(data)
        )

        @connStatus = @conn.start().done( () -> @connStatus = null )

        return @hub

    subscribe: (type, ids, groups) ->
        hub = getHub()

        if (!groups)
            groups = Mojio.EventTypes

        if (hub.connection.state != 1)
            if (@connStatus)
                @connStatus.done( () -> subscribe(type, ids, groups) )
            else
                @connStatus = hub.connection.start().done(() -> subscribe(type, ids, groups) )

            return @connStatus

        action = (ids instanceof Array) ? "Subscribe" : "SubscribeOne"

        return hub.invoke(action, @getTokenId(), type, ids, groups)

    unsubscribe: (type, ids, groups) ->
        hub = getHub()

        if (!groups)
            groups = Mojio.EventTypes

        if (hub.connection.state != 1)
            if (@connStatus)
                @connStatus.done( () -> unsubscribe(type, ids, groups) )
            else
                @connStatus = hub.connection.start().done( () -> unsubscribe(type, ids, groups) )

            return @connStatus

        return hub.invoke("Unsubscribe", @getTokenId(), type, ids, groups)

