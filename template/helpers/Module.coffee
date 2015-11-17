moduleKeywords = ['extended', 'included']

module.exports = class Module
    constructor: () ->

    @extend: (obj) ->
        if (typeof obj is "object")
            for key, value of obj when key not in moduleKeywords
                @[key] = value
        else if (typeof obj is "function")
            for key, value of obj.prototype when key not in moduleKeywords
                @[key] = value
        obj.extended?.apply(@)
        @

    @include: (obj) ->
        if (typeof obj is "object")
            for key, value of obj when key not in moduleKeywords
                @::[key] = value
        else if (typeof obj is "function")
            for key, value of obj.prototype when key not in moduleKeywords
                @::[key] = value
        obj.included?.apply(@)
        @

#    extend: (obj) ->
#        Module.extend(obj)

    include: (obj) ->
        Module.include(obj)

