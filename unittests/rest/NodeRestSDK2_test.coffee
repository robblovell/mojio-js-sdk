should = require('should')
MojioSDK = require '../../src/nodejs/sdk/MojioSDK'
MojioRestSDK = require '../../src/nodejs/sdk/MojioAuthSDK'

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
            call = nock('https://staging-accounts.moj.io')
            .post("/oauth2/token", authorization)
            .reply((uri, requestBody, cb) ->
                cb(null, [200, { id: 1}]))
            return call


    testErrorResult = (error, result) ->
        (error==null).should.be.true
        (result!=null).should.be.true

    it 'can be not implemented yet.', (done) ->
        @.timeout(timeout)
        call = setupNock()

        sdk = new MojioSDK({ sdk: MojioRestSDK, client_id: 'id', client_secret: 'secret', test: true })

        sdk
        .token(callback_url)
        .credentials('testing', 'Test123!')
        .callback(
            (error, result) ->
                testErrorResult(error, result)
                call.done() if call?
                done()
        )