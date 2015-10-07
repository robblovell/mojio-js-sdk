should = require('should')
MojioSDK = require '../../src/sdk/MojioSDK'
MojioAuthSDK = require '../../src/sdk/MojioAuthSDK'
MojioPromiseStyle = require '../../src/sdk/MojioPromiseStyle'
MojioReactiveStyle = require '../../src/sdk/MojioReactiveStyle'
MojioAsyncAwaitStyle = require '../../src/sdk/MojioAsyncAwaitStyle'
MojioSyncStyle = require '../../src/sdk/MojioSyncStyle'
nock = require 'nock'
async = require('asyncawait/async')
await = require('asyncawait/await')

describe 'Node Mojio Auth SDK password type auth', ->

    call = null
    timeout = 50
    authorization = {
        client_id: '5f81657f-47f6-4d86-8213-5c01c1f3a243',
        password: 'Test123!', response_type: 'password',
        username: 'testing'
    }

    beforeEach(() ->
        if (true || process.env.FUNCTIONAL_TESTS?)
            timeout = 3000
        else
            call = nock('https://accounts.moj.io')
            .post("/oauth2/token",authorization)
            .reply((uri, requestBody, cb) ->
                cb(null, [200, { id: 1}]))
    )

    testErrorResult = (error, result) ->
        (error==null).should.be.true
        (result!=null).should.be.true

    it 'can authorize with password flow, callback async', (done) ->
        @.timeout(timeout)
        sdk = new MojioSDK({sdk: MojioAuthSDK, test: true})

        sdk
        .token('5f81657f-47f6-4d86-8213-5c01c1f3a243', "fcca6c06-3d30-488e-947b-a6291e39ff3c")
        .credentials('testing', 'Test123!')
        .callback(
            (error, result) ->
                testErrorResult(error, result)
                call.done() if call?
                done()
        )

#    it 'can authorize with promise', (done) ->
#        @.timeout(timeout)
#
#        sdk = new MojioSDK({sdk: MojioAuthSDK, styles: [MojioPromiseStyle], test: true})
#        promise = sdk
#        .authorize(authorization)
#        .promise()
#
#        promise
#        .then(
#            (result) ->
#                testErrorResult(null, result)
#                call.done() if call?
#                done()
#            ,
#            (error) ->
#                testErrorResult(error, null)
#                done()
#        )
#        .catch(
## Rejected promises are passed on by Promise.prototype.then(onFulfilled)
#            (error) ->
#                console.log('Handle rejected promise ('+error+') here.');
#                (error==null).should.be.true
#                done()
#        )
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
