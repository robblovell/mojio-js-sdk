Http = require 'http'
Https = require 'https'
constants = require 'constants'
module.exports = class HttpNodeWrapper

    request: (params, callback) ->
        params.agent = false
        #params.rejectUnauthorized = false
        params.secureOptions = constants.SSL_OP_NO_TLSv1_2
        params.secureProtocol = 'SSLv3_method'
        params.strictSSL = false

        if (params.scheme == 'https')
            action = Https.request params
        else
            action = Http.request params

        action.on('response', (response) ->
            if (response.statusCode > 299)
                callback(response, null)
            else if (response.statusCode != 204)
                data = ""
                response.setEncoding('utf8') if !window?
                response.on('data', (chunk) ->
                    data += chunk
                )

                response.on('end', () ->
                    if (data instanceof Object)
                        callback(data,null)
                    else
                        if (data == "")
                            callback(null, {result: "ok"})
                        else
                            callback(null, JSON.parse(data))
                )
            else
                callback(null, response)
        )
        action.on 'close', () ->
            action.emit('end')

        action.on 'error', (error) ->
            callback(error,null)

        action.write(params.body) if (params.body?)

        action.end()
