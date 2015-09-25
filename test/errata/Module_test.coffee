should = require('should')
Module = require '.././Module'

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