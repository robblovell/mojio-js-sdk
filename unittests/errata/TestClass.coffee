_ = require 'underscore'

describe 'Test Defaults and Options', ->
    it 'Module can extend from object', ->
        class Guitar
            defaults = { has: "default", isnt: "default"}
            constructor: (@options={}) ->
                @configure(@options)

            configure: (options={}) ->
                _.extend(@, options)
                _.defaults(@, defaults)
                return @


        guitar = new Guitar({isnt: "option"})
        guitar.has.should.be.equal("default")
        guitar.isnt.should.be.equal("option")
        guitar = new Guitar()
        guitar.has.should.be.equal("default")
        guitar.isnt.should.be.equal("default")
        guitar = new Guitar({another: "option"})
        guitar.has.should.be.equal("default")
        guitar.isnt.should.be.equal("default")
        guitar.another.should.be.equal("option")

    it 'can extend', ->
        body = {}
        _.extend(body, {one: "thing", two: "to go"})
        _.extend(body, {three: "things"})
        console.log(JSON.stringify(body))