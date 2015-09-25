MojioREST = require '.././rest/MojioREST'
User = require '.././models/User'
Mojio = require '.././models/Mojio'
Vehicle = require '.././models/Vehicle'
Trip = require '.././models/Trip'
App = require '.././models/App'
should = require('should')
async = require('async')
nock = require 'nock'

describe 'Node Mojio Rest SDK', ->
    user = null
    mojio = null
    vehicle = null

    testErrorResult = (error, result) ->
        (error==null).should.be.true
        (result!=null).should.be.true

    it 'can query, create, save, and delete user, vehicle, mojio, or trip', (done) ->
        sdk = new MojioREST(token="test") # when the token is "test" return the rest url.
        for call in ["get", "put", "post", "delete"]
            for resource in ["users", "vehicles", "trips", "mojios", "apps"]
                switch call
                    when "get"
                        path = "/v2/#{resource}/1"
                        sdkCall = "query"
                    when "put"
                        path = "/v2/#{resource}"
                        sdkCall = "save"
                    when "post"
                        path = "/v2/#{resource}"
                        sdkCall = "create"
                    when "delete"
                        path = "/v2/#{resource}"
                        sdkCall = "delete"

                path = "/v2/#{resource}" if call is not "get"
                nock('https://api2.moj.io')[call](path)
                    .reply((uri, requestBody, cb) ->
                        cb(null, [200, { id: 1}]))

                sdk[sdkCall](resource, {id: 1}, (error, result) ->
                    testErrorResult(error, result)
                    result.should.be.equal(url+path)
                )

