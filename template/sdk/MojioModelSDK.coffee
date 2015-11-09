
# The Model segment of the Mojio SDK. The model part of the SDK is the lowest level of the fluent chain and is used
# by all other SDK segments. It provides ways to specify the type of resource, identification of particular resources,
# and data for the resource.
#
module.exports = class MojioModelSDK

    # @nodoc
    constructor: () ->
        # make non plural versions of each resource call.
        for p,v of @
            capital = p.charAt(0).toUpperCase() + p.slice(1)
            @[capital] = @[p]
            ies = p.slice(p.length-3,p.length)
            s = p[p.length-1]
            if (ies is 'ies')
                iesModel = p.slice(0,p.length-3)+'y'
                iesCapital = sModel.charAt(0).toUpperCase() + iesModel.slice(1)
                @[iesModel] = @[p]
                @[iesCapital] = @[p]
            else if (s is 's')
                sModel = p.slice(0,p.length-1)
                sCapital = sModel.charAt(0).toUpperCase() + sModel.slice(1)
                @[sModel] = @[p]
                @[sCapital] = @[p]

    setup: (data) ->
        @stateMachine.reset()
        @stateMachine.setEndpoint("api")
        @stateMachine.setAction("")

    setCriteria: (data) ->
        if data instanceof Array
            throw new Error "Not implemented"
        else if typeof data is 'object'
            throw new Error "Not implemented"
        else if typeof data is 'string' or typeof data is 'number'
            @stateMachine.setId(data)

    # Specify a list of users to apply operations to in the fluent chain.
    #
    # A list of users can be specified either with an array of users (id's or objects), or a query string.
    # Pass null or undefined for all users accessible by the current user.
    #
    # @param {array or string} users A list of user ids or objects. A string will specify a query.
    # @example Observe a list of users.
    #   sdk.observe("key").users(["user_id1", "user_id2", { some user object }]).callback((error, result) ->
    #       ...
    #   )
    # @return {object} this
    users: (data) ->
        @setup()
        @setCriteria(data)
        @stateMachine.setResource('Users')
        return @

    # Specify a list of vehicles to apply operations to in the fluent chain.
    #
    # A list of vehicles can be specified either with an array of vehicles (id's or objects), or a query string.
    # Pass null or undefined for all vehicles accessible by the current vehicle.
    #
    # @param {array or string} vehicles A list of vehicle ids or objects. A string will specify a query.
    # @example Observe a list of vehicles.
    #   sdk.observe("key").vehicles(["vehicle_id1", "vehicle_id2", { some vehicle object }]).callback((error, result) ->
    #       ...
    #   )
    # @return {object} this
    vehicles: (data) ->
        @setup()
        @setCriteria(data)
        @stateMachine.setResource('Vehicles')
        return @

    # Specify a list of mojios to apply operations to in the fluent chain.
    #
    # A list of mojios can be specified either with an array of mojios (id's or objects), or a query string.
    # Pass null or undefined for all mojios accessible by the current mojio.
    #
    # @param {array or string} mojios A list of mojio ids or objects. A string will specify a query.
    # @example Observe a list of mojios.
    #   sdk.observe("key").mojios(["mojio_id1", "mojio_id2", { some mojio object }]).callback((error, result) ->
    #       ...
    #   )
    # @return {object} this
    mojios: (data) ->
        @setup()
        @setCriteria(data)
        @stateMachine.setResource('Mojios')
        return @

    # Specify a list of trips to apply operations to in the fluent chain.
    #
    # A list of trips can be specified either with an array of trips (id's or objects), or a query string.
    # Pass null or undefined for all trips accessible by the current trip.
    #
    # @param {array or string} trips A list of trip ids or objects. A string will specify a query.
    # @example Observe a list of trips.
    #   sdk.observe("key").trips(["trip_id1", "trip_id2", { some trip object }]).callback((error, result) ->
    #       ...
    #   )
    # @return {object} this
    trips: (data) ->
        @setup()
        @setCriteria(data)
        @stateMachine.setResource('Trips')
        return @

    # Specify a list of apps to apply operations to in the fluent chain.
    #
    # @return {object} this
    apps: (data) ->
        @setup()
        @setCriteria(data)
        @stateMachine.setResource('Apps')
        return @

    # group
    # @return {object} this
    groups: (data) ->
        #todo:: instantiate groups from names?
        @setup()
        @setCriteria(data)
        @stateMachine.setResource('Groups')
        @stateMachine.setObject(names)
        return @

    # permissions
    # @return {object} this
    permissions: (data) ->
        @stateMachine.setAction('Permissions')
        return @

    # Specify an image to apply operations to in the fluent chain. One image can be associated with either Vehicles or Users.
    #
    # @return {object} this
    images: (data) ->
        @stateMachine.setAction('Images')
        return @

    # Specify a tag to apply operations to in the fluent chain. Tags are secondary resources associated with Vehicles, Mojios, Users, Groups, or Trips
    #
    # @return {object} this
    tags: (data) ->
        @stateMachine.setAction('Tags')
        return @

    # Return the changeable details of a resource
    #
    # @return {object} this
    details: (data) ->
        @stateMachine.setAction('Details')
        return @ # resource or action

    # Return the changeable details of a resource
    #
    # @return {object} this
    histories: (measurement=null) ->
        @stateMachine.setObject('History')
        @stateMachine.setAction(measurement) if measurement?
        return @ # this

    # Return the changeable details of a resource
    #
    # @return {object} this
    states: () ->
        @stateMachine.setAction('States')
        return @ # this

    # Return the changeable details of a resource
    #
    # @return {object} this
    locations: () ->
        @stateMachine.setAction('Locations')
        return @ # this

    # Create models for testing purposes.
    #
    # Mocks up objects for testing, objects are not persisted and are created with random values.
    # @param {string} type The model type: Vehicle, User, Mojio, or Trip.
    # @example Create a Vehicle for unit testing
    #   sdk.mock().vehicle().callback((error, result) ->
    #       ...
    #   )
    # @return {object} this
    mock: () ->
        @stateMachine.mock()
        return @


