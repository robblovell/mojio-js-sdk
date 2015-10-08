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
        parts = url.parse(uri)

        parts.method = if request.method? then request.method else "GET"
        parts.host = request.hostname if (!request.host? and request.hostname?)
        parts.scheme = window.location.protocol.split(':')[0] unless request.scheme? || !window?
        parts.scheme = 'https' if !request.scheme || request.scheme == 'file'

        parts.headers["MojioAPIToken"] = token if token?
        parts.headers = if request.headers? then request.headers else {}

        parts.data = if request.data? then request.data else {}
        parts.data = request.body if request.body?

        parts.params = ''
        if request.method == "GET" and request.data? and request.data.length > 0
            parts.params = '?' + Object.keys(request.data).map( (k) ->
                    return encodeURIComponent(k) + '=' + encodeURIComponent(request.data[k])
                ).join('&')
        else if (request.parameters? and Object.keys(request.parameters).length > 0)
            parts.params = HttpWrapperHelper._makeParameters(request.parameters)
        else if (request.params? and Object.keys(request.params).length > 0)
            parts.params = HttpWrapperHelper._makeParameters(request.params)

        return parts

    url: (request) ->
        parts = @_parts(request, @token, @uri, @encoding)
        return parts.scheme+"://"+parts.host+":"+parts.port+parts.path + parts.params

    request: (request, callback) ->
        url = _parts(request, @token, @uri, @encoding)
        _request(parts, @requester, callback)

    redirect: (params, callback) -> # callback is through a server call.
        url = params.scheme+"://"+params.host+":"+params.port+params.path

        return window.location = url;