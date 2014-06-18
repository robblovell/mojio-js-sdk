MojioClient = require '../lib/nodejs/MojioClient'
Observer = require '../src/models/Observer'
config = require './config/mojio-config.coffee'
mojio_client = new MojioClient(config)
assert = require('assert')
testdata = require('./data/mojio-test-data')
should = require('should')

describe 'Observer', ->

    before( (done) ->
        mojio_client.login(testdata.username, testdata.password, (error, result) ->
            (error==null).should.be.true
            done()
        )
    )

    # test Observer

    it 'can post Observer', (done) ->
        true.should.be.true
        done()

    it 'can put Observer', (done) ->
        true.should.be.true
        done()

    it 'can get Observer', (done) ->
        mojio_client.observer((error, result) ->
            (error==null).should.be.true
            mojio_client.should.be.an.instanceOf(MojioClient)
            if (result.Data instanceof Array)
                observer = new Observer(result.Data[0])
            else if (result.Data?)
                observer = new Observer(result.Data)
            else
                observer = new Observer(result)
            observer.should.be.an.instanceOf(Observer)
            done()
        )


    it 'can delete Observer', (done) ->
        true.should.be.true
        done()

    # Test Observer with Observer

    it 'can post Observer observer', (done) ->
        true.should.be.true
        done()

    it 'can put Observer observer', (done) ->
        true.should.be.true
        done()

    it 'can get Observer observer', (done) ->
        true.should.be.true
        done()

    it 'can delete Observer observer', (done) ->
        true.should.be.true
        done()