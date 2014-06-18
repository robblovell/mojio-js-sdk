!function(e){if("object"==typeof exports)module.exports=e();else if("function"==typeof define&&define.amd)define(e);else{var f;"undefined"!=typeof window?f=window:"undefined"!=typeof global?f=global:"undefined"!=typeof self&&(f=self),f.App=e()}}(function(){var define,module,exports;return (function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(_dereq_,module,exports){
// Generated by CoffeeScript 1.6.3
(function() {
  var Location, MojioModel,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  MojioModel = _dereq_('./MojioModel');

  module.exports = Location = (function(_super) {
    __extends(Location, _super);

    Location.prototype._schema = {
      "Lat": "Float",
      "Lng": "Float",
      "FromLockedGPS": "Boolean",
      "Dilution": "Float",
      "IsValid": "Boolean"
    };

    Location.prototype._resource = 'Locations';

    Location.prototype._model = 'Location';

    function Location(json) {
      Location.__super__.constructor.call(this, json);
    }

    Location.prototype.observe = function(children, callback) {
      if (children == null) {
        children = null;
      }
      return callback(null, null);
    };

    Location.prototype.storage = function(property, value, callback) {
      return callback(null, null);
    };

    Location.prototype.statistic = function(expression, callback) {
      return callback(null, null);
    };

    Location._resource = 'Locations';

    Location._model = 'Location';

    Location.resource = function() {
      return Location._resource;
    };

    Location.model = function() {
      return Location._model;
    };

    return Location;

  })(MojioModel);

}).call(this);

/*
//@ sourceMappingURL=Location.map
*/

},{"./MojioModel":2}],2:[function(_dereq_,module,exports){
// Generated by CoffeeScript 1.6.3
(function() {
  var MojioModel;

  module.exports = MojioModel = (function() {
    MojioModel._resource = 'Schema';

    MojioModel._model = 'Model';

    function MojioModel(json) {
      this._client = null;
      this.validate(json);
    }

    MojioModel.prototype.set = function(field, value) {
      if ((this.schema()[field] != null) || typeof value === "function") {
        this[field] = value;
        return this[field];
      }
      if (!(field === "_client" || field === "_schema" || field === "_resource" || field === "_model" || field === "_AuthenticationType" || field === "AuthenticationType" || field === "_IsAuthenticated" || field === "IsAuthenticated")) {
        throw "Field '" + field + "' not in model '" + this.constructor.name + "'.";
      }
    };

    MojioModel.prototype.get = function(field) {
      return this[field];
    };

    MojioModel.prototype.validate = function(json) {
      var field, value, _results;
      _results = [];
      for (field in json) {
        value = json[field];
        _results.push(this.set(field, value));
      }
      return _results;
    };

    MojioModel.prototype.stringify = function() {
      return JSON.stringify(this, this.filter);
    };

    MojioModel.prototype.filter = function(key, value) {
      if (key === "_client" || key === "_schema" || key === "_resource" || key === "_model") {
        return void 0;
      } else {
        return value;
      }
    };

    MojioModel.prototype.query = function(criteria, callback) {
      var _this = this;
      if (this._client === null) {
        callback("No authorization set for model, use authorize(), passing in a mojio _client where login() has been called successfully.", null);
        return;
      }
      if (criteria instanceof Object) {
        return this._client.request({
          method: 'GET',
          resource: this.resource(),
          parameters: criteria
        }, function(error, result) {
          return callback(error, _this._client.make_model(_this.model(), result));
        });
      } else if (typeof criteria === "string") {
        return this._client.request({
          method: 'GET',
          resource: this.resource(),
          parameters: {
            id: criteria
          }
        }, function(error, result) {
          return callback(error, _this._client.make_model(_this.model(), result));
        });
      } else {
        return callback("criteria given is not in understood format, string or object.", null);
      }
    };

    MojioModel.prototype.create = function(callback) {
      var _this = this;
      if (this._client === null) {
        callback("No authorization set for model, use authorize(), passing in a mojio _client where login() has been called successfully.", null);
        return;
      }
      return this._client.request({
        method: 'POST',
        resource: this.resource(),
        body: this.stringify()
      }, function(error, result) {
        return callback(error, result);
      });
    };

    MojioModel.prototype.save = function(callback) {
      var _this = this;
      if (this._client === null) {
        callback("No authorization set for model, use authorize(), passing in a mojio _client where login() has been called successfully.", null);
        return;
      }
      return this._client.request({
        method: 'PUT',
        resource: this.resource(),
        body: this.stringify(),
        parameters: {
          id: this._id
        }
      }, function(error, result) {
        return callback(error, result);
      });
    };

    MojioModel.prototype["delete"] = function(callback) {
      var _this = this;
      return this._client.request({
        method: 'DELETE',
        resource: this.resource(),
        parameters: {
          id: this._id
        }
      }, function(error, result) {
        return callback(error, result);
      });
    };

    MojioModel.prototype.resource = function() {
      return this._resource;
    };

    MojioModel.prototype.model = function() {
      return this._model;
    };

    MojioModel.prototype.schema = function() {
      return this._schema;
    };

    MojioModel.prototype.authorization = function(client) {
      this._client = client;
      return this;
    };

    MojioModel.prototype.id = function() {
      return this._id;
    };

    MojioModel.prototype.mock = function(type, withid) {
      var field, value, _ref;
      if (withid == null) {
        withid = false;
      }
      _ref = this.schema();
      for (field in _ref) {
        value = _ref[field];
        if (field === "Type") {
          this.set(field, this.model());
        } else if (field === "UserName") {
          this.set(field, "Tester");
        } else if (field === "Email") {
          this.set(field, "test@moj.io");
        } else if (field === "Password") {
          this.set(field, "Password007!");
        } else if (field !== '_id' || withid) {
          switch (value) {
            case "Integer":
              this.set(field, "0");
              break;
            case "Boolean":
              this.set(field, false);
              break;
            case "String":
              this.set(field, "test" + Math.random());
          }
        }
      }
      return this;
    };

    return MojioModel;

  })();

}).call(this);

/*
//@ sourceMappingURL=MojioModel.map
*/

},{}]},{},[1])
(1)
});