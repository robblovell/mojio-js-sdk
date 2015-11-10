MojioSDK = require '../../src/nodejs/sdk/MojioSDK'
MojioRestSDK = require '../../src/nodejs/sdk/MojioRestSDK'

should = require('should')
async = require('async')
nock = require 'nock'

describe 'Node Mojio Fluent Rest SDK', ->
    user = null
    mojio = null
    vehicle = null
    client_id = '41a04077-0157-49fb-a35c-6e2824f3b348'
    client_secret = 'd80357f8-cbc9-4022-b340-6e99a72e7e0b'
    call = null
    timeout = 50
    callback_url = "http://localhost:3000/callback"
    authorization = {
        client_id: client_id,
        client_secret: client_secret
        redirect_uri: 'http://localhost:3000/callback'
        username: 'testing@moj.io'
        password: 'Test123!'
        scope: 'full'
        grant_type: 'password'
    }
    sdk = new MojioSDK({ sdk: MojioRestSDK, client_id: client_id, client_secret: client_secret, test: true })
    setupTokenNock = () ->
        if (process.env.FUNCTIONAL_TESTS?)
            timeout = 3000
            return {done: () ->}
        else
            call = nock('https://accounts.moj.io')
            .post("/oauth2/token", {
                    client_id: client_id,
                    client_secret: client_secret})
            .reply((uri, requestBody, cb) ->
                cb(null, [200, { id: 1, access_token:"token"}]))
            return call
    setupAuthorizeNock = () ->
        if (process.env.FUNCTIONAL_TESTS?)
            timeout = 3000
            return {done: () ->}
        else
            call = nock('https://accounts.moj.io')
            .post("/oauth2/token", authorization)
            .reply((uri, requestBody, cb) ->
                cb(null, [200, { id: 1, access_token:"token"}]))
            return call

    setupNock = (api, verb, version, primary_, pid_, secondary_, sid_, _tertiary, tid_) ->
        if (process.env.FUNCTIONAL_TESTS?)
            timeout = 3000
            return {done: () ->}
        else
            pid = pid_
            sid = sid_
            tid = tid_
            secondary = secondary_
            primary = primary_
            tertiary = _tertiary
            call = nock(api).filteringPath((path) ->

                parts = path.split('/')
                idRegex = /\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b/
                parts = parts[1...parts.length]
                versionValid = parts[0] is version
                parts = parts[1...parts.length]
                if parts.length == 1 # # /primary
                    valid = parts[0] is primary
                else if parts.length == 2 # /primary/[id]
                    valid = parts[0] is primary and (parts[1].match(idRegex) or parts[1] == ""+pid)
                else if parts.length == 3 # /primary/[id]/secondary
                    valid = parts[0] is primary    and (parts[1].match(idRegex) or parts[1] == ""+pid) and
                            parts[2] is secondary
                else if parts.length == 4 and sid? # /primary/[pid]/secondary/[sid]
                    valid = (parts[0] is primary   and (parts[1].match(idRegex) or parts[1] == ""+pid) and
                             parts[2] is secondary and (parts[3].match(idRegex) or parts[3] is ""+sid))
                else if parts.length == 4 and !sid? # /primary/[pid]/secondary/tertiary
                    valid = (parts[0] is primary   and (parts[1].match(idRegex) or parts[1] == ""+pid) and
                             parts[2] is secondary and parts[3] is tertiary)
                else if parts.length == 5  # /primary/[id]/secondary/[id]/tertiary
                    valid = (parts[0] is primary   and (parts[1].match(idRegex) or parts[1] == ""+pid) and
                             parts[2] is secondary and (parts[3].match(idRegex) or parts[3] == ""+sid) and
                             parts[4] is tertiary)
                else if parts.length == 6  # /primary/[id]/secondary/[id]/tertiary/id
                    valid = (parts[0] is primary   and (parts[1].match(idRegex) or parts[1] == ""+pid) and
                             parts[2] is secondary and (parts[3].match(idRegex) or parts[3] == ""+sid) and
                             parts[4] is tertiary  and (parts[5].match(idRegex) or parts[5] == ""+tid))
                if valid and versionValid
                    return '/true'
                else
                    return '/false'
            )[verb]('/true')
            .reply((uri, requestBody, cb) ->
                cb(null, [200, { id: 1, message: "hi"}]))
            return call

    setupPostNock = (api, verb, version, primary_, pid_, secondary_, data_) ->
        if (process.env.FUNCTIONAL_TESTS?)
            timeout = 3000
            return {done: () ->}
        else
            check = {
                pid: pid_
                data: data_
                secondary: secondary_
                primary: primary_
            }
            call = nock(api).filteringPath((path) ->
                parts = path.split('/')
                idRegex = /\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b/
                parts = parts[1...parts.length]
                versionValid = parts[0] is version
                parts = parts[1...parts.length]
                if parts.length == 1 # /primary & [data]
                    valid = parts[0] is check.primary
                else if parts.length == 3 # /primary/[id]/secondary & [data]
                    valid = parts[0] is check.primary and (parts[1].match(idRegex) or parts[1] == ""+check.pid) and
                            parts[2] is check.secondary

                if valid and versionValid
                    return '/'+check.primary+'/'+check.pid+'/'+check.secondary
                else
                    return '/false'
            )[verb]('/'+check.primary+'/'+check.pid+'/'+check.secondary, check.data)
            .reply((uri, requestBody, cb) ->
                cb(null, [200, { id: 1, name: "name"}]))
            return call

    testErrorResult = (error, result) ->
        console.log("ERROR: "+error) if error?
        (error==null).should.be.true
        (result!=null).should.be.true

    execute = (test, done) ->
        async.series([ # todo encrypted password
                (cb) ->
                    setupAuthorizeNock()
                    sdk
                    .token(authorization.redirect_uri)
                    .credentials(authorization.username, authorization.password)
                    .scope(['full'])
                    .callback((error, result) ->
                        if (error)
                            console.log('Access Token Error', JSON.stringify(error.content)+
                                    "  message:"+error.statusMessage+"  url:"+sdk.url())
                            cb(error, result)
                        else
                            setupTokenNock()
                            sdk.token().parse(result).callback((error, result) ->
                                token = result
                                cb(error, result)
                            )
                    )
#            ,
#                (cb) ->
#                    console.log("mock the user")
#                    sdk.mock().user({}).callback(
#                        (error, result) -> user = result; cb(error, result))
#            ,
#                (cb) ->
#                    console.log("mock the mojio")
#
#                    sdk.mojio({UserId: user.id, Imei: "9991234567891234"})
#                    .mock().callback((error, result) -> mojio = result; cb(error, result))
#            ,
#                (cb) ->
#                    console.log("mock the vehicle")
#                    sdk.mock().vehicle({MojioId: mojio.id, UserId: user.id, Speed: 80}).callback(
#                        ((error, result) -> vehicle = result; cb(error, result)))
            ,
                (cb) ->
#                    console.log("run the test")
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

    it 'can GET a resource or list of resources, secondary resource, or history by ids or no query', (done) ->
#        @.timeout(5000)

        docall = (entity, pid=null, secondary=null, sid=null, tertiary=null, tid=null) ->
            if entity == 'Trips' and secondary == 'History' and tertiary == 'Locations'
                finish = done
            else
                finish = (() ->)
            execute(
                (cb) ->
                    console.log(entity)
                    console.log(secondary)
                    console.log(tertiary)
                    if (tertiary?)
                        setupNock('https://api2.moj.io', 'get', 'v2', entity, pid, secondary, null, tertiary, null)
                        sdk.get()[entity](pid)[secondary]()[tertiary]().callback((error, result) ->
                            testErrorResult(error, result)
                            cb(null, result)
                        )
                    else if (secondary?)
                        if sid?
                            setupNock('https://api2.moj.io', 'get', 'v2', entity, pid, secondary, sid, null, null)
                            sdk.get()[entity](pid)[secondary](sid).callback((error, result) ->
                                testErrorResult(error, result)
                                cb(null, result)
                            )
                        else if pid?
                            setupNock('https://api2.moj.io', 'get', 'v2', entity, pid, secondary, null, null, null)
                            sdk.get()[entity](pid)[secondary]().callback((error, result) ->
                                testErrorResult(error, result)
                                cb(null, result)
                            )
                    else
                        if pid?
                            setupNock('https://api2.moj.io', 'get', 'v2', entity, pid, null, null, null, null)
                            sdk.get()[entity](pid).callback((error, result) ->
                                testErrorResult(error, result)
                                cb(null, result)
                            )
                        else
                            setupNock('https://api2.moj.io', 'get', 'v2', entity, null, null, null, null, null)
                            sdk.get()[entity]().callback((error, result) ->
                                testErrorResult(error, result)
                                cb(null, result)
                            )
            , finish
            )
        entities = ['Vehicles', 'Mojios', 'Users', 'Apps', 'Groups', 'Trips']
        secondaries = ['Tags', 'Permissions']
        for entity in entities
            docall(entity)
            docall(entity, 1)
            for secondaryEntity in secondaries
                docall(entity,1,secondaryEntity)
                docall(entity,1,secondaryEntity, 1)
        entities = ['Vehicles', 'Trips']
        secondaries = ['History']
        tertiary = ['States','Locations']
        for entity in entities
            for secondaryEntity in secondaries
                for tertiaryEntity in tertiary
                    docall(entity,1,secondaryEntity,null,tertiaryEntity, null)

    it 'can POST and PUT entities and get a resource or secondary resource by ids or lists', (done) ->
#        @.timeout(5000)

        docall = (entity, pid=null, secondary=null, data = null) ->
            if entity == 'Trips' and secondary == 'Permissions'
                finish = done
            else
                finish = (() ->)
            execute(
                (cb) ->
                    console.log("Primary:"+entity)
                    console.log("Pid:"+pid)
                    console.log("Secondary:"+secondary)
                    console.log("Data:"+JSON.stringify(data))
                    if (secondary?)
                        console.log("Setup Nock")
                        setupPostNock('https://api2.moj.io', 'post', 'v2', entity, pid, secondary, data)
                        sdk.post()[entity](pid)[secondary](data).callback((error, result) ->
                            testErrorResult(error, result)
                            cb(null, result)
                        )
                    else
                        console.log("Setup Nock")
                        setupPostNock('https://api2.moj.io', 'post', 'v2', entity, null, null, data)
                        sdk.post()[entity](data).callback((error, result) ->
                            testErrorResult(error, result)
                            cb(null, result)
                        )

            , finish
            )
        entities = ['Mojios', 'Vehicles', 'Users', 'Apps', 'Groups', 'Trips']
        secondaries = ['Tags', 'Permissions']
        for entity in entities
            docall(entity, null, null, {name: 'name'+entity})
#            for secondaryEntity in secondaries
#                docall(entity,1,secondaryEntity, {name: 'name/'+entity+'/1/'+secondaryEntity})

#    it 'can create share and revoke a vehicle', (done) ->
#        @.timeout(5000)
#        execute(
#            (cb) ->
#                sdk.share().vehicle(vehicle).with(user).access("write").callback((error, result) ->
#                    testErrorResult(error, result)
#                    # todo: test validity of vehicle
#                    cb(null, result)
#                )
#                sdk.revoke().vehicle(vehicle).from(user).callback((error, result) ->
#                    testErrorResult(error, result)
#                    # todo: test validity of vehicle
#                    cb(null, result)
#                )
#            , done
#        )
#    it 'can create share and revoke a list of vehicles', (done) ->
#        @.timeout(5000)
#        execute(
#            (cb) ->
#                sdk.share().vehicles([vehicle]).with(user).access("read").callback((error, result) ->
#                    testErrorResult(error, result)
#                    # todo: test validity of vehicle
#                    cb(null, result)
#                )
#                sdk.revoke().vehicles([vehicle]).from(user).access("read").callback((error, result) ->
#                    testErrorResult(error, result)
#                    # todo: test validity of vehicle
#                    cb(null, result)
#                )
#            , done
#        )
#    it "can create share and revoke a vehicle's fields", (done) ->
#        @.timeout(5000)
#        execute(
#            (cb) ->
#                sdk.share().vehicle(vehicle).fields(['location', 'speed']).with(user).access("read").callback((error, result) ->
#                    testErrorResult(error, result)
#                    # todo: test validity of vehicle
#                    cb(null, result)
#                )
#                sdk.revoke().vehicle(vehicle).from(user).access("read").callback((error, result) ->
#                    testErrorResult(error, result)
#                    # todo: test validity of vehicle
#                    cb(null, result)
#                )
#        , done
#        )
#    it 'can create group add/remove users', (done) ->
#        @.timeout(5000)
#        execute(
#            (cb) ->
#                sdk.create().group({name: "blah"}).with([user]).callback((error, result) ->
#                    testErrorResult(error, result)
#                    # todo: test validity of vehicle
#                    (error, result) ->
#                        group = result
#                )
#
#                sdk.group("blah").add(user).callback((error, result) ->
#                    testErrorResult(error, result)
#                    # todo: test validity of vehicle
#                    cb(null, result)
#                )
#                sdk.add(user).into().group("blah").callback((error, result) ->
#                    testErrorResult(error, result)
#                    # todo: test validity of vehicle
#                    cb(null, result)
#                )
#                sdk.remove(user).outof().group("blah").callback((error, result) ->
#                    testErrorResult(error, result)
#                    # todo: test validity of vehicle
#                    cb(null, result)
#                )
#                sdk.create().mojio({imei: "123981392131"}) # attach to current user.
#            , done
#        )