MojioSDK = require '../../src/nodejs/sdk/MojioSDK'
MojioRestSDK = require '../../src/nodejs/sdk/MojioRestSDK'

should = require('should')
async = require('async')
nock = require 'nock'

describe 'Node Mojio Fluent Rest SDK', ->
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
    sdk = new MojioSDK({ sdk: MojioRestSDK, client_id: 'id', client_secret: 'secret', test: true })

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
                    sdk.mock().user({}).callback(
                        (error, result) -> user = result; cb(error, result))
            ,
                (cb) ->
                    sdk.mojio({UserId: user.id, Imei: "9991234567891234"})
                    .mock().callback((error, result) -> mojio = result; cb(error, result))
            ,
                (cb) ->
                    sdk.mock().vehicle({MojioId: mojio.id, UserId: user.id, Speed: 80}).callback(
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
                sdk.create().vehicle({ }).for(user).callback( (error, result) ->
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