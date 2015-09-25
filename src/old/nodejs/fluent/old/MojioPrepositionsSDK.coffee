# version 4.0.0
#Http = require './HttpNodeWrapper'
#FormUrlencoded = require 'form-urlencoded'

MojioRestSDK = require './MojioRestSDK'

module.exports = class MojioPrepositionsSDK extends MojioRestSDK

    # @nodoc
    constructor: (options={}) ->
        super(options)

    # With is used to improve the readability of fluent expressions.
    #
    # @return {object} this
    with: () ->
        return @

    # With is used to improve the readability of fluent expressions.
    #
    # @return {object} this
    from: () ->
        return @

    # With is used to improve the readability of fluent expressions.
    #
    # @return {object} this
    into: () ->
        return @

    # With is used to improve the readability of fluent expressions.
    #
    # @return {object} this
    outof: () ->
        return @
