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
    redirect_url = "http://localhost:3000/callback"
    init = {
    sdk: MojioAuthSDK,
    client_id: client_id,
    client_secret: client_secret
    test: true,
    }
    testErrorResult = (error, result) ->
        (error==null).should.be.true
        (result!=null).should.be.true

    it 'can set credentials', () ->
        sdk = new MojioSDK(init)

        sdk.credentials(username, password)
        stuff = sdk.show()
        stuff.body.username.should.be.equal(username)
        stuff.body.password.should.be.equal(password)

    it 'can set credentials with object', () ->
        sdk = new MojioSDK(init)

        sdk.credentials({ user: username, password: password})
        stuff = sdk.show()
        stuff.body.username.should.be.equal(username)
        stuff.body.password.should.be.equal(password)

    it 'can set token parameters', () ->
        sdk = new MojioSDK(init)
        sdk.token(redirect_url)
        stuff = sdk.show()
        stuff.method.should.be.equal('POST')
        stuff.endpoint.should.be.equal('accounts')
        stuff.resource.should.be.equal('oauth2')
        stuff.action.should.be.equal('token')
        stuff.body.redirect_uri.should.be.equal(redirect_url)
    testErrorResult = (error, result) ->
        (error==null).should.be.true
        (result!=null).should.be.true
    it 'can set token with string', (done) ->
        sdk = new MojioSDK(init)
        sdk.token().parse("Token").callback((error, result) ->
            testErrorResult(error,result)
            sdk.getToken().access_token.should.be.equal("Token")
            stuff = sdk.show()
            stuff.method.should.be.equal('POST')
            stuff.endpoint.should.be.equal('accounts')
            stuff.resource.should.be.equal('oauth2')
            stuff.action.should.be.equal('token')
            done()
        )
        return