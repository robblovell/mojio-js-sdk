MojioClient = require '../lib/MojioClient'
config = require './config/mojio-config.coffee'
# Sandbox/Production anonymous
#    application: '0c7dccc6-810a-489a-9675-30a112d03cb8',
#    secret: 'dd52b356-a41c-4a7f-b268-07b7b742c05a',
#    username: 'anonymous@moj.io'
#    password: 'Password007'
#config.hostname = "10.0.1.11"
#
#module.exports =
#    {
#        application: 'e626b252-5e1f-48c6-a56c-54832e655c46',
#        secret: '295869cf-c4ae-439b-ba9e-a0fd1423ac0a',
#
#        hostname: 'staging.api.moj.io',
#        version: 'v1',
#        port:'80'
#    }
#module.exports =
#    {
#        application: '0c7dccc6-810a-489a-9675-30a112d03cb8',
#        secret: 'dd52b356-a41c-4a7f-b268-07b7b742c05a',
#        hostname: 'sandbox.api.moj.io',
#        version: 'v1',
#        port:'80'
#    }
mojio_client = new MojioClient(config)

assert = require("assert")
testdata = require('./data/mojio-test-data')
should = require('should')

describe 'Get_Schema', ->

    it 'can get resource', (done) ->
        mojio_client.schema((error, result) ->
            (error==null).should.be.true
            mojio_client.should.be.an.instanceOf(MojioClient)
            done()
        )