MojioSDK = require '../../src/nodejs/sdk/MojioSDK'
MojioPushSDK = require '../../src/nodejs/sdk/MojioPushSDK'

should = require('should')
async = require('async')
nock = require 'nock'

describe 'Node Mojio Fluent Push SDK', ->
    user = null
    mojio = null
    vehicle = null
    call = null
    timeout = 50
    callback_url = "http://localhost:3000/callback"

    authorization = {
        client_id: 'id',
        client_secret: 'secret'
        redirect_uri: 'http://localhost:3000/callback'
        username: 'testing'
        password: 'Test123!'
        scope: 'full'
        grant_type: 'password'
    }

    sdk = new MojioSDK({ sdk: MojioPushSDK, client_id: 'id', client_secret: 'secret', test: true })

    setupNock = () ->
        if (process.env.FUNCTIONAL_TESTS?)
            timeout = 3000
            return {done: () ->}
        else
            call = nock('https://staging-accounts.moj.io')
            .post("/oauth2/token", authorization)
            .reply((uri, requestBody, cb) ->
                cb(null, [200, { id: 1}]))
            return call

    testErrorResult = (error, result) ->
        (error==null).should.be.true
        (result!=null).should.be.true

    changeVehicle = (vehicle, cb) ->
        sdk.vehicle(vehicle).update((error, result) ->
            cb("Error: Vehicle could not be saved", null) if error?
            console.log("vehicle changed:"+result) if result?
            # observers will call the ultimate callback, or a timeout will occur and call it.
        )

    execute = (test, done) ->
        async.series([ # todo encrypted password
                (cb) ->
                    setupNock()
                    sdk
                    .token(authorization.redirect_uri)
                    .credentials(authorization.username, authorization.password)
                    .scope(['full'])
                    .callback((error, result) ->
                        if (error)
                            console.log('Access Token Error', JSON.stringify(error.content)+"  message:"+error.statusMessage+"  url:"+sdk.url())
                        else
                            token = result
                            console.log("Token:"+JSON.stringify(token))
                        cb(error, result)
                    )
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
                (results!=null).should.be.true # test results content to be the observed entitiy
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
                .throttle("5 samples") # 1 second, 1 minute, 3.17:25:30.5000000
                .debounce("3 samples")
                .debounce("3 seconds")
                .timing(['edge','high'])
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
