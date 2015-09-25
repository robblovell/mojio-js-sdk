# version 3.5.2
Http = require '../HttpNodeWrapper'
_ = require 'underscore'

# @nodoc
module.exports = class MojioClient

    defaults = { url: 'https://api.moj.io/v1', live: true, token: null}

    constructor: (options) ->
        options ?= defaults
        @configure(options)

    configure: (options={}) ->
        _.extend(@, options)
        return @

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

    dataByMethod: (data, method) ->
        switch (method.toUpperCase())
            when 'POST' or 'PUT' then return @stringify(data)
            else return data

    stringify: (data) ->
        return JSON.stringify(data)

    request: (request, callback, isOauth = false) ->
        parts = {
            hostname: @options.hostname
            host: @options.hostname
            port: @options.port
            scheme: @options.scheme
            path: (if isOauth then '' else '/' + @options.version)
            method: request.method,
            withCredentials: false
        }
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

    mojio_models = {}  # this is so model can use a string to constuct the model.


    App = require('../models/App');
    mojio_models['App'] = App

    Mojio = require('../models/Mojio');
    mojio_models['Mojio'] = Mojio

    Trip = require('../models/Trip');
    mojio_models['Trip'] = Trip

    User = require('../models/User');
    mojio_models['User'] = User

    Vehicle = require('../models/Vehicle');
    mojio_models['Vehicle'] = Vehicle

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

    query: (model, parameters, callback) ->
        return @
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
        return @
        @request({ method: 'PUT', resource: model.resource(), body: model.stringify(), parameters: {id: model._id} }, callback)

    put: (model, callback) ->
        @save(model, callback)

    create: (model, callback) ->
        @request({ method: 'POST', resource: model.resource(), body: model.stringify() }, callback)

    post: (model, callback) ->
        return @
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
    value: (model, key, callback) ->
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
