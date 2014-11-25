MojioClient = require '../../src/nodejs/MojioClient'
Vehicle = require '../../src/models/Vehicle'
Mojio = require '../../src/models/Mojio'
Observer = require '../../src/models/Observer'
config = require '../config/mojio-config.coffee'
mojio_client = new MojioClient(config)
assert = require('assert')
testdata = require('../data/mojio-test-data')
should = require('should')

testObject = null
observer = null

describe 'Vehicle', ->

    before( (done) ->
        mojio_client.login(testdata.username, testdata.password, (error, result) ->
            (error==null).should.be.true
            done()
        )
    )

#    it 'can create, find, save, and delete Vehicle', (done) ->
#        vehicle = new Vehicle().mock()
#        mojio_client.post(vehicle, (error, result) ->
#            (error==null).should.be.true
#            vehicle = new Vehicle(result)
#        )

    it 'can create, find, save, and delete Vehicle', (done) ->

        mojio_client.get(Mojio, {}, (error, result) ->
            (error==null).should.be.true
            mojio_client.should.be.an.instanceOf(MojioClient)
            result.Objects.should.be.an.instanceOf(Array)
            instance.should.be.an.instanceOf(Mojio) for instance in result.Objects
            mojio = new Mojio(result.Objects[0])

            vehicle = new Vehicle({
                "Type": "Vehicle",
                "MojioId": mojio.id(),
                "Name": "String",
                "VIN": "String",
                "LicensePlate": "String"
            })
            mojio_client.create(vehicle, (error, result) ->
                (error==null).should.be.true
                vehicle = new Vehicle(result)

                mojio_client.get(Vehicle, result._id, (error, result) ->
                    (error==null).should.be.true
                    mojio_client.should.be.an.instanceOf(MojioClient)
                    result.should.be.an.instanceOf(Vehicle)
                    vehicle = new Vehicle(result)

                    mojio_client.observe(vehicle, null,
                        (entity) ->
                            entity.should.be.an.instanceOf(Object)
                            console.log("Observed change seen.")
                            mojio_client.unobserve(observer, vehicle, null, null, (error, result) ->
                                mojio_client.delete(vehicle, (error, result) ->
                                    (error==null).should.be.true
                                    (result.result == "ok").should.be.true
                                    console.log("Vehicle deleted.")
                                    mojio_client.delete(mojio, (error, result) ->
                                        (error==null).should.be.true
                                        (result.result == "ok").should.be.true
                                        console.log("Mojio deleted.")
                                        done()
                                    )
                                )
                            )
                        ,
                        (error, result) ->
                            result.Status.should.equal("Approved")

                            vehicle.Name = "Changed"
                            console.log("changing vehicle...")
                            result.should.be.an.instanceOf(Observer)
                            observer = result

                            mojio_client.save(vehicle, (error, result) ->
                                (error==null).should.be.true
                                console.log("Vehicle changed.")
                            )
                    )
                )
            )
        )


