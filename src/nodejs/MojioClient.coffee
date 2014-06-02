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
    _makeParameters: (params) ->
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
            parts.path += @_makeParameters(request.parameters)

        parts.headers = {}
        parts.headers["MojioAPIToken"] = getTokenId()
        parts.headers += request.headers if (request.headers?)
        #parts.headers["Access-Control-Allow-Credentials"] = 'true'

        parts.body = request.body if request.body

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
                id: if mojio_token? then mojio_token else getTokenId()
            }, callback
        )

    # Logout
    logout: (callback) ->
        @_logout((error, result) =>
            @token = null
            callback(error, result)
        )

    ###
        CRUD
    ###
    get: (request, callback) ->
        @request(request, callback)

    post: (request, callback) ->
        @request(request, callback)

    put: (request, callback) ->
        @request(request, callback)

    delete: (request, callback) ->
        @request(request, callback)


    mojio_models = {}  # this is so make_model can use a string to constuct the model.
    App = require('../src/models/App');
    mojio_models['App'] = App

    # Make an app from a result
    make_model: (type, json) ->
        if (json.Data instanceof Array)
            object = new mojio_models[type](json.Data[0])
        else if (json.Data?)
            object = new mojio_models[type](json.Data)
        else
            object = new mojio_models[type](json)
        return object

    ###
    App
    ###

    # Post App
    postApp: (app_model, callback) ->
        @request({ method: 'POST', resource: 'Apps', body: JSON.stringify(app_model) }, callback)

    # Put App
    putApp: (app_model, callback) ->
        @request({ method: 'PUT',  resource: 'Apps', body: JSON.stringify(app_model) }, callback)

    # Delete App
    deleteApp: (app_model, callback) ->
        @request({ method: 'PUT',  resource: 'Apps', parameters: JSON.stringify({id: app_model.id}) }, callback)

    # Get Apps
    getApps: (parameters, callback) ->
        @request({ method: 'GET',  resource: 'Apps', parameters: parameters }, (error, result) =>
            callback(error, @make_model('App', result))
        )

    # Get App
    getApp: (id, callback) ->
        @request({ method: 'GET',  resource: 'Apps', parameters: {id: id} }, (error, result) =>
            callback(error, @make_model('App', result))
        )

    # Get Apps Legacy
    apps: (callback) ->
        console.log("Deprication Warning: Use getApps instead")
        @getApps({}, callback)

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
    Mojio
    ###
    mojios_resource: 'Mojios'

    _mojios: (callback) -> # Use if you want the raw result of the call.
        @request({ method: 'GET', resource: @mojios_resource}, callback)

    # Get Mojio
    mojios: (callback) ->
        @_mojios((error, result) => callback(error, result))

    # Post Mojio
    # TODO::

    # Put Mojio
    # TODO::

    # Delete Mojio
    # TODO::

    # Post Mojio_observer
    # TODO::

    # Put Mojio_observer
    # TODO::

    # Delete Mojio_observer
    # TODO:


    ###
    Trip
    ###
    trips_resource: 'Trips'
    Trip = require('../src/models/Trip');

    _trips: (callback) -> # Use if you want the raw result of the call.
        @request({ method: 'GET', resource: @trips_resource}, callback)

    # Get Trip
    trips: (callback) ->
        @_trips((error, result) =>
            if (result.Data instanceof Array)
                object = new Trip(result.Data[0])
            else if (result.Data?)
                object = new Trip(result.Data)
            else
                object = new Trip(result)
            callback(error, object)
        )

    # Post Trip
    # TODO::

    # Put Trip
    # TODO::

    # Delete Trip
    # TODO::

    # Post Trip_observer
    # TODO::

    # Put Trip_observer
    # TODO::

    # Delete Trip_observer
    # TODO:


    ###
    User
    ###
    users_resource: 'Users'

    _users: (callback) -> # Use if you want the raw result of the call.
        @request({ method: 'GET', resource: @users_resource}, callback)

    # Get User
    users: (callback) ->
        @_users((error, result) => callback(error, result))

    # Post User
    # TODO::

    # Put User
    # TODO::

    # Delete User
    # TODO::

    # Post User_observer
    # TODO::

    # Put User_observer
    # TODO::

    # Delete User_observer
    # TODO:


    ###
    Vehicle
    ###
    vehicles_resource: 'Vehicles'

    _vehicles: (callback) -> # Use if you want the raw result of the call.
        @request({ method: 'GET', resource: @vehicles_resource}, callback)

    # Get Vehicle
    vehicles: (callback) ->
        @_vehicles((error, result) => callback(error, result))

    # Post Vehicle
    # TODO::

    # Put Vehicle
    # TODO::

    # Delete Vehicle
    # TODO::

    # Post Vehicle_observer
    # TODO::

    # Put Vehicle_observer
    # TODO::

    # Delete Vehicle_observer
    # TODO:


    ###
    Product
    ###
    products_resource: 'Products'

    _products: (callback) -> # Use if you want the raw result of the call.
        @request({ method: 'GET', resource: @products_resource}, callback)

    # Get Product
    products: (callback) ->
        @_products((error, result) => callback(error, result))

    # Post Product
    # TODO::

    # Put Product
    # TODO::

    # Delete Product
    # TODO::

    # Post Product_observer
    # TODO::

    # Put Product_observer
    # TODO::

    # Delete Product_observer
    # TODO:


    ###
    Subscription
    ###
    subscriptions_resource: 'Subscriptions'

    _subscriptions: (callback) -> # Use if you want the raw result of the call.
        @request({ method: 'GET', resource: @subscriptions_resource}, callback)

    # Get Subscription
    subscriptions: (callback) ->
        @_subscriptions((error, result) => callback(error, result))

    # Post Subscription
    # TODO::

    # Put Subscription
    # TODO::

    # Delete Subscription
    # TODO::

    # Post Subscription_observer
    # TODO::

    # Put Subscription_observer
    # TODO::

    # Delete Subscription_observer
    # TODO:


    ###
    Event
    ###
    events_resource: 'Events'

    _events: (callback) -> # Use if you want the raw result of the call.
        @request({ method: 'GET', resource: @events_resource}, callback)

    # Get Event
    events: (callback) ->
        @_events((error, result) => callback(error, result))

    # Post Event
    # TODO::

    # Put Event
    # TODO::

    # Delete Event
    # TODO::

    # Post Event_observer
    # TODO::

    # Put Event_observer
    # TODO::

    # Delete Event_observer
    # TODO:



    ###
            Schema
    ###
    schema_resource: 'Schema'

    _schema: (callback) -> # Use if you want the raw result of the call.
        @request({ method: 'GET', resource: @schema_resource}, callback)

    # Get Applications
    schema: (callback) ->
        @_schema((error, result) => callback(error, result))


    ###
            Observer
    ###
    observer_resource: 'Observe'

    _observer: (callback) -> # Use if you want the raw result of the call.
        @request({ method: 'GET', resource: @observer_resource}, callback)

    # Get Applications
    observer: (callback) ->
        @_observer((error, result) => callback(error, result))

#    trip_observer: (callback) ->
#        @request({ method: 'POST', resource: @observer_resource}, callback)

    ###
        Signal R
    ###

    getTokenId:  () ->
        return if @token? then @token.id else null

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

        return hub.invoke(action, getTokenId(), type, ids, groups)

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

        return hub.invoke("Unsubscribe", getTokenId(), type, ids, groups)

