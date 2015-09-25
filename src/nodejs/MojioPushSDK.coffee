# version 4.0.0
Http = require './HttpNodeWrapper'
SignalR = require './SignalRNodeWrapper'
FormUrlencoded = require 'form-urlencoded'
_ = require 'underscore'
MojioSharingSDK = require './MojioSharingSDK'

module.exports = class MojioPushSDK extends MojioSharingSDK

    defaultTransports = { signalr: {}, httpPost: {}}
    # Instantiate the Mojio Push SDK.
    #
    # @param {object} options
    # @return {object} this
    constructor: (transports, options={}) ->
        _.extend(@, transports)
        super(options)

    # Observe a Vehicle, Mojio, or User object in the Mojio API.
    #
    # Observers on particular objects are setup by chaining them with calls to the RestSDK's entity methods: Vehicle, Vehicles, User, Users, Mojio, or Mojios.
    # The observer will observe the entities specified in those calls.
    # @param {string} key This parameter is a name that can be used to find the observer later, or to modify it.
    # @param {function} callback Optional parameter to initiate the fluent chain if needed.
    # @example
    #   sdk.observe("MyUniqueKeyName")
    #   .vehicles() # observe all vehicles for the account of the authorized token
    # @example
    #   sdk.observe("MyUniqueKeyName")
    #    .vehicle("[some id]") # observe all vehicles for a specific vehicle
    #    .callback((error, result) ->
    #       console.log("success in creating an observer") if (result?)
    #    )
    # @return {object} this
    observe: (key, callback) ->
        @callback(callback) if (callback?)
        return @

    # Limit the fields returned to a specific set of properties.
    #
    # Fields are given as an array of strings that are the names of the properties of the entity returned.
    # @param {array of strings} fields The fields of an object to deliver in the results of a query.
    # @param {function} callback Optional parameter to initiate the fluent chain if needed.
    # @example
    #   sdk.observe({key: "MyUniqueKeyName"})
    #   .vehicles()
    #   .fields(
    #           "VIN",
    #           "AccidentState",
    #           "Battery",
    #           "Location",
    #           "Heading",
    #           "Altitude",
    #           "Speed",
    #           "Accelerometer",
    #           "LastContactTime",
    #           "GatewayTimeStamp",
    #           "FuelLevel"
    #       ])
    # @return {object} this
    fields: (fields, callback) ->
        @callback(callback) if (callback?)
        return @

    # The condition that must be satisfied for the observer to fire.
    #
    # When the condition fires, the observer sends data. For instance, if the observer is setup
    # with the condition send data when MilStatus is true, it will fire when the MilStatus field on the vehicle
    # changes from false to true. See "timing" below to change the time when the data is sent.
    # @param {string} clause A where clause for queries.
    # @param {function} callback Optional parameter to initiate the fluent chain if needed. 
    # @return {object} this
    # @example Send only when the battery level transitions is in this condition
    #   sdk.observe({key: "MyUniqueKeyName"})
    #   .vehicles()
    #   .where("Battery > min or Battery < max")
    where: (clause, callback) ->
        @callback(callback) if (callback?)
        return @

    # Specify how data is sent.
    #
    # Specify the transport used to send data. Possible transports are numerous and include: SignalR, Http Post, MQTT, etc.
    # @param {object} transport An object that contains the information about how the entity will be delivered, eg http post, signalr etc.
    # @param {function} callback Optional parameter to initiate the fluent chain if needed. 
    # @return {object} this
    # @example Use SignalR as a transport with the given callback:
    #   # coffeescript
    #   sdk.observe({key: "MyUniqueKeyName"})
    #   .vehicles()
    #   .transport({
    #       Type: "SignalR",
    #       Callback: (error, result) -> # function to call when the condition fires.
    #           console.log("Error:"+ JSON.stringify(error)) if error
    #          console.log(JSON.stringify(result)) if result
    #   })
    transport: (transport, callback) ->
        @callback(callback) if (callback?)
        return @

    # Limit how much data is sent.
    #
    # Throttle back the data sent by telling the push API to send data at a limited rate. The rate is limited by
    # specifying a window of time to refrain from sending data after the observer has fired.
    # @param {object} throttle An object that defines how often to send data.
    # @param {function} callback Optional parameter to initiate the fluent chain if needed. 
    # @return {object} this
    # @example Don't send data faster than 10 seconds, in other words, once data is sent, don't send anything again until 10 seconds have past.
    #   throttle("10 seconds")
    throttle: (throttle, callback) ->
        @callback(callback) if (callback?)
        return @

    # Debounce the condtion for the obserer.
    #
    # Prevent false positives by making sure that the condition has fired by specifying either the number of
    # readings required for a condition to be considered true, or specifying the amount of time the condition must
    # be true in order to be sure of the change.
    # @param {object} debounce An object that defines how to smooth out detection of transitions of state.
    # @param {function} callback Optional parameter to initiate the fluent chain if needed. 
    # @return {object} this
    # @example Set the observer so that it detects a transition if 6 true data points show the change.
    #   debounce({ DataPoints: 6 })
    # @example Set the observer so that it detects a transition if the change has been active for 15 seconds.
    #   debounce({ TimeWindow: "00:00:15" }) # time window is given in a csharp timespan format
    # @example Set the observer so that it detects a transition there are 6 true datapoints within 15 seconds.
    #   debounce({ DataPoints: 6, TimeWindow: "00:00:15" }) # time window is given in a csharp timespan format
    debounce: (debounce, callback) ->
        @callback(callback) if (callback?)
        return @

    # Set the timing of the observer. Timing refers to when to send data in relation to the given condition.
    # Possible timings are: leading, trailing, high, low, edge, and continuous.
    #
    # leading- deliver data when the condition transitions from false to true.
    #
    # trailing- deliver the data when the condition transitions from true to false
    #
    # high- deliver the data when the condition is true and information comes from the vehicle (subject to throttle)
    #
    # low- deliver the data when the condition is false and information comes from the vehicle (subject to throttle)
    #
    # edge- both leading and trailing edges
    #
    # continuous- both high and low
    #
    # @param {string} states An object that defines how to smooth out detection of transitions of state.
    # @param {function} callback Optional parameter to initiate the fluent chain if needed.
    # @return {object} this
    # @example Set the observer so that it detects a transition if 6 data points show the change.
    #   timing("high")
    # @example Set the observer so that it detects a transition if the change has been active for 15 seconds.
    #   timing("leading")
    timing: (state, callback) ->
        @callback(callback) if (callback?)
        return @


