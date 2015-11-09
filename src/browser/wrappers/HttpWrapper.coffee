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

    _parts = (request) ->
        parts = HttpWrapperHelper._parse(@uri, request, @encoding, @token)
        parts.scheme = window.location.protocol.split(':')[0] unless parts.scheme? || !window?
        parts.scheme = 'https' if !parts.scheme || parts.scheme == 'file'
        return parts

    url: (request) ->
        parts = _parts(request, @token, @uri, @encoding)
        return parts.protocol + '//' + parts.hostname + parts.pathname + parts.params

    request: (request, callback) ->
        parts = _parts(request)
        _request(parts, @requester, callback)

    redirect: (request, redirectClass=null) => # callback is through a server call.
        if (redirectClass?)
            redirectClass.redirect(@url(request))
        else
            window.location = @url(request);
        return