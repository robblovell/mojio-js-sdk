should = require('should')
MojioSDK = require '../../src/nodejs/sdk/MojioSDK'
MojioAuthSDK = require '../../src/nodejs/sdk/MojioAuthSDK'
MojioPromiseStyle = require '../../src/nodejs/styles/MojioPromiseStyle'
MojioReactiveStyle = require '../../src/nodejs/styles/MojioReactiveStyle'
MojioAsyncAwaitStyle = require '../../src/nodejs/styles/MojioAsyncAwaitStyle'
MojioSyncStyle = require '../../src/nodejs/styles/MojioSyncStyle'
nock = require 'nock'
async = require('asyncawait/async')
await = require('asyncawait/await')

describe 'Node Mojio Auth SDK password type auth', ->

    call = null
    timeout = 50
    callback_url = "http://localhost:3000/callback"
    authorization = {
        client_id: 'id',
        client_secret: 'secret'
        redirect_uri: 'http://localhost:3000/callback'
        username: 'testing'
        password: 'Test123!',
        grant_type: 'password',
    }

    setupNock = () ->
        if (process.env.FUNCTIONAL_TESTS?)
            timeout = 3000
            return {done: () ->}
        else
            call = nock('https://accounts.moj.io')
                .post("/oauth2/token", authorization)
                .reply((uri, requestBody, cb) ->
                    cb(null, [200, { id: 1}]))
            return call


    testErrorResult = (error, result) ->
        (error==null).should.be.true
        (result!=null).should.be.true

    it 'can authorize with password flow, callback async', (done) ->
        @.timeout(timeout)
        call = setupNock()

        sdk = new MojioSDK({sdk: MojioAuthSDK, client_id: 'id', client_secret: 'secret', test: true})

        sdk
        .token(callback_url)
        .credentials('testing', 'Test123!')
        .callback(
            (error, result) ->
                testErrorResult(error, result)
                call.done() if call?
                done()
        )

    it 'can authorize with promise', (done) ->
#        @.timeout(timeout)
        call = setupNock()
        sdk = new MojioSDK({sdk: MojioAuthSDK, styles: [MojioPromiseStyle],
        client_id: 'id', client_secret: 'secret', test: true})

        promise = sdk
        .token(callback_url)
        .credentials('testing', 'Test123!')
        .promise()

        promise
        .then(
            (result) ->
                testErrorResult(null, result)
                call.done() if call?
                done()
            ,
            (error) ->
                console.log("")
                console.log("Error with promise: "+error)
                process.exit(1)

        )


#
#    it 'can authorize with reactive observable.', (done) ->
#        @.timeout(timeout)
#        Rx = require('rx')
#
#        sdk = new MojioSDK({sdk: MojioAuthSDK, styles: [MojioReactiveStyle], test: true})
#
#        observable = sdk
#        .authorize(authorization)
#        .observable()
#        observer = Rx.Observer.create(
#            (result) -> console.log("Result:#{JSON.stringify(result)}")
#        ,
#            (error) -> console.log("Error:#{JSON.stringify(error)}")
#        ,
#            () ->
#                console.log("Done.")
#                call.done() if call?
#                done()
#        )
#        observable.subscribe(observer)
#
#    it 'can authorize with reactive subscribe', (done) ->
#        @.timeout(timeout)
#
#        sdk = new MojioSDK({sdk: MojioAuthSDK, styles: [MojioReactiveStyle], test: true})
#        sdk
#        .authorize(authorization)
#        .subscribe(
#            (result) -> console.log("Result:#{JSON.stringify(result)}")
#        ,
#            (error) -> console.log("Error:#{JSON.stringify(error)}")
#        ,
#            () ->
#                console.log("Done.")
#                call.done() if call?
#                done()
#        )
#
#    it 'can authorize with async call', (done) ->
#        @.timeout(timeout)
#
#        sdk = new MojioSDK({sdk: MojioAuthSDK, styles: [MojioAsyncAwaitStyle], test: true})
#        sdk
#        .authorize(authorization)
#        .async()
#        .then(
#            (result) ->
#                console.log('Async promise Result: ' + result)
#                console.log("")
#                call.done() if call?
#                done()
#            ,
#            (error) ->
#                console.log("Error:#{JSON.stringify(error)}")
#                done()
#        )
#        .catch((err) ->
#            console.log('Something went wrong: ' + err)
#        )
#
#    it 'can authorize with synchronous call', (done) ->
#        @.timeout(timeout)
#
#        sdk = new MojioSDK({sdk: MojioAuthSDK, styles: [MojioSyncStyle], test: true})
#
#        result = sdk
#        .authorize(authorization)
#        .sync()
#        call.done() if call?
#        console.log(JSON.stringify(result))
#        done()
