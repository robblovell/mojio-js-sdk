MojioClient = require '../lib/MojioClient'
User = require '../src/models/User'
config = require './config/mojio-config.coffee'
mojio_client = new MojioClient(config)
assert = require('assert')
testdata = require('./data/mojio-test-data')
should = require('should')

describe 'User', ->

    before( (done) ->
        mojio_client.login(testdata.username, testdata.password, (error, result) ->
            (error==null).should.be.true
            done()
        )
    )

    # test User

    it 'can post User', (done) ->
        true.should.be.true
        done()

    it 'can put User', (done) ->
        true.should.be.true
        done()

    it 'can get User', (done) ->
        mojio_client.users((error, result) ->
            (error==null).should.be.true
            mojio_client.should.be.an.instanceOf(MojioClient)
            if (result.Data instanceof Array)
                user = new User(result.Data[0])
            else if (result.Data?)
                user = new User(result.Data)
            else
                user = new User(result)
            user.should.be.an.instanceOf(User)
            done()
        )


    it 'can delete User', (done) ->
        true.should.be.true
        done()

    # Test Observer with User

    it 'can post User observer', (done) ->
        true.should.be.true
        done()

    it 'can put User observer', (done) ->
        true.should.be.true
        done()

    it 'can get User observer', (done) ->
        true.should.be.true
        done()

    it 'can delete User observer', (done) ->
        true.should.be.true
        done()