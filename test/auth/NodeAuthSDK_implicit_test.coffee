should = require('should')
MojioSDK = require '../../src/sdk/MojioSDK'
MojioAuthSDK = require '../../src/sdk/MojioAuthSDK'
nock = require 'nock'

describe 'Node Mojio Auth SDK password type auth', ->
    sdk = new MojioSDK({sdk: MojioAuthSDK, test: true})

    testErrorResult = (error, result) ->
        (error==null).should.be.true
        (result!=null).should.be.true

    it 'can authorize with callback', (done) ->
        @.timeout(2000)
        nock('https://accounts.moj.io')
        .get("oauth2/authorize")
        .query({app_id: "1234", redirect_uri: "http://localhost" })
        .reply((uri, requestBody, cb) ->
            cb(null, [200, { id: 1}]))
        sdk
        .authorize({type: "implicit", app_id: "1234", redirect_uri: "http://localhost" })
        .callback(
            (error, result) ->
                testErrorResult(error, result)
                done()
        )
    it 'can authorize with promise', (done) ->
        @.timeout(2000)
        nock('https://accounts.moj.io')
        .get("oauth2/authorize")
        .reply((uri, requestBody, cb) ->
            cb(null, [200, { id: 1}]))
        promise = sdk
        .authorize({type: "implicit", app_id: "1234", redirect_uri: "http://localhost" })
        .submit()
        promise
        .then(
            (result) ->
                testErrorResult(null, result)
                done()
        )
        .catch(
            # Rejected promises are passed on by Promise.prototype.then(onFulfilled)
            (error) ->
                console.log('Handle rejected promise ('+error+') here.');
                (error==null).should.be.true
                done()
        )

    it 'can authorize with stream', (done) ->
        @.timeout(2000)
        nock('https://accounts.moj.io')
        .get("oauth2/authorize")
        .reply((uri, requestBody, cb) ->
            cb(null, [200, { id: 1}]))
        observer = sdk
        .authorize({type: "implicit", app_id: "1234", redirect_uri: "http://localhost" })
        .stream()

    it 'can authorize with sync', (done) ->
        @.timeout(2000)
        nock('https://accounts.moj.io')
        .get("oauth2/authorize")
        .reply((uri, requestBody, cb) ->
            cb(null, [200, { id: 1}]))
        result = sdk
        .authorize({type: "implicit", app_id: "1234", redirect_uri: "http://localhost" })
        .sync()
