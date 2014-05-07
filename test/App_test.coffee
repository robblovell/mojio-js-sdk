MojioClient = require '../lib/MojioClient'
App = require '../src/models/App'
config = require './config/mojio-config.coffee'
mojio_client = new MojioClient(config)
assert = require('assert')
testdata = require('./data/mojio-test-data')
should = require('should')
describe 'App', ->
    it 'can get App', (done) ->
        mojio_client.login(testdata.username, testdata.password, (error, result) ->
            (error==null).should.be.true
            mojio_client.apps((error, result) ->
                (error==null).should.be.true
                mojio_client.should.be.an.instanceOf(MojioClient)
                if (result.Data instanceof Array)
                    app = new App(result.Data[0])
                else if (result.Data?)
                    app = new App(result.Data)
                else
                    app = new App(result)
                app.should.be.an.instanceOf(App)
                done()
            )
        )
