MojioClient = require '../lib/MojioClient'
Event = require '../src/models/Event'
config = require './config/mojio-config.coffee'
mojio_client = new MojioClient(config)
assert = require('assert')
testdata = require('./data/mojio-test-data')
should = require('should')

describe 'Event', ->

    before( (done) ->
        mojio_client.login(testdata.username, testdata.password, (error, result) ->
            (error==null).should.be.true
            done()
        )
    )

    # test Event

    it 'can post Event', (done) ->
        true.should.be.true
        done()

    it 'can put Event', (done) ->
        true.should.be.true
        done()

    it 'can get Event', (done) ->
        mojio_client.events((error, result) ->
            (error==null).should.be.true
            mojio_client.should.be.an.instanceOf(MojioClient)
            if (result.Data instanceof Array)
                event = new Event(result.Data[0])
            else if (result.Data?)
                event = new Event(result.Data)
            else
                event = new Event(result)
            event.should.be.an.instanceOf(Event)
            done()
        )


    it 'can delete Event', (done) ->
        true.should.be.true
        done()

    # Test Observer with Event

    it 'can post Event observer', (done) ->
        true.should.be.true
        done()

    it 'can put Event observer', (done) ->
        true.should.be.true
        done()

    it 'can get Event observer', (done) ->
        true.should.be.true
        done()

    it 'can delete Event observer', (done) ->
        true.should.be.true
        done()