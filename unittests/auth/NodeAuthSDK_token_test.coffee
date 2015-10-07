#should = require('should')
#MojioSDK = require '../../src/sdk/MojioSDK'
#MojioAuthSDK = require '../../src/sdk/MojioAuthSDK'
#MojioPromiseStyle = require '../../src/sdk/MojioPromiseStyle'
#MojioReactiveStyle = require '../../src/sdk/MojioReactiveStyle'
#MojioAsyncAwaitStyle = require '../../src/sdk/MojioAsyncAwaitStyle'
#MojioSyncStyle = require '../../src/sdk/MojioSyncStyle'
#nock = require 'nock'
#async = require('asyncawait/async')
#await = require('asyncawait/await')
#
#describe 'Node Mojio Auth SDK code type auth', ->
#    sdk = new MojioSDK({sdk: MojioAuthSDK, test: true})
#
#    testErrorResult = (error, result) ->
#        (error==null).should.be.true
#        (result!=null).should.be.true
#
#    it 'can authorize with callback async', (done) ->
#        @.timeout(2000)
#        nock('https://accounts.moj.io')
#        .get("oauth2/authorize")
#        .query({response_type: "code", client_id: "1234", redirect_url: "http://localhost" })
#        .reply((uri, requestBody, cb) ->
#            cb(null, [200, { id: 1}]))
#        sdk
#        .authorize({response_type: "code", client_id: "1234", redirect_url: "http://localhost" })
#        .callback(
#            (error, result) ->
#                testErrorResult(error, result)
#                done()
#        )
#    it 'can authorize with promise', (done) ->
#        @.timeout(2000)
#        nock('https://accounts.moj.io')
#        .get("oauth2/authorize")
#        .reply((uri, requestBody, cb) ->
#            cb(null, [200, { id: 1}]))
#        sdk = new MojioSDK({sdk: MojioAuthSDK, styles: [MojioPromiseStyle], test: true})
#
#        promise = sdk
#        .authorize({type: "code", user: "1234", password: "http://localhost" })
#        .promise()
#
#        promise
#        .then(
#            (result) ->
#                testErrorResult(null, result)
#                done()
#        )
#        .catch(
#            # Rejected promises are passed on by Promise.prototype.then(onFulfilled)
#            (error) ->
#                console.log('Handle rejected promise ('+error+') here.');
#                (error==null).should.be.true
#                done()
#        )
#
#    it 'can authorize with reactive observable.', (done) ->
#        @.timeout(2000)
#        Rx = require('rx')
#
#        nock('https://accounts.moj.io')
#        .get("oauth2/authorize")
#        .reply((uri, requestBody, cb) ->
#            cb(null, [200, { id: 1}]))
#        sdk = new MojioSDK({sdk: MojioAuthSDK, styles: [MojioReactiveStyle], test: true})
#
#        observable = sdk
#        .authorize({type: "code", user: "1234", password: "http://localhost" })
#        .observable()
#        observer = Rx.Observer.create(
#            (result) -> console.log("Result:#{JSON.stringify(result)}")
#        ,
#            (error) -> console.log("Error:#{JSON.stringify(error)}")
#        ,
#            () ->
#                console.log("Done.")
#                done()
#        )
#        observable.subscribe(observer)
#
#
#    it 'can authorize with reactive subscribe', (done) ->
#        @.timeout(2000)
#        nock('https://accounts.moj.io')
#        .get("oauth2/authorize")
#        .reply((uri, requestBody, cb) ->
#            cb(null, [200, { id: 1}]))
#        sdk = new MojioSDK({sdk: MojioAuthSDK, styles: [MojioReactiveStyle], test: true})
#
#        sdk
#        .authorize({type: "code", user: "1234", password: "http://localhost" })
#        .subscribe(
#            (result) -> console.log("Result:#{JSON.stringify(result)}")
#        ,
#            (error) -> console.log("Error:#{JSON.stringify(error)}")
#        ,
#            () ->
#                console.log("Done.")
#                done()
#        )
#
#    it 'can authorize with async call', (done) ->
#        @.timeout(2000)
#        nock('https://accounts.moj.io')
#        .get("oauth2/authorize")
#        .reply((uri, requestBody, cb) ->
#            cb(null, [200, { id: 1}]))
#        sdk = new MojioSDK({sdk: MojioAuthSDK, styles: [MojioAsyncAwaitStyle], test: true})
#
#        thing = sdk
#        .authorize({type: "code", user: "1234", password: "http://localhost" })
#        .async()
#        .then (((result) ->
#            console.log('Async promise Result: ' + result);
#            console.log("")
#            done())
#        )
#        .catch(((err) ->
#                console.log('Something went wrong: ' + err))
#        )
#        console.log("async thing: #{thing}")
#
#
#    it 'can authorize with synchronous call', (done) ->
#        @.timeout(2000)
#        nock('https://accounts.moj.io')
#        .get("oauth2/authorize")
#        .reply((uri, requestBody, cb) ->
#            cb(null, [200, { id: 1}]))
#        sdk = new MojioSDK({sdk: MojioAuthSDK, styles: [MojioSyncStyle], test: true})
#
#        result = sdk
#        .authorize({type: "code", user: "1234", password: "http://localhost" })
#        .sync()
#        console.log(JSON.stringify(result))
#        done()
