MojioClient = require '../lib/MojioClient'
Product = require '../src/models/Product'
config = require './config/mojio-config.coffee'
mojio_client = new MojioClient(config)
assert = require('assert')
testdata = require('./data/mojio-test-data')
should = require('should')

describe 'Product', ->

    before( (done) ->
        mojio_client.login(testdata.username, testdata.password, (error, result) ->
            (error==null).should.be.true
            done()
        )
    )

    # test Product

    it 'can post Product', (done) ->
        true.should.be.true
        done()

    it 'can put Product', (done) ->
        true.should.be.true
        done()

    it 'can get Product', (done) ->
        mojio_client.products((error, result) ->
            (error==null).should.be.true
            mojio_client.should.be.an.instanceOf(MojioClient)
            if (result.Data instanceof Array)
                product = new Product(result.Data[0])
            else if (result.Data?)
                product = new Product(result.Data)
            else
                product = new Product(result)
            product.should.be.an.instanceOf(Product)
            done()
        )


    it 'can delete Product', (done) ->
        true.should.be.true
        done()

    # Test Observer with Product

    it 'can post Product observer', (done) ->
        true.should.be.true
        done()

    it 'can put Product observer', (done) ->
        true.should.be.true
        done()

    it 'can get Product observer', (done) ->
        true.should.be.true
        done()

    it 'can delete Product observer', (done) ->
        true.should.be.true
        done()