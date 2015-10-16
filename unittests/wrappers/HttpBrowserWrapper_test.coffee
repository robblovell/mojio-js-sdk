should = require('should')
async = require('async')
HttpBrowserWrapper = require '../../template/wrappers-browser/HttpWrapper'
nock = require 'nock'
sinon = require 'sinon'
describe 'Http Browser Wrapper', ->

    token = "token"
    contentType = "application/json"
    testErrorResult = (error, result) ->
        (error==null).should.be.true
        (result!=null).should.be.true

    xhr = null
    requests = null
    before( () ->
        xhr = sinon.useFakeXMLHttpRequest()
        requests = []
        xhr.onCreate = (req) ->
            requests.push(req)
    )

    after( () ->
        # Like before we must clean up when tampering with globals.
        xhr.restore()
    )

#    it("makes a GET request for todo items", function () {
#        getTodos(42, sinon.spy());
#
#        assert.equals(requests.length, 1);
#        assert.match(requests[0].url, "/todo/42/items");
#    });
    it 'tests @request get resource with id', (done) ->
        nock('https://api.moj.io')
        .get('/v1/Vehicles/1')
        .reply((uri, requestBody, cb) ->
            @.req.headers.mojioapitoken.should.be.equal(token)
            @.req.headers['content-type'].should.be.equal(contentType)
            cb(null, [200, { id: 1}]))
        httpBrowserWrapper = new HttpBrowserWrapper("token")

        httpBrowserWrapper.request({
                method: 'Get',
                resource: "Vehicles",
                id: "1"
            }, (error, result) =>
            testErrorResult(error, result)
            done()
        )

    it 'tests @request get resource with id and form url encoding', (done) ->
        nock('https://api.moj.io')
        .get('/v1/Vehicles/1')
        .reply((uri, requestBody, cb) ->
            @.req.headers.mojioapitoken.should.be.equal(token)
            @.req.headers['content-type'].should.be.equal(contentType)
            @.req.headers['host'].should.be.equal("api.moj.io")
            cb(null, [200, { id: 1}]))
        httpBrowserWrapper = new HttpBrowserWrapper("token", 'https://api.moj.io/v1', true)

        httpBrowserWrapper.request({
                method: 'Get',
                resource: "Vehicles",
                id: "1"
            }, (error, result) =>
            testErrorResult(error, result)
            done()
        )
