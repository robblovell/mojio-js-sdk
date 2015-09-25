# version 4.0.0
#Http = require './HttpNodeWrapper'
FormUrlencoded = require 'form-urlencoded'

MojioAuthSDK = require './MojioAuthSDK'

module.exports = class MojioRestSDK extends MojioAuthSDK

    # Constructor for the MojioRestSDK
    # @param [object] options Configurable options for the sdk.
    # @option options [String] version api version to use 'v1' or 'v2't
    # @return {object} Returns a new MojioAuthSDK object
    constructor: (options={}) ->
        super(options)

    # Put without arguments sets up the fluent chain to save an already persisted object in the Mojio system.
    # @param [resourceObject] object_model_or_json Specification of the data of a domain object. Can be specified in three ways:
    #   1 a type string and a data object with the id property set (type, data{id})
    #   2 a data object with an id and type property set: (data{type, id})
    #   3 a model object instantiated from the mojio SDK: (model{type, id})
    # @public
    put: (object_or_json_string) ->
        setState("put")
        setObject(object_or_json_string)
        return @
    save: (object_model_or_json) ->
        @put(object_or_json_string)
        return @
    update: (object_or_json_string) ->
        @put(object_or_json_string)
        return @

    create: (object_or_json_string) -> # POST, throw error if it already exists
        @post(object_or_json_string)
        return @
    post: (object_or_json_string) ->
        setState("post")
        setObject(object_or_json_string)
        return @

    destroy: (id_or_array_of_ids) -> # DELETE
        @delete(id_or_array_of_ids)
        return @
    delete: (id_or_array_of_ids) ->
        setState("delete")
        setWhere(id_example_or_query)
        return @

    query: (id_example_or_query) -> # GET
        @get(id_example_or_query)
        return @
    get: (id_example_or_query) -> # number, object, or string
        setState("get")
        # determine if this is a get with a later where, or a call with a given id, example, or a query string
        setWhere(id_example_or_query)
        return @

    limit: (limit) ->
        state.limit = limit
        return @

    offset: (offset) ->
        state.offset = offset
        return @

    desc: (desc) ->
        state.desc = desc
        return @


