if (window?)
    Http = require './HttpBrowser'
else
    http = require 'http'

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
        if (window?)
            http = new Http($)
            action = http.request parts, (error, result) ->
                callback(error, null) if (error)
                callback(null, result)

        else
            action = http.request parts

            action.on('response', (response) ->
                if (response.statusCode > 299)
                    callback(response, null)
                else if (response.statusCode != 204)
                    data = ""
                    response.setEncoding('utf8') if !window?
                    response.on('data', (chunk) ->
                        data += chunk
                    )

                    response.on('end', () ->
                        if (data instanceof Object)
                            callback(data,null)
                        else
                            callback(null, JSON.parse(data))
                    )
                else
                    callback(null, response)
            )
            action.on 'error', (error) ->
                callback(error,null)

            action.end()

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
        Applications
    ###
    apps_resource: 'Apps'

    _applications: (callback) -> # Use if you want the raw result of the call.
        @request({ method: 'GET', resource: @apps_resource, id: @options.application}, callback)

    # Get Applications
    applications: (callback) ->
        @_applications((error, result) => callback(error, result))

    _apps: (callback) -> # Use if you want the raw result of the call.
        @request({ method: 'GET', resource: @apps_resource, id: @options.application}, callback)

    # Get Applications
    apps: (callback) ->
        @_apps((error, result) => callback(error, result))

    ###
        Trips
    ###
    trips_resource: 'Trips'

    _trips: (callback) -> # Use if you want the raw result of the call.
        @request({ method: 'GET', resource: @trips_resource }, callback)

    # Get Applications
    trips: (callback) ->
        @_trips((error, result) => callback(error, result))

    ###
        Users
    ###
    users_resource: 'Users'

    _users: (callback) -> # Use if you want the raw result of the call.
        @request({ method: 'GET', resource: @users_resource }, callback)

    # Get Applications
    users: (callback) ->
        @_users((error, result) => callback(error, result))


    ###
        Events
    ###
    events_resource: 'Events'

    _events: (callback) -> # Use if you want the raw result of the call.
        @request({ method: 'GET', resource: @events_resource }, callback)

    # Get Applications
    events: (callback) ->
        @_events((error, result) => callback(error, result))

    ###
        Mojios
    ###
    mojios_resource: 'Mojios'

    _mojios: (callback) -> # Use if you want the raw result of the call.
        @request({ method: 'GET', resource: @mojios_resource }, callback)

    # Get Applications
    mojios: (callback) ->
        @_mojios((error, result) => callback(error, result))

    ###
        Vehicles
    ###
    vehicles_resource: 'Vehicles'

    _vehicles: (callback) -> # Use if you want the raw result of the call.
        @request({ method: 'GET', resource: @vehicles_resource }, callback)

    # Get Applications
    vehicles: (callback) ->
        @_vehicles((error, result) => callback(error, result))

    ###
            Schema
    ###
    schema_resource: 'Schema'

    _schema: (callback) -> # Use if you want the raw result of the call.
        @request({ method: 'GET', resource: @schema_resource}, callback)

    # Get Applications
    schema: (callback) ->
        @_schema((error, result) => callback(error, result))
