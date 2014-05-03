Mojio = require '../lib/Mojio'
config = require './config/mojio-config.coffee'

mojio = new Mojio(config)

assert = require("assert")
testdata = require('./data/mojio-test-data')
should = require('should')

describe 'Event', ->
    @.timeout(15000)
    it 'can get events', (done) ->

        mojio.login(testdata.username, testdata.password, (error, result) ->
            (error==null).should.be.true
            mojio.should.be.an.instanceOf(Mojio)
            mojio.token.should.be.ok
            result.should.be.an.instanceOf(Object)
            result._id.should.be.an.instanceOf(String)
            mojio.events((error, result) ->
                (error==null).should.be.true
                mojio.should.be.an.instanceOf(Mojio)

                done()
            )
        )