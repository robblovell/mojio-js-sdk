MojioClient = require '../../src/MojioClient'
config = require '../config/mojio-config.coffee'

mojio_client = new MojioClient(config)

###
    Sandbox:
        application: '0c7dccc6-810a-489a-9675-30a112d03cb8',
        secret: 'dd52b356-a41c-4a7f-b268-07b7b742c05a',
    Staging
        application: 'e626b252-5e1f-48c6-a56c-54832e655c46',
        secret: '295869cf-c4ae-439b-ba9e-a0fd1423ac0a',
###

assert = require("assert")
testdata = require('../data/mojio-test-data')
should = require('should')

#describe 'Login', ->
#
#    it 'can login', (done) ->
#        mojio_client.login(testdata.username, testdata.password, (error, result) ->
#            (error==null).should.be.true
#            mojio_client.should.be.an.instanceOf(MojioClient)
#            mojio_client.token.should.be.ok
#            result.should.be.an.instanceOf(Object)
#            result._id.should.be.an.instanceOf(String)
#            done()
#        )
#
#describe 'Logout', ->
#
#    it 'can logout', (done) ->
#        mojio_client.login(testdata.username, testdata.password, (error, result) ->
#            mojio_client.logout((error, result) ->
#                (error==null).should.be.true
#                mojio_client.should.be.an.instanceOf(MojioClient)
#                (mojio_client.token==null).should.be.true
#                done()
#            )
#        )
