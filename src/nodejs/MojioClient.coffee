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

    _apps: (callback) -> # Use if you want the raw result of the call.
        @request({ method: 'GET', resource: @apps_resource}, callback)

    # Get App
    apps: (callback) ->
        @_apps((error, result) => callback(error, result))


    ###
    Mojio
    ###
    mojios_resource: 'Mojios'

    _mojios: (callback) -> # Use if you want the raw result of the call.
        @request({ method: 'GET', resource: @mojios_resource}, callback)

    # Get Mojio
    mojios: (callback) ->
        @_mojios((error, result) => callback(error, result))


    ###
    Trip
    ###
    trips_resource: 'Trips'

    _trips: (callback) -> # Use if you want the raw result of the call.
        @request({ method: 'GET', resource: @trips_resource}, callback)

    # Get Trip
    trips: (callback) ->
        @_trips((error, result) => callback(error, result))


    ###
    User
    ###
    users_resource: 'Users'

    _users: (callback) -> # Use if you want the raw result of the call.
        @request({ method: 'GET', resource: @users_resource}, callback)

    # Get User
    users: (callback) ->
        @_users((error, result) => callback(error, result))


    ###
    Vehicle
    ###
    vehicles_resource: 'Vehicles'

    _vehicles: (callback) -> # Use if you want the raw result of the call.
        @request({ method: 'GET', resource: @vehicles_resource}, callback)

    # Get Vehicle
    vehicles: (callback) ->
        @_vehicles((error, result) => callback(error, result))


    ###
    Event
    ###
    events_resource: 'Events'

    _events: (callback) -> # Use if you want the raw result of the call.
        @request({ method: 'GET', resource: @events_resource}, callback)

    # Get Event
    events: (callback) ->
        @_events((error, result) => callback(error, result))


    ###
       Event
    ###
    events_resource: 'Events'

    _events: (callback) -> # Use if you want the raw result of the call.
        @request({ method: 'GET', resource: @events_resource}, callback)

    # Get Trip
    events: (callback) ->
        @_events((error, result) => callback(error, result))

    ###
            Schema
    ###
    schema_resource: 'Schema'

    _schema: (callback) -> # Use if you want the raw result of the call.
        @request({ method: 'GET', resource: @schema_resource}, callback)

    # Get Applications
    schema: (callback) ->
        @_schema((error, result) => callback(error, result))
