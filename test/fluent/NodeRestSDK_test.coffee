MojioSDK = require '../../src/nodejs/MojioSDK'
should = require('should')
async = require('async')

describe 'Node Mojio Rest SDK', ->
    sdk = new MojioSDK()
    user = null
    mojio = null
    vehicle = null

    testErrorResult = (error, result) ->
        (error==null).should.be.true
        (result!=null).should.be.true

    execute = (test, done) ->
        async.series([ # todo encrypted password
                (cb) ->
                    sdk.authorize({type: "token", user: "unittest@moj.io", password: "mojioRocks" },
                        ((error, result) -> vehicle = result; cb(error, result)))
            ,
                (cb) ->
                    sdk.mock().user({}).callback(
                        (error, result) -> user = result; cb(error, result))
            ,
                (cb) ->
                    sdk.mojio({UserId: user.id, Imei: "9991234567891234"})
                    .mock((error, result) -> mojio = result; cb(error, result))
            ,
                (cb) ->
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
                #(error==null).should.be.true
                # todo:: test results for correctness.
                (result!=null).should.be.true # test results content to be the observed entitiy
                done()
        )
    beforeEach () ->
        user = null
        mojio = null
        vehicle = null

    it 'can create create a vehicle', (done) ->
        @.timeout(5000)
        execute(
            (cb) ->
                sdk.create().vehicle({ }).for(user).callback((error, result) ->
                    testErrorResult(error, result)
                    # todo: test validity of vehicle
                    cb(null, result)
                )
            , done
        )
    it 'can create create a vehicle', (done) ->
        @.timeout(5000)
        execute(
            (cb) ->
                sdk.create().vehicle({ }).for(user, (error, result) ->
                    testErrorResult(error, result)
                    # todo: test validity of vehicle
                    cb(null, result)
                )
            , done
        )

    it 'can create share and revoke a vehicle', (done) ->
        @.timeout(5000)
        execute(
            (cb) ->
                sdk.share().vehicle(vehicle).with(user).access("write").callback((error, result) ->
                    testErrorResult(error, result)
                    # todo: test validity of vehicle
                    cb(null, result)
                )
                sdk.revoke().vehicle(vehicle).from(user).callback((error, result) ->
                    testErrorResult(error, result)
                    # todo: test validity of vehicle
                    cb(null, result)
                )
            , done
        )
    it 'can create share and revoke a list of vehicles', (done) ->
        @.timeout(5000)
        execute(
            (cb) ->
                sdk.share().vehicles([vehicle]).with(user).access("read").callback((error, result) ->
                    testErrorResult(error, result)
                    # todo: test validity of vehicle
                    cb(null, result)
                )
                sdk.revoke().vehicles([vehicle]).from(user).access("read").callback((error, result) ->
                    testErrorResult(error, result)
                    # todo: test validity of vehicle
                    cb(null, result)
                )
            , done
        )
    it "can create share and revoke a vehicle's fields", (done) ->
        @.timeout(5000)
        execute(
            (cb) ->
                sdk.share().vehicle(vehicle).fields(['location', 'speed']).with(user).access("read").callback((error, result) ->
                    testErrorResult(error, result)
                    # todo: test validity of vehicle
                    cb(null, result)
                )
                sdk.revoke().vehicle(vehicle).from(user).access("read").callback((error, result) ->
                    testErrorResult(error, result)
                    # todo: test validity of vehicle
                    cb(null, result)
                )
        , done
        )
    it 'can create group add/remove users', (done) ->
        @.timeout(5000)
        execute(
            (cb) ->
                sdk.create().group({name: "blah"}).with([user]).callback((error, result) ->
                    testErrorResult(error, result)
                    # todo: test validity of vehicle
                    (error, result) ->
                        group = result
                )

                sdk.group("blah").add(user).callback((error, result) ->
                    testErrorResult(error, result)
                    # todo: test validity of vehicle
                    cb(null, result)
                )
                sdk.add(user).into().group("blah").callback((error, result) ->
                    testErrorResult(error, result)
                    # todo: test validity of vehicle
                    cb(null, result)
                )
                sdk.remove(user).outof().group("blah").callback((error, result) ->
                    testErrorResult(error, result)
                    # todo: test validity of vehicle
                    cb(null, result)
                )
                sdk.create().mojio({imei: "123981392131"}) # attach to current user.
            , done
        )