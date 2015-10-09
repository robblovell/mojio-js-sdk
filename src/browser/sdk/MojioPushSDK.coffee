# version 4.0.0

MojioRestSDK = require './MojioRestSDK'
# The Push segment of the Mojio SDK. The Push segement of the SDK provides a mechanism for applications to subscribe
# to changes occurring on primary API resources of Vehicles, Users, Mojios, Trips, Groups, and Apps.
#
# Mojio maintains a separate "Push" style API where applications can subscribe to changes on resources and receive those
# changes across multiple transports.  Current transports include: SIGNALR, HTTPS POST, and MQTT.
#
# Subscriptions are instantiated by posting "Observers" to the Push API's REST interface.  Observers define what, when
# and how data is channeled to the application from the server.
#
# What is defined by specification of the resource type and id.
# The "What" delivered can be narrowed down to a specific set of fields through a filter specification (basically a list of the names of the fields).
#
# The "When" is defined by optional conditions, debounce, throttle, and timings.
#
# The "How" is defined by a transport specification
# that has the connection details to a method, server or hub, depending on the transport type.  For SignalR, Mojio provides
# the hub of communication, for other protocols like MQTT or Http Post, the application writer is responsible for the
# communication infrastructure.
#
#
# The inheritance path is:
#    MojioPushSDK->MojioRestSDK->MojioAuthSDK->MojioModelSDK
#
#
# @example
#   mojioSdk = new MojioSDK({sdk: MojioPushSDK}) # instantiate the mojioSDK to all available API calls.
#
module.exports = class MojioPushSDK extends MojioRestSDK
    defaults = {
        hostname: 'api2.moj.io'
        version: 'v2'
    }
    defaultTransports = { signalr: {}, httpPost: {}}

    # Instantiate the Mojio Push SDK.
    #
    # @param {object} options
    # @return {object} this
    # @nodoc
    constructor: (transports, options={}) ->
        for property, value of transports
            @[property] = value
#        _.extend(@, transports)
        super(options)

    # Observe a Vehicle, Mojio, or User object in the Mojio API.
    #
    # Observers on particular objects are setup by chaining them with calls to the RestSDK's entity methods: Vehicle, Vehicles, User, Users, Mojio, or Mojios.
    # The observer will observe the entities specified in those calls.
    # @param {string} key This parameter is a name that can be used to find the observer later, or to modify it.
    # @param {function} callback Optional parameter to initiate the fluent chain if needed.
    # @example observe all vehicles for this user, assumes SignalR transport and the callback given is the handler.
    #   sdk.observe("MyUniqueKeyName")
    #   .vehicles() # observe all vehicles for the account of the authorized token
    #   .callback((error, result) ->
    #        if (typeof result is 'boolean') # this is a callback via nodejs return
    #            console.log("Vehicle Observer created with signalR transport and this callback as the handler")
    #        else if (result instanceof 'object') # we are in a callback via signalR
    #            ... # receive the changes to the objects.
    #    )
    # @example
    #   sdk.observe("MyUniqueKeyName")
    #    .vehicle("[some id]") # observe all vehicles for a specific vehicle
    #    .callback((error, result) ->
    #       console.log("success in creating an observer") if (result?)
    #    )
    # @return {object} this
    observe: (key) ->
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
    fields: (fields) ->
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
    where: (clause) ->
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
    transport: (transport) ->
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
    throttle: (throttle) ->
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
    debounce: (debounce) ->
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
    timing: (state) ->
        return @


