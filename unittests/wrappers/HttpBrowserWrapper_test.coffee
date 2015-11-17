should = require('should')
async = require('async')
HttpBrowserWrapper = require '../../src/browser/wrappers/HttpWrapper'
nock = require 'nock'
sinon = require 'sinon'
XMLHttpRequest = require("xmlhttprequest").XMLHttpRequest;
xhr = new XMLHttpRequest()

describe 'Http Browser Wrapper', ->
    unittest = true
    if (process.env.FUNCTIONAL_TESTS?)
        unittest = false
    token = "token"
    contentType = "application/json"
    testErrorResult = (error, result) ->
        (error==null).should.be.true
        (result!=null).should.be.true

    xhr = null

    it 'tests @request get resource with id', (done) ->
        nock('https://api.moj.io')
        .get('/v1/Vehicles/1')
        .reply((uri, requestBody, cb) ->
            @.req.headers.mojioapitoken.should.be.equal(token) unless unittest
            @.req.headers['content-type'].should.be.equal(contentType)
            cb(null, [200, { id: 1}]))

        httpBrowserWrapper = new HttpBrowserWrapper("token",
            'https://api.moj.io/v1', false, new XMLHttpRequest())

        httpBrowserWrapper.request({
                method: 'Get',
                resource: "Vehicles",
                pid: "1"
            }, (error, result) =>
                testErrorResult(error, result)
                done()
        )

    it 'tests @request get resource with id and form url encoding', (done) ->
        nock('https://api.moj.io')
        .get('/v1/Vehicles/2')
        .reply((uri, requestBody, cb) ->
            @.req.headers.mojioapitoken.should.be.equal(token) unless unittest
            @.req.headers['content-type'].should.be.equal(contentType)
            @.req.headers['host'].should.be.equal("api.moj.io")
            cb(null, [200, { id: 1}]))

        httpBrowserWrapper = new HttpBrowserWrapper("token",
            'https://api.moj.io/v1', true, new XMLHttpRequest())

        httpBrowserWrapper.request({
                method: 'Get',
                resource: "Vehicles",
                pid: "2"
            }, (error, result) =>
                testErrorResult(error, result)
                done()
        )
