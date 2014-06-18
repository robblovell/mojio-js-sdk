MojioClient = require '../../src/nodejs/MojioClient'
User = require '../../src/models/User'
config = require '../config/mojio-config.coffee'
mojio_client = new MojioClient(config)
assert = require('assert')
testdata = require('../data/mojio-test-data')
should = require('should')
mock = require('jsmockito')

testObject = null

describe 'User', ->

    before( (done) ->
        mojio_client.login(testdata.username, testdata.password, (error, result) ->
            (error==null).should.be.true
            done()
        )
    )

    # test User
    it 'can get Users from Model', (done) ->
        user = new User({})
        user.authorization(mojio_client)

        user.query({}, (error, result) ->
            (error==null).should.be.true
            mojio_client.should.be.an.instanceOf(MojioClient)
            result.should.be.an.instanceOf(Array)
            if (result instanceof (Array))
                instance.should.be.an.instanceOf(User) for instance in result
                testObject = instance  # save for later reference.
            else
                result.should.be.an.instanceOf(User)
                testObject = result
            done()
        )

    it 'can get Users', (done) ->

        mojio_client.query(User, {}, (error, result) ->
            (error==null).should.be.true
            mojio_client.should.be.an.instanceOf(MojioClient)
            result.should.be.an.instanceOf(Array)
            instance.should.be.an.instanceOf(User) for instance in result
            done()
        )

    it 'can create, find, save, and delete User', (done) ->
        user = new User().mock()

        mojio_client.create(user, (error, result) ->
            (error==null).should.be.true
            user = new User(result)

            mojio_client.query(User, user.id(), (error, result) ->
                (error==null).should.be.true
                mojio_client.should.be.an.instanceOf(MojioClient)
                result.should.be.an.instanceOf(User)

                mojio_client.save(result, (error, result) ->
                    (error==null).should.be.true
                    result.should.be.an.instanceOf(Object)
                    user = new User(result)

                    mojio_client.delete(user, (error, result) ->
                        (error==null).should.be.true
                        (result.result == "ok").should.be.true
                        done()
                    )
                )
            )
        )

    it 'can create, save, and delete User from model', (done) ->
        # todo define entityType as an enum to be used here.
        user = new User().mock()
        user.authorization(mojio_client)
        user._id = null;

        user.create((error, result) ->
            (error==null).should.be.true
            result.should.be.an.instanceOf(Object)
            user = new User(result)
            user.authorization(mojio_client)

            user.query(user.id(), (error, result) ->
                result.should.be.an.instanceOf(User)
                user = new User(result)
                user.authorization(mojio_client)

                user.save((error, result) ->
                    (error==null).should.be.true
                    result.should.be.an.instanceOf(Object)
                    user = new User(result)
                    user.authorization(mojio_client)

                    user.delete((error, result) ->
                        (error==null).should.be.true
                        (result.result == "ok").should.be.true
                        done()
                    )
                )

            )
        )