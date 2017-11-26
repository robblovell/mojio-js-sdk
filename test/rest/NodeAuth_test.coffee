MojioAuth = require '../../src/nodejs/sdk/MojioAuthSDK'

should = require('should')
async = require('async')
nock = require 'nock'

describe 'Node Mojio Authentication', ->

    testErrorResult = (error, result) ->
        (error==null).should.be.true
        (result!=null).should.be.true

    it 'can authenticate via oauth code', () ->
        sdk = new MojioAuth() # when the token is "test" return the rest url.

        nock('https://accounts.moj.io')
        .get("oauth2/authorize")
        .reply((uri, requestBody, cb) ->
            cb(null, [200, { id: 1}]))

        sdk.authorize("http://redirect.test.com/index.html", "full", (error, result) ->
            testErrorResult(error, result)
            result.should.be.equal(url)
        )

    it 'can get token', () ->
        sdk = new MojioAuth() # when the token is "test" return the rest url.

        nock('https://accounts.moj.io')
        .get("Login")
        .reply((uri, requestBody, cb) ->
            cb(null, [200, { id: 1}]))

        sdk.token((error, result) ->
            testErrorResult(error, result)
            result.should.be.equal(url)
        )

    it 'can get login using token', () ->
        sdk = new MojioAuth() # when the token is "test" return the rest url.

        nock('https://accounts.moj.io')
        .get("Login")
        .reply((uri, requestBody, cb) ->
            cb(null, [200, { id: 1}]))

        sdk.login((error, result) ->
            testErrorResult(error, result)
            result.should.be.equal(url)
        )