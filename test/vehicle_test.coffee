Mojio = require '../lib/Mojio'
config = require './config/mojio-config.coffee'

mojio = new Mojio(config)

assert = require("assert")
testdata = require('./data/mojio-test-data')
should = require('should')

describe 'Vehicle', ->

    it 'can get vehicles', (done) ->
        mojio.login(testdata.username, testdata.password, (error, result) ->
            (error==null).should.be.true
            mojio.should.be.an.instanceOf(Mojio)
            mojio.token.should.be.ok
            result.should.be.an.instanceOf(Object)
            result._id.should.be.an.instanceOf(String)
            mojio.vehicles((error, result) ->
                (error==null).should.be.true
                mojio.should.be.an.instanceOf(Mojio)

                done()
            )
        )