_MOJIO = require './mojio-client-login'

module.exports = class MOJIO_APPS extends _MOJIO

    constructor: (@options) ->
        super(@options)

    GET: (request, callback) ->
        @Request(request, callback)

    POST: (request, callback) ->
        @Request(request, callback)

    PUT: (request, callback) ->
        @Request(request, callback)

    DELETE: (request, callback) ->
        @Request(request, callback)
