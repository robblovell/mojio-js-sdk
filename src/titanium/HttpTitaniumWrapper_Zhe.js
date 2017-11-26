(function () {
    var Http, HttpNodeWrapper, Https;

    module.exports = HttpNodeWrapper = (function () {
        function HttpNodeWrapper() {
        }

        var Http = Ti.Network.createHTTPClient({
            // function called when the response data is available
            onload: function (e) {
                Ti.API.info("Received text: " + this.responseText);
                alert('success');
            },
            // function called when an error occurs, including a timeout
            onerror: function (e) {
                Ti.API.debug(e.error);
                alert('error');
            },
            timeout: 5000  // in milliseconds
        });


        HttpNodeWrapper.prototype.request = function (params, callback) {
            var action;
            var url = params.scheme + "://" + params.hostname + ":" + params.port + params.path;
            var method = params.method;
            var resource = params.header;

            //https://api.moj.io:443/v1/Vehicles?limit=10&offset=0&sortBy=Name&desc=false&criteria=
            //https://api.moj.io:443/v1/Login/y
            Ti.API.info("before url: " + url);
            if (params.method === "GET" && (params.data != null) && params.data.length > 0) {
                url += '?' + Object.keys(params.data).map(function (k) {
                        return encodeURIComponent(k) + '=' + encodeURIComponent(params.data[k]);
                    }).join('&');


            }
            var headers = null;
            Ti.API.info("params.header: " + params.headers);
            Ti.API.info("params.lenght: " + params.headers.length);

            if (params.method === "GET" && (params.headers != null)) {
                headers = Object.keys(params.headers).map(function (k) {
                    return encodeURIComponent(k) + '=' + encodeURIComponent(params.headers[k]);
                }).join('&');
            }

            Ti.API.info("MojioAPIToken index  " + headers.indexOf("MojioAPIToken"));

            if (headers.indexOf("MojioAPIToken") != -1) {
                var accessToken = headers.substring(headers.indexOf("MojioAPIToken") + 14, headers.indexOf("&"));
                Ti.API.info("Token   " + accessToken);
            }


            Ti.API.info("params.header: " + headers);
            Ti.API.info("after url: " + url);
            Ti.API.info("params.method: " + params.method);


            Ti.API.info("params.path: " + params.path);
            Ti.API.info("url: " + url);


            Http.onload = callback;

            //Ti.API.info("params.path.indexOf(\"Vehicles\"): " + params.path.toString().indexOf("Vehicles"));

            //Http.setRequestHeader("MojioAPIToken",accessToken);
            Http.open(method, url); //client.open("GET", url);

            if (headers.indexOf("MojioAPIToken") != -1) {
                Http.setRequestHeader("MojioAPIToken", accessToken);
            }

            // Send the request.
            Http.send();

        };

        return HttpNodeWrapper;

    })();

}).call(this);