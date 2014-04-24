module.exports = class HttpBrowser

    constructor: (@$) ->

    dataByMethod =  (data, method) ->
        switch method.toUpperCase()
            when 'POST','PUT' then JSON.stringify(data)
            else return data

    sendRequest = (url, data, method) ->

        method = "GET" if (!method)
        data = {} if (!data)

        headers = {}

#        headers[settings.mojioTokenHeader] = getTokenId() if (getTokenId() != null)

        return @$.ajax(url, {
            data: dataByMethod(data, method),
            headers: headers,
            contentType: "application/json",
            type: method,
            cache: false,
            error: (obj, status, error) ->
                log('Error during request: (' + status + ') ' + error);

        })

    request: (params, callback) ->
        params.method = "GET" unless params.method?
        params.host = params.hostname if (!params.host? and params.hostname?)
        params.scheme = window.location.protocol.split(':')[0] unless params.scheme?
        params.data = {} unless params.data?

        url = params.scheme+"://"+params.host+":"+params.port+params.path

        return sendRequest(url, params.data, params.method)
            .done((result) ->
                callback(null,result)
            )
            .fail( () ->
                callback("Failed",null)
            )
