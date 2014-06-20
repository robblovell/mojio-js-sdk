MojioClient = require '../lib/nodejs/MojioClient'
Observer = require '../lib/models/Observer'
App = require '../lib/models/App'
config = require './config/mojio-config.coffee'
mojio_client = new MojioClient(config)
assert = require('assert')
testdata = require('./data/mojio-test-data')
should = require('should')
count = [0,0]
app1=null
app2=null
describe 'Observer', ->

    before( (done) ->
        mojio_client.login(testdata.username, testdata.password, (error, result) ->
            (error==null).should.be.true
            done()
        )
    )

    # test Observer

    it 'can Observe Object', (done) ->
        app = new App().mock()

        mojio_client.post(app, (error, result) ->
            (error==null).should.be.true
            app = new App(result)

            mojio_client.observer(app, null,
                (entity) ->
                    entity.should.be.an.instanceOf(Object)
                    done()
                ,
                (error, result) ->
                    app.Description = "Changed"
                    mojio_client.put(app, (error, result) ->
                        (error==null).should.be.true
                    )
            )
        )

    it 'can Observe 2 Objects Separately.', (done) ->
        app = new App().mock()

        doubleDone = (which) ->
            count[which]++
            if (count[0] == 1 && count[1]==1)
                done()
            else if (count[0] > 1 || count[1] > 1)
                true.should.be.false

        mojio_client.post(app, (error, result) ->
            (error==null).should.be.true
            app1 = new App(result)
            console.log("created app1")

            mojio_client.post(app, (error, result) ->
                (error==null).should.be.true
                app2 = new App(result)
                console.log("created app2")

                mojio_client.observer(app1, null,
                    # Callback for app1.
                    (entity) ->
                        entity.should.be.an.instanceOf(Object)
                        console.log("observed change app1")
                        entity._id.should.be.equal(app1._id)
                        doubleDone(0)
                    ,
                    (error, result) ->
                        mojio_client.observer(app2, null,
                            # Callback for app2.
                            (entity) ->
                                entity.should.be.an.instanceOf(Object)
                                console.log("observed change app2")
                                entity._id.should.be.equal(app2._id)
                                doubleDone(1)
                            ,
                            (error, result) ->
                                app1.Description = "Changed1"
                                mojio_client.put(app1, (error, result) ->
                                    (error==null).should.be.true
                                    console.log("updated app1")
                                )
                                app2.Description = "Changed2"
                                mojio_client.put(app2, (error, result) ->
                                    (error==null).should.be.true
                                    console.log("updated app2")
                                )
                        )
                )

            )
        )