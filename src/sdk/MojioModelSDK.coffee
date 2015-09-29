# The Model segment of the Mojio SDK. The model part of the SDK is the lowest level of the fluent chain and is used
# by all other SDK segments. It provides ways to specify the type of resource, identification of particular resources,
# and data for the resource.
#
module.exports = class MojioModelSDK

    # @nodoc
    constructor: () ->

    # @nodoc
    configure: (options={}) ->
        _.extend(@, options)
        return @

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
    users: (users) ->
        state.resource = 'Users'
        state.object = users
        return @

    # Specify a user to apply operations to in the fluent chain.
    #
    # A user id, object or query string resulting in one user.
    # Pass null or undefined to specify a user type for mocking objects.
    #
    # @param {string} user A user id, object or null.
    # @example Create a User for unit testing.
    #   sdk.user().mock((error, result) ->
    #       ...
    #   )
    # @example Observe a user.
    #   sdk.observe("key").user().callback((error, result) ->
    #       ...
    #   )
    # @return {object} this
    user: (user) ->
        @users([user])
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
    vehicles: (vehicles) ->
        state.resource = 'Vehicles'
        state.object = vehicles
        return @

    # Specify a vehicle to apply operations to in the fluent chain.
    #
    # A vehicle id, object or query string resulting in one vehicle.
    # Pass null or undefined to specify a vehicle type for mocking objects.
    #
    # @param {string} vehicle A vehicle id, object or null.
    # @example Create a User for unit testing.
    #   sdk.vehicle().mock((error, result) ->
    #       ...
    #   )
    # @example Observe a vehicle.
    #   sdk.observe("key").vehicle().callback((error, result) ->
    #       ...
    #   )
    # @return {object} this
    vehicle: (vehicle) ->
        @vehicles([vehicle])
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
    mojios: (mojios) ->
        state.resource = 'Vehicles'
        state.object = vehicles
        return @

    # Specify a mojio to apply operations to in the fluent chain.
    #
    # A mojio id, object or query string resulting in one mojio.
    # Pass null or undefined to specify a mojio type for mocking objects.
    #
    # @param {string} mojio A mojio id, object or null.
    # @example Create a User for unit testing.
    #   sdk.mojio().mock((error, result) ->
    #       ...
    #   )
    # @example Observe a mojio.
    #   sdk.observe("key").mojio().callback((error, result) ->
    #       ...
    #   )
    # @return {object} this
    mojio: (mojio) ->
        @mojios([mojio])
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
    trips: (trips) ->
        state.resource = 'Trips'
        state.object = trips
        return @

    # group
    # @return {object} this
    groups: (names, callback) ->
        #todo:: instantiate groups from names?
        state.resource = 'Groups'
        state.object = names
        @callback(callback) if (callback?)
        return @

    # groups
    # @return {object} this
    group: (name, callback) ->
        @groups([name])
        @callback(callback) if (callback?)
        return @

    # permissions
    # @return {object} this
    permissions: (user, callback) ->
        @callback(callback) if (callback?)
        return @

    # Specify an image to apply operations to in the fluent chain. One image can be associated with either Vehicles or Users.
    #
    # @return {object} this
    image: (image) ->
        state.action = 'Image'
        state.object = image
        return @

    # Specify a tag to apply operations to in the fluent chain. Tags are secondary resources associated with Vehicles, Mojios, Users, Groups, or Trips
    #
    # @return {object} this
    tags: (tags) ->
        state.action = 'Tags'
        state.object = tags
        return @

    # Specify a tag to apply operations to in the fluent chain. Tags are secondary resources associated with Vehicles, Mojios, Users, Groups, or Trips
    #
    # @return {object} this
    tag: (tag) ->
        tags([tag])
        return @

    # Return the name of a resource as a string
    # @parameter {string} Get the name of the resource or action. default is "resource"
    # @example Return the string used to retrieve a vehicle:
    #   sdk.vehicles().name() # returns "Vehicle"
    # @example Return the string used to retrieve a vehicle:
    #   sdk.vehicles().tag().name() # returns "Image"
    # @return {string} The name of a resource or action
    name: (type = "resource") ->
        return state[type] # resource or action


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
        return @


