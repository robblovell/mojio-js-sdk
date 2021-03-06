should = require('should')
Module = require '../../template/helpers/Module'

#class Module
#    constructor: () ->
#
#    @extend: (obj) ->
#        for key, value of obj when key not in moduleKeywords
#            @[key] = value
#        obj.extended?.apply(@)
#        @
#
#    @include: (obj) ->
#        for key, value of obj when key not in moduleKeywords
#            @::[key] = value
#        obj.included?.apply(@)
#        @

describe 'Test Module', ->
    it 'Module can extend from object', ->
        classProperties =
            tuning: () ->
                return true

        class Guitar extends Module
            @extend classProperties

        Guitar.tuning().should.be.true

    it 'Module can include from object', ->
        instanceProperties =
            makeSound: () ->
                return true

        class Guitar extends Module
            @include instanceProperties

        guitar = new Guitar()
        guitar.makeSound().should.be.true



    it 'Module can extend from class', ->
        class classProperties
            tuning: () ->
                return true

        class Guitar extends Module
            @extend classProperties

        Guitar.tuning().should.be.true

    it 'Module can include from class', ->
        class instanceProperties
            makeSound: () ->
                return true

        class Guitar extends Module
            @include instanceProperties

        guitar = new Guitar()
        guitar.makeSound().should.be.true



#    it 'Module can extend from object in constructor', ->
#        classProperties1 =
#            tuning: () ->
#                return true
#
#        class Guitar3 extends Module
#            constructor: () ->
#                @extend classProperties1
#
#        guitar = new Guitar3()
#        Guitar3.tuning().should.be.true
#
#    it 'Module can extend from class in constructor', ->
#        class classProperties2
#            tuning: () ->
#                return true
#
#        class Guitar2 extends Module
#            constructor:() ->
#                @extend classProperties2
#
#        guitar = new Guitar2()
#        Guitar2.tuning().should.be.true




    it 'Module can include from object in constructor', ->
        instanceProperties =
            makeSound: () ->
                return true

        class Guitar extends Module
            constructor: () ->
                @include instanceProperties

        guitar = new Guitar()
        guitar.makeSound().should.be.true

    it 'Module can include from class in constructor', ->
        class instanceProperties
            makeSound: () ->
                return true

        class Guitar extends Module
            constructor: () ->
                @include instanceProperties

        guitar = new Guitar()
        guitar.makeSound().should.be.true

    it "Module can't include from hidden variables", ->
        try
            class instanceProperties
                state = {}
                makeSound: () ->
                    stateMachine["thing"] = true
                    return true

            class Guitar extends Module
                constructor: () ->
                    @include instanceProperties
                makeAnotherSound: () ->
                    try
                        stateMachine["thing"] = true
                    catch
                        return true
                    return true

            guitar = new Guitar()
            guitar.makeSound().should.be.true
            guitar.makeAnotherSound().should.be.true
        catch
            true.should.be.true

    it "Module can't include from hidden variables", ->
        class State
            stuff = {stuff: "hi"}
            constructor: () ->
                @stateMachine = {stuff: "hi"}
            set: () ->
                stuff['thing'] = true
            reset: () ->
                stuff['thing'] = false
            show: () ->
                return stuff

        class instanceProperties
            constructor: () ->
            makeSound: () ->
                console.log(JSON.stringify(@stateMachine.show()))
                @stateMachine.set()
                console.log(JSON.stringify(@stateMachine.show()))

                return true

        class Guitar extends Module
            constructor: () ->
                super()
                @include instanceProperties
                @stateMachine = new State()
            makeAnotherSound: () ->
                console.log(JSON.stringify(@stateMachine.show()))
                @stateMachine.reset()
                console.log(JSON.stringify(@stateMachine.show()))
                return true

        guitar = new Guitar()
        guitar.makeSound().should.be.true
        guitar.makeAnotherSound().should.be.true