HttpWrapperHelper = require '../helpers/HttpWrapperHelper'
iHttpWrapper = require '../interfaces/iHttpWrapper'

module.exports = class HttpBrowserWrapper extends iHttpWrapper

    constructor: (@token, @uri='https://api.moj.io/v1', @encoding = false, @requester=null) ->

        super()
    _request = (request, requester, callback) ->

        if (XMLHttpRequest?)
            xmlhttp = new XMLHttpRequest
        else
            xmlhttp = requester
        xmlhttp.open request.method , url ,true

        for k,v of request.headers
            xmlhttp.setRequestHeader k, v

        xmlhttp.onreadystatechange=() ->
            if xmlhttp.readyState==4
                if (xmlhttp.status >= 200 and xmlhttp.status <= 299)
                    callback(null,JSON.parse xmlhttp.responseText)
                else
                    callback(xmlhttp.statusText,null)

        if request.method == "GET"
            xmlhttp.send()
        else
            xmlhttp.send(request.data)
    _parts = (request, token, uri, encoding) ->
        uri += HttpWrapperHelper._getPath(request.resource, request.id, request.action, request.key)
        parts = HttpWrapperHelper._parse(uri)
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

        if (request.body?)
#            if (encoding?) #
#                parts.headers["Content-Type"] = 'application/x-www-form-urlencoded'
#                parts.body = FormUrlencoded.encode(request.body)
#            else
#                parts.headers["Content-Type"] = 'application/json'
#                parts.body = request.body
            parts.headers["Content-Type"] = 'application/json'
            parts.body = request.body
            parts.data = parts.body

        if (request.data?)
#            if (encoding?) #
#                parts.headers["Content-Type"] = 'application/x-www-form-urlencoded'
#                parts.data = FormUrlencoded.encode(request.data)
#            else
#                parts.headers["Content-Type"] = 'application/json'
#                parts.data = request.data
            parts.headers["Content-Type"] = 'application/json'
            parts.data = request.data
            parts.body = parts.data
        parts.scheme = window.location.protocol.split(':')[0] unless parts.scheme? || !window?
        parts.scheme = 'https' if !parts.scheme || parts.scheme == 'file'

        return parts

    url: (request) ->
        parts = _parts(request, @token, @uri, @encoding)
        return parts.protocol + '//' + parts.hostname + parts.pathname + parts.params

    request: (request, callback) ->
        parts = _parts(request, @token, @uri, @encoding)
        _request(parts, @requester, callback)

    redirect: (request, redirectClass=null) => # callback is through a server call.
        if (redirectClass?)
            redirectClass.redirect(@url(request))
        else
            window.location = @url(request);
        return