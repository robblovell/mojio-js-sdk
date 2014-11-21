Http = require 'http'
Https = require 'https'
constants = require 'constants'
module.exports = class HttpNodeWrapper

    request: (params, callback) ->
#        params.agent = false
#        #params.rejectUnauthorized = false
#        params.secureOptions = constants.SSL_OP_NO_TLSv1_2
#        params.secureProtocol = 'SSLv3_method'
#        params.strictSSL = false

        if (params.scheme == 'https')
            action = Https.request params
        else
            action = Http.request params

        action.on('response', (response) ->
            data = null
            response.setEncoding 'utf8' if !window?
            
            response.on 'data', (chunk) -> data += chunk
            response.on 'end', () ->
                if response.statusCode > 299
                    callback response, null
                else if data
                    callback null, JSON.parse data
                else
                    callback null, response
        )

        action.on 'error', (error) ->
            callback(error,null)

        action.write(params.body) if (params.body?)
        action.end()
