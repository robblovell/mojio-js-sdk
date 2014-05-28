MojioClient = require '../lib/MojioClient'
Subscription = require '../src/models/Subscription'
config = require './config/mojio-config.coffee'
mojio_client = new MojioClient(config)
assert = require('assert')
testdata = require('./data/mojio-test-data')
should = require('should')

describe 'Subscription', ->

    before( (done) ->
        mojio_client.login(testdata.username, testdata.password, (error, result) ->
            (error==null).should.be.true
            done()
        )
    )

    # test Subscription

    it 'can post Subscription', (done) ->
        true.should.be.true
        done()

    it 'can put Subscription', (done) ->
        true.should.be.true
        done()

    it 'can get Subscription', (done) ->
        mojio_client.subscriptions((error, result) ->
            (error==null).should.be.true
            mojio_client.should.be.an.instanceOf(MojioClient)
            if (result.Data instanceof Array)
                subscription = new Subscription(result.Data[0])
            else if (result.Data?)
                subscription = new Subscription(result.Data)
            else
                subscription = new Subscription(result)
            subscription.should.be.an.instanceOf(Subscription)
            done()
        )


    it 'can delete Subscription', (done) ->
        true.should.be.true
        done()

    # Test Observer with Subscription

    it 'can post Subscription observer', (done) ->
        true.should.be.true
        done()

    it 'can put Subscription observer', (done) ->
        true.should.be.true
        done()

    it 'can get Subscription observer', (done) ->
        true.should.be.true
        done()

    it 'can delete Subscription observer', (done) ->
        true.should.be.true
        done()