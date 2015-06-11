(function() {
    var HttpNodeWrapper;
    module.exports = HttpNodeWrapper = function() {
        function HttpNodeWrapper() {}
        var Http = Ti.Network.createHTTPClient({
            onload: function() {
                Ti.API.info("Received text: " + this.responseText);
                alert("success");
            },
            onerror: function(e) {
                Ti.API.debug(e.error);
                alert("error");
            },
            timeout: 5e3
        });
        HttpNodeWrapper.prototype.request = function(params, callback) {
            var url = params.scheme + "://" + params.host + ":" + params.port + params.path;
            var method = params.method;
            params.header;
            Ti.API.info("before url: " + url);
            "GET" === params.method && null != params.data && params.data.length > 0 && (url += "?" + Object.keys(params.data).map(function(k) {
                return encodeURIComponent(k) + "=" + encodeURIComponent(params.data[k]);
            }).join("&"));
            var headers = null;
            Ti.API.info("params.header: " + params.headers);
            Ti.API.info("params.lenght: " + params.headers.length);
            "GET" === params.method && null != params.headers && (headers = Object.keys(params.headers).map(function(k) {
                return encodeURIComponent(k) + "=" + encodeURIComponent(params.headers[k]);
            }).join("&"));
            Ti.API.info("MojioAPIToken index  " + headers.indexOf("MojioAPIToken"));
            if (-1 != headers.indexOf("MojioAPIToken")) {
                var accessToken = headers.substring(headers.indexOf("MojioAPIToken") + 14, headers.indexOf("&"));
                Ti.API.info("Token   " + accessToken);
            }
            Ti.API.info("params.header: " + headers);
            Ti.API.info("after url: " + url);
            Ti.API.info("params.method: " + params.method);
            Ti.API.info("params.path: " + params.path);
            Ti.API.info("url: " + url);
            Http.onload = callback;
            Http.open(method, url);
            -1 != headers.indexOf("MojioAPIToken") && Http.setRequestHeader("MojioAPIToken", accessToken);
            Http.send();
        };
        return HttpNodeWrapper;
    }();
}).call(this);