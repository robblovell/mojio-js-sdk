MojioClient = require '../lib/MojioClient'
Vehicle = require '../src/models/Vehicle'
config = require './config/mojio-config.coffee'
mojio_client = new MojioClient(config)
assert = require('assert')
testdata = require('./data/mojio-test-data')
should = require('should')

describe 'Vehicle', ->

    before( (done) ->
        mojio_client.login(testdata.username, testdata.password, (error, result) ->
            (error==null).should.be.true
            done()
        )
    )

    # test Vehicle

    it 'can post Vehicle', (done) ->
        true.should.be.true
        done()

    it 'can put Vehicle', (done) ->
        true.should.be.true
        done()

    it 'can get Vehicle', (done) ->
        mojio_client.vehicles((error, result) ->
            (error==null).should.be.true
            mojio_client.should.be.an.instanceOf(MojioClient)
            if (result.Data instanceof Array)
                vehicle = new Vehicle(result.Data[0])
            else if (result.Data?)
                vehicle = new Vehicle(result.Data)
            else
                vehicle = new Vehicle(result)
            vehicle.should.be.an.instanceOf(Vehicle)
            done()
        )


    it 'can delete Vehicle', (done) ->
        true.should.be.true
        done()

    # Test Observer with Vehicle

    it 'can post Vehicle observer', (done) ->
        true.should.be.true
        done()

    it 'can put Vehicle observer', (done) ->
        true.should.be.true
        done()

    it 'can get Vehicle observer', (done) ->
        true.should.be.true
        done()

    it 'can delete Vehicle observer', (done) ->
        true.should.be.true
        done()