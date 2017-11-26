# @nodoc
URL = require('url-parse')
FormUrlencoded = require 'form-urlencoded'

module.exports = class HttpWrapperHelper
    constructor: () ->
#        super()

    @_makeParameters: (params) ->
        '' if params.length==0
        query = '?'
        for property, value of params
            query += "#{encodeURIComponent property}=#{encodeURIComponent value}&"
        return query.slice(0,-1)

    @_makePath: (elements) ->
        return elements.reduce (x,y) -> x + "/" + encodeURIComponent(y)

    @_getPath: (resource, pid, action, sid, object, oid) ->
        path = ""
        path += "/" + encodeURIComponent(resource) if resource?
        path += "/" + encodeURIComponent(pid) if pid?
        path += "/" + encodeURIComponent(action) if action?
        path += "/" + encodeURIComponent(sid) if sid?
        path += "/" + encodeURIComponent(object) if object?
        path += "/" + encodeURIComponent(oid) if oid?
        return path


    @_parse: (url, request, encoding, token) ->
        parts = new URL(url)
        parts.path = parts.pathname
        parts.method = request.method
        parts.withCredentials = false
        parts.params = ''
        if (request.parameters? and Object.keys(request.parameters).length > 0)
            parts.params = HttpWrapperHelper._makeParameters(request.parameters)
        if (request.params? and Object.keys(request.params).length > 0)
            parts.params = HttpWrapperHelper._makeParameters(request.params)
        parts.path += parts.params
        parts.headers = {}

        parts.headers["MojioAPIToken"] = token.access_token if token? and token.access_token?
        parts.headers += request.headers if (request.headers?)
        parts.headers['Accept'] = 'application/json'
        parts.headers["Content-Type"] = 'application/json'

        if (request.body?)
            if (encoding?) #
                parts.headers["Content-Type"] = 'application/x-www-form-urlencoded'
                parts.body = FormUrlencoded.encode(request.body)
            else
                parts.body = request.body
            parts.data = parts.body

        if (request.data?)
            if (encoding?) #
                parts.headers["Content-Type"] = 'application/x-www-form-urlencoded'
                parts.data = FormUrlencoded.encode(request.data)
            else
                parts.data = request.data
            parts.body = parts.data

#        console.log(JSON.stringify(parts))
        return parts