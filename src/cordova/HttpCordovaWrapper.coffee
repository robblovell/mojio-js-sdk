module.exports = class HttpCordovaWrapper

    constructor: (applicationName=null) ->
        @applicationName = applicationName if applicationName?

    Http = Ti.Network.createHTTPClient(
        # function called when the response data is available
        onload: (e) -> 
            Ti.API.info("Received text: " + this.responseText)
            alert('success')
        ,
        # function called when an error occurs, including a timeout
        onerror: (e) ->
            Ti.API.debug(e.error)
            alert('error')
        ,
        timeout: 5000  # in milliseconds
    )

    resquest: (params, callback) ->
        url = params.scheme + ":#" + params.hostname + ":" + params.port + params.path
        method = params.method
        resource = params.header

        Ti.API.info("before url: " + url)
        if (params.method == "GET" and (params.data != null) and params.data.length > 0)
            url += '?' + Object.keys(params.data).map( (k) ->
                return encodeURIComponent(k) + '=' + encodeURIComponent(params.data[k])
            ).join('&')

        headers = null
        Ti.API.info("params.header: " + params.headers)
        Ti.API.info("params.lenght: " + params.headers.length)

        if (params.method == "GET" and (params.headers != null))
            headers = Object.keys(params.headers).map( (k) ->
                return encodeURIComponent(k) + '=' + encodeURIComponent(params.headers[k])
            ).join('&')


        Ti.API.info("MojioAPIToken index  " + headers.indexOf("MojioAPIToken"))

        if (headers.indexOf("MojioAPIToken") != -1)
            accessToken = headers.substring(headers.indexOf("MojioAPIToken") + 14, headers.indexOf("&"))
            Ti.API.info("Token   " + accessToken)

        Ti.API.info("params.header: " + headers)
        Ti.API.info("after url: " + url)
        Ti.API.info("params.method: " + params.method)

        Ti.API.info("params.path: " + params.path)
        Ti.API.info("url: " + url)

        Http.onload = callback
        Http.open(method, url) #client.open("GET", url)

        if (headers.indexOf("MojioAPIToken") != -1)
            Http.setRequestHeader("MojioAPIToken", accessToken)

        # Send the request.
        Http.send()

    redirect: (params, callback) -> # @applicationName is appname
        url = params.scheme+"://"+params.hostname+":"+params.port+params.path

        webview = Titanium.UI.createWebView()
        Ti.API.info("webview")
        webview.setUrl(url)
        webview.addEventListener('load', (e)  ->
            #TPD, detect the status
            if (e.url.indexOf(@applicationName) == 0)
                # stop the event
                e.bubble = false
                # stop the url from loading
                webview.stopLoading()

                #localize the accessToken from the redirected URL
                tokenIndex = e.url.indexOf("token")
                accessToken = e.url.substring(tokenIndex+6,tokenIndex + 42)    #e.url.toString()#

                webview.setVisible(false)
                webview.hide()
                window.remove(webview)
                window.close()
                callback(null, accessToken)
        )
        return webview