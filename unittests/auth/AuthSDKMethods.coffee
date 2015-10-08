should = require('should')
MojioSDK = require '../../src/nodejs/sdk/MojioSDK'
MojioAuthSDK = require '../../src/nodejs/sdk/MojioAuthSDK'

describe 'Node Mojio Auth SDK Methods', ->

    call = null
    timeout = 50

    client_id = 'client_id'
    client_secret = 'client_secret'
    password = 'password!'
    username = 'username'
    response_type = 'response_type'
    grant_type = 'grant_type'

    testErrorResult = (error, result) ->
        (error==null).should.be.true
        (result!=null).should.be.true

    it 'can set credentials', () ->
        sdk = new MojioSDK({sdk: MojioAuthSDK, test: true})

        sdk.credentials(username, password)
        stuff = sdk.show()
        stuff.body.username.should.be.equal(username)
        stuff.body.password.should.be.equal(password)

    it 'can set credentials with object', () ->
        sdk = new MojioSDK({sdk: MojioAuthSDK, test: true})

        sdk.credentials({ user: username, password: password})
        stuff = sdk.show()
        stuff.body.username.should.be.equal(username)
        stuff.body.password.should.be.equal(password)

    it 'can set token parameters', () ->
        sdk = new MojioSDK({sdk: MojioAuthSDK, test: true})
        sdk.token(client_id, client_secret)
        stuff = sdk.show()
        stuff.method.should.be.equal('POST')
        stuff.endpoint.should.be.equal('accounts')
        stuff.resource.should.be.equal('oauth2')
        stuff.action.should.be.equal('token')
        stuff.body.client_id.should.be.equal(client_id)
        stuff.body.client_secret.should.be.equal(client_secret)