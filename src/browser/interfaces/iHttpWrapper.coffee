Http = require 'http'
Https = require 'https'
FormUrlencoded = require 'form-urlencoded'
url = require("url");
constants = require 'constants'
# @nodoc
module.exports = class HttpNodeWrapper

    constructor: () ->

    request: (request, callback) ->
        throw new Error("Not implemented")

    redirect: (params, callback) -> # @applicationName is appname
        throw new Error("Not implemented")


