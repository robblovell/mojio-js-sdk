MojioClient = require '../../lib/nodejs/MojioClient'
Vehicle = require '../../lib/models/Vehicle'
Trip = require '../../lib/models/Trip'
Mojio = require '../../lib/models/Mojio'
config = require '../config/mojio-config.coffee'
config.application = '6457d3dc-32f1-4f47-b030-211bc5544533'
config.secret = '35bf63e7-4443-4883-8d46-1e9195dec800'
config.live = false

mojio_client = new MojioClient(config)
assert = require('assert')
testdata = require('../data/mojio-test-data')
testdata.username = 'anonymous'
testdata.password = 'Password007'

should = require('should')

testObject = null

describe 'Vehicle', ->

    before( (done) ->
        mojio_client.login(testdata.username, testdata.password, (error, result) ->
            (error==null).should.be.true
            mojio_client.getCurrentUser((error, result) ->
                (error==null).should.be.true
            )
            done()
        )
    )

    # test Vehicle
#    it 'can get Vehicles from Model', (done) ->
#        vehicle = new Vehicle({})
#        vehicle.authorization(mojio_client)
#
#        vehicle.get({}, (error, result) ->
#            (error==null).should.be.true
#            mojio_client.should.be.an.instanceOf(MojioClient)
#            result.Objects.should.be.an.instanceOf(Array)
#            if (result.Objects? and result.Objects instanceof (Array))
#                instance.should.be.an.instanceOf(Vehicle) for instance in result.Objects
#                testObject = instance  # save for later reference.
#            else
#                result.should.be.an.instanceOf(Vehicle)
#                testObject = result
#            done()
#        )

    it 'can get Vehicles and get a vehicle by id and criteria', (done) ->

        mojio_client.get(Vehicle, {}, (error, result) ->
            (error==null).should.be.true
            mojio_client.should.be.an.instanceOf(MojioClient)
            result.Objects.should.be.an.instanceOf(Array)
            instance.should.be.an.instanceOf(Vehicle) for instance in result.Objects
            vehicle = result.Objects[0]
            mojio_client.get(Vehicle, "f7fd11ba-3a0a-4f8c-9a21-08c5605ca718", (error, result) ->
                result.should.be.an.instanceOf(Vehicle)
                mojio_client.get(Trip, {criteria: {VehicleId: result.id()}}, (error, result) ->
                    result.Objects.should.be.an.instanceOf(Array)
                    instance.should.be.an.instanceOf(Trip) for instance in result.Objects
                    done()
                )
            )

        )

#
#    it 'can create, find, save, and delete Vehicle', (done) ->
#        mojio_client.get(Mojio, {}, (error, result) ->
#            (error==null).should.be.true
#            mojio_client.should.be.an.instanceOf(MojioClient)
#            result.Objects.should.be.an.instanceOf(Array)
#            instance.should.be.an.instanceOf(Mojio) for instance in result.Objects
#            mojio = new Mojio(result.Objects[0])
#
#            vehicle = new Vehicle({
#                "Type": "Vehicle",
#                "MojioId": mojio.id(),
#                "Name": "String",
#                "VIN": "String",
#                "LicensePlate": "String"
#            })
#
#            vehicle.authorization(mojio_client)
#            vehicle._id = null;
#            mojio_client.post(vehicle, (error, result) ->
#                (error==null).should.be.true
#                vehicle = new Vehicle(result)
#
#                mojio_client.get(Vehicle, vehicle.id(), (error, result) ->
#                    (error==null).should.be.true
#                    mojio_client.should.be.an.instanceOf(MojioClient)
#                    result.should.be.an.instanceOf(Vehicle)
#
#                    mojio_client.put(result, (error, result) ->
#                        (error==null).should.be.true
#                        result.should.be.an.instanceOf(Object)
#                        vehicle = new Vehicle(result)
#
#                        mojio_client.delete(vehicle, (error, result) ->
#                            (error==null).should.be.true
#                            (result.result == "ok").should.be.true
#                            done()
#                        )
#                    )
#                )
#            )
#        )
#
#
#    it 'can create, save, and delete Vehicle from model', (done) ->
#        mojio_client.get(Mojio, {}, (error, result) ->
#            (error==null).should.be.true
#            mojio_client.should.be.an.instanceOf(MojioClient)
#            result.Objects.should.be.an.instanceOf(Array)
#            instance.should.be.an.instanceOf(Mojio) for instance in result.Objects
#            mojio = new Mojio(result.Objects[0])
#
#            vehicle = new Vehicle({
#                "Type": "Vehicle",
#                "MojioId": mojio.id(),
#                "Name": "String",
#                "VIN": "String",
#                "LicensePlate": "String"
#            })
#
#            vehicle.authorization(mojio_client)
#            vehicle._id = null;
#
#            vehicle.post((error, result) ->
#                (error==null).should.be.true
#                result.should.be.an.instanceOf(Object)
#                vehicle = new Vehicle(result)
#                vehicle.authorization(mojio_client)
#
#                vehicle.get(vehicle.id(), (error, result) ->
#                    result.should.be.an.instanceOf(Vehicle)
#                    vehicle = new Vehicle(result)
#                    vehicle.authorization(mojio_client)
#
#                    vehicle.put((error, result) ->
#                        (error==null).should.be.true
#                        result.should.be.an.instanceOf(Object)
#                        vehicle = new Vehicle(result)
#                        vehicle.authorization(mojio_client)
#
#                        vehicle.delete((error, result) ->
#                            (error==null).should.be.true
#                            (result.result == "ok").should.be.true
#                            done()
#                        )
#                    )
#
#                )
#            )
#        )
