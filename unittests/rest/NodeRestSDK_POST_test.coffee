MojioSDK = require '../../src/nodejs/sdk/MojioSDK'
MojioRestSDK = require '../../src/nodejs/sdk/MojioRestSDK'

should = require('should')
async = require('async')
nock = require 'nock'

describe 'Node Mojio Fluent Rest SDK POST calls', ->
    user = null
    mojio = null
    vehicle = null
    client_id = 'cacc0d94-b6b4-4da7-9983-3991de197038'
    client_secret = '427d5794-5021-4274-a6e8-a38d5d83bf99'
    call = null
    timeout = 50
    callback_url = "http://localhost:3000/callback"
    authorization = {
        client_id: client_id,
        client_secret: client_secret
        redirect_uri: 'http://localhost:3000/callback'
        username: 'testing'
        password: 'Test123!'
        scope: 'full'
        grant_type: 'password'
    }
    options = {
        sdk: MojioRestSDK,
        environment: 'staging'
        accountsURL: 'accounts.moj.io'
        apiURL: 'api.moj.io'
        pushURL: 'push.moj.io'
        client_id: authorization.client_id,
        client_secret: authorization.client_secret,
#        styles: [MojioPromiseStyle]

    }
    if options.environment != ''
        testAccountsURL = 'https://'+options.environment+'-'+options.accountsURL
        testApiURL = 'https://'+options.environment+'-'+options.apiURL
    else
        testAccountsURL = 'https://'+options.accountsURL
        testApiURL = 'https://'+options.apiURL


    beforeEach () ->
        user = null
        mojio = null
        vehicle = null
    sdk = new MojioSDK(options)

    it 'can POST and PUT entities and get a resource or secondary resource by ids or lists', (done) ->
        setupTokenNock = () ->
            if (process.env.FUNCTIONAL_TESTS=='true')
                timeout = 3000
                return {done: () ->}
            else
                call = nock(testAccountsURL)
                .post("/oauth2/token", authorization)
                .reply((uri, requestBody, cb) ->
                    cb(null, [200, { id: 4, access_token:"token"}])
                    return
                )
                return call

        setupAuthorizeNock = () ->
            if (process.env.FUNCTIONAL_TESTS=='true')
                timeout = 3000
                return {done: () ->}
            else
                call = nock(testAccountsURL)
                .post("/oauth2/token", authorization)
                .reply((uri, requestBody, cb) ->
                    cb(null, [200, { id: 2, access_token:"token"}])
                    return
                )
                return call

        setupNock = (api, verb, version, primary_, pid_, secondary_, sid_, _tertiary, tid_) ->
            if (process.env.FUNCTIONAL_TESTS=='true')
                timeout = 3000
                return {done: () ->}
            else
                test = {
                    pid: pid_
                    sid: sid_
                    tid: tid_
                    secondary: secondary_
                    primary: primary_
                    tertiary: _tertiary
                }

                pathFilter = (path) ->
                    parts = path.split('/')
                    idRegex = /\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b/
                    parts = parts[1...parts.length]
                    versionValid = parts[0] is version
                    parts = parts[1...parts.length]
                    if parts.length == 1 # # /primary
                        valid = parts[0] is test.primary
                    else if parts.length == 2 # /primary/[id]
                        valid = parts[0] is test.primary and (parts[1].match(idRegex) or parts[1] == ""+test.pid)
                    else if parts.length == 3 # /primary/[id]/secondary
                        valid = parts[0] is test.primary    and (parts[1].match(idRegex) or parts[1] == ""+test.pid) and
                            parts[2] is test.secondary
                    else if parts.length == 4 and test.sid? # /primary/[pid]/secondary/[sid]
                        valid = (parts[0] is test.primary   and (parts[1].match(idRegex) or parts[1] == ""+test.pid) and
                            parts[2] is test.secondary and (parts[3].match(idRegex) or parts[3] is ""+test.sid))
                    else if parts.length == 4 and !test.sid? # /primary/[pid]/secondary/tertiary
                        valid = (parts[0] is test.primary   and (parts[1].match(idRegex) or parts[1] == ""+test.pid) and
                            parts[2] is test.secondary and parts[3] is test.tertiary)
                    else if parts.length == 5  # /primary/[id]/secondary/[id]/tertiary
                        valid = (parts[0] is test.primary   and (parts[1].match(idRegex) or parts[1] == ""+test.pid) and
                            parts[2] is test.secondary and (parts[3].match(idRegex) or parts[3] == ""+test.sid) and
                            parts[4] is test.tertiary)
                    else if parts.length == 6  # /primary/[id]/secondary/[id]/tertiary/id
                        valid = (parts[0] is test.primary   and (parts[1].match(idRegex) or parts[1] == ""+test.pid) and
                            parts[2] is test.secondary and (parts[3].match(idRegex) or parts[3] == ""+test.sid) and
                            parts[4] is test.tertiary  and (parts[5].match(idRegex) or parts[5] == ""+test.tid))
                    if valid and versionValid
                        return '/true'
                    else
                        return '/false'

                nock.removeInterceptor({hostname:api})
                call = nock(api).filteringPath(pathFilter)[verb]('/true')
                .reply((uri, requestBody, cb) ->
                    cb(null, [200, { id: 3, message: "hi"}])
                    return
                )
                return call


        testErrorResult = (error, result) ->
            console.log("ERROR: "+error.statusMessage+" content:"+error.content) if error?
            (error==null).should.be.true
            (result!=null).should.be.true

        execute = (test, doneOne) ->
            async.series([ # todo encrypted password
                    (cb) ->
                        setupAuthorizeNock()
                        sdk
                        .token(authorization.redirect_uri)
                        .credentials(authorization.username, authorization.password)
                        .scope(['full'])
                        .callback((error, result) ->
                            if (error)
                                console.log('Access Token Error'+"  url:"+sdk.url())
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
                        test(cb) # execute a test.

                ]
            ,
                # callback when the series is done or in error.
                (error, results) ->
                    console.log(error) if error?
                    (error==null).should.be.true
                    # todo:: test results for correctness.
                    (results!=null).should.be.true # test results content to be the observed entitiy
                    doneOne()
                    return
            )



        setupPostPutNock = (api, verb, version, primary_, pid_, secondary_, data_) ->
            if (process.env.FUNCTIONAL_TESTS=='true')
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
                        return '/true' #'/'+check.primary+'/'+check.pid+'/'+check.secondary
                    else
                        return '/false'
                )[verb]('/true', check.data) #'/'+check.primary+'/'+check.pid+'/'+check.secondary, check.data)
                .reply((uri, requestBody, cb) ->
                    cb(null, [200, { id: 1, name: "name"}]))
                return null

