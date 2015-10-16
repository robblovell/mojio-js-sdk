Http = require 'http'
Https = require 'https'
FormUrlencoded = require 'form-urlencoded'
#url = require("url");
constants = require 'constants'
HttpWrapperHelper = require '../helpers/HttpWrapperHelper'
iHttpWrapper = require '../interfaces/iHttpWrapper'
# @nodoc
module.exports = class HttpNodeWrapper extends iHttpWrapper
    constructor: (@token, @uri='https://api.moj.io/v1', @encoding = false, @requester=null) ->
        super()

    _request = (params, requester, callback) ->
        if (requester?)
            action = requester
        else if (params.href.slice(0,"https".length) == "https")
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

    _parts = (request, token, uri, encoding) ->
        uri += HttpWrapperHelper._getPath(request.resource, request.id, request.action, request.key)
        parts = HttpWrapperHelper._parse(uri, request, encoding, token)
#        parts.path = parts.pathname
#        parts.method = request.method
#        parts.withCredentials = false
#        parts.params = ''
#        if (request.parameters? and Object.keys(request.parameters).length > 0)
#            parts.params = HttpWrapperHelper._makeParameters(request.parameters)
#        if (request.params? and Object.keys(request.params).length > 0)
#            parts.params = HttpWrapperHelper._makeParameters(request.params)
#        parts.path += parts.params
#        parts.headers = {}
#
#        parts.headers["MojioAPIToken"] = token if token?
#        parts.headers += request.headers if (request.headers?)
#        parts.headers['Accept'] = 'application/json'
#        parts.headers["Content-Type"] = 'application/json'
#
#        if (request.body?)
#            if (encoding?) #
#                parts.headers["Content-Type"] = 'application/x-www-form-urlencoded'
#                parts.body = FormUrlencoded.encode(request.body)
#            else
#                parts.body = request.body
#            parts.data = parts.body
#
#        if (request.data?)
#            if (encoding?) #
#                parts.headers["Content-Type"] = 'application/x-www-form-urlencoded'
#                parts.data = FormUrlencoded.encode(request.data)
#            else
#                parts.data = request.data
#            parts.body = parts.data

        return parts

    url: (request) ->
        parts = _parts(request, @token, @uri, @encoding)
        return parts.protocol + '//' + parts.hostname + parts.pathname + parts.params

    request: (request, callback) ->
        parts = _parts(request, @token, @uri, @encoding)
        _request(parts, @requester, callback)

    redirect: (request, redirectClass=null) => # @applicationName is appname
        if (redirectClass?)
            redirectClass.redirect(@url(request))
        else
            throw new Error("Please pass in the redirecting function of the framework used in nodejs")
