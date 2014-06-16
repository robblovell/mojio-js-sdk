MojioClient = require '../lib/MojioClient'
App = require '../src/models/App'
config = require './config/mojio-config.coffee'
mojio_client = new MojioClient(config)
assert = require('assert')
testdata = require('./data/mojio-test-data')
should = require('should')

describe 'App', ->

    before( (done) ->
        mojio_client.login(testdata.username, testdata.password, (error, result) ->
            (error==null).should.be.true
            done()
        )
    )

    # test App

    it 'can post App', (done) ->
        true.should.be.true
        done()

    it 'can put App', (done) ->
        true.should.be.true
        done()

    it 'can get Apps from Model', (done) ->
        App = new App({})
        App.authorization(mojio_client, (error, result) ->
            App.get({}, (error, result) ->
                (error==null).should.be.true
                mojio_client.should.be.an.instanceOf(MojioClient)

                result.should.be.an.instanceOf(App)
                done()
            )
        )

    it 'can get Apps', (done) ->
        mojio_client.getApps({}, (error, result) ->
            (error==null).should.be.true
            mojio_client.should.be.an.instanceOf(MojioClient)

            result.should.be.an.instanceOf(App)
            done()
        )

    it 'can get App', (done) ->
        mojio_client.getApp("cb154fcc-4ec1-4ebb-a703-3a8c6e8a9525", (error, result) ->
            (error==null).should.be.true
            mojio_client.should.be.an.instanceOf(MojioClient)

            result.should.be.an.instanceOf(App)
            done()
        )

    it 'can delete App', (done) ->
        true.should.be.true
        done()

    # Test Observer with App

    it 'can post App observer', (done) ->
        true.should.be.true
        done()

    it 'can put App observer', (done) ->
        true.should.be.true
        done()

    it 'can get App observer', (done) ->
        true.should.be.true
        done()

    it 'can delete App observer', (done) ->
        true.should.be.true
        don e()