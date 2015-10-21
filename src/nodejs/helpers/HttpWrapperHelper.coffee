# @nodoc
URL = require('url-parse')
FormUrlencoded = require 'form-urlencoded'

module.exports = class HttpWrapperHelper
    constructor: () ->
        super()

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

        parts.headers["MojioAPIToken"] = token if token?
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

        return parts