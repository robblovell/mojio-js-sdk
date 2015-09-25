Http = require 'http'
Https = require 'https'
FormUrlencoded = require 'form-urlencoded'
url = require("url");
constants = require 'constants'
iHttpWrapper = require '../interfaces/iHttpWrapper'
# @nodoc
module.exports = class HttpNodeWrapper extends iHttpWrapper
    constructor: (@token, @uri='https://api.moj.io/v1', @encoding = false) ->
        super(@token, @uri, @encoding)
    @_makeParameters: (params) ->
        '' if params.length==0
        query = '?'
        for property, value of params
            query += "#{encodeURIComponent property}=#{encodeURIComponent value}&"
        return query.slice(0,-1)

    @_getPath: (resource, id, action, key) ->
        if (key && id && action && id != '' && action != '')
            return "/" + encodeURIComponent(resource) + "/" + encodeURIComponent(id) + "/" + encodeURIComponent(action) + "/" + encodeURIComponent(key);
        else if (id && action && id != '' && action != '')
            return "/" + encodeURIComponent(resource) + "/" + encodeURIComponent(id) + "/" + encodeURIComponent(action);
        else if (id && id != '')
            return "/" + encodeURIComponent(resource) + "/" + encodeURIComponent(id);
        else if (action && action != '')
            return "/" + encodeURIComponent(resource) + "/" + encodeURIComponent(action);
        return "/" + encodeURIComponent(resource);

    @_request: (params, callback) ->
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

    request: (request, callback) ->
        token = @token
        uri = @uri
        encoding = @encoding
        uri += HttpNodeWrapper._getPath(request.resource, request.id, request.action, request.key)
        console.log("Request:"+uri)
        parts = url.parse(uri)
        parts.method = request.method
        parts.withCredentials = false

        if (request.parameters? and Object.keys(request.parameters).length > 0)
            parts.path += HttpNodeWrapper._makeParameters(request.parameters)

        parts.headers = {}
        parts.headers["MojioAPIToken"] = token
        parts.headers += request.headers if (request.headers?)
        parts.headers["Content-Type"] = 'application/json'

        if (request.body?)
            if (encoding?)
                parts.body = FormUrlencoded.encode(request.body)
            else
                parts.body = request.body

        HttpNodeWrapper._request(parts, callback)

    redirect: (params, callback) -> # @applicationName is appname
        HttpNodeWrapper.request(params, callback)
