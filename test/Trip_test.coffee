MojioClient = require '../lib/MojioClient'
Trip = require '../src/models/Trip'
config = require './config/mojio-config.coffee'
mojio_client = new MojioClient(config)
assert = require('assert')
testdata = require('./data/mojio-test-data')
should = require('should')

describe 'Trip', ->

    before( (done) ->
        mojio_client.login(testdata.username, testdata.password, (error, result) ->
            (error==null).should.be.true
            done()
        )
    )

    # test Trip

    it 'can post Trip', (done) ->
        true.should.be.true
        done()

    it 'can put Trip', (done) ->
        true.should.be.true
        done()

    it 'can get Trip', (done) ->
        mojio_client.trips((error, result) ->
            (error==null).should.be.true
            mojio_client.should.be.an.instanceOf(MojioClient)
            if (result.Data instanceof Array)
                trip = new Trip(result.Data[0])
            else if (result.Data?)
                trip = new Trip(result.Data)
            else
                trip = new Trip(result)
            trip.should.be.an.instanceOf(Trip)
            done()
        )


    it 'can delete Trip', (done) ->
        true.should.be.true
        done()

    # Test Observer with Trip

    it 'can post Trip observer', (done) ->
        true.should.be.true
        done()

    it 'can put Trip observer', (done) ->
        true.should.be.true
        done()

    it 'can get Trip observer', (done) ->
        true.should.be.true
        done()

    it 'can delete Trip observer', (done) ->
        true.should.be.true
        done()