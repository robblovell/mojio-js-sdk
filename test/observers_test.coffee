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

    it 'can Observe Object', (done) ->

        mojio_client.get(App, {}, (error, result) ->
            (error==null).should.be.true
            mojio_client.should.be.an.instanceOf(MojioClient)
            result.should.be.an.instanceOf(Array)
            instance.should.be.an.instanceOf(App) for instance in result
            app = new App(result[0])

            mojio_client.observer(app, null,
                test_callback(entity) ->
                    entity.should.be.an.instanceOf(Object)
                    done()
                ,
                (error, result) ->
                    app.Description = "Changed"
                    mojio_client.post(app, (error, result) ->
                        (error==null).should.be.true
                    )
            )
        )


