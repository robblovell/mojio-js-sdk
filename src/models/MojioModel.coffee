# the base class for models.
module.exports = class MojioModel
    @_resource: 'Schema'
    @_model: 'Model'

    constructor: (json) ->
        @_client = null
        @validate(json)

    set: (field, value) =>
        if (@schema()[field]?)
            @[field] = value
        else
            throw "Field '"+field+"' not in model '"+@constructor.name+"'."

    get: (field) =>
        return @[field]

    validate: (json) =>
        for field, value of json
            @set(field, value)

    stringify: () ->
        JSON.stringify(@, @filter)

    filter: (key, value) ->
        if (key=="_client" || key=="_schema" || key == "_resource" || key == "_model")
            return undefined
        else
            return value

    # instance methods.
    query: (criteria, callback) ->
        if (@_client == null)
            callback("No authorization set for model, use authorize(), passing in a mojio _client where login() has been called successfully.", null)
            return
        if (criteria instanceof Object)
            @_client.request({ method: 'GET',  resource: @resource(), parameters: criteria }, (error, result) =>
                callback(error, @_client.make_model(@model(), result))
            )
        else if (typeof criteria == "string") # instanceof only works for coffeescript classes.
            @_client.request({ method: 'GET',  resource: @resource(), parameters: {id: criteria} }, (error, result) =>
                callback(error, @_client.make_model(@model(), result))
            )
        else
            callback("criteria given is not in understood format, string or object.",null)

    create: (callback) ->
        if (@_client == null)
            callback("No authorization set for model, use authorize(), passing in a mojio _client where login() has been called successfully.", null)
            return
        @_client.request({ method: 'POST',  resource: @resource(), body: @stringify() }, (error, result) =>
            callback(error, result)
        )

    save: (callback) ->
        if (@_client == null)
            callback("No authorization set for model, use authorize(), passing in a mojio _client where login() has been called successfully.", null)
            return
        @_client.request({ method: 'PUT',  resource: @resource(), body: @stringify() }, (error, result) =>
            callback(error, result)
        )

    delete: (callback) ->
        @_client.request({ method: 'DELETE',  resource: @resource(), parameters: {id: @_id} }, (error, result) =>
            callback(error, result)
        )

    resource: () ->
        return @_resource

    model: ()  ->
        return @_model

    schema: () ->
        return @_schema

    authorization: (client) ->
        @_client = client
        return @


