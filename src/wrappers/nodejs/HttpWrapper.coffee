Http = require 'http'
Https = require 'https'
FormUrlencoded = require 'form-urlencoded'
url = require("url");
constants = require 'constants'
HttpWrapperHelper = require '../HttpWrapperHelper'
iHttpWrapper = require '../../interfaces/iHttpWrapper'
# @nodoc
module.exports = class HttpNodeWrapper extends iHttpWrapper
    constructor: (@token, @uri='https://api.moj.io/v1', @encoding = false) ->
        super()

    _request = (params, callback) ->
        if (params.href.slice(0,"https".length) == "https")
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

    # moved request to wrapper, added api and ecoding to the parameter list
    #
#    example = {
#        method: "GET, PUT, POST, DELETE"
#        resource: "vehicle, mojio, user, app, permissions, etc."
#        id: "id of the entity"
#        action: "secondary resource: image, tag, etc."
#        key: "id of the secondary resource (action)"
#        parameters: "query parameters"
#        body: "body of the request"
#        headers: "add to headers these values"
#        encoding: "true if the body is to be FormUrlEncoded, otherwise false"
#
#        uri: "url of api if different than initialized"
#        token: "access token if different than initialized."
#    }
#    post = {
#        method: 'POST', resource: if @options.live then '/OAuth2/token' else '/OAuth2Sandbox/token',
#        body:
#            {
#                username: username
#                password: password
#                client_id: @options.application
#                client_secret: @options.secret
#                grant_type: 'password'
#            }
#    }
#    query = { method: 'GET',  resource: "Vehicles", parameters: { criteria: "name=blah; field=blah", limit:10, offset:0, sortby:"name", desc:false }}
#    get = { method: 'GET',  resource: "Vehicles", parameters: {id: parameters} }

    parts: (request) ->
        token = @token
        uri = @uri
        encoding = @encoding
        uri += HttpWrapperHelper._getPath(request.resource, request.id, request.action, request.key)
        console.log("Request:"+uri)
        parts = url.parse(uri)
        parts.method = request.method
        parts.withCredentials = false
        parts.params = ''
        if (request.parameters? and Object.keys(request.parameters).length > 0)
            parts.params = HttpWrapperHelper._makeParameters(request.parameters)
        if (request.params? and Object.keys(request.params).length > 0)
            parts.params = HttpWrapperHelper._makeParameters(request.params)
        parts.path += parts.params
        parts.headers = {}

        parts.headers["MojioAPIToken"] = token if token?
        parts.headers += request.headers if (request.headers?)

        if (request.body?)
            if (encoding?) #
                parts.headers["Content-Type"] = 'application/x-www-form-urlencoded'
                parts.body = FormUrlencoded.encode(request.body)
            else
                parts.headers["Content-Type"] = 'application/json'
                parts.body = request.body
        return parts

    url: (request) ->
        parts = @parts(request)
        return parts.protocol + '//' + parts.hostname + parts.pathname + parts.params


    request: (request, callback) ->
        parts = @parts(request)

        _request(parts, callback)

    redirect: (params, callback) -> # @applicationName is appname
        _request(params, callback)
