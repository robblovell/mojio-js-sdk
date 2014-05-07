MojioClient = require '../lib/MojioClient'
config = require './config/mojio-config.coffee'

mojio_client = new MojioClient(config)

assert = require("assert")
testdata = require('./data/mojio-test-data')
should = require('should')

describe 'Event', ->
    @.timeout(15000)
    it 'can get events', (done) ->

        mojio_client.login(testdata.username, testdata.password, (error, result) ->
            (error==null).should.be.true
            mojio_client.events((error, result) ->
                (error==null).should.be.true
                mojio_client.should.be.an.instanceOf(MojioClient)
                done()
            )
        )