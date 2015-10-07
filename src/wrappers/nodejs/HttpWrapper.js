// Generated by CoffeeScript 1.9.3
(function() {
  var FormUrlencoded, Http, HttpNodeWrapper, HttpWrapperHelper, Https, constants, iHttpWrapper, url,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  Http = require('http');

  Https = require('https');

  FormUrlencoded = require('form-urlencoded');

  url = require("url");

  constants = require('constants');

  HttpWrapperHelper = require('../HttpWrapperHelper');

  iHttpWrapper = require('../../interfaces/iHttpWrapper');

  module.exports = HttpNodeWrapper = (function(superClass) {
    var _request;

    extend(HttpNodeWrapper, superClass);

    function HttpNodeWrapper(token1, uri1, encoding1) {
      this.token = token1;
      this.uri = uri1 != null ? uri1 : 'https://api.moj.io/v1';
      this.encoding = encoding1 != null ? encoding1 : false;
      HttpNodeWrapper.__super__.constructor.call(this);
    }

    _request = function(params, callback) {
      var action;
      if (params.href.slice(0, "https".length) === "https") {
        action = Https.request(params);
      } else {
        action = Http.request(params);
      }
      action.on('response', function(response) {
        var data;
        if (typeof window === "undefined" || window === null) {
          response.setEncoding('utf8');
        }
        data = "";
        response.on('data', function(chunk) {
          if (chunk) {
            return data += chunk;
          }
        });
        return response.on('end', function() {
          if (response.statusCode > 299) {
            response.content = data;
            return callback(response, null);
          } else if (data.length > 0) {
            return callback(null, JSON.parse(data));
          } else {
            return callback(null, {
              result: "ok"
            });
          }
        });
      });
      if ((params != null ? params.timeout : void 0) != null) {
        action.on('socket', function(socket) {
          socket.setTimeout(params.timeout);
          return socket.on('timeout', function() {
            return callback(socket, null);
          });
        });
      }
      action.on('error', function(error) {
        return callback(error, null);
      });
      if ((params.body != null)) {
        action.write(params.body);
      }
      return action.end();
    };

    HttpNodeWrapper.prototype.parts = function(request) {
      var encoding, parts, token, uri;
      token = this.token;
      uri = this.uri;
      encoding = this.encoding;
      uri += HttpWrapperHelper._getPath(request.resource, request.id, request.action, request.key);
      console.log("Request:" + uri);
      parts = url.parse(uri);
      parts.method = request.method;
      parts.withCredentials = false;
      parts.params = '';
      if ((request.parameters != null) && Object.keys(request.parameters).length > 0) {
        parts.params = HttpWrapperHelper._makeParameters(request.parameters);
      }
      if ((request.params != null) && Object.keys(request.params).length > 0) {
        parts.params = HttpWrapperHelper._makeParameters(request.params);
      }
      parts.path += parts.params;
      parts.headers = {};
      if (token != null) {
        parts.headers["MojioAPIToken"] = token;
      }
      if ((request.headers != null)) {
        parts.headers += request.headers;
      }
      if ((request.body != null)) {
        if ((encoding != null)) {
          parts.headers["Content-Type"] = 'application/x-www-form-urlencoded';
          parts.body = FormUrlencoded.encode(request.body);
        } else {
          parts.headers["Content-Type"] = 'application/json';
          parts.body = request.body;
        }
      }
      return parts;
    };

    HttpNodeWrapper.prototype.url = function(request) {
      var parts;
      parts = this.parts(request);
      return parts.protocol + '//' + parts.hostname + parts.pathname + parts.params;
    };

    HttpNodeWrapper.prototype.request = function(request, callback) {
      var parts;
      parts = this.parts(request);
      return _request(parts, callback);
    };

    HttpNodeWrapper.prototype.redirect = function(params, callback) {
      return _request(params, callback);
    };

    return HttpNodeWrapper;

  })(iHttpWrapper);

}).call(this);

//# sourceMappingURL=HttpWrapper.js.map
