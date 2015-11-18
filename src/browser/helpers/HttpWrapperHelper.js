// Generated by CoffeeScript 1.10.0
(function() {
  var FormUrlencoded, HttpWrapperHelper, URL;

  URL = require('url-parse');

  FormUrlencoded = require('form-urlencoded');

  module.exports = HttpWrapperHelper = (function() {
    function HttpWrapperHelper() {
      HttpWrapperHelper.__super__.constructor.call(this);
    }

    HttpWrapperHelper._makeParameters = function(params) {
      var property, query, value;
      if (params.length === 0) {
        '';
      }
      query = '?';
      for (property in params) {
        value = params[property];
        query += (encodeURIComponent(property)) + "=" + (encodeURIComponent(value)) + "&";
      }
      return query.slice(0, -1);
    };

    HttpWrapperHelper._makePath = function(elements) {
      return elements.reduce(function(x, y) {
        return x + "/" + encodeURIComponent(y);
      });
    };

    HttpWrapperHelper._getPath = function(resource, pid, action, sid, object, oid) {
      var path;
      path = "";
      if (resource != null) {
        path += "/" + encodeURIComponent(resource);
      }
      if (pid != null) {
        path += "/" + encodeURIComponent(pid);
      }
      if (action != null) {
        path += "/" + encodeURIComponent(action);
      }
      if (sid != null) {
        path += "/" + encodeURIComponent(sid);
      }
      if (object != null) {
        path += "/" + encodeURIComponent(object);
      }
      if (oid != null) {
        path += "/" + encodeURIComponent(oid);
      }
      return path;
    };

    HttpWrapperHelper._parse = function(url, request, encoding, token) {
      var parts;
      parts = new URL(url);
      parts.path = parts.pathname;
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
        parts.headers["MojioAPIToken"] = token.access_token;
      }
      if ((request.headers != null)) {
        parts.headers += request.headers;
      }
      parts.headers['Accept'] = 'application/json';
      parts.headers["Content-Type"] = 'application/json';
      if ((request.body != null)) {
        if ((encoding != null)) {
          parts.headers["Content-Type"] = 'application/x-www-form-urlencoded';
          parts.body = FormUrlencoded.encode(request.body);
        } else {
          parts.body = request.body;
        }
        parts.data = parts.body;
      }
      if ((request.data != null)) {
        if ((encoding != null)) {
          parts.headers["Content-Type"] = 'application/x-www-form-urlencoded';
          parts.data = FormUrlencoded.encode(request.data);
        } else {
          parts.data = request.data;
        }
        parts.body = parts.data;
      }
      return parts;
    };

    return HttpWrapperHelper;

  })();

}).call(this);
