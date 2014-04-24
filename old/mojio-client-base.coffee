http = require 'http'

module.exports = class MOJIO_BASE
    defaults = { hostname: 'sandbox.api.moj.io/v1', port: '80', version: 'v1' }

    constructor: (@options) ->
        @options ?= { hostname: defaults.hostname, port: @defaults.port, version: @defaults.version }
        @options.hostname ?= defaults.hostname
        @options.port ?= defaults.port
        @options.version ?= defaults.version
        @options.application = @options.application
        @options.secret = @options.secret  # TODO:: header and https only

    _makeParameters: (params) ->
        '' if params.length==0
        query = '?'
        for property, value of params
            query += "#{property}=#{value}&"
        return query.slice(0,-1)

    Request: (request, callback) ->
        parts = {
            hostname: @options.hostname
            port: @options.port
            path: '/'+@options.version
            method: request.method
        }
        parts.path += '/'+request.resource if (request.resource?)
        parts.path += '/'+request.id if (request.id != '')
        if (request.parameters? and Object.keys(request.parameters).length > 0)
            parts.path += @_makeParameters(request.parameters)

        parts.headers = { MojioAPIToken: @token } if @token?
        parts.headers += request.headers if (request.headers?)

        parts.body = request.body if request.body

        action = http.request parts, (result) ->
            if (result.statusCode > 299)
                callback(result, null)
            else if (result.statusCode != 204)
                result.setEncoding('utf8')
                result.on('data', (data) ->
                    if (data instanceof Object)
                        callback(data,null)
                    else
                        callback(null, JSON.parse(data))
                )
            else
                callback(null, result)

        action.on 'error', (error) ->
            callback(error,null)

        action.end()
