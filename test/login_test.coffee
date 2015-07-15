MojioClient = require '../lib/nodejs/MojioClient'
config = require './config/mojio-config.coffee'

mojio_client = new MojioClient(config)

assert = require("assert")
testdata = require('./data/mojio-test-data')
should = require('should')

describe 'Authorize', ->

    it 'can Authorize', (done) ->
        mojio_client.authorize(null, null, (error, result) ->
            console.log(error) if error?
            (error==null).should.be.true
            mojio_client.should.be.an.instanceOf(MojioClient)
            mojio_client.auth_token.should.be.ok
            result.should.be.an.instanceOf(Object)
            result.access_token.should.be.an.instanceOf(String)
            done()
        )

describe 'UnAuthorize', ->

    it 'can UnAuthorize', (done) ->
        mojio_client.authorize(null, null, (error, result) ->
            console.log(error) if error?
            (error==null).should.be.true
            mojio_client.unauthorize((error, result) ->
                console.log(error) if error?
                (error==null).should.be.true
                mojio_client.should.be.an.instanceOf(MojioClient)
                (mojio_client.getToken()==null).should.be.true
                done()
            )
        )

