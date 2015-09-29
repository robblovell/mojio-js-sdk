MojioSDK = require '../../src/sdk/MojioSDK'
should = require('should')
async = require('async')
nock = require 'nock'

describe 'Node Mojio Fluent Push SDK', ->
    sdk = new MojioSDK()
    user = null
    mojio = null
    vehicle = null

    testErrorResult = (error, result) ->
        (error==null).should.be.true
        (result!=null).should.be.true

    changeVehicle = (vehicle, cb) ->
        sdk.vehicle(vehicle).update((error, result) ->
            cb("Error: Vehicle could not be saved", null) if error?
            console.log("vehicle changed:"+result) if result?
            # observers will call the ultimate callback, or a timeout will occur and call it.
        )

    execute = (test) ->

        async.series([ # todo encrypted password
                (cb) ->
                    console.log("Authorize")
                    sdk.authorize({type: "token", user: "unittest@moj.io", password: "mojioRocks" },
                        ((error, result) -> vehicle = result; cb(error, result)))
            ,
                (cb) ->
                    console.log("Mock User")
                    sdk.mock().user({}).callback(
                        (error, result) -> user = result; cb(error, result))
            ,
                (cb) ->
                    console.log("Mock Mojio")

                    sdk.mojio({UserId: user.id, Imei: "9991234567891234"})
                    .mock((error, result) -> mojio = result; cb(error, result))
            ,
                (cb) ->
                    console.log("Mock Vehicle")

                    sdk.mock().vehicle({MojioId: mojio.id, UserId: user.id, Speed: 80},
                        ((error, result) -> vehicle = result; cb(error, result)))
            ,
                (cb) ->
                    test(cb) # execute a test.
            ]
        ,
            # callback when the series is done or in error.
            (error, results) ->
                console.log(error) if error?
                (error==null).should.be.true
                # todo:: test results for correctness.
                (result!=null).should.be.true # test results content to be the observed entitiy
                done()
        )
    beforeEach () ->
        user = null
        mojio = null
        vehicle = null

    it 'can create an observer of vehicles with minimum defaults', (done) ->
        @.timeout(2000)
        execute(
            (cb) ->
                console.log("Start observer test")
                sdk.observe({key: "UnitTestVehicleDefault"})
                .vehicles()
                # in this case, the callback given below is the signalR callback too.
                .callback((error, result) ->
                    testErrorResult(error, result)
                    if (typeof result is 'boolean') # this is a callback via nodejs return
                        # change the vehicle
                        console.log("Change Vehicle")
                        changeVehicle(vehicle, cb)
                    else if (++callbackTimes == 2 or result instanceof 'object') # we are in a callback via signalR
                        # todo: test validity of vehicle
                        cb(null, result)
                )
            ,
            done
        )


    it 'can create a complex observer of vehicles', (done) ->
        @.timeout(2000)
        execute(
            (cb) ->
                sdk.observe({key: "AccidentStateOnVehicleForMojio"})
                .vehicles()
                .fields([
                        "VIN",
                        "AccidentState",
                        "Battery",
                        "Location",
                        "Heading",
                        "Altitude",
                        "Speed",
                        "Accelerometer",
                        "LastContactTime",
                        "GatewayTimeStamp",
                        "FuelLevel"
                    ])

                .where("Battery > min or Battery < max and MojioId == [mojio id]")
# later: .Where("Battery ∆ -20")

                .throttle("1 second") # 1 second, 1 minute, 3.17:25:30.5000000
                .debounce({
                        DataPoints: 6,
                        TimeWindow: "timespan"
                    })
                .transport({
                        Type: "SignalR",
                        Callback: (error, result) ->
                            testErrorResult(error, result)
                            # todo: test validity of vehicle
                            done()
                    })
                .callback((error, result) ->
                    testErrorResult(error, result)
                    changeVehicle(vehicle, cb)
                )
            ,
            done
        )
