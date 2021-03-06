should = require('should')
async = require('async')
HttpNodeWrapper = require '../../src/nodejs/wrappers/HttpWrapper'
nock = require 'nock'

describe 'Http Nodejs Wrapper', ->
    unittest = true
    if (process.env.FUNCTIONAL_TESTS?)
        unittest = false
    token = "token"
    contentType = "application/json"
    testErrorResult = (error, result) ->
        (error==null).should.be.true
        (result!=null).should.be.true

    it 'tests @request get resource with id', (done) ->
        nock('https://api.moj.io')
        .get('/v1/Vehicles/3')
        .reply((uri, requestBody, cb) ->
            @.req.headers.mojioapitoken.should.be.equal(token) unless unittest
            @.req.headers['content-type'].should.be.equal(contentType)
            cb(null, [200, { id: 1}]))
        httpNodeWrapper = new HttpNodeWrapper("token")

        httpNodeWrapper.request({
                method: 'Get',
                resource: "Vehicles",
                pid: "3"
            }, (error, result) =>
                testErrorResult(error, result)
                done()
        )

    it 'tests @request get resource with id and form url encoding', (done) ->
        nock('https://api.moj.io')
        .get('/v1/Vehicles/4')
        .reply((uri, requestBody, cb) ->
            @.req.headers.mojioapitoken.should.be.equal(token) unless unittest
            @.req.headers['content-type'].should.be.equal(contentType)
            @.req.headers['host'].should.be.equal("api.moj.io")
            cb(null, [200, { id: 1}]))
        httpNodeWrapper = new HttpNodeWrapper("token",
            'https://api.moj.io/v1', true)

        httpNodeWrapper.request({
                method: 'Get',
                resource: "Vehicles",
                id: "4"
            }, (error, result) =>
            testErrorResult(error, result)
            done()
        )
