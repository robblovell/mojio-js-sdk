MojioClient = require '../lib/nodejs/MojioClient'
Vehicle = require '../lib/models/Vehicle'
config = require './config/mojio-config.coffee'
mojio_client = new MojioClient(config)
assert = require('assert')
testdata = require('./data/mojio-test-data')
should = require('should')
mock = require('jsmockito')

testObject = null

describe 'Vehicle', ->

    before( (done) ->
        mojio_client.login(testdata.username, testdata.password, (error, result) ->
            (error==null).should.be.true
            done()
        )
    )

    # test Vehicle
    it 'can get Vehicles from Model', (done) ->
        vehicle = new Vehicle({})
        vehicle.authorization(mojio_client)

        vehicle.query({}, (error, result) ->
            (error==null).should.be.true
            mojio_client.should.be.an.instanceOf(MojioClient)
            result.should.be.an.instanceOf(Array)
            if (result instanceof (Array))
                instance.should.be.an.instanceOf(Vehicle) for instance in result
                testObject = instance  # save for later reference.
            else
                result.should.be.an.instanceOf(Vehicle)
                testObject = result
            done()
        )

    it 'can get Vehicles', (done) ->

        mojio_client.query(Vehicle, {}, (error, result) ->
            (error==null).should.be.true
            mojio_client.should.be.an.instanceOf(MojioClient)
            result.should.be.an.instanceOf(Array)
            instance.should.be.an.instanceOf(Vehicle) for instance in result
            done()
        )

    it 'can create, find, save, and delete Vehicle', (done) ->
        vehicle = new Vehicle().mock()

        mojio_client.create(vehicle, (error, result) ->
            (error==null).should.be.true
            vehicle = new Vehicle(result)

            mojio_client.query(Vehicle, vehicle.id(), (error, result) ->
                (error==null).should.be.true
                mojio_client.should.be.an.instanceOf(MojioClient)
                result.should.be.an.instanceOf(Vehicle)

                mojio_client.save(result, (error, result) ->
                    (error==null).should.be.true
                    result.should.be.an.instanceOf(Object)
                    vehicle = new Vehicle(result)

                    mojio_client.delete(vehicle, (error, result) ->
                        (error==null).should.be.true
                        (result.result == "ok").should.be.true
                        done()
                    )
                )
            )
        )

    it 'can create, save, and delete Vehicle from model', (done) ->
        # todo define entityType as an enum to be used here.
        vehicle = new Vehicle().mock()
        vehicle.authorization(mojio_client)
        vehicle._id = null;

        vehicle.create((error, result) ->
            (error==null).should.be.true
            result.should.be.an.instanceOf(Object)
            vehicle = new Vehicle(result)
            vehicle.authorization(mojio_client)

            vehicle.query(vehicle.id(), (error, result) ->
                result.should.be.an.instanceOf(Vehicle)
                vehicle = new Vehicle(result)
                vehicle.authorization(mojio_client)

                vehicle.save((error, result) ->
                    (error==null).should.be.true
                    result.should.be.an.instanceOf(Object)
                    vehicle = new Vehicle(result)
                    vehicle.authorization(mojio_client)

                    vehicle.delete((error, result) ->
                        (error==null).should.be.true
                        (result.result == "ok").should.be.true
                        done()
                    )
                )

            )
        )