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
        parts.headers["MojioAPIToken"] = @token if @token?
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
                @token = result._id
            callback(error, result)
        )

    _logout: (callback) ->
        @request(
            {
                method: 'DELETE', resource: @login_resource,
                id: if mojio_token? then mojio_token else @token
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

    ###
    App
    ###

    apps_resource: 'Apps'
    App = require('../src/models/App');

    # Post App
    post_app: (app_model, callback) ->
        @request({ method: 'POST', resource: @apps_resource, body: JSON.stringify(app_model) }, callback)

    # Put App
    put_app: (app_model, callback) ->
        @request({ method: 'PUT', resource: @apps_resource, body: JSON.stringify(app_model) }, callback)

    # Delete App
    delete_app: (id, callback) ->
        @request({ method: 'PUT', resource: @apps_resource, parameters: JSON.stringify({id: id}) }, callback)

    # Make an app from a result
    make_app: (json) ->
        if (json.Data instanceof Array)
            object = new App(json.Data[0])
        else if (json.Data?)
            object = new App(json.Data)
        else
            object = new App(json)
        return object

    # Get Apps
    _apps: (criteria, callback) -> # Internal, Use if you want the raw result of the call.
        @request({ method: 'GET', resource: @apps_resource, parameters: criteria }, callback)

    apps: (criteria, callback) ->
        @_apps(criteria, (error, result) =>
            callback(error, @make_app(result))
        )

    # Get App
    app: (id, callback) ->
        @request({ method: 'GET', resource: @apps_resource, parameters: {id: id} },
            (error, result) =>
                callback(error, @make_app(result))
        )

    # Post App_observer
    # TODO::

    # Put App_observer
    # TODO::

    # Delete App_observer
    # TODO:


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

