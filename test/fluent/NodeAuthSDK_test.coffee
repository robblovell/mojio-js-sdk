MojioSDK = require '../../src/nodejs/MojioSDK'
should = require('should')

describe 'Node Mojio Auth SDK', ->
    sdk = new MojioSDK()

    testErrorResult = (error, result) ->
        (error==null).should.be.true
        (result!=null).should.be.true

    it 'can authorize', (done) ->
        @.timeout(2000)
        sdk.authorize({type: "token", user: "unittest@moj.io", password: "mojioRocks" },
            (error, result) ->
                testErrorResult(error, result)
                done()
        )
