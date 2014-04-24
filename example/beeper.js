//var http = require('http');
var $ = require('jquery');
var HttpBrowser = require('../browser-http.js')
//
//http.get({ path : '/MOJIO.nodejs.client/example/beep.html' }, function (res) {
//    var div = document.getElementById('result');
//    div.innerHTML += 'GET /beep<br>';
//
//    res.on('data', function (buf) {
//        div.innerHTML += buf;
//    });
//
//    res.on('end', function () {
//        div.innerHTML += '<br>__END__';
//    });
//});
//
//var req = http.request({
//   hostname: "10.0.1.11",
//   method: "post",
//   port: 2006,
//   withCredentials: false,
//   scheme: "http",
//   path: "/v1/Login/dfecec6b-0554-4187-8bee-d5239eb2bd08?userOrEmail=mojio&password=mojioR0cks&secretKey=5047798f-2549-4ed0-9437-32e185a59602"
//}, function(res) {
//    var div = document.getElementById('result2');
//    div.innerHTML += 'POST /login<br>';
//
//    res.on('data', function (buf) {
//        div.innerHTML += buf;
//    });
//
//    res.on('error', function (buf) {
//        div.innerHTML += buf;
//    });
//
//    res.on('end', function () {
//        div.innerHTML += '<br>__END__';
//    });
//});
//req.on('error', function (error) { console.log("err"); });
//req.end();

httpbrowser = new HttpBrowser();
var req2 = httpbrowser.request({
    hostname: "10.0.1.11",
    method: "post",
    port: 2006,
    withCredentials: false,
    scheme: "http",
    path: "/v1/Login/dfecec6b-0554-4187-8bee-d5239eb2bd08?userOrEmail=mojio&password=mojioR0cks&secretKey=5047798f-2549-4ed0-9437-32e185a59602"
}, function(res) {
    var div = document.getElementById('result4');
    div.innerHTML += 'POST /login<br>';

    res.on('data', function (buf) {
        div.innerHTML += buf;
    });

    res.on('error', function (buf) {
        div.innerHTML += buf;
    });

    res.on('end', function () {
        div.innerHTML += '<br>__END__';
    });
});
req2.on('error', function (error) { console.log("err"); });
req2.end();

var dataByMethod = function (data, method) {
    switch (method.toUpperCase()) {
        case 'POST':
        case 'PUT':
            return JSON.stringify(data);
        default:
            return data;
    }
}

var sendRequest = function (url, data, method) {
    if (!method)
        method = "GET";

    if (!data)
        data = {};

    var headers = {};
//    if (getTokenId() != null)
//        headers[settings.mojioTokenHeader] = getTokenId();

    return $.ajax(url, {
        data: dataByMethod(data, method),
        headers: headers,
        contentType: "application/json",
        type: method,
        cache: false,
        error: function (obj, status, error) {
            log('Error during request: (' + status + ') ' + error);
        }
    });
}

data = sendRequest("http://10.0.1.11:2006/v1/Login/dfecec6b-0554-4187-8bee-d5239eb2bd08?userOrEmail=mojio&password=mojioR0cks&secretKey=5047798f-2549-4ed0-9437-32e185a59602",
    {}, "POST")
    .done(function (token) {
        var div = document.getElementById('result3');
        div.innerHTML += 'POST /login<br>';
        div.innerHTML += token._id

    })
    .fail(function () {
        console.log('Failed to login');
    });

