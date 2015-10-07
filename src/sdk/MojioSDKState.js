// Generated by CoffeeScript 1.9.3
(function() {
  var HttpNodeWrapper, MojioSDKState, MojioValidator, _,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  _ = require('underscore');

  HttpNodeWrapper = require('../wrappers/nodejs/HttpWrapper');

  MojioValidator = require('./MojioValidator');

  module.exports = MojioSDKState = (function() {
    var accountsURL, apiURL, defaultEndpoint, pushURL, state;

    state = {};

    accountsURL = "accounts.moj.io";

    pushURL = "push.moj.io";

    apiURL = "api.moj.io";

    defaultEndpoint = "api";

    function MojioSDKState(options) {
      if (options == null) {
        options = {
          environment: 'staging',
          version: 'v2'
        };
      }
      this.initiate = bind(this.initiate, this);
      if (options.environment == null) {
        options.environment = 'staging';
      }
      if (options.version == null) {
        options.version = 'v2';
      }
      if (options.environment !== '') {
        options.environment += '-';
      }
      this.endpoints = {
        accounts: {
          uri: "https://" + options.environment + accountsURL,
          encoding: true
        },
        api: {
          uri: "https://" + options.environment + apiURL + '/' + options.version,
          encoding: false
        },
        push: {
          uri: "https://" + options.environment + pushURL + '/' + options.version,
          encoding: false
        }
      };
      this.validator = new MojioValidator();
      this.reset();
    }

    MojioSDKState._makeParameters = function(params) {
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

    MojioSDKState.prototype.getPath = function(resource, id, action, key) {
      if (key && id && action && id !== '' && action !== '') {
        return "/" + encodeURIComponent(resource) + "/" + encodeURIComponent(id) + "/" + encodeURIComponent(action) + "/" + encodeURIComponent(key);
      } else if (id && action && id !== '' && action !== '') {
        return "/" + encodeURIComponent(resource) + "/" + encodeURIComponent(id) + "/" + encodeURIComponent(action);
      } else if (id && id !== '') {
        return "/" + encodeURIComponent(resource) + "/" + encodeURIComponent(id);
      } else if (action && action !== '') {
        return "/" + encodeURIComponent(resource) + "/" + encodeURIComponent(action);
      }
      return "/" + encodeURIComponent(resource);
    };

    MojioSDKState.prototype.initiate = function(callback) {
      var httpNodeWrapper;
      if (state.answer != null) {
        return callback(null, state.answer);
      } else {
        this.validator.credentials(state.body);
        httpNodeWrapper = new HttpNodeWrapper(state.token, this.endpoints[state.endpoint].uri, this.endpoints[state.endpoint].encoding);
        return httpNodeWrapper.request({
          method: state.method,
          resource: state.resource,
          id: state.id,
          action: state.action,
          key: state.key,
          body: state.body,
          params: state.params
        }, callback);
      }
    };

    MojioSDKState.prototype.url = function(bodyAsParameters) {
      var httpNodeWrapper, url;
      if (bodyAsParameters == null) {
        bodyAsParameters = true;
      }
      httpNodeWrapper = new HttpNodeWrapper(state.token, this.endpoints[state.endpoint].uri, this.endpoints[state.endpoint].encoding);
      url = httpNodeWrapper.url({
        method: state.method,
        resource: state.resource,
        id: state.id,
        action: state.action,
        key: state.key,
        body: bodyAsParameters ? "" : state.body,
        params: bodyAsParameters ? state.body : state.params
      });
      return url;
    };

    MojioSDKState.prototype.show = function() {
      console.log(JSON.stringify(state));
      return state;
    };

    MojioSDKState.prototype.setToken = function(token) {
      return state.token = token;
    };

    MojioSDKState.prototype.setAnswer = function(token) {
      return state.answer = token;
    };

    MojioSDKState.prototype.setObject = function(object_or_json_string) {
      switch (typeof object_or_json_string) {
        case "string":
          state.body = object_or_json_string;
          break;
        case "object":
          state.body = JSON.stringify(object_or_json_string);
      }
      return state;
    };

    MojioSDKState.prototype.setEndpoint = function(endpoint) {
      var validateEndpoint;
      validateEndpoint = (function(_this) {
        return function(endpoint, endpoints) {
          var found, name, value;
          found = false;
          for (name in endpoints) {
            value = endpoints[name];
            if (endpoint === name) {
              found = true;
              break;
            }
          }
          if (!found) {
            throw "Endpoint must be accounts, api, or push";
          }
          return found;
        };
      })(this);
      if (validateEndpoint(endpoint, this.endpoints)) {
        return state.endpoint = endpoint;
      }
    };

    MojioSDKState.prototype.setMethod = function(method) {
      this.reset();
      return state.method = method;
    };

    MojioSDKState.prototype.setResource = function(resource) {
      return state.resource = resource;
    };

    MojioSDKState.prototype.setAction = function(action) {
      return state.action = action;
    };

    MojioSDKState.prototype.setParams = function(parameters) {
      return _.extend(state.parameters, parameters);
    };

    MojioSDKState.prototype.setBody = function(parameters) {
      _.extend(state.body, parameters);
    };

    MojioSDKState.prototype.getBody = function() {
      return state.body;
    };

    MojioSDKState.prototype.getParams = function() {
      return state.parameters;
    };

    MojioSDKState.prototype.setWhere = function(id_example_or_query) {
      state.type = "all";
      state.where = null;
      if (id_example_or_query !== null) {
        switch (typeof id_example_or_query) {
          case "number":
            state.type = "id";
            state.where = id_example_or_query;
            break;
          case "string":
            state.type = "query";
            state.where = id_example_or_query;
            break;
          case "object":
            state.type = "example";
            state.where = id_example_or_query;
            break;
          default:
            state.type = "query";
            state.where = id_example_or_query;
        }
      }
      return state;
    };

    MojioSDKState.prototype.fixup = function() {
      var lowP, lowV, p, results, v;
      results = [];
      for (p in state) {
        v = state[p];
        lowP = p.toLowerCase();
        lowV = v.toLowerCase();
        state[lowP] = lowV;
        results.push(delete state[p]);
      }
      return results;
    };

    MojioSDKState.prototype.reset = function() {
      state.answer = null;
      state.endpoint = defaultEndpoint;
      state.method = null;
      state.resource = null;
      state.id = null;
      state.action = null;
      state.key = null;
      state.parameters = {};
      state.operation = "";
      state.lmiit = 10;
      state.offset = 0;
      state.desc = false;
      state.query = null;
      state.type = "all";
      state.where = null;
      return state.body = {};
    };

    return MojioSDKState;

  })();

}).call(this);

//# sourceMappingURL=MojioSDKState.js.map
