Mojio = require '../lib/Mojio'
config = require './config/mojio-config.coffee'
# Sandbox/Production anonymous
#    application: '0c7dccc6-810a-489a-9675-30a112d03cb8',
#    secret: 'dd52b356-a41c-4a7f-b268-07b7b742c05a',
#    username: 'anonymous@moj.io'
#    password: 'Password007'
#config.hostname = "10.0.1.11"
mojio = new Mojio(config)

assert = require("assert")
testdata = require('./data/mojio-test-data')
should = require('should')

describe 'Get_Schema', ->

    it 'can get resource', (done) ->
        mojio.login(testdata.username, testdata.password, (error, result) ->
            (error==null).should.be.true
            mojio.should.be.an.instanceOf(Mojio)
            mojio.token.should.be.ok
            result.should.be.an.instanceOf(Object)
            result._id.should.be.an.instanceOf(String)

            mojio.schema((error, result) ->
                (error==null).should.be.true
                mojio.should.be.an.instanceOf(Mojio)

                done()
            )
        )