#        @.timeout(5000)

        docall = (verb, entity, pid=null, secondary=null, data = null) ->
            if entity == 'Trips' and secondary == 'Permissions' and verb == 'put'
                finish = done
            else
                finish = (() ->)
            execute(
                (cb) ->
                    if (secondary?)
                        call = setupPostPutNock(testApiURL, verb, 'v2', entity, pid, secondary, data)
                        sdk[verb]()[entity](pid)[secondary](data).callback((error, result) ->
                            testErrorResult(error, result)
                            cb(null, result)
                        )
                    else
                        call = setupPostPutNock(testApiURL, verb, 'v2', entity, null, null, data)
                        sdk[verb]()[entity](data).callback((error, result) ->
                            testErrorResult(error, result)
                            cb(null, result)
                        )

            , finish
            )
        entities = ['Mojios', 'Vehicles', 'Users', 'Apps', 'Groups', 'Trips']
        secondaries = ['Tags', 'Permissions', 'Images', 'Details']
        for entity in entities
            docall('post',entity, null, null, {name: 'name'+entity})
            docall('put',entity, null, null, {name: 'name'+entity})
            for secondaryEntity in secondaries
                docall('post',entity,1,secondaryEntity, {name: 'name/'+entity+'/1/'+secondaryEntity})
                docall('put',entity,1,secondaryEntity, {name: 'name/'+entity+'/1/'+secondaryEntity})

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