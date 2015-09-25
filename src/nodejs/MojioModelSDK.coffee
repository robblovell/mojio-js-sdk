# version 4.0.0
Http = require './HttpNodeWrapper'
SignalR = require './SignalRNodeWrapper'
FormUrlencoded = require 'form-urlencoded'
_ = require 'underscore'

module.exports = class MojioModelSDK

    constructor: (options={}) ->
        super(options)

    # Specify a list of users to apply operations to in the fluent chain.
    #
    # A list of users can be specified either with an array of users (id's or objects), or a query string.
    # Pass null or undefined for all users accessible by the current user.
    #
    # @param {array or string} users A list of user ids or objects. A string will specify a query.
    # @example Observe a list of users.
    #   sdk.observe("key").users(["user_id1", "user_id2", { some user object }], (error, result) ->
    #       ...
    #   )
    users: (users, callback) ->
        @callback(callback) if (callback?)
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
    user: (user, callback) ->
        @callback(callback) if (callback?)
        return @

    # Specify a list of vehicles to apply operations to in the fluent chain.
    #
    # A list of vehicles can be specified either with an array of vehicles (id's or objects), or a query string.
    # Pass null or undefined for all vehicles accessible by the current vehicle.
    #
    # @param {array or string} vehicles A list of vehicle ids or objects. A string will specify a query.
    # @example Observe a list of vehicles.
    #   sdk.observe("key").vehicles(["vehicle_id1", "vehicle_id2", { some vehicle object }], (error, result) ->
    #       ...
    #   )
    vehicles: (vehicles, callback) ->
        @callback(callback) if (callback?)
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
    vehicle: (vehicle, callback) ->
        @callback(callback) if (callback?)
        return @

    # Specify a list of mojios to apply operations to in the fluent chain.
    #
    # A list of mojios can be specified either with an array of mojios (id's or objects), or a query string.
    # Pass null or undefined for all mojios accessible by the current mojio.
    #
    # @param {array or string} mojios A list of mojio ids or objects. A string will specify a query.
    # @example Observe a list of mojios.
    #   sdk.observe("key").mojios(["mojio_id1", "mojio_id2", { some mojio object }], (error, result) ->
    #       ...
    #   )
    mojios: (mojios, callback) ->
        @callback(callback) if (callback?)
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
    mojio: (mojio, callback) ->
        @callback(callback) if (callback?)
        return @

    # Specify a list of trips to apply operations to in the fluent chain.
    #
    # A list of trips can be specified either with an array of trips (id's or objects), or a query string.
    # Pass null or undefined for all trips accessible by the current trip.
    #
    # @param {array or string} trips A list of trip ids or objects. A string will specify a query.
    # @example Observe a list of trips.
    #   sdk.observe("key").trips(["trip_id1", "trip_id2", { some trip object }], (error, result) ->
    #       ...
    #   )
    trips: (trips, callback) ->
        @callback(callback) if (callback?)
        return @

    # Create models entities for testing purposes.
    #
    # Mocks up objects for testing, objects are not persisted and are created with random values.
    # @param {string} type The model type: Vehicle, User, Mojio, or Trip.
    # @example Create a Vehicle for unit testing
    #   sdk.mock((error, result) ->
    #       Vehicle = result
    #   )
    mock: (callback) ->
        @callback(callback) if (callback?)
        return @

    # An optional call that will initiate the actions of the fluent chain. When the actions of the
    # chain are completed, the given function will be called with the results. In the case of a redirect
    # control will be returned to the url given and you must call authorize again with the results
    # until 'true' is given in the callback results.
    # @param callback {function} A function to call when the fluent chain is complete.
    # @public
    callback: (callback) ->
        callback(null, true)
        return @
