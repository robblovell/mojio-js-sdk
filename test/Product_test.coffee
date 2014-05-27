MojioClient = require '../lib/MojioClient'
Product = require '../src/models/Product'
config = require './config/mojio-config.coffee'
mojio_client = new MojioClient(config)
assert = require('assert')
testdata = require('./data/mojio-test-data')
should = require('should')
describe 'Product', ->
    it 'can get Product', (done) ->
        mojio_client.login(testdata.username, testdata.password, (error, result) ->
            (error==null).should.be.true
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
        )
