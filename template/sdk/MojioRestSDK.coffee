# version 4.0.0
MojioAuthSDK = require './MojioAuthSDK'
# The REST segment of the Mojio SDK. The REST methods provide a mechanism to retrieve, create, save, or destroy
# objects in the Mojio API. Availablity of REST calls is subject to the access rights of the user authenticated.
#
# There are two types of resources within the Mojio Domain Model, primary objects and secondary associated objects.
# Primary objects are: Vehicles, Users, Mojios, Trips, Apps, and Groups.  Secondary Objects are Images and Tags.
#
# This segement of the SDK provides a set of verbs that represent actions within the fluent chain.
#
# Verbs on primary resources are GET, PUT, POST, DELETE.  QUERY is an alias for GET, both provide a subset of ODATA
# style criteria for retrieval of lists of objects.  ODATA verbs include: TAKE, TOP, SKIP, FILTER, SELECT, and ORDERBY.
# Direct inspection of the code will reveal aliases for all of these verbs.
#
# Verbs available for actions on secondary resources provide mechanisms to associate secondary resources with primary.
# These are ADD, SET, REMOVE, and GET.
#
# @example
#   mojioRestSdk = new MojioSDK({sdk: MojioRestSDK}) # instantiate the mojioSDK to do only REST and authentication methods.
#
module.exports = class MojioRestSDK extends MojioAuthSDK
    defaults = {
        apiURL: 'api2.moj.io'
        version: 'v2'
    }
    # Constructor for the MojioRestSDK
    # @param [object] options Configurable options for the sdk.
    # @option options [String] version api version to use 'v1' or 'v2't
    # @return {object} Returns a new MojioAuthSDK object
    # @nodoc
    constructor: (options={}) ->
        super(options)

    # Put sets up the fluent chain in order to save an already persisted object in the Mojio system.
    # Use with one of the ModelSDK calls to specify the data for a vehicle, mojio, user, trip, group, or permission.
    # (alias: save and update)
    # @example
    #   sdk.put().vehicle([resourceObject])
    # @return {object} this
    put: (object_or_json_string) ->
        @stateMachine.setMethod("put")
        @stateMachine.setBody_ObjectOrJson(object_or_json_string)
        return @
    # Save, is an alias for Put, sets up the fluent chain to save an already persisted object in the Mojio system.
    # Use with one of the ModelSDK calls to specify the data for a vehicle, mojio, user, trip, group, or permission.
    # @example
    #   sdk.save().user([resourceObject])
    # @return {object} this
    # @nodoc
    save: (object_model_or_json) ->
        @put(object_model_or_json)
        return @
    # Update is an alias for Put, sets up the fluent chain to save an already persisted object in the Mojio system.
    # Use with one of the ModelSDK calls to specify the data for a vehicle, mojio, user, trip, group, or permission.
    # @example
    #   sdk.update().mojio([resourceObject])
    # @return {object} this
    # @nodoc
    update: (object_or_json_string) ->
        @put(object_or_json_string)
        return @

    # Post sets up the fluent chain in order to create a new persisted object in the Mojio system.
    # Use with one of the ModelSDK calls to specify the data for a vehicle, mojio, user, trip, group, or permission.
    # (alias: create)
    # @example
    #   sdk.post().vehicle([resourceObject])
    # @return {object} this
    post: (object_or_json_string) ->
        @stateMachine.setMethod("post")
        @stateMachine.setBody_ObjectOrJson(object_or_json_string)
        return @
    # Create is an alias for Post, sets up the fluent chain to create a new persisted object in the Mojio system.
    # Use with one of the ModelSDK calls to specify the data for a vehicle, mojio, user, trip, group, or permission.
    # @example
    #   sdk.create().mojio([resourceObject])
    # @return {object} this
    # @nodoc
    create: (object_or_json_string) -> # POST, throw error if it already exists
        @post(object_or_json_string)
        return @

    # Delete sets up the fluent chain to delete an existing persisted object in the Mojio system.
    # Use with one of the ModelSDK calls to specify the Id for a vehicle, mojio, user, trip, group, or permission.
    # (alias: destroy)
    # @example
    #   sdk.delete().vehicle([resourceId])
    # @return {object} this
    delete: (id_or_array_of_ids) ->
        @stateMachine.setMethod("delete")
        @stateMachine.setWhere(id_or_array_of_ids)
        return @
    # Destroy is an alias for delete, sets up the fluent chain to delete an existing persisted object in the Mojio system.
    # Use with one of the ModelSDK calls to specify the Id for a vehicle, mojio, user, trip, group, or permission.
    # @example
    #   sdk.destroy().mojio([resourceId])
    # @return {object} this
    # @nodoc
    destroy: (id_or_array_of_ids) -> # DELETE
        @delete(id_or_array_of_ids)
        return @

    # Get sets up the fluent chain for retrieving an existing persisted object in the Mojio system.
    # Use with one of the ModelSDK calls to specify the Id for a vehicle, mojio, user, trip, group, or permission.
    # (alias: query)
    # @example
    #   sdk.get().mojio([resourceId]).submit()
    # @example
    #   sdk.get().tag(key).vehicle(vehicleId).submit()
    # @return {object} this
    get: (id_example_or_query) ->
        @stateMachine.setMethod("get")
        # determine if this is a get with a later where, or a call with a given type and id, example, or a query string
        @stateMachine.setWhere(id_example_or_query)
        return @

    # Query sets up the fluent chain for retrieving an existing persisted object in the Mojio system.
    # Use with one of the ModelSDK calls to specify the type of object for a vehicle, mojio, user, trip, group, or permission.
    # The query is specified with follow on query specificaiton calls: select, top, skip, orderby, fields and desc.
    # (alias: get)
    # @example
    #   sdk.get/query().vehicles().fields([FieldsList]).select([selectString]).top(#).skip(#).orderby(field).desc(bool)
    # @return {object} this
    query: (id_example_or_query) ->
        @get(id_example_or_query)
        return @

    # Select specifies a criteria for the objects that will be returned.
    # (alias: where)
    # @example
    #   sdk.get/query().vehicles().select("query string").submit()
    # @return {object} this
    select: (id_example_or_query) ->
        @get(id_example_or_query)
        return @
    # Where specifies a criteria for the objects that will be returned.
    # @example
    #   sdk.get/query().vehicles().where("query string").submit()
    # @return {object} this
    # @nodoc
    where: (id_example_or_query) ->
        @get(id_example_or_query)
        return @

    # Filter specifies which fields are returned in the objects returned.
    # (alias: fields)
    # @example
    #   sdk.get/query().vehicles().top(#).filter(["Location", "Speed", "RPM"].submit()
    # @return {object} this
    filter: (filter) ->
        @stateMachine.filter = filter
        return @
    # Fields specifies which fields are returned in the objects returned.
    # @example
    #   sdk.get/query().vehicles().top(#).fields(["Location", "Speed", "RPM"].submit()
    # @return {object} this
    # @nodoc
    fields: (fields) ->
        @stateMachine.fields = fields
        return @

    # Top specifies that the query should only return the given number of results.
    # (alias: limit)
    # @example
    #   sdk.get/query().vehicles().top(#).submit()
    # @return {object} this
    top: (top) ->
        return @limit(top)
    # Limit is an alias for top, it specifies that the query should only return the given number of results.
    # @example
    #   sdk.get/query().vehicles().limit(#).submit()
    # @return {object} this
    # @nodoc
    limit: (limit) ->
        @stateMachine.limit = limit
        return @

    # Skip specifies that the query should skip the specified number of records when it return the results.
    # (alias: offset)
    # @example
    #   sdk.get/query().vehicles().top(#).skip(#).submit()
    # @return {object} this
    skip: (offset) ->
        return @offset(offset)
    # Offset is an alias for skip and specifies that the query should skip the specified number of records when it return the results.
    # @example
    #   sdk.get/query().vehicles().limit(#).offset(#).submit()
    # @return {object} this
    # @nodoc
    offset: (offset) ->
        stateMachine.offset = offset
        return @

    # Orderby specifies that the query results should be ordered by the given field and if it's descending (true) or ascending (false). The default is by id ascending.
    # (partial alias: desc)
    # @example
    #   sdk.get/query().vehicles().top(#).skip(#).orderby(TimeStamp, true).submit()
    # @return {object} this
    orderby: (field, desc=null) ->
        stateMachine.field = field
        stateMachine.desc = desc if desc?
        return @

    # Desc specifies that the query results should be descending (true) or ascending (false). The default is ascending.
    # @example
    #   sdk.get/query().vehicles().top(#).skip(#).desc(false).submit()
    # @example
    #   sdk.get/query().vehicles().top(#).skip(#).desc().submit()
    # @return {object} this
    # @nodoc
    desc: (desc=null) ->
        if desc?
            stateMachine.desc = desc
        else
            stateMachine.desc = true
        return @

    # Asc specifies that the query results should be ascending (true) or descending (false). The default is ascending.
    # @example
    #   sdk.get/query().vehicles().top(#).skip(#).asc(false).submit()
    # @example
    #   sdk.get/query().vehicles().top(#).skip(#).asc().submit()
    # @return {object} this
    # @nodoc
    asc: (asc=null) ->
        if asc?
            stateMachine.desc = !asc
        else
            stateMachine.desc = false
        return @

    # Field specifies that the query results should be ordered by the given field
    # (partial alias: desc)
    # @example
    #   sdk.get/query().vehicles().top(#).skip(#).field(TimeStamp).desc().submit()
    # @return {object} this
    field: (field, desc=null) ->
        stateMachine.field = field
        stateMachine.desc = desc if desc?
        return @

    # Add allows the code to associate add a tag to a vehicle, mojio, group, user, or app.
    # When used with the Sharing SDK, it allows the code to add users to groups or to add permission 'access rules' to groups for resources.
    # @example
    #   sdk.add().tag(key, value).vehicle(vehicleId).submit()
    # @return {object} this
    add: (field, desc=null) ->
        stateMachine.field = field
        stateMachine.desc = desc if desc?
        return @

    # Set allows the code to associate an image with a vehicle or user, a tag with a vehicle, mojio, group, user, or app.
    # When used with the Sharing SDK, it allows the code to set users for groups or to set permission 'access rules' to resources from groups.
    # @example
    #   sdk.add().tag(key, value).vehicle(vehicleId).submit()
    # @return {object} this
    set: (field, desc=null) ->
        stateMachine.field = field
        stateMachine.desc = desc if desc?
        return @

    # Remove allows the code to remove an associated image with a vehicle or user, or remove a tag from a vehicle, mojio, group, user, or app.
    # (alias: revoke)
    # @example
    #   sdk.remove().tag(key).vehicle(vehicleId).submit()
    # @return {object} this
    remove: (field, desc=null) ->
        stateMachine.field = field
        stateMachine.desc = desc if desc?
        return @

    # Revoke allows the code to remove an associated image with a vehicle or user, or remove a tag from a vehicle, mojio, group, user, or app.
    # @example
    #   sdk.revoke().tag(key).vehicle(vehicleId).submit()
    # @return {object} this
    # @nodoc
    revoke: (user, callback) ->
        @callback(callback) if (callback?)
        return @
