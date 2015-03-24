module.exports = class HttpBrowserWrapper

    constructor: (requester=null) ->
        @requester = requester if requester?
#    sendRequest = (url, data, method, headers) ->
#        return @$.ajax(url, {
#            data: data,
#            headers: headers,
#            contentType: "application/json",
#            dataType: "json",
#            type: method,
#            cache: false,
#            error: (obj, status, error) ->
#                console.log('Error during request: (' + status + ') ' + error);
#
#        })
#
#    request: (params, callback) ->
#        params.method = "GET" unless params.method?
#        params.host = params.hostname if (!params.host? and params.hostname?)
#        params.scheme = window.location.protocol.split(':')[0] unless params.scheme?
#        params.scheme = 'http' if params.scheme == 'file'
#        params.data = {} unless params.data?
#        params.data = params.body if params.body?
#        params.headers = {} unless params.headers?
#
#        url = params.scheme+"://"+params.host+":"+params.port+params.path
#
#        return sendRequest(url, params.data, params.method, params.headers).done((result) ->
#                callback(null,result)
#            ).fail( () ->
#                callback("Failed",null)
#            )

    request: (params, callback) ->
        params.method = "GET" unless params.method?
        params.host = params.hostname if (!params.host? and params.hostname?)
        params.scheme = window.location.protocol.split(':')[0] unless params.scheme? || !window?

        params.scheme = 'https' if !params.scheme || params.scheme == 'file'

        params.data = {} unless params.data?
        params.data = params.body if params.body?

        params.data = Object.keys(params.data).map( (k) ->
            return encodeURIComponent(k) + '=' + encodeURIComponent(params.data[k])
        ).join('&')

        params.headers = {} unless params.headers?

        url = params.scheme+"://"+params.host+":"+params.port+params.path
        if params.method == "GET"
            url +='?' + params.data

        if (XMLHttpRequest?)
            xmlhttp = new XMLHttpRequest
        else
            xmlhttp = @requester
        xmlhttp.open params.method , url ,true

        for k,v of params.headers
            xmlhttp.setRequestHeader k, v

        xmlhttp.onreadystatechange=() ->
            if xmlhttp.readyState==4
                if (xmlhttp.status >= 200 and xmlhttp.status <= 299)
                    callback(null,JSON.parse xmlhttp.responseText)
                else
                    callback(xmlhttp.statusText,null)

        if params.method == "GET"
            xmlhttp.send()
        else
            xmlhttp.send(params.data)