
Http = require 'http'
Https = require 'https'
constants = require 'constants'
# @nodoc
module.exports = class HttpNodeWrapper

    request: (params, callback) ->

        if (params.scheme == 'https')
            action = Https.request params
        else
            action = Http.request params

        action.on('response', (response) ->
            response.setEncoding 'utf8' if !window?
            
            data = ""
            response.on 'data', (chunk) -> data += chunk if chunk
            response.on 'end', () ->
                if response.statusCode > 299
                    response.content = data
                    callback(response, null)
                else if data.length > 0
                    callback(null, JSON.parse data)
                else
                    callback null, { result: "ok" }
        )

        if params?.timeout? then action.on 'socket', (socket) ->
          socket.setTimeout params.timeout
          socket.on 'timeout', () ->
            callback socket, null

        action.on 'error', (error) ->
            callback(error,null)

        action.write(params.body) if (params.body?)
        action.end()

    redirect: (params, callback) -> # @applicationName is appname
        @request(params, callback)
