MojioClient = require '../../src/MojioClient'
App = require '../../src/models/App'
config = require '../config/mojio-config.coffee'
mojio_client = new MojioClient(config)
assert = require('assert')
testdata = require('../data/mojio-test-data')
should = require('should')

describe 'App', ->

    before( (done) ->
        mojio_client.login(testdata.username, testdata.password, (error, result) ->
            (error==null).should.be.true
            done()
        )
    )

    # test App
    it 'Apps have different name and resource than MojioModel base class', (done) ->
        app = new App({})
        (app.resource()=='Apps').should.be.true
        (app.model()=='App').should.be.true
        (App.resource() == 'Apps').should.be.true
        (App.model() == 'App').should.be.true

        done()

    it 'can get Apps from Model', (done) ->
        app = new App({})
        app.authorization(mojio_client)
        app.query({}, (error, result) ->
            (error==null).should.be.true
            mojio_client.should.be.an.instanceOf(MojioClient)

            result.should.be.an.instanceOf(Array)
            if (result.instanceOf(Array))
                instance.should.be.an.instanceOf(App) for instance in result
            done()
        )


    it 'can get App from Model', (done) ->
        app = new App({})
        app.authorization(mojio_client)
        app.query("cb154fcc-4ec1-4ebb-a703-3a8c6e8a9525", (error, result) ->
            (error==null).should.be.true
            mojio_client.should.be.an.instanceOf(MojioClient)

            result.should.be.an.instanceOf(App)
            done()
        )


    it 'can get Apps', (done) ->
        mojio_client.query(App, {}, (error, result) ->
            (error==null).should.be.true
            mojio_client.should.be.an.instanceOf(MojioClient)
            result.should.be.an.instanceOf(Array)
            instance.should.be.an.instanceOf(App) for instance in result
            done()
        )

    it 'can get App', (done) ->
        mojio_client.query(App, "cb154fcc-4ec1-4ebb-a703-3a8c6e8a9525", (error, result) ->
            (error==null).should.be.true
            mojio_client.should.be.an.instanceOf(MojioClient)

            result.should.be.an.instanceOf(App)
            done()
        )

    it 'can create, save, and delete App', (done) ->
        # todo define entityType as an enum to be used here.
        app = new App({
            Type: 14,
            Name: "Auto Test",
            Description: "A Client test of post.",
            CreationDate: "2013-07-09 19:03:19.963Z",
            Downloads: 0,
            _deleted: false
        })
        mojio_client.save(app, (error, result) ->
            (error==null).should.be.true
            result.should.be.an.instanceOf(Object)
            app = new App(result)
            mojio_client.delete(app, (error, result) ->
                (error==null).should.be.true
                (result.result == "ok").should.be.true
                done()
            )

        )

    it 'can create, save, and delete App from model', (done) ->
        # todo define entityType as an enum to be used here.
        app = new App({
            Type: 14,
            Name: "Auto Test",
            Description: "A Client test of post.",
            CreationDate: "2013-07-09 19:03:19.963Z",
            Downloads: 0,
            _deleted: false
        })
        app.authorization(mojio_client)
        app.save((error, result) ->
            (error==null).should.be.true
            result.should.be.an.instanceOf(Object)
            app = new App(result)
            app.authorization(mojio_client)
            app.delete((error, result) ->
                (error==null).should.be.true
                (result.result == "ok").should.be.true
                done()
            )
        )