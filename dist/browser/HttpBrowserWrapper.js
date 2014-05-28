!function(e){if("object"==typeof exports)module.exports=e();else if("function"==typeof define&&define.amd)define(e);else{var f;"undefined"!=typeof window?f=window:"undefined"!=typeof global?f=global:"undefined"!=typeof self&&(f=self),f.HttpBrowserWrapper=e()}}(function(){var define,module,exports;return (function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(_dereq_,module,exports){
// Generated by CoffeeScript 1.6.3
(function() {
  var HttpBrowserWrapper;

  module.exports = HttpBrowserWrapper = (function() {
    var dataByMethod, sendRequest;

    function HttpBrowserWrapper($) {
      this.$ = $;
    }

    dataByMethod = function(data, method) {
      switch (method.toUpperCase()) {
        case 'POST':
        case 'PUT':
          return JSON.stringify(data);
        default:
          return data;
      }
    };

    sendRequest = function(url, data, method, headers) {
      return this.$.ajax(url, {
        data: dataByMethod(data, method),
        headers: headers,
        contentType: "application/json",
        type: method,
        cache: false,
        error: function(obj, status, error) {
          return console.log('Error during request: (' + status + ') ' + error);
        }
      });
    };

    HttpBrowserWrapper.prototype.request = function(params, callback) {
      var url;
      if (params.method == null) {
        params.method = "GET";
      }
      if ((params.host == null) && (params.hostname != null)) {
        params.host = params.hostname;
      }
      if (params.scheme == null) {
        params.scheme = window.location.protocol.split(':')[0];
      }
      if (params.scheme === 'file') {
        params.scheme = 'http';
      }
      if (params.data == null) {
        params.data = {};
      }
      if (params.headers == null) {
        params.headers = {};
      }
      url = params.scheme + "://" + params.host + ":" + params.port + params.path;
      return sendRequest(url, params.data, params.method, params.headers).done(function(result) {
        return callback(null, result);
      }).fail(function() {
        return callback("Failed", null);
      });
    };

    return HttpBrowserWrapper;

  })();

}).call(this);

/*
//@ sourceMappingURL=HttpBrowserWrapper.map
*/

},{}]},{},[1])
(1)
});