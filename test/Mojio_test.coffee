MojioClient = require '../lib/nodejs/MojioClient'
Mojio = require '../lib/models/Mojio'
config = require './config/mojio-config.coffee'
mojio_client = new MojioClient(config)
assert = require('assert')
testdata = require('./data/mojio-test-data')
should = require('should')
mock = require('jsmockito')

testObject = null

describe 'Mojio', ->

    before( (done) ->
        mojio_client.login(testdata.username, testdata.password, (error, result) ->
            (error==null).should.be.true
            done()
        )
    )

    # test Mojio
    it 'can get Mojios from Model', (done) ->
        mojio = new Mojio({})
        mojio.authorization(mojio_client)

        mojio.query({}, (error, result) ->
            (error==null).should.be.true
            mojio_client.should.be.an.instanceOf(MojioClient)
            result.should.be.an.instanceOf(Array)
            if (result instanceof (Array))
                instance.should.be.an.instanceOf(Mojio) for instance in result
                testObject = instance  # save for later reference.
            else
                result.should.be.an.instanceOf(Mojio)
                testObject = result
            done()
        )

    it 'can get Mojios', (done) ->

        mojio_client.query(Mojio, {}, (error, result) ->
            (error==null).should.be.true
            mojio_client.should.be.an.instanceOf(MojioClient)
            result.should.be.an.instanceOf(Array)
            instance.should.be.an.instanceOf(Mojio) for instance in result
            done()
        )

    it 'can create, find, save, and delete Mojio', (done) ->
        mojio = new Mojio().mock()

        mojio_client.create(mojio, (error, result) ->
            (error==null).should.be.true
            mojio = new Mojio(result)

            mojio_client.query(Mojio, mojio.id(), (error, result) ->
                (error==null).should.be.true
                mojio_client.should.be.an.instanceOf(MojioClient)
                result.should.be.an.instanceOf(Mojio)

                mojio_client.save(result, (error, result) ->
                    (error==null).should.be.true
                    result.should.be.an.instanceOf(Object)
                    mojio = new Mojio(result)

                    mojio_client.delete(mojio, (error, result) ->
                        (error==null).should.be.true
                        (result.result == "ok").should.be.true
                        done()
                    )
                )
            )
        )

    it 'can create, save, and delete Mojio from model', (done) ->
        # todo define entityType as an enum to be used here.
        mojio = new Mojio().mock()
        mojio.authorization(mojio_client)
        mojio._id = null;

        mojio.create((error, result) ->
            (error==null).should.be.true
            result.should.be.an.instanceOf(Object)
            mojio = new Mojio(result)
            mojio.authorization(mojio_client)

            mojio.query(mojio.id(), (error, result) ->
                result.should.be.an.instanceOf(Mojio)
                mojio = new Mojio(result)
                mojio.authorization(mojio_client)

                mojio.save((error, result) ->
                    (error==null).should.be.true
                    result.should.be.an.instanceOf(Object)
                    mojio = new Mojio(result)
                    mojio.authorization(mojio_client)

                    mojio.delete((error, result) ->
                        (error==null).should.be.true
                        (result.result == "ok").should.be.true
                        done()
                    )
                )

            )
        